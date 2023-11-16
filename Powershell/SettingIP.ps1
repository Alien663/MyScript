# Setting IP Address

$OK = $True
$Reboot = $False
$IP = "192.168.192.30"
$SubNet = "255.255.255.0"
$Gateway = "192.168.192.254"
$DNSServers = "168.95.1.1", "168.95.192.1"
$WINSServer = "192.168.192.253", "192.168.192.1"

# 找到要設定的網路卡
$NIC = Get-WmiObject Win32_NetworkAdapterConfiguration |`
  Where {$_.IPEnabled -eq $True -and`
    $_.Description -eq "Microsoft Hyper-V Network Adapter"}

# 檢查網路卡物件是否為 null
if ($NIC -eq $Null) {
  $OK = $False
  Write-Host "找不到要設定的網路卡！"
}
else
{
  # 開始設定
  $Status = $NIC.EnableStatic($IP, $SubNet)
  # 檢查設定的回傳值，0 表示設定成功，其他表示設定失敗
  if ($Status.ReturnValue -gt 0) {
    if ($Status.ReturnValue -eq 1) {
      $Reboot = $True
    }
    $OK = $False
    Write-Host "設定 IP 位址失敗！"}

  $Status = $NIC.SetGateWays($Gateway)
  # 檢查設定的回傳值，0 表示設定成功，其他表示設定失敗
  if ($Status.ReturnValue -gt 0) {
    if ($Status.ReturnValue -eq 1) {
      $Reboot = $True
    }
    $OK = $False
    Write-Host "設定預設閘道失敗！"}

  $Status = $NIC.SetDNSServerSearchOrder($DNSServers)
  # 檢查設定的回傳值，0 表示設定成功，其他表示設定失敗
  if ($Status.ReturnValue -gt 0) {
    if ($Status.ReturnValue -eq 1) {
      $Reboot = $True
    }
    $OK = $False
    Write-Host "設定 DNS 失敗！"}

  $Status = $NIC.SetWINSServer($WINSServer[0], $WINSServer[1])
  if ($Status.ReturnValue -gt 0) {
    if ($Status.ReturnValue -eq 1) {
      $Reboot = $True
    }
    $OK = $False
    Write-Host "設定 WINS 失敗！"}
}

# 檢查設定結果
if ($OK) {
  # 暫停 500 毫秒讓設定生效
  Start-Sleep -m 500

  Write-Host "設定成功！設定的結果如下："
  Write-Host "=============================="
  Write-Host "網路卡說明 : " $NIC.Description
  Write-Host "IP 位址 : " $NIC.IPAddress
  Write-Host "預設閘道 : " $NIC.DefaultIPGateway
  Write-Host "DNS 位址 : " $NIC.DNSServerSearchOrder
}

if ($Reboot) {
  Write-Host "您必須重新開機，才能讓設定生效！"
}


#--------------------------------------------------------------------------------
$old_ip = "169.254.10.10"
$new_ip = "169.254.20.10"
$new_gw = "169.254.20.254"
$id = (Get-NetIPAddress | where IPAddress -like "169.254.*").InterfaceIndex
$old_gw = (Get-NetRoute -interfaceindex $id -DestinationPrefix '0.0.0.0/0')[0].NextHop
New-NetIPAddress -InterfaceIndex $id -IPAddress $new_ip -PrefixLength 16 -DefaultGateway $new_gw
Remove-NetIPAddress -IPAddress $old_ip -confirm:$false
Remove-NetRoute -interfaceindex 8 -NextHop $old_gw -confirm:$false
#--------------------------------------------------------------------------------