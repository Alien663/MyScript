$sendMailMessageSplat = @{
    From = "sender@test.com"
    To = "receiver1@test.com", "receiver2@test.com"
    Subject = "Title"
    Body = "your content"
    Attachments = "file absolute path"
    Priority = 'High'
    DeliveryNotificationOption = 'OnSuccess', 'OnFailure'
    SmtpServer = 'smtp.test.com'
}

try {
    Send-MailMessage @sendMailMessageSplat
    Write-Host "Email sent successfully."
} catch {
    throw "Failed to send email. Error: $_"
}