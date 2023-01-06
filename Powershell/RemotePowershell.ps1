# get full name auto
# -------------------------------------------------------------------------------
$names = @("computer name 1", "computer name 2", "computer name 3")
$servers = @()
foreach( $name in $names){
    $servers += [System.Net.Dns]::GetHostByName($name).HostName
}

$servers
# 1. It needs to certificate user by AD
foreach( $server in $servers){
    InVoke-Command -ComputerName $server -ScriptBlock{
        $myname = hostname
        echo "---------------------------------------------------------------------------------"
        echo "$myname start to run command"


        # you can wirte your script here


        echo "$myname done"
        echo "---------------------------------------------------------------------------------"
    }
}
# -------------------------------------------------------------------------------


# send small file to remote computer with invoke command
# -------------------------------------------------------------------------------
$FileContents = Get-Content -Path 'C:\local\myfile.txt'
InVoke-Command -ComputerName "computer.full.name" -ScriptBlock {
    param($FilePath,$data)
    Set-Content -Path $FilePath -Value $data
} -ArgumentList "C:\remote\myfile.txt", $FileContents
# -------------------------------------------------------------------------------