/*
* This program will restore database and send it's table schema by EMail.
* There are 4 steps bellow :
* 1. create the table about database name and backup file path
* 2. restore database and get talbe schema one by one(restore to default path)
* 3. send EMail(dbname, table schema)
* 4. drop database
* remark : database restore mode cant modify, no need to full
* 	       modify step 2 to your backup file format 
* 
*/
set nocount on
-- 1. create the table about database name and backup file path
declare @temp table(RN int, dbname varchar(10), backfile varchar(255), result varchar(max))
insert into @temp(RN, dbname, backfile)
    select ROW_NUMBER() over(order by a) as RN, *
	from( values
        ('mydatabase', '\\remote path')
    ) T(a, b, c)
declare @counts int = (select count(*) from @temp)
declare @i int = 1
declare @today varchar(10) = (select convert(varchar(10), DATEADD(dd, -1, GETDATE()), 112))

-- 2. restore database and get talbe schema one by one(restore to default path)
while @i <= @counts begin
    begin try
        declare @the_dbname varchar(30) = (select dbname + '_' + @today from @temp where RN = @i)
        declare @default_datapath varchar(200), @default_logpath varchar(200)
        SELECT @default_datapath = convert(varchar(200), SERVERPROPERTY('InstanceDefaultDataPath')),--get sql server default path
            @default_logpath = convert(varchar(200), SERVERPROPERTY('InstanceDefaultLogPath'))
        -- restore dastabase
        declare @sql varchar(max)= '
            restore database ' + @the_dbname + '
            from disk='''+ (select backfile + '\' + @the_dbname from @temp where RN = @i ) + '.bak''
            WITH  FILE = 1,
            MOVE ''' + (select dbname from @temp where RN = @i) + ''' TO ''' + @default_datapath + @the_dbname + '.mdf'',
            MOVE ''' + (select dbname from @temp where RN = @i) + '_log'' TO ''' + @default_logpath + @the_dbname + '_log.ldf'',
            NOUNLOAD,  STATS = 5'
        print(@sql) -- for debug, can remove if no need
        exec(@sql)
        -- get database's schema
        declare @check nvarchar(max) = ' set @result = (
            SELECT ''' + @the_dbname + '''  as DBName, TABLE_NAME 
            FROM [' + @the_dbname + '].INFORMATION_SCHEMA.TABLES
            WHERE TABLE_TYPE = ''BASE TABLE''
            for json path)'
        print(@check) -- for debug, can remove if no need
        declare @tt varchar(max) = ''
        exec sp_executesql @check, N'@result varchar(max) OUTPUT', @result = @tt OUTPUT
        update @temp set result = @tt where RN = @i
    end try
    begin catch 
        declare @errmsg nvarchar(max) = (select ERROR_MESSAGE())
        update @temp set result = @errmsg where RN = @i
    end catch
    set @i += 1
end
-- 3. send EMail(dbname, table schema)
declare @MailList varchar(100) = 'receiver@test.com'
declare @subject varchar(200) = '[Noitfy] Database Restore Drill Report'
declare @reporthtml varchar(max) = N'
    This is the report of restoring result
    <table border="1">
    <tr bgcolor="#ffff33"><th>Index</th><th>DB Name</th><th>Result</th></tr>' +
    CAST(
            (select
                td=RN, '',
                td=dbname, '',
                td=result, ''
            from @temp
            for xml path('tr'), TYPE)
        as nvarchar(max))
    + N'</table>'
EXEC msdb.dbo.sp_send_dbmail @profile_name = 'AlertMail',
							 @RECIPIENTS= @MailList ,
							 @SUBJECT=@subject,
							 @BODY = @reporthtml,
							 @body_format = 'HTML' ;
-- 4. drop database
set @i = 1
while @i <= @counts begin
    set @the_dbname = (select dbname + '_' + @today from @temp where RN = @i)
    if exists(select 1 from sys.databases DBS where [name] = @the_dbname)
        exec('drop database ' + @the_dbname)
    set @i += 1
end
set nocount off