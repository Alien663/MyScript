# select data
$physicalPath = (Get-Website | Select-Object).PhysicalPath
Get-Website | ConvertTo-Json | ConvertFrom-Json | Select-Object -Property Name, PhysicalPath

# true / false judge
"abcdefg", "defghi" -match "abc"


# declare object list
$data = @( @{ Name="123";YearOld=15}, @{Name="ABC";YearOld=20})

# object array can not modify
$array1 = @("A", "B", "C")
$array1.GetType()
$array1.Add("D")

# ArrayList array can modify
$array2 = [System.Collections.ArrayList]@("A", "B", "C")
$array2.GetType()
$array2.Add("D")


$today = get-date -format "yyyyMMdd"