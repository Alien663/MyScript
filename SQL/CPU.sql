SET QUOTED_IDENTIFIER ON
GO

    while (1=1) begin
        select text,hostprocess,* from sys.sysprocesses 
        cross apply sys.dm_exec_sql_text(sql_handle)
        where text like '%sp_server_diagnostics%' and program_name like '%Operating System%'

        waitfor delay '00:00:10'
    end