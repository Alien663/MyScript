# disable Job
# -------------------------------------------------------------------------------
$log_file = "D:\JobScheduler\"
$the_user = "account"
if(!(Test-Path -Path $log_file)){ # create the log_file folder
    New-Item -ItemType Directory -Path $log_file
}
# if the state of job is disable, don't write to log.txt
$data = get-scheduledtask | select-object TaskPath,Taskname,Author,State,Principal | where {$_.State -ne "Disabled"}
foreach($sch in $data){
    if($the_user -eq $sch.Principal.UserId -or $the_user -eq ("domain\" + $the_user)){ 
        echo $sch >> $log_file"disable_task.txt"
        echo ($sch.TaskPath + $sch.TaskName) >> $log_file"log.txt"
        # Disable-ScheduledTask -TaskName ($sch.TaskPath + $sch.TaskName)
    }
}
# -------------------------------------------------------------------------------


# modify password
# -------------------------------------------------------------------------------
$TaskCredential = Get-Credential
Get-ScheduledTask | Where-Object { $_.Principal.UserId -eq $TaskCredential.UserName } | Set-ScheduledTask -User $TaskCredential.UserName -Password $TaskCredential.GetNetworkCredential().Password
# -------------------------------------------------------------------------------


# Enable Job
# -------------------------------------------------------------------------------
$log_file = "D:\JobScheduler\"
$enable_list = Get-Content $log_file"log.txt"
foreach($sch in $enable_list){
    echo $sch
    #Enable-ScheduledTask -TaskName $sch
}
# -------------------------------------------------------------------------------