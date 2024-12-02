DECLARE @t TABLE
(
    StartDate DATETIME,
	EndDate DATETIME
);

INSERT INTO @t( StartDate, EndDate )
	VALUES ('2017/01/01', '2018/01/01');

;WITH CTE (Dates,EndDate) AS
(
	SELECT StartDate AS Dates,EndDate AS EndDate
	FROM @t
	UNION ALL --注意這邊使用 UNION ALL
	SELECT DATEADD(MONTH,1,Dates),EndDate
	FROM CTE 
	WHERE DATEADD(MONTH,1,Dates) < EndDate --判斷是否目前遞迴月份小於結束日期
)

SELECT CTE.Dates
FROM CTE

WITH Tree
AS
(
	SELECT CBID Id, PBID ParentId
	FROM Inheritance P
	WHERE P.CBID = 1 -- parent id
	UNION ALL
	SELECT C.CBID, C.PBID
	FROM Inheritance C
		INNER JOIN Tree T ON C.PBID = T.Id
)
SELECT * FROM Tree