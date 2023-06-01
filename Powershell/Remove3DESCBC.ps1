$tt = Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002
mkdir "D:\Remove3DESCBC"
echo $tt.Functions >> "D:\Remove3DESCBC\log.txt"
$new_functions = [System.Collections.ArrayList]@()
foreach($item in $tt.Functions)
{
    if($item -notlike "*3DES-CBC*")
    {
        $new_functions.Add($item)
    }
}
$tt.Functions = $new_functions
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002 -Value $tt