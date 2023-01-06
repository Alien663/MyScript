# select data
$physicalPath = (Get-Website | Select-Object).PhysicalPath


# true / false judge
"abcdefg", "defghi" -match "abc"


# declare object list
$data = @( @{ Name="123";YearOld=15}, @{Name="ABC";YearOld=20})