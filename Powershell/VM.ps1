# VM setting for DR dril 
# -------------------------------------------------------------------------------
$servers = @(
    [pscustomobject]@{VMName="TestVM1";ExportPath="D:\Test\_VMBackup";NewPath="D:\Test\_VM\TVM1-1";NewName="TestVM1-1"},
    [pscustomobject]@{VMName="TestVM2";ExportPath="D:\Test\_VMBackup";NewPath="D:\Test\_VM\TVM2-1";NewName="TestVM2-1"})

foreach($server in $servers){
    # create folder if not exists
    if(!(Test-Path -Path $server.NewPath)){
        New-Item -ItemType Directory -Path $server.NewPath
    }
    
    #export vm
    $oldVM = Get-VM -Name $server.VMName
    Export-VM -VM $oldVM -Path $server.ExportPath
    
    # import VM
    $filepath = $server.ExportPath + '\' + $server.VMName + '\Virtual Machines\' + $oldVM.ID + '.vmcx'
    $newVM = (Import-VM -Path $filepath -Copy -GenerateNewId -VirtualMachinePath $server.NewPath -VhdDestinationPath $server.NewPath)

    # rename VM
    Set-VM -VM $newVM -NewVMName $server.NewName

    # disable to virsual switch
    Disconnect-VMNetworkAdapter -VMName $newVM.VMName

    # start VM
    start-vm -VM $newVM
}
# -------------------------------------------------------------------------------



# -------------------------------------------------------------------------------
# create new virtual switch first
# replace TestVS to your new virtual switch name
# check vlanid is correct
# check vmlist is correct
$vmlist = @("UBT", "TestVM1")
$newvs = Get-VMSwitch -Name TestVS
$vlanid =  477

foreach($vmname in $vmlist){
    $vm = Get-VM -Name $vmname
    Connect-VMNetworkAdapter -VMNetworkAdapter $vm.NetworkAdapters -VMSwitch $newvs
    Set-VMNetworkAdapterVlan -VMName $vm.Name -Access -VlanId $vlanid
}
# -------------------------------------------------------------------------------



# -------------------------------------------------------------------------------
$newvs = Get-VMSwitch -Name VirtualSwitchOnTrunkPort
function Get-VlanIDWithRule($ip){
    $ipRule = @(
        [pscustomobject]@{ipRex="*.*.28.*";VlanID=447},
        [pscustomobject]@{ipRex="*.*.29.*";VlanID=447}
    )
    foreach($rule in $ipRule){
        if($ip -like $rule.ipRex){
            return $rule.VlanID
        }
        else{
            return 0
        }
    }
} 

$vms = (Get-VM | where State -eq "Running")

foreach($vm in $vms){
    $myvlanid = Get-VlanIDWithRule($vm.NetworkAdapters.IPAddresses)
    if($myvlanid -gt 0){
        Connect-VMNetworkAdapter -VMNetworkAdapter $vm.NetworkAdapters -VMSwitch $newvs
        Set-VMNetworkAdapterVlan -VMName $vm.Name -Access -VlanId $myvlanid
    }
}
# -------------------------------------------------------------------------------