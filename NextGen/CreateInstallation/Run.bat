@echo off

rem Check if first argument was provided.
if "%1"=="" (
    echo Error: No commit SHA provided. Should be first argument
    exit 1
)

cd

rem Get all files from GitHub for specific commit SHA
git clone https://github.com/APSIMInitiative/ApsimX APSIMx
cd ApsimX
git reset --hard %1

rem Create installs
echo.
echo ########### Creating documentation
cd Documentation
call GenerateDocumentation.bat
IF ERRORLEVEL 1 GOTO END

echo.
echo ########### Creating Windows installation
cd ..\Setup
"C:\Program Files (x86)\Inno Setup 5\ISCC.exe" apsimx.iss

echo ########### Creating Debian package
cd Linux
call BuildDeb.bat

echo ########### Creating Mac OS X installation
cd "..\OS X"
call BuildMacDist.bat



rem echo ########### Uploading installations
rem cd "C:\Jenkins\workspace\1. GitHub pull request\ApsimX\Setup"
rem call C:\Jenkins\ftpcommand.bat %Issue_Number%
rem echo.
rem 
rem echo ########### Add a green build to DB
rem set /p PASSWORD=<C:\Jenkins\ChangeDBPassword.txt
rem curl -k https://www.apsim.info/APSIM.Builds.Service/Builds.svc/AddGreenBuild?pullRequestNumber=%ghprbPullId%^&buildTimeStamp=%DATETIMESTAMP%^&changeDBPassword=%PASSWORD%