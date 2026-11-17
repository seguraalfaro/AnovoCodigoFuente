@echo off
rem Anovo: prepara el equipo para correr las compilaciones de demostracion: restaura la base
rem en cero en C:\Anovo\demo, crea el usuario ANOVO_BACKEND y confia en el certificado de localhost.
setlocal
chcp 65001 >nul

net session >nul 2>&1
if errorlevel 1 (
  echo Abra este archivo con clic derecho, "Ejecutar como administrador".
  pause
  exit /b 1
)

set "FB="
for /f "tokens=2,*" %%a in ('reg query "HKLM\SOFTWARE\Firebird Project\Firebird Server\Instances" /v DefaultInstance 2^>nul') do set "FB=%%b"
if not defined FB (
  echo No se encontro Firebird 4. Instale Firebird 4.0 y vuelva a correr este archivo.
  pause
  exit /b 1
)
if not "%FB:~-1%"=="\" set "FB=%FB%\"

set "BASE=C:\Anovo\demo\ANOVO.FDB"
set /p "ISC_PASSWORD=Clave de SYSDBA de Firebird: "
set "ISC_USER=SYSDBA"

if exist "%BASE%" (
  echo La base %BASE% ya existe: se deja como esta.
) else (
  if not exist "C:\Anovo\demo" mkdir "C:\Anovo\demo"
  echo Restaurando la base en cero...
  "%FB%gbak.exe" -c "%~dp0Base\anovo_cero.fbk" "127.0.0.1:%BASE%" || goto fallo
)

echo Creando el usuario ANOVO_BACKEND...
> "%TEMP%\anovo-demo.sql" echo CREATE OR ALTER USER ANOVO_BACKEND PASSWORD 'AnovoDemo2026' USING PLUGIN Srp;
>> "%TEMP%\anovo-demo.sql" echo COMMIT;
"%FB%isql.exe" -q -bail -i "%TEMP%\anovo-demo.sql" "127.0.0.1:%BASE%"
set "ERR=%errorlevel%"
del "%TEMP%\anovo-demo.sql"
if not "%ERR%"=="0" goto fallo

echo Instalando el certificado de localhost en Windows...
certutil -f -addstore Root "%~dp0Win64\Servidor\certificates\servidor.crt" >nul || goto fallo

echo.
echo Listo. Abra Win64\Servidor\AnovoAPI.exe y despues Win64\Escritorio\AnovoEscritorio.exe.
pause
exit /b 0

:fallo
echo.
echo No se pudo completar. Revise la clave de SYSDBA y que el servicio de Firebird este encendido.
pause
exit /b 1
