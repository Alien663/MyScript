# check is volume space enough
# -------------------------------------------------------------------------------
$data = Get-Volume | select DriveLetter,SizeRemaining,Size | where DriveLetter -ne $null
foreach($vol in $data)
{
    if(($vol.SizeRemaining/$vol.Size) -le 0.2) # if size remaining <= 20%
    {
        echo ("Alert!! Volume : " + $vol.DriveLetter + " Space is going to limit")
    }
}
# -------------------------------------------------------------------------------