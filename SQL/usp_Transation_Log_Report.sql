USE [master]
GO
/****** Object:  StoredProcedure [dbo].[usp_Transation_Log_Report]    Script Date: 2022/9/27 上午 09:19:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_Transation_Log_Report]
AS
BEGIN
SELECT 'QSMC' [SITE], LS.MONITOR_SERVER, LS.PRIMARY_SERVER,LS.PRIMARY_DATABASE,LSD.RESTORE_DELAY,
DATEDIFF(MI,LMS.LAST_RESTORED_DATE,GETDATE()) AS [TIME_SINCE_LAST_RESTORE(mins)],
LMS.LAST_RESTORED_DATE,LMS.LAST_RESTORED_FILE
INTO #LOG 
FROM MSDB.DBO.LOG_SHIPPING_SECONDARY LS
JOIN MSDB.DBO.LOG_SHIPPING_SECONDARY_DATABASES LSD
  ON LSD.SECONDARY_ID=LS.SECONDARY_ID
JOIN MSDB.DBO.LOG_SHIPPING_MONITOR_SECONDARY LMS
  ON LMS.SECONDARY_ID=LSD.SECONDARY_ID




DECLARE @eventData XML;
DECLARE @REPORTHTML  NVARCHAR(MAX);
DECLARE @MAILLIST VARCHAR(1000);
DECLARE @SUBJECT AS VARCHAR(200);
DECLARE @Header AS VARCHAR(100) ='[GL_Info]';
SET @eventData = eventdata();

SELECT TOP 1 @Header = '[GL_Critical]' FROM #LOG WHERE [TIME_SINCE_LAST_RESTORE(mins)] > 1440

	SET @MAILLIST = ''
	SELECT @MAILLIST = 'GL-Sys_ITSupport@quantatw.com'

	SET @SUBJECT = @Header + 'GL/OF QSMC Transaction Log Shipping Status ' + CONVERT(VARCHAR,GETDATE(),20);	
	SET @REPORTHTML =
		N'Dear ALL,<BR> The following information is for your reference. ' +
		N'<table border="1">' +
		N'<tr bgcolor =''#ffff33''><th>SITE</th><th>DR_SERVER</th><th>PRIMARY_SERVER</th><th>PRIMARY_DATABASE</th><th>LAST_RESTORED_DATE</th><th>LAST_RESTORED_FILE</th><th>[TIME_SINCE_LAST_RESTORE(mins)]</th></tr>' +
		CAST ( ( 
		SELECT Distinct 
						td = A.[SITE], '',
						td = A.MONITOR_SERVER, '',
						td = A.PRIMARY_SERVER, '',
						td = A.PRIMARY_DATABASE, '',
						td = A.LAST_RESTORED_DATE, '',
						td = A.LAST_RESTORED_FILE, '',
						td = A.[TIME_SINCE_LAST_RESTORE(mins)], ''
		FROM #LOG AS A
		FOR XML PATH('tr'), TYPE 
		) AS NVARCHAR(MAX) ) +
		N'</table>';

		
		

	EXEC msdb.dbo.sp_send_dbmail @profile_name = 'AlertMail',
								 @RECIPIENTS= @MAILLIST ,
								 @SUBJECT=@SUBJECT,
								 @BODY = @REPORTHTML,
								 @body_format = 'HTML' ;


END
