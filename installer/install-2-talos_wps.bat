@echo off
::AT > NUL
@NET SESSION >nul 2>&1
@IF %ERRORLEVEL% EQU 0 (
    goto install
) ELSE (
    @ECHO you are NOT Administrator. Please run this script as Administrator. Exiting...
    goto finish
)

:install

pushd "%~dp0"

@echo installation paths
SET PYTHON_HOME=C:\Python39\
SET PYTHON_EXE=%PYTHON_HOME%\python.exe
IF NOT EXIST %PYTHON_EXE% (
    SET /p PYTHON_HOME="Enter python.exe path (%PYTHON_HOME%):" %=%
    SET PYTHON_EXE=%PYTHON_HOME%\python.exe
)

set talos_wps=c:\talos_wps
set wheels=%~dp0\wheels\

@echo talos_wps install files
set talos_wps_7z=%~dp0\talos_wps_install\talos_wps.7z

@echo step 2: git clone or extract talos_wps
if exist %talos_wps_7z% (
	7za x %talos_wps_7z% -aoa -o%talos_wps%
) else (
	git clone https://github.com/talos-gis/pywps-flask.git %talos_wps%
	pushd "%~dp0"
	cd /d %talos_wps%
	::git checkout talos_wps
	git pull
	popd 
)

set online=
if "%1x" neq "x" set online=y
if not exist %wheels% set online=y

set pip_offline=
if %online%x==x set pip_offline=--upgrade --no-index --find-links %wheels%

@echo step 3: install talos_wps python package requirements
%PYTHON_EXE% -m pip install --force-reinstall %pip_offline% -r %talos_wps%\requirements.txt

popd

@echo done!

:finish
pause