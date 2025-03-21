$logfile = "D:\log.txt"

try{
    sajlksd
}
catch{
    echo "-------------------------------------------------------------------------" >> $logfile
    echo "Error Occur :" >> $logfile
    echo $Error[0] >> $logfile
    echo "-------------------------------------------------------------------------" >> $logfile
} 