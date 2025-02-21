# $mypat = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
# $AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("`:$mypat")) }
$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$(System.AccessToken)")) }
$basedURL = "$(System.TeamFoundationCollectionUri)$(System.TeamProject)/_apis"

$url1 = "$basedURL/pipelines/$(System.DefinitionId)/runs/$(Build.BuildId)"
$response = Invoke-RestMethod -Uri $url1 -Method Get -Headers $AzureDevOpsAuthenicationHeader

$mergeCommit = $response.resources.repositories.self.version
$body = @"
{
    "queries": [{
        "items": [
            "$mergeCommit"
        ],
        "type": "lastMergeCommit"
    }]
}
"@ 
$url2 = "$basedURL/git/repositories/$(Build.Repository.Name)/pullrequestquery?api-version=6.0"
$response = Invoke-RestMethod -Uri $url2 -Method Post -Headers $AzureDevOpsAuthenicationHeader -Body $body -ContentType "application/json"

$prid = $response.results."$mergeCommit".pullRequestId

$url3 = "$basedURL/git/repositories/$(Build.Repository.Name)/pullRequests/$prid/labels"
$response = Invoke-RestMethod -Uri $url3 -Method Get -Headers $AzureDevOpsAuthenicationHeader
foreach($tag in $response.value.name){
    Write-Host "##vso[build.addbuildtag]$($tag)"
}