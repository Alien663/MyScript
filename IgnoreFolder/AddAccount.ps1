# add SMA Account into administrator group
# -------------------------------------------------------------------------------
Add-LocalGroupMember -Group "Administrators" -Member "Quanta\SMA10611031"
Add-LocalGroupMember -Group "Administrators" -Member "Quanta\SMA10605005"
Add-LocalGroupMember -Group "Administrators" -Member "Quanta\SMA93110110"
Add-LocalGroupMember -Group "Administrators" -Member "Quanta\SMA95110112"
Add-LocalGroupMember -Group "Administrators" -Member "Quanta\SMA97030311"
Add-LocalGroupMember -Group "Administrators" -Member "Quanta\SMA11107063"
Add-LocalGroupMember -Group "Administrators" -Member "Quanta\tdsadmin"
# -------------------------------------------------------------------------------


# add adcount into DKAccess group
# -------------------------------------------------------------------------------
$item="account"
$auth="DKAccess"
New-LocalGroup -Name $auth -Description "Set Access Folder"
Add-LocalGroupMember -Group $auth -Member $item
# -------------------------------------------------------------------------------


# add new local Account
# -------------------------------------------------------------------------------
$Account = "account"
$_password = "password"
$Password = ConvertTo-SecureString $_password -AsPlainText -Force
#$Password = ConvertTo-SecureString "your password" -AsPlainText -Force
New-LocalUser $Account -Password $Password
Add-LocalGroupMember -Group "Administrators" -Member $Account
# -------------------------------------------------------------------------------


# set credential
# -------------------------------------------------------------------------------
$account = "account"
$_password = "password"
$password = ConvertTo-SecureString $_password -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("the local admin", $password)
# -------------------------------------------------------------------------------