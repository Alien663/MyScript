# -------------------------------------------------------------------------------
# 
# You need to set virtual switch name
# IP rule can find in the page https://learn.microsoft.com/zh-tw/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.3#comparison-operators
#
$newvs = Get-VMSwitch -Name VirtualSwitchOnTrunkPort
function Get-VlanIDWithRule($ip){
    $ipRule = @(
        [pscustomobject]@{ipRex="*.*.28.*";VlanID=477},
        [pscustomobject]@{ipRex="*.*.29.*";VlanID=477}
    )
    foreach($rule in $ipRule){
        if($ip -like $rule.ipRex){
            return $rule.VlanID
        }
        return 0
    }
} 

$vms = (Get-VM | where State -eq "Running")

foreach($vm in $vms){
    # echo $vm.NetworkAdapters.IPAddresses
    $myvlanid = Get-VlanIDWithRule($vm.NetworkAdapters.IPAddresses)
    if($myvlanid -gt 0){
        # echo $myvlanid
        Connect-VMNetworkAdapter -VMNetworkAdapter $vm.NetworkAdapters -VMSwitch $newvs
        Set-VMNetworkAdapterVlan -VMName $vm.Name -Access -VlanId $myvlanid
    }
    else{
        # echo $vm.Name
    }
}
# -------------------------------------------------------------------------------