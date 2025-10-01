BULK INSERT dbo.LOGData
FROM 'D:\Project\Server Manage\ACL\ACL6\MIS-OF-DB-deny.csv'
WITH (
    FORMAT = 'CSV',                -- SQL 2019 開始支援 CSV 格式
    FIRSTROW = 2,                  -- 如果第一列是標題，從第2列開始
    FIELDTERMINATOR = ',',         -- 欄位分隔符號
    ROWTERMINATOR = '0x0a',          -- 換行符號（Windows 預設為 '\r\n'）
    TABLOCK,                       -- 提高效能
    CODEPAGE = '65001'             -- UTF-8 編碼
);

