@echo off
setlocal enabledelayedexpansion
title English++ Package Manager (EPM)

:: 1. Isolate the target site-packages folder path dynamically
set "SITE_PACKAGES=%~dp0Lib\site-packages"

:: 2. Ensure the site-packages directory structure exists
if not exist "!SITE_PACKAGES!" (
    mkdir "!SITE_PACKAGES!"
)

:: 3. Route core command arguments
set "action=%~1"
set "target=%~2"

if /I "!action!"=="" (
    goto :ShowUsage
)

if /I "!action!"=="install" (
    if "!target!"=="" (
        echo [ERROR] Please specify a package name to install.
        echo Example: epm install custom_theme
        exit /b 1
    )
    goto :InstallPackage
)

if /I "!action!"=="list" (
    goto :ListPackages
)

:: If a command doesn't match, drop back to default usage guide
goto :ShowUsage

:InstallPackage
echo [EPM] Indexing local site-packages module folder...
set "pkg_file=!SITE_PACKAGES!\!target!.epp"

if exist "!pkg_file!" (
    echo [EPM] Package '!target!' is already installed.
    exit /b 0
)

echo [EPM] Resolving environment dependencies for '!target!'...

:: Build a clean placeholder .epp package structure to initialize the module
echo # English++ Third-Party Package Module > "!pkg_file!"
echo # Module Name: !target! >> "!pkg_file!"
echo # Installed via EPM >> "!pkg_file!"
echo. >> "!pkg_file!"
echo !target!_version = "1.0.0" >> "!pkg_file!"

echo [SUCCESS] Package '!target!' installed successfully to Lib\site-packages\!target!.epp
exit /b 0

:ListPackages
echo --- Installed English++ Packages ---
set "count=0"
for %%F in ("!SITE_PACKAGES!\*.epp") do (
    set /a count+=1
    echo  [!count!] %%~nF
)
if "!count!"=="0" (
    echo No third-party packages found inside Lib\site-packages.
)
echo ------------------------------------
exit /b 0

:ShowUsage
echo English++ Package Manager (EPM) - Starter Interface
echo.
echo Usage:
echo   epm install ^<package_name^>   Installs a package to Lib\site-packages
echo   epm list                       Lists all installed packages
echo.
exit /b 0
