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