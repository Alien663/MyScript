backup database [Member] to disk='null' with copy_only
--BACKUP DATABASE 已於 0.017 秒內成功處理了 473 頁 (216.997 MB/sec)。

backup database [Member] to disk='C:\temp\test.bak' with copy_only
--BACKUP DATABASE 已於 0.018 秒內成功處理了 473 頁 (204.942 MB/sec)。

print(473 * 8.0 / 1024 / (0.018 - 0.017)) -- write speed : MB/sec