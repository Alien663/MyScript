# unjoin domain
# -------------------------------------------------------------------------------
$NewComputerName = "Keroro"
$password = ConvertTo-SecureString "your password" -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("the local admin", $password)
Add-Computer -LocalCredential $Cred -WorkgroupName "WORKGROUP" -NewName $NewComputerName -Restart -Force #It will unjoin domain automatically
# -------------------------------------------------------------------------------

# unjoin domain
# Remove-Computer -LocalCredential $Cred -Force