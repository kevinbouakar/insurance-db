@echo off
set "LAB=C:\Users\kev\Documents\Database\InsuranceDB-Project"
set "DBApp=InsuranceDB"
set "MYSQL_USER=root"
@REM set "MYSQL_PASS=admin4321"
set /p MYSQL_PASS=Enter MySQL root password: 
set "MYSQL_HOST=localhost"

echo Beginning InsuranceDB setup...

"C:\Program Files\MySQL\MySQL Server 9.5\bin\mysql.exe" -h %MYSQL_HOST% -u %MYSQL_USER% -p%MYSQL_PASS% < "%LAB%\SQL\%DBApp%_createDB.sql" > "%LAB%\LOG\%DBApp%_createDB.log" 2>&1
"C:\Program Files\MySQL\MySQL Server 9.5\bin\mysql.exe" -h %MYSQL_HOST% -u %MYSQL_USER% -p%MYSQL_PASS% %DBApp% < "%LAB%\SQL\%DBApp%_createTables.sql" > "%LAB%\LOG\%DBApp%_createTables.log" 2>&1
"C:\Program Files\MySQL\MySQL Server 9.5\bin\mysql.exe" -h %MYSQL_HOST% -u %MYSQL_USER% -p%MYSQL_PASS% %DBApp% < "%LAB%\SQL\%DBApp%_createIndexes.sql" > "%LAB%\LOG\%DBApp%_createIndexes.log" 2>&1
"C:\Program Files\MySQL\MySQL Server 9.5\bin\mysql.exe" -h %MYSQL_HOST% -u %MYSQL_USER% -p%MYSQL_PASS% %DBApp% < "%LAB%\SQL\%DBApp%_createTriggers.sql" > "%LAB%\LOG\%DBApp%_createTriggers.log" 2>&1
"C:\Program Files\MySQL\MySQL Server 9.5\bin\mysql.exe" -h %MYSQL_HOST% -u %MYSQL_USER% -p%MYSQL_PASS% %DBApp% < "%LAB%\SQL\%DBApp%_createViews.sql" > "%LAB%\LOG\%DBApp%_createViews.log" 2>&1
"C:\Program Files\MySQL\MySQL Server 9.5\bin\mysql.exe" -h %MYSQL_HOST% -u %MYSQL_USER% -p%MYSQL_PASS% %DBApp% < "%LAB%\SQL\%DBApp%_createRoles.sql" > "%LAB%\LOG\%DBApp%_createRoles.log" 2>&1
"C:\Program Files\MySQL\MySQL Server 9.5\bin\mysql.exe" -h %MYSQL_HOST% -u %MYSQL_USER% -p%MYSQL_PASS% %DBApp% < "%LAB%\SQL\%DBApp%_createProcedures.sql" > "%LAB%\LOG\%DBApp%_createProcedures.log" 2>&1
"C:\Program Files\MySQL\MySQL Server 9.5\bin\mysql.exe" -h %MYSQL_HOST% -u %MYSQL_USER% -p%MYSQL_PASS% %DBApp% < "%LAB%\SQL\%DBApp%_insertData.sql" > "%LAB%\LOG\%DBApp%_insertData.log" 2>&1

echo Setup complete! Check LOG folder for results.
pause
