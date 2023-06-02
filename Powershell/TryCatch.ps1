$logfile = "D:\log.txt"

try{
    sajlksd
}
catch{
    echo "-------------------------------------------------------------------------" >> $logfile
    echo "Error Occur :" >> $logfile
    echo $_ >> $logfile
    echo "-------------------------------------------------------------------------" >> $logfile
} 