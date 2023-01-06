# set folder access control list(with inheritance to sub folder and sub file)
# -------------------------------------------------------------------------------
$Folder="D:\Test"
$auth="domain\account"
$user="Users"
$AccessRule2 = New-Object System.Security.AccessControl.FIleSYstemAccessRule($user, "ReadAndExecute, Synchronize", (1,2),0, "Allow")
# 3. maintain $ACL, give auth's modify permission
$AccessRule1 = New-Object System.Security.AccessControl.FIleSYstemAccessRule($auth, "Modify", (0,2),0, "Allow")
$ACL.AddAccessRule($AccessRule1)
$ACL.AddAccessRule($AccessRule2)
$ACL.SetAccessRuleProtection($false, $true)
# run command bellow that you can check the ACL before setting
# $ACL.Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize
$ACL | Set-ACL -Path $Folder
(Get-ACL -Path $Folder).Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize
# -------------------------------------------------------------------------------