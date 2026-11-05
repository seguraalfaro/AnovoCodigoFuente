# Anovo: escribe en -Salida las IPv4 del equipo, una por linea, sin loopback ni APIPA.
param([string]$Salida)
$ips = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
  Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254.*' } |
  Select-Object -ExpandProperty IPAddress -Unique
Set-Content -Encoding Ascii -Path $Salida -Value $ips
