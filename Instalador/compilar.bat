@echo off
rem Anovo: compila API y escritorio en Release (Win32 y Win64) y genera el instalador.
setlocal
set RAIZ=%~dp0..
set SALIDA=%~dp0compilado
call "F:\Program Files (x86)\Embarcadero\Studio\21.0\bin\rsvars.bat" || exit /b 1

for %%P in (Win32 Win64) do (
  msbuild "%RAIZ%\Backend\AnovoAPI.dproj" /t:Build /p:Config=Release /p:Platform=%%P /p:DCC_ExeOutput="%SALIDA%\%%P" /v:minimal /nologo || exit /b 1
  msbuild "%RAIZ%\Desktop\AnovoEscritorio.dproj" /t:Build /p:Config=Release /p:Platform=%%P /p:DCC_ExeOutput="%SALIDA%\%%P" /v:minimal /nologo || exit /b 1
)

"F:\Program Files\Inno Setup 7\ISCC.exe" "%~dp0anovo.iss" || exit /b 1
endlocal
