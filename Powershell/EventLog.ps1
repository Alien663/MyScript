$today = (get-date).date
$the_date = [Datetime]::ParseExact("31/12/2022", "dd/MM/yyyy", $null)

$date = get-eventlog -logname security -instanceid 4688 | where TimeGenerated -lt $today
$date = get-eventlog -logname security -instanceid 4625 | where TimeGenerated -lt $the_date