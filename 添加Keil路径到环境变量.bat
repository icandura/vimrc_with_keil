@echo off
echo ��C�̲�ѯ Keil_MDK ��UV4.exe������λ��

for /r C:\ %%i in (uv4.e?e) do set uv4_exe=%%i
if defined uv4_exe (goto hasUV4) else (goto noUV4)

:hasUV4
echo ��������λ���ҵ�UV4.exe
echo %uv4_exe%

set uv4_path=%uv4_exe:~0,-8%
echo ����·��Ϊ
echo %uv4_path%

set env_path=%PATH%
echo %env_path%|findstr %uv4_path% >nul
if %errorlevel% equ 0 (echo ����ӹ��û�������) else (goto SETPATH)
goto ENDING

:SETPATH
echo ���ڽ�UV4.exe����·�����Ϊ��������
echo ��ע�������ӵ���ǰ�û����������У�
set env_path=%path%;%uv4_path%
echo %env_path%
setx path "%env_path%"
echo ������
goto ENDING

:noUV4
echo δ��C���ҵ�UV4.exe�����ֶ���ӻ�������
goto ENDING

:ENDING
pause
