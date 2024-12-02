# Learning Deadlock case by "Deadlock Notification From GLDB02-1 at 2022/11/4 (週五) 上午 10:12"

## Sample to create a deadlock

* Create data to test([from open database of Microsoft](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms))

```sql
-- Invoices
SELECT *
INTO dbo.Invoices
FROM [AdventureWorks].[Sales].[SalesOrderHeader]
-- InvoiceDetails
SELECT *
INTO dbo.InvoiceDetails
FROM [AdventureWorks].[Sales].[SalesOrderDetail]
```

* Run code bellow as session A

```sql
DECLARE @SalesOrderId BIGINT;
DECLARE @SumValue BIGINT;
SET @SalesOrderId = 43659;
 
--SELECT * From dbo.Invoices where SalesOrderId = @SalesOrderId ;
 
BEGIN TRAN
 
SELECT @SumValue = SUM(LineTotal) -- we will round up to next int
FROM dbo.InvoiceDetails --WITH(ROWLOCK,XLOCK)
WHERE SalesOrderId = @SalesOrderId 
 
UPDATE dbo.Invoices 
SET 
    SubTotal = @SumValue ,
TaxAmt   = @SumValue * .21
WHERE SalesOrderId = @SalesOrderId
;
--  rollback tran
```

* Run code bellow as session B

```sql
DECLARE @SalesOrderId BIGINT;
DECLARE @SumValue BIGINT;
SET @SalesOrderId = 43659;
 
BEGIN TRAN
 
UPDATE dbo.InvoiceDetails SET LineTotal = 0 where SalesOrderId = @SalesOrderId ;
SELECT * FROM dbo.Invoices where SalesOrderId = @SalesOrderId ;

--  rollback tran
```

* back to session A and run code bellow

```sql
select * from dbo.InvoiceDetails;
```

* It can check transactin

```sql
SELECT * FROM sys.sysprocesses WHERE open_tran = 1
```

## How to solve it

解決方法不只一種，可以透過多種方式

1. 減少將select納入到transaction中
2. 強制鎖定方式，利用 WITH(ROWLOCK,XLOCK)讓lock彼此互斥，這樣session B就必須等到session A的交易提交或是rollback之後才能執行

## Why don't use "nolock"

使用nolock應該要非常謹慎，因為nolock會將尚未commit的資料一併取得，若資料後來被那個交易給rollback，那使用nolock查出來的資料就從髒資料變成錯誤資料了。

以下範例中，先執行session A，在執行session B，可以看到看到session B取出的資料是session A尚未commit的結果，是為髒資料

* session A

```sql
create table TT(
    TID int identity(1,1 ),
    TName nvarchar(4),
    TDes varchar(4),
    constraint PK_TT primary key(TID)    
)
go
insert into TT(TName, TDes)
select * from (values
    (N'我不會飛', 'abcd'),
    ('abcd', 'abcd')
) T(TID, TName, TDes)
go

begin transaction
update TT
    set TDes = 'test'
    where TID = 1

--rollback transaction
```

* session B

```sql
select * from TT with(nolock)
```

## References

[What are SQL Server deadlocks and how to monitor them](https://www.sqlshack.com/what-are-sql-server-deadlocks-and-how-to-monitor-them/)

[高併發系統系列-不得不了解的Isolation Level(by 錢包被扣到變負值)](https://isdaniel.github.io/db-isolation/)

[ACID](https://isdaniel.github.io/acid/)

[淺談SqlServer Lock(一)](https://isdaniel.github.io/dblock-1/)
