@echo off
set "LAB=C:\Users\kev\Documents\Database\I3306E-Project2024-25"
set "DBApp=yourDBAppName"

:: MySQL connection
set "MYSQL_USER=root"
set "MYSQL_PASS=yourpassword"
set "MYSQL_HOST=localhost"

echo Beginning...

mysql -h %MYSQL_HOST% -u %MYSQL_USER% -p%MYSQL_PASS% < "%LAB%\sql\%DBApp%_createDB.sql"        > "%LAB%\log\%DBApp%_createDB.log"
mysql -h %MYSQL_HOST% -u %MYSQL_USER% -p%MYSQL_PASS% < "%LAB%\sql\%DBApp%_createTables.sql"    > "%LAB%\log\%DBApp%_createTables.log"
mysql -h %MYSQL_HOST% -u %MYSQL_USER% -p%MYSQL_PASS% < "%LAB%\sql\%DBApp%_createTriggers.sql"  > "%LAB%\log\%DBApp%_createTriggers.log"
mysql -h %MYSQL_HOST% -u %MYSQL_USER% -p%MYSQL_PASS% < "%LAB%\sql\%DBApp%_createIndexes.sql"   > "%LAB%\log\%DBApp%_createIndexes.log"

echo End of batch file...
