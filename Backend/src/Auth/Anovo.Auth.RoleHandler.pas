// ***************************************************************************
//
// Delphi MVC Framework
//
// Copyright (c) 2010-2026 Daniele Teti and the DMVCFramework Team
//
// https://github.com/danieleteti/delphimvcframework
//
// ***************************************************************************

unit Anovo.Auth.RoleHandler;


// Handler de autenticacion contra USUARIOS / USUARIOS_CLAVES.
//
// Desciende de TRoleBasedAuthHandler y no de IMVCAuthenticationHandler a secas:
// ahi viven OnRequest y OnAuthorization, que leen [MVCRequiresAuthentication] y
// [MVCRequiresRole] por RTTI. Implementando la interfaz directamente esos
// atributos compilan y no protegen nada.
//
// Por eso aqui solo se sobrescribe OnAuthentication: lo demas ya esta resuelto.

interface

uses
  System.Generics.Collections,
  MVCFramework,
  MVCFramework.Middleware.Authentication.RoleBasedAuthHandler,
  Anovo.Services.Clave;

type
  TAuthentication = class(TRoleBasedAuthHandler)
  private
    fClave: IClaveService;
  public
    // Se instancea el servicio al crear y no cada login
    constructor Create;
    procedure OnAuthentication(const AContext: TWebContext;
      const UserName: string; const Password: string; UserRoles: TList<string>;
      var IsValid: Boolean;
      const SessionData: TDictionary<string, string>); override;
  end;

implementation

uses
  System.SysUtils,
  MVCFramework.ActiveRecord,
  MVCFramework.Container,
  MVCFramework.Logger,
  Anovo.Auditoria.Contexto,
  Anovo.Entities.Usuarios;

constructor TAuthentication.Create;
begin
  inherited Create;
  fClave := NewServiceContainerResolver.Resolve(TypeInfo(IClaveService))
    as IClaveService;
end;

procedure TAuthentication.OnAuthentication(const AContext: TWebContext;
  const UserName: string; const Password: string; UserRoles: TList<string>;
  var IsValid: Boolean; const SessionData: TDictionary<string, string>);
var
  lUsuario: TUsuario;
  lFila: TUsuarioClave;
  lRol: TRol;
begin
  IsValid := False;
  UserRoles.Clear;

  lUsuario := TMVCActiveRecord.GetOneByWhere<TUsuario>('CORREO = ?',
    [UserName.Trim.ToLower], False);

  if lUsuario = nil then
  begin
    // Hashear algo y tirarlo. Sin esto el login contesta al instante para un
    // correo inexistente y tarda 250 ms para uno real, y esa diferencia de
    // tiempo delata que correos estan registrados aunque el mensaje sea igual.
    fClave.Hashear(Password);
    LogW('Login fallido: correo no registrado');
    Exit;
  end;

  try
    if lUsuario.Activo.ValueOrDefault = False then
    begin
      fClave.Hashear(Password);
      LogW(Format('Login fallido: usuario %d inactivo', [lUsuario.ID.Value]));
      Exit;
    end;

    lFila := TMVCActiveRecord.GetOneByWhere<TUsuarioClave>
      ('USUARIO_ID = ? AND ACTIVO = ?', [lUsuario.ID.Value, True], False);

    if lFila = nil then
    begin
      fClave.Hashear(Password);
      LogW(Format('Login fallido: usuario %d sin clave activa',
        [lUsuario.ID.Value]));
      Exit;
    end;

    try
      if not fClave.Verificar(Password, lFila.ClaveHash) then
      begin
        LogW(Format('Login fallido: clave incorrecta, usuario %d',
          [lUsuario.ID.Value]));
        Exit;
      end;

      // Unico momento en que se tiene la clave en claro. Si el costo subio
      // desde que se guardo, se rehashea aqui y el usuario no se entera.
      if fClave.RequiereRehash(lFila.ClaveHash) then
      begin
        // USUARIOS_CLAVES esta auditada y este Update corre durante el login,
        // cuando todavia no hay token: el middleware de contexto no ha podido
        // fijar nada y el disparador tumbaria la escritura con
        // E_AUDITORIA_SIN_USUARIO. Aqui ya se sabe quien es, asi que lo fija el
        // propio login. Queda registrado a nombre del dueno de la clave, que es
        // quien la esta presentando.
        FijarUsuario(lUsuario.ID.Value);
        try
          lFila.ClaveHash := fClave.Hashear(Password);
          lFila.Update;
        finally
          LimpiarUsuario;
        end;
        LogI(Format('Clave rehasheada al costo vigente, usuario %d',
          [lUsuario.ID.Value]));
      end;
    finally
      lFila.Free;
    end;

    lRol := TMVCActiveRecord.GetByPK<TRol>(lUsuario.RolID, False);
    if lRol = nil then
    begin
      // La base lo impide con NOT NULL + clave foranea, pero si llegara a pasar
      // el usuario entraria sin rol y sin que nada falle. Mejor no dejarlo.
      LogE(Format('Usuario %d con ROL_ID %d inexistente', [lUsuario.ID.Value,
        lUsuario.RolID]));
      Exit;
    end;

    try
      if lUsuario.DebeCambiarClave then
        // Clave provisional: el token sale con un unico rol que solo abre el
        // cambio de clave. Asi el limite lo pone el servidor y no la buena
        // voluntad del cliente.
        UserRoles.Add('clave_vencida')
      else
        UserRoles.Add(lRol.Codigo);
    finally
      lRol.Free;
    end;

    // Va al token. Nada de datos personales aqui: un JWT va firmado, no
    // cifrado, y cualquiera que lo tenga lee su contenido.
    SessionData.AddOrSetValue('USUARIO_ID', lUsuario.ID.Value.ToString);
    SessionData.AddOrSetValue('DEBE_CAMBIAR_CLAVE',
      BoolToStr(lUsuario.DebeCambiarClave, True));

    IsValid := True;
    LogI(Format('Login correcto, usuario %d', [lUsuario.ID.Value]));
  finally
    lUsuario.Free;
  end;
end;

end.
