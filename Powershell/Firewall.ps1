# set Outbound port deny specific IP
# -------------------------------------------------------------------------------
$denyIP = @("192.168.1.1", "192.168.1.2")
New-NetFirewallRule -DisplayName "Block MSSQL Remote Port 1433" -Direction Outbound -LocalPort 1433 -Protocol TCP -Action Block -RemoteAddress $denyIP
Remove-NetFirewallRule -DisplayName "Block MSSQL Remote Port 1433"
Get-NetFirewallRule -DisplayName "Block MSSQL Remote Port 1433"
# -------------------------------------------------------------------------------