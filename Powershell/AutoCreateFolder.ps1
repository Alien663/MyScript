$report_file = "./report.json"
$folder_list = $report_file -split "\\"
$folder = $folder_list[0..($folder_list.count-2)] -join "\"
if(!(Test-Path $folder)){
    New-Item $folder -Type Directory
}