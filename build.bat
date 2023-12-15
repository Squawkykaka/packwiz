@echo off
setlocal

where /q packwiz
if errorlevel 1 (
    echo packwiz is not installed. Please install it and try again.
    exit /b
)

:: Set the pack name
set "packname=Squawkypack"
set "packwizdownload=true"
set "packwizlocation=https://github.com/Squawkykaka/packwiz/raw/master/Squawkypack-packwiz.zip"


:: Remove old output files
if exist "output\" (
    echo Removing old output files...
    rmdir /s /q "output"
)

:: Check if output directory exists, if not create it
if not exist "output\" (
    echo Creating output directory...
    mkdir "output"
)


:: Extract the version from the pack.toml file
for /f "tokens=2 delims==" %%a in ('findstr /b /c:"version =" pack.toml') do set "version=%%a"

:: Export the modpack for Modrinth and CurseForge
echo Exporting modpack...
packwiz mr export -o output\%packname%-modrinth.mrpack
packwiz cf export -o output\%packname%-curseforge.zip

:: Download packwiz autoupdate modpack
if %packwizdownload% == true (
    echo Downloading packwiz modpack...
    cd output 
    curl -LO %packwizlocation%
    cd ..
)

echo Done!