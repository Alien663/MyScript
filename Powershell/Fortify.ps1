# Parameters Settings
# -------------------------------------------------------------------------------
$PATH =  "$(Build.ArtifactStagingDirectory)\sca_artifacts\$(BuildID)"
$LogPATH =  $PATH + "_scan.log"
$nowDate = (Get-Date).ToString("yyyyMMdd")
$resultString = ""
# -------------------------------------------------------------------------------

# Critical Issue
# -------------------------------------------------------------------------------
$queryCriticalData = (FPRUtility -project "$PATH.fpr" -information -search -filterSet "Security Auditor View" -listIssues -categoryIssueCounts -outputFormat CSV  -query "[fortify priority order]:Critical")
if($queryCriticalData.Count -gt 0){
    $criticalCSVData = $queryCriticalData | ConvertFrom-CSV
    $resultString += "<hr><h2 style='background-color:rgb(255,0,0);'>Critical</h2><h4>" + $criticalCSVData[-1].IID + "</h4>"
    foreach($item in ($criticalCSVData[0..($criticalCSVData.Count-2)] | group -Property category)){
        $groupPath = $item.Group.path | group
        $resultString += "<h3>" + $item.Name + "</h3><div>" + ($groupPath.Name -join "<br>")  + "</div>"
    }
}
# -------------------------------------------------------------------------------

# Hight Issue
# -------------------------------------------------------------------------------
$$queryHighData = (FPRUtility -project "$PATH.fpr" -information -search -filterSet "Security Auditor View" -listIssues -categoryIssueCounts -outputFormat CSV  -query "[fortify priority order]:High")
if($queryHighData.Count -gt 0){
    $hightCSVData = $queryHighData | ConvertFrom-CSV
    $resultString += "<hr><h2 style='background-color:rgb(255,128,0);'>Critical</h2><h4>" + $hightCSVData[-1].IID + "</h4>"
    foreach($item in ($hightCSVData[0..($hightCSVData.Count-2)] | group -Property category)){
        $groupPath = $item.Group.path | group
        $resultString += "<h3>" + $item.Name + "</h3><div>" + ($groupPath.Name -join "<br>")  + "</div>"
    }
}
# -------------------------------------------------------------------------------

# Send EMail
# -------------------------------------------------------------------------------
$outputFile = $PATH + "_$(Build.Repository.Name)_" + $nowDate + ".pdf"
BIRTReportGenerator -template "Developer Workbook" -format PDF -output $outputFile -source "$PATH.fpr"
$issueFlag = $queryCriticalData.Count -gt 0 -or $queryHighData.Count -gt 0
$sendMailMessageSplat = @{
    From = "sender@email.com"
    To = "$(Email)" -split ';'
    Subject = "[$(Build.Repository.Name)]$(if($issueFlag){"Urgent!Critical or Hight Issues Detected in Fortify Static Code Analyze!"}else{"Fortify Static Code Analyzer"})"
    Body = "<p>please check Detail in fortify report in Attaching file.<p>" + $resultString
    Attachments = $outputFile,$LogPATH
    Priority = if($issueFlag){"High"}else{"Normal"}
    DeliveryNotificationOption = 'OnSuccess', 'OnFailure'
    SmtpServer = "smtp.server.com"
    BodyAsHtml = $true
}

try {
    Send-MailMessage @sendMailMessageSplat
    Write-Host "Email sent successfully."
} catch {
    throw "Failed to send email. Error: $_"
}
# -------------------------------------------------------------------------------