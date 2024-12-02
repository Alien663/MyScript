EXECUTE sp_addextendedproperty N'MS_Description','表說明',N'user',N'dbo',N'table',N'表名',NULL,NULL
EXEC sp_dropextendedproperty N'MS_Description','user','dbo','table', '表名', NULL,NULL

EXECUTE sp_addextendedproperty N'MS_Description','欄位說明內容',N'user',N'dbo',N'table',N'表名',N'column',N'欄位名'
EXEC sp_dropextendedproperty N'MS_Description', 'user','dbo', 'table', '表名', 'column','欄位名'


SELECT
    a.TABLE_NAME                as 表格名稱,
    b.COLUMN_NAME               as 欄位名稱,
    b.DATA_TYPE                 as 資料型別,
    b.CHARACTER_MAXIMUM_LENGTH  as 最大長度,
    b.COLUMN_DEFAULT            as 預設值,
    b.IS_NULLABLE               as 允許空值,
    (
        SELECT
            value
        FROM
            fn_listextendedproperty (NULL, 'schema', 'dbo', 'table', a.TABLE_NAME, 'column', default)
        WHERE
            name='MS_Description' 
            and objtype='COLUMN' 
            and objname Collate Chinese_Taiwan_Stroke_CI_AS=b.COLUMN_NAME
    ) as 欄位備註
FROM
    INFORMATION_SCHEMA.TABLES  a
    LEFT JOIN INFORMATION_SCHEMA.COLUMNS b ON (a.TABLE_NAME=b.TABLE_NAME)
WHERE
    TABLE_TYPE='BASE TABLE'
ORDER BY
    a.TABLE_NAME, ordinal_position