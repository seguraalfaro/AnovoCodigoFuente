# Anovo: se conecta al servidor por TLS y guarda en -Salida el certificado que presenta (PEM).
param([string]$Servidor, [int]$Puerto, [string]$Salida)
$ErrorActionPreference = 'Stop'
$tcp = New-Object Net.Sockets.TcpClient
$tcp.Connect($Servidor, $Puerto)
try {
  $aceptar = [Net.Security.RemoteCertificateValidationCallback] { $true }
  $tls = New-Object Net.Security.SslStream($tcp.GetStream(), $false, $aceptar)
  $tls.AuthenticateAsClient($Servidor)
  $cert = New-Object Security.Cryptography.X509Certificates.X509Certificate2 $tls.RemoteCertificate
  $pem = "-----BEGIN CERTIFICATE-----`r`n" + [Convert]::ToBase64String($cert.RawData, 'InsertLineBreaks') + "`r`n-----END CERTIFICATE-----`r`n"
  Set-Content -Encoding Ascii -NoNewline -Path $Salida -Value $pem
} finally { $tcp.Close() }
