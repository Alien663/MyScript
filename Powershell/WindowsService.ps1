# change credential that manage service
# -------------------------------------------------------------------------------
$username = "domain\account" # the user to change to
$password = "password" # the password to change to
$services = gwmi win32_service | select * | where StartName -like "*old_account" # the condition to change credential
foreach($ser in $services){
    $ser.change($null,$null,$null,$null,$null,$null,$username,$password)
}
# -------------------------------------------------------------------------------