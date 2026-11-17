@echo off
rem Anovo: compila API y escritorio en Release (Win32 y Win64) en sus carpetas de salida
rem de Delphi y genera los instaladores del servidor y del escritorio.
setlocal
set RAIZ=%~dp0..
call "F:\Program Files (x86)\Embarcadero\Studio\21.0\bin\rsvars.bat" || exit /b 1

for %%P in (Win32 Win64) do (
  msbuild "%RAIZ%\Backend\AnovoAPI.dproj" /t:Build /p:Config=Release /p:Platform=%%P /v:minimal /nologo || exit /b 1
  msbuild "%RAIZ%\Desktop\AnovoEscritorio.dproj" /t:Build /p:Config=Release /p:Platform=%%P /v:minimal /nologo || exit /b 1
)

for %%I in (servidor escritorio) do (
  "F:\Program Files\Inno Setup 7\ISCC.exe" /DProducto=%%I "%~dp0anovo.iss" || exit /b 1
)
"F:\Program Files\Inno Setup 7\ISCC.exe" /DProducto=servidor /DEdicion=cero "%~dp0anovo.iss" || exit /b 1
endlocal
