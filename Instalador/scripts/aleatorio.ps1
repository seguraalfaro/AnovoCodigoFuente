# Anovo: escribe en -Salida una clave aleatoria en hexadecimal de -Bytes bytes.
param([int]$Bytes, [string]$Salida)
$b = New-Object byte[] $Bytes
[Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($b)
Set-Content -Encoding Ascii -NoNewline -Path $Salida -Value (-join ($b | ForEach-Object { $_.ToString('x2') }))
