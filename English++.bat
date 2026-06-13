@echo off
setlocal enabledelayedexpansion
title English++ Interpreter (.epp)

:: 1. Verify a file was provided
if "%~1" == "" (
    echo [ERROR] No file specified. Usage: English++.bat script.epp
    pause
    exit /b
)

:: 2. Enforce the .epp extension
if /I not "%~x1" == ".epp" (
    echo [ERROR] English++ can only execute .epp files.
    pause
    exit /b
)

:: 3. Build a clean temporary script file to run the code
set "temp_runner=%temp%\epp_runtime_%random%.bat"
echo @echo off > "%temp_runner%"
echo setlocal enabledelayedexpansion >> "%temp_runner%"

:: 4. Compile the main .epp source code lines into the runtime script
for /f "usebackq delims=" %%L in ("%~1") do (
    set "line_raw=%%L"
    set "line_strip=!line_raw: =!"
    
    if not "!line_strip!"=="" if not "!line_strip:~0,1!"=="#" (
        for /f "tokens=1* delims= " %%A in ("!line_raw!") do (
            set "cmd_name=%%A"
            set "cmd_args=%%B"
            set "cmd_name_clean=!cmd_name: =!"
            
            :: CONTROL STRUCTURES
            if "!cmd_name_clean!" == "if" (
                for /f "tokens=1,2,3" %%G in ("!cmd_args!") do (
                    echo if "^!%%G^!" %%H "%%I" ^( >> "%temp_runner%"
                )
            ) else if "!cmd_name_clean!" == "else" (
                echo ^) else ^( >> "%temp_runner%"
            ) else if "!cmd_name_clean!" == "endif" (
                echo ^) >> "%temp_runner%"
            ) else (
                :: VARIABLE MANIPULATION AND ASSIGNMENTS
                set "is_assign=0"
                echo !line_raw!| find "=" >nul && set "is_assign=1"
                
                if "!is_assign!" == "1" (
                    for /f "tokens=1,2 delims==" %%M in ("!line_raw!") do (
                        set "v_name=%%M"
                        set "v_val=%%N"
                        set "v_name=!v_name: =!"
                        if "!v_val:~0,1!"==" " set "v_val=!v_val:~1!"
                        
                        if "!v_val!"=="input" (
                            echo set /p "!v_name!= " >> "%temp_runner%"
                        ) else (
                            :: Check if value starts with a quote mark safely
                            set "first_char=!v_val:~0,1!"
                            if "!first_char!"=="""" (
                                echo set "!v_name!=!v_val!" >> "%temp_runner%"
                            ) else (
                                set "has_dot=0"
                                echo !v_val!| find "." >nul && set "has_dot=1"
                                if "!has_dot!"=="1" (
                                    echo for /f "delims=" %%%%M in ^('powershell -Command "[double]$res = !v_val!; [math]::Round^($res, 4^)"'^) do set "!v_name!=%%%%M" >> "%temp_runner%"
                                ) else (
                                    echo set /a "!v_name!=!v_val!" 2^>nul ^|^| set "!v_name!=!v_val!" >> "%temp_runner%"
                                )
                            )
                        )
                    )
                ) else (
                    :: CORE KEYWORD SYSTEM RUNTIMES
                    if "!cmd_name_clean!" == "print" (
                        echo if defined !cmd_args! ^( call echo %%%%!cmd_args!%%%% ^) else ^( echo !cmd_args! ^) >> "%temp_runner%"
                    )
                    if "!cmd_name_clean!" == "clear" (
                        echo cls >> "%temp_runner%"
                    )
                    if "!cmd_name_clean!" == "color" (
                        echo color !cmd_args! >> "%temp_runner%"
                    )
                    
                    :: DYNAMIC LIBRARIES HOOK
                    if "!cmd_name_clean!" == "include" (
                        set "found_path="
                        if exist "%~dp0!cmd_args!.epp" set "found_path=%~dp0!cmd_args!.epp"
                        if exist "%~dp0Lib\!cmd_args!.epp" set "found_path=%~dp0Lib\!cmd_args!.epp"
                        if exist "%~dp0Lib\site-packages\!cmd_args!.epp" set "found_path=%~dp0Lib\site-packages\!cmd_args!.epp"
                        
                        if not "!found_path!"=="" (
                            for /f "usebackq delims=" %%I in ("!found_path!") do (
                                set "l_line=%%I"
                                set "l_check=!l_line: =!"
                                if not "!l_check!"=="" if not "!l_check:~0,1!"=="#" (
                                    for /f "tokens=1,2 delims==" %%X in ("!l_line!") do (
                                        set "l_var=%%X"
                                        set "l_val=%%Y"
                                        set "l_var=!l_var: =!"
                                        if "!l_val:~0,1!"==" " set "l_val=!l_val:~1!"
                                        
                                        :: Robust native character validation inside the library loader
                                        set "l_first_char=!l_val:~0,1!"
                                        if "!l_first_char!"=="""" (
                                            echo call set "!l_var!=!l_val!" >> "%temp_runner%"
                                        ) else (
                                            set "l_has_dot=0"
                                            echo !l_val!| find "." >nul && set "l_has_dot=1"
                                            if "!l_has_dot!"=="1" (
                                                echo for /f "delims=" %%%%K in ^('powershell -Command "[double]$res = !l_val!; [math]::Round^($res, 4^)"'^) do set "!l_var!=%%%%K" >> "%temp_runner%"
                                            ) else (
                                                echo call set "!l_var!=!l_val!" >> "%temp_runner%"
                                            )
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )
)

:: 5. Execute project footprint context
call "%temp_runner%"

:: 6. Clean temporary workspace generations
del "%temp_runner%"
echo.
echo --- Program Finished ---
pause
