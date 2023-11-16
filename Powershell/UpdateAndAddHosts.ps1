$data = @(
    [pscustomobject]@{ip="127.0.0.10";url="http://test1"},
    [pscustomobject]@{ip="127.0.0.2";url="http://test2"},
    [pscustomobject]@{ip="127.0.0.3";url="http://test3"})

$hosts_content = Get-Content $env:windir\System32\drivers\etc\hosts
foreach($item in $data){
    $temp = $hosts_content | ?{$_ -imatch ("\s" + $item.url)}
    if($temp -eq $null){
        echo 1
        $hosts_content += ($item.ip + " " + $item.url)
    } else {
        echo 0
        $idx = [array]::indexof($hosts_content, $temp)
        $hosts_content[$idx] += ($item.ip + " " + $item.url)
    }
}
$hosts_content | Out-File -FilePath "$env:windir\System32\drivers\etc\hosts" -encoding ascii