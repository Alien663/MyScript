$today = get-date -format "yyyy-MM-dd"
$regedit_path = "HKLM:\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
$prop = (Get-ItemProperty -Path $regedit_path).Functions
$folder = "D:\Remove3DESCBC"
if(!(Test-Path $folder)){
    New-Item $folder -Type Directory
}
echo $prop >> "D:\Remove3DESCBC\log_$today.txt"
echo $prop -like "*3DES*"
Set-ItemProperty -Path $regedit_path -Name "Functions" -Value ($prop -notlike "*3DES*")