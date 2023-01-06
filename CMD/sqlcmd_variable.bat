sqlcmd -d Northwind -y 0 -Q "set nocount on select top 10 * from Customers for json auto set nocount off" -o "test.json"
pause

dbname="Northwind"
sqlcmd -S . -i test.sql -v the_db=%dbname%
pause