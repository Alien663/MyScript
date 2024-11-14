# change credential that manage service
# -------------------------------------------------------------------------------
$username = "domain\account" # the user to change to
$password = "password" # the password to change to
# the condition to change credential
$services = gwmi win32_service | select * | where StartName -like "*old_account" 
foreach($ser in $services){
    $ser.change($null,$null,$null,$null,$null,$null,$username,$password)
}
# -------------------------------------------------------------------------------