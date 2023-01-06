# setting TLS Version
# -------------------------------------------------------------------------------
# show all Cipher
Get-ChildItem -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers'
# show all protocols
Get-ChildItem -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\' -Recurse |
ForEach-Object {
    $p = Get-ItemProperty -Path $_.PSPath
    if ('Enabled' -in $p.PSObject.Properties.Name) {
        $_.PSPath.Split(':')[2]
        "Enabled = $($p.Enabled)"
    }
}
# -------------------------------------------------------------------------------



# disable SSL and TLS 1.0、1.1
# -------------------------------------------------------------------------------
$Protocols = @("SSL 2.0", "SSL 3.0", "TLS 1.0", "TLS 1.1")
$EndPoints = @("Client", "Server")

$Protocols | ForEach{
    $Protocol = $_
    If(!(Test-Path -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\$Protocol")){
        New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\$Protocol" | Out-Null
    }
    $EndPoints | ForEach{
        $EndPoint = $_
        If(!(Test-Path -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\$Protocol\$EndPoint")){
            New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\$Protocol\$EndPoint" | Out-Null
        }
        Switch($EndPoint){
            "Client"{
                Try{
                    Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\$Protocol\$EndPoint" -Name DisabledByDefault -ErrorAction Ignore
                    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\$Protocol\$EndPoint" -Name DisabledByDefault -PropertyType DWORD -Value "0x0" –Force | Out-Null
                }Catch{
                    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\$Protocol\$EndPoint" -Name DisabledByDefault -PropertyType DWORD -Value "0x0" –Force | Out-Null
                }
            }
            "Server"{
                Try{
                    Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\$Protocol\$EndPoint" -Name Enabled -ErrorAction Ignore
                    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\$Protocol\$EndPoint" -Name Enabled -PropertyType DWORD -Value "0x0" –Force | Out-Null
                }Catch{
                    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Protocols\$Protocol\$EndPoint" -Name Enabled -PropertyType DWORD -Value "0x0" –Force | Out-Null
                }
            }
        }
    }
}
# -------------------------------------------------------------------------------