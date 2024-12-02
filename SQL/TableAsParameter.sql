CREATE TYPE test_table as TABLE
(
    TID int,
    Since date,
    TName varchar(100)
)
go

create procedure xp_testInsertTable
@tt test_table readonly
as begin
	select * from @tt
end
go

declare @kk test_table
insert into @kk(TID, Since, TName)
	values
		(1, GETDATE(), 'a'),
		(2, GETDATE(), 'b'),
		(3, GETDATE(), 'c'),
		(4, GETDATE(), 'd')

exec xp_testInsertTable @kk

drop procedure xp_testInsertTable
drop type test_table