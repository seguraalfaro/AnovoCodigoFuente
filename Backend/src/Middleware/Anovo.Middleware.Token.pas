unit Anovo.Middleware.Token;

// Revisa la forma del token Bearer antes que el middleware JWT: uno roto
// responde 401 en vez del 500 que da DMVC al no poder leerlo.

interface

uses
  MVCFramework;

type
  TTokenFormatoMiddleware = class(TInterfacedObject, IMVCMiddleware)
  public
    procedure OnBeforeRouting(AContext: TWebContext; var AHandled: Boolean);
    procedure OnBeforeControllerAction(AContext: TWebContext;
      const AControllerQualifiedClassName: string; const AActionName: string;
      var AHandled: Boolean);
    procedure OnAfterControllerAction(AContext: TWebContext;
      const AControllerQualifiedClassName: string; const AActionName: string;
      const AHandled: Boolean);
    procedure OnAfterRouting(AContext: TWebContext; const AHandled: Boolean);
  end;

implementation

uses
  System.SysUtils,
  JsonDataObjects,
  MVCFramework.Commons,
  Anovo.Errors,
  Anovo.Textos;

const
  ESQUEMA_BEARER = 'bearer ';
  PARTES_JWT = 3;
  CARACTERES_BASE64URL = ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '-', '_', '='];

function EsBase64Url(const ATexto: string): Boolean;
var
  lCaracter: Char;
begin
  Result := not ATexto.IsEmpty;
  for lCaracter in ATexto do
    if not CharInSet(lCaracter, CARACTERES_BASE64URL) then
      Exit(False);
end;

function EsObjetoJson(const ABase64Url: string): Boolean;
var
  lTexto: string;
  lJson: TJsonBaseObject;
begin
  try
    lTexto := TEncoding.UTF8.GetString(URLSafeB64DecodeBytes(ABase64Url));
    lJson := TJsonBaseObject.Parse(lTexto);
    try
      Result := lJson is TJsonObject;
    finally
      lJson.Free;
    end;
  except
    Result := False;
  end;
end;

function TokenBienFormado(const AToken: string): Boolean;
var
  lPartes: TArray<string>;
  lParte: string;
begin
  lPartes := AToken.Split(['.']);
  if Length(lPartes) <> PARTES_JWT then
    Exit(False);
  for lParte in lPartes do
    if not EsBase64Url(lParte) then
      Exit(False);
  Result := EsObjetoJson(lPartes[0]) and EsObjetoJson(lPartes[1]);
end;

procedure TTokenFormatoMiddleware.OnBeforeRouting(AContext: TWebContext;
  var AHandled: Boolean);
var
  lEncabezado: string;
begin
  lEncabezado := AContext.Request.Headers['Authorization'].Trim;
  if not lEncabezado.ToLower.StartsWith(ESQUEMA_BEARER) then
    Exit;
  if TokenBienFormado(lEncabezado.Substring(ESQUEMA_BEARER.Length).Trim) then
    Exit;

  AContext.Response.StatusCode := HTTP_STATUS.Unauthorized;
  AContext.Response.ContentType := TMVCMediaType.APPLICATION_JSON;
  AContext.Response.Content := CuerpoError('TOKEN_INVALIDO',
    STokenAccesoInvalido);
  AHandled := True;
end;

procedure TTokenFormatoMiddleware.OnBeforeControllerAction(
  AContext: TWebContext; const AControllerQualifiedClassName: string;
  const AActionName: string; var AHandled: Boolean);
begin
end;

procedure TTokenFormatoMiddleware.OnAfterControllerAction(
  AContext: TWebContext; const AControllerQualifiedClassName: string;
  const AActionName: string; const AHandled: Boolean);
begin
end;

procedure TTokenFormatoMiddleware.OnAfterRouting(AContext: TWebContext;
  const AHandled: Boolean);
begin
end;

end.
