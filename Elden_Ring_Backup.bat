@Echo off
setlocal enabledelayedexpansion

REM This is the path to the saves
set SavesPath=%UserProfile%\AppData\Roaming\EldenRing

REM This is how often we want to make backups (in seconds)
set /A frequency=600


REM check if the folder exists
if not exist %SavesPath% (
	echo ERROR: Could not find directory!
	echo %SavesPath%
	exit 1
)

REM Get the profile subfolder path, exit if multiple profiles exist
for /f "tokens=*" %%G IN ('dir /b /A:D %SavesPath%') DO (
	if !count!==1 (
		REM goto :ERMultipleProfileHandler
		echo ERROR: Multiple profiles detected!
		exit 1
	)
	set SavesPath=%SavesPath%\%%G
	set count=1
)

:loop
	REM Reformat the time variable, because batch is stupid
	For /f "tokens=1-2 delims=/:" %%a in ("%time%") do (set mytime=%%a-%%b)

	REM Set the path to the backups
	set BackupPath=%SavesPath%\backups\%date%\%mytime%

	REM Create the folder structure if it don't exist
	if not exist %BackupPath% (
		mkdir %BackupPath%
	)

	REM Copy the files
	copy %SavesPath%\*.* %BackupPath% > NUL
	echo Backed up: %date% %mytime%

	REM Sleep for %frequency% defined at the top
	timeout /T %frequency% /nobreak > NUL

	goto :loop
