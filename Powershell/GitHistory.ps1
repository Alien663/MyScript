$logs = git log
foreach($log in $logs){
    if($log -like "commit *"){
        $commitid=$log.split(" ")[1]
        git show $commitid --name-only
    }
}
