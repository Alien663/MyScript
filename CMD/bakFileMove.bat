set today=%date:~0,4%%date:~5,2%%date:~8,2%
set serverList=Server1 Server2 Server3
for %%i in (%serverList%) do (echo %%i%today%.bak)
pause