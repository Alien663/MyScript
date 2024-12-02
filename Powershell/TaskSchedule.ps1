# Update Items:
# 1. Change file format to json, it makes people and program easier to read
# 2. Add TaskPath to make it more presicesily to find the job
# 3. Add State to check previoud state
# disable Job
# -------------------------------------------------------------------------------
$log_file = "D:\JobScheduler\"
$accounts = @("admin1")
if(!(Test-Path -Path $log_file)){ # create the log_file folder
    New-Item -ItemType Directory -Path $log_file
}
$jobs = Get-ScheduledTask | where-object { $accounts -contains $_.Principal.UserId }
$jobs | select TaskPath,TaskName,State,@{N='RunAs';E={$_.Principal.UserId}} | ConvertTo-Json > $log_file"JobList.json"
#$jobs | Disable-ScheduledTask
# -------------------------------------------------------------------------------

# create credential: How many accounts you need to change
# -------------------------------------------------------------------------------
$account1 = "domain\admin1"
$_password1 = 'password'
$password1 = ConvertTo-SecureString $_password1 -AsPlainText -Force
$admin1Credential = New-Object System.Management.Automation.PSCredential ($account1, $password1)
# -------------------------------------------------------------------------------

# Update credential and enable job
# -------------------------------------------------------------------------------
$log_file = "D:\JobScheduler\"
$joblist = Get-Content $log_file"JobList.json" | ConvertFrom-Json
foreach($job in $joblist){
    $thisJob = Get-ScheduledTask -TaskPath $job.TaskPath -TaskName $job.TaskName
    # if there are many accounts, you can add more if statement here
    if($thisJob.Principal.UserId -eq "admin1"){
        $thisJob | Set-ScheduledTask -User $admin1Credential.UserName -Password $admin1Credential.GetNetworkCredential().Password
    }

    # when job's previous state is not "Disalbed"
    if($job.State -ne 1){
        #$thisJob | Enable-ScheduledTask
    }
}
# -------------------------------------------------------------------------------