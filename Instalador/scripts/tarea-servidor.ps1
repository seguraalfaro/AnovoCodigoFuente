# Anovo: registra la tarea «Servidor Anovo», que arranca el servidor al encender el equipo,
# como SYSTEM, un minuto despues para que Firebird ya este arriba, sin limite de tiempo.
param([string]$Carpeta)
$ErrorActionPreference = 'Stop'
$accion = New-ScheduledTaskAction -Execute (Join-Path $Carpeta 'AnovoAPI.exe') -WorkingDirectory $Carpeta
$disparo = New-ScheduledTaskTrigger -AtStartup
$disparo.Delay = 'PT1M'
$ajustes = New-ScheduledTaskSettingsSet -ExecutionTimeLimit ([TimeSpan]::Zero) -RestartCount 3 `
  -RestartInterval (New-TimeSpan -Minutes 1) -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
$cuenta = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName 'Servidor Anovo' -Action $accion -Trigger $disparo -Settings $ajustes `
  -Principal $cuenta -Force | Out-Null
