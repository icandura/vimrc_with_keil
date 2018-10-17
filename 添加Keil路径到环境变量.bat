@echo off
echo 在C盘查询 Keil_MDK （UV4.exe）所在位置

for /r C:\ %%i in (uv4.e?e) do set uv4_exe=%%i
if defined uv4_exe (goto hasUV4) else (goto noUV4)

:hasUV4
echo 已在下列位置找到UV4.exe
echo %uv4_exe%

set uv4_path=%uv4_exe:~0,-8%
echo 所在路径为
echo %uv4_path%

set env_path=%PATH%
echo %env_path%|findstr %uv4_path% >nul
if %errorlevel% equ 0 (echo 已添加过该环境变量) else (goto SETPATH)
goto ENDING

:SETPATH
echo 正在将UV4.exe所在路径添加为环境变量
echo （注：仅增加到当前用户环境变量中）
set env_path=%path%;%uv4_path%
echo %env_path%
setx path "%env_path%"
echo 添加完成
goto ENDING

:noUV4
echo 未在C盘找到UV4.exe，请手动添加环境变量
goto ENDING

:ENDING
pause
