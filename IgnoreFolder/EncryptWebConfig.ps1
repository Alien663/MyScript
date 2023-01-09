# find program in the searching path
$Programs = @()
$ProgramName = 'aspnet_regiis.exe'
$SearchingPath = 'C:\Windows\Microsoft.NET\Framework'
$Programs += Get-ChildItem -Path $SearchingPath -Filter $ProgramName -Recurse -Force | %{$_.FullName}
cd $Programs[$Programs.count-1].replace('aspnet_regiis.exe', '')
Copy-Item "\\sapfs5vm\Documentation\GL\Server Management\CA\ConfigKey\GLConfigurationKey.xml" -Destination "D:\"
Copy-Item "\\sapfs5vm\Documentation\GL\Server Management\CA\ConfigKey\OFConfigurationKey.xml" -Destination "D:\"
.\aspnet_regiis.exe -pi "OFConfigurationKey" D:\OFConfigurationKey.xml
.\aspnet_regiis.exe -pi "GLConfigurationKey"  D:\OFConfigurationKey.xml
