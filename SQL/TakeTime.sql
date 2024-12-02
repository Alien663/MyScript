declare @time1 datetime = '20220811'
declare @time2 datetime = getdate()

UPDDAT = convert(varchar, getutcdate(), 112),
UPDTIM = replace(convert(varchar, getutcdate(), 8), ':', '')

SELECT CONVERT(VARCHAR,
		DATEADD(s,
			DATEDIFF(ss, @time1, @time2), '1900/01/01'), 108) as TakeTime

select
	convert(varchar, getutcdate(), 112) as str_date,
	replace(convert(varchar, getutcdate(), 8), ':', '') as str_time,
	format(getdate(),'yyyyMMdd') as str_date2,
	format(getdate(),'HHmmss') as str_time2
