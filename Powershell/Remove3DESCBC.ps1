$regedit_path = "HKLM:\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002"
$prop = Get-ItemProperty -Path $regedit_path
mkdir "D:\Remove3DESCBC"
echo $prop.Functions >> "D:\Remove3DESCBC\log.txt"
echo $prop.Functions -like "*3DES*"
Set-ItemProperty -Path $regedit_path -Name "Functions" -Value ($prop.Functions -notlike "*3DES")