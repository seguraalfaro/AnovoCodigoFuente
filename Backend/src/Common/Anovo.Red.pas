unit Anovo.Red;

// IP real del cliente. Detras del tunel de Cloudflare todas las peticiones
// llegan desde cloudflared; solo de un proxy confiable se lee su encabezado.

interface

uses
  MVCFramework;

function IpCliente(const AContext: TWebContext): string;

implementation

uses
  System.SysUtils,
  MVCFramework.Commons;

const
  PROXIES_POR_DEFECTO = '127.0.0.1,::1,::ffff:127.0.0.1';
  ENCABEZADO_POR_DEFECTO = 'CF-Connecting-IP';
  CARACTERES_IP = ['0' .. '9', 'a' .. 'f', 'A' .. 'F', '.', ':'];
  LARGO_MAXIMO_IP = 45;

function EsIp(const ATexto: string): Boolean;
var
  lCaracter: Char;
begin
  Result := (not ATexto.IsEmpty) and (ATexto.Length <= LARGO_MAXIMO_IP);
  if not Result then
    Exit;
  for lCaracter in ATexto do
    if not CharInSet(lCaracter, CARACTERES_IP) then
      Exit(False);
end;

function EsProxyConfiable(const AIp: string): Boolean;
var
  lProxy: string;
begin
  Result := False;
  for lProxy in dotEnv.Env('anovo.proxy.confiables', PROXIES_POR_DEFECTO)
    .Split([',']) do
    if SameText(lProxy.Trim, AIp) then
      Exit(True);
end;

function IpCliente(const AContext: TWebContext): string;
var
  lReal: string;
begin
  Result := AContext.Request.PeerIp;
  if not EsProxyConfiable(Result) then
    Exit;
  lReal := AContext.Request.Headers[dotEnv.Env('anovo.proxy.encabezado',
    ENCABEZADO_POR_DEFECTO)].Trim;
  if EsIp(lReal) then
    Result := lReal;
end;

end.
