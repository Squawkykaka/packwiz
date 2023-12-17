@echo off
setlocal

:: Set the pack name
set "packname=Squawkypack"
set "packwizdownload=false"
set "packwizlocation=https://github.com/Squawkykaka/packwiz/raw/master/Squawkypack-packwiz.zip"

:: Process all arguments
for %%a in (%*) do (
    if "%%~a" == "--help" goto :help
    if "%%~a" == "-h" goto :help
    if "%%~a" == "--modlist" set "modlist=true"
    if "%%~a" == "-m" set "modlist=true"
    if "%%~a" == "--download" set "packwizdownload=true"
    if "%%~a" == "-d" set "packwizdownload=true"
)

where /q packwiz
if errorlevel 1 (
    echo packwiz is not installed. Please install it and try again.
    exit /b
)

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

:: Check for --modlist flag
if "%modlist%" == "true" (
    where /q cargo
    if errorlevel 1 (
        echo cargo is not installed. Please install it and try again.
        exit /b
    )
    where /q packwizml
    if errorlevel 1 (
        echo Installing packwiz-modlist...
        cargo install packwiz-modlist
    )
    echo Generating modlist...
    packwizml --output modlist.md -F
)

:: Download packwiz autoupdate modpack
if "%packwizdownload%" == "true" (
    echo Downloading packwiz modpack...
    cd output 
    curl -LO %packwizlocation%
    cd ..
)

echo Done!

goto :eof

:help
    echo Usage: build.bat [OPTIONS]
    echo.
    echo Options:
    echo   --modlist, -m Generate a modlist using packwiz-modlist
    echo   --download, -d Download packwiz modpack
    echo   --help, -h Show this message
    exit /b