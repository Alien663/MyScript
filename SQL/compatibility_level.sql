-- 查相容性層級，openjson需要130才能使用
SELECT name, compatibility_level FROM sys.databases;


-- 修改資料庫的相容層級
ALTER DATABASE database_name SET COMPATIBILITY_LEVEL = 130

/*
* 微軟官方網站
* https://docs.microsoft.com/zh-tw/sql/t-sql/statements/alter-database-transact-sql-compatibility-level?view=sql-server-ver16#compatibility_level--160--150--140--130--120--110--100--90--80-
* 
*/