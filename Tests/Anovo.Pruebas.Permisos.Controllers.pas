unit Anovo.Pruebas.Permisos.Controllers;

// Revision por RTTI de los controllers (RNF-004): cada codigo de
// MVCRequiresPermiso existe y toda accion pide sesion o es publica a proposito.

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture('Controllers: permisos declarados en cada accion')]
  TPruebasPermisosControllers = class
  public
    [Test]
    procedure HayControllersParaRevisar;
    [Test]
    procedure CadaCodigoDePermisoExiste;
    [Test]
    procedure CadaAccionPideSesionOEsPublicaAProposito;
  end;

implementation

uses
  System.SysUtils,
  System.Rtti,
  System.Generics.Collections,
  MVCFramework,
  Anovo.Permisos,
  Anovo.Auth.Permisos,
  Anovo.Controllers.Auditoria,
  Anovo.Controllers.Catalogos,
  Anovo.Controllers.Clientes,
  Anovo.Controllers.Consentimiento,
  Anovo.Controllers.Correo,
  Anovo.Controllers.Cotizaciones,
  Anovo.Controllers.Dashboard,
  Anovo.Controllers.Dispositivos,
  Anovo.Controllers.Empresa,
  Anovo.Controllers.Reportes,
  Anovo.Controllers.Roles,
  Anovo.Controllers.Sesion,
  Anovo.Controllers.Sincronizacion,
  Anovo.Controllers.Solicitudes,
  Anovo.Controllers.Usuarios,
  Anovo.Controllers.Version;

const
  PREFIJO_CONTROLLERS = 'Anovo.Controllers.';

  PERMISOS_VALIDOS: array [0 .. 32] of string = (PERMISO_ACCESO_ESCRITORIO,
    PERMISO_ACCESO_MOVIL, PERMISO_ADJUNTOS_CREAR,
    PERMISO_ADJUNTOS_VER, PERMISO_AUDITORIA_VER_CUENTAS,
    PERMISO_AUDITORIA_VER_TODA, PERMISO_CATALOGOS_EDITAR, PERMISO_CATALOGOS_VER,
    PERMISO_CLIENTES_CONSENTIMIENTO, PERMISO_CLIENTES_CREAR,
    PERMISO_CLIENTES_EDITAR, PERMISO_CLIENTES_INACTIVAR, PERMISO_CLIENTES_VER,
    PERMISO_COTIZACIONES_APROBAR, PERMISO_COTIZACIONES_ELABORAR,
    PERMISO_COTIZACIONES_ELABORAR_PROPIAS, PERMISO_COTIZACIONES_RESPONDER,
    PERMISO_COTIZACIONES_VER_APROBADAS_PROPIAS, PERMISO_COTIZACIONES_VER_PROPIAS,
    PERMISO_COTIZACIONES_VER_TODAS,
    PERMISO_EMPRESA_ADMINISTRAR, PERMISO_EMPRESA_EDITAR,
    PERMISO_PERMISOS_EDITAR, PERMISO_PERMISOS_VER, PERMISO_REPORTES_VER,
    PERMISO_REPORTES_VER_PROPIOS, PERMISO_SOLICITUDES_CREAR,
    PERMISO_SOLICITUDES_EDITAR_PROPIAS, PERMISO_SOLICITUDES_EDITAR_TODAS,
    PERMISO_SOLICITUDES_TOMAR, PERMISO_SOLICITUDES_VER_PROPIAS,
    PERMISO_SOLICITUDES_VER_TODAS, PERMISO_USUARIOS_ADMINISTRAR);

  ACCIONES_PUBLICAS: array [0 .. 2] of string = ('TVersionController.Obtener',
    'TDispositivosController.Renovar', 'TDispositivosController.Cerrar');

function Controllers: TArray<TRttiInstanceType>;
var
  lContexto: TRttiContext;
  lTipo: TRttiType;
begin
  Result := [];
  lContexto := TRttiContext.Create;
  for lTipo in lContexto.GetTypes do
    if (lTipo is TRttiInstanceType) and
      TRttiInstanceType(lTipo).MetaclassType.InheritsFrom(TMVCController) and
      TRttiInstanceType(lTipo).DeclaringUnitName.StartsWith(PREFIJO_CONTROLLERS)
      and not TRttiInstanceType(lTipo).MetaclassType.ClassName.EndsWith('Base')
    then
      Result := Result + [TRttiInstanceType(lTipo)];
end;

function Atributos(AObjeto: TRttiObject): TArray<TCustomAttribute>;
begin
  Result := AObjeto.GetAttributes;
end;

function PideSesion(AObjeto: TRttiObject): Boolean;
var
  lAtributo: TCustomAttribute;
begin
  for lAtributo in Atributos(AObjeto) do
    if lAtributo is MVCRequiresAuthenticationAttribute then
      Exit(True);
  Result := False;
end;

function ClasePideSesion(ATipo: TRttiType): Boolean;
begin
  while ATipo <> nil do
  begin
    if PideSesion(ATipo) then
      Exit(True);
    ATipo := ATipo.BaseType;
  end;
  Result := False;
end;

function EsAccion(AMetodo: TRttiMethod): Boolean;
var
  lAtributo: TCustomAttribute;
begin
  for lAtributo in Atributos(AMetodo) do
    if lAtributo is MVCPathAttribute then
      Exit(True);
  Result := False;
end;

function EsPublicaAProposito(const ANombre: string): Boolean;
var
  lPublica: string;
begin
  for lPublica in ACCIONES_PUBLICAS do
    if SameText(lPublica, ANombre) then
      Exit(True);
  Result := False;
end;

function CodigosDe(AObjeto: TRttiObject): TArray<string>;
var
  lAtributo: TCustomAttribute;
begin
  Result := [];
  for lAtributo in Atributos(AObjeto) do
    if lAtributo is MVCRequiresPermisoAttribute then
      Result := Result + MVCRequiresPermisoAttribute(lAtributo).GetPermisos;
end;

procedure TPruebasPermisosControllers.HayControllersParaRevisar;
begin
  Assert.IsTrue(Length(Controllers) >= 15,
    Format('Solo se encontraron %d controllers', [Length(Controllers)]));
end;

procedure TPruebasPermisosControllers.CadaCodigoDePermisoExiste;
var
  lValidos: TList<string>;
  lMalos: TStringBuilder;
  lTipo: TRttiInstanceType;
  lMetodo: TRttiMethod;
  lCodigo: string;
  lRevisados: Integer;

  procedure Revisar(const ADonde: string; const ACodigos: TArray<string>);
  var
    lUno: string;
  begin
    for lUno in ACodigos do
    begin
      Inc(lRevisados);
      if not lValidos.Contains(lUno) then
        lMalos.AppendFormat('%s: "%s"; ', [ADonde, lUno]);
    end;
  end;

begin
  lValidos := TList<string>.Create;
  lMalos := TStringBuilder.Create;
  try
    for lCodigo in PERMISOS_VALIDOS do
      lValidos.Add(lCodigo);
    lRevisados := 0;
    for lTipo in Controllers do
    begin
      Revisar(lTipo.Name, CodigosDe(lTipo));
      for lMetodo in lTipo.GetDeclaredMethods do
        Revisar(lTipo.Name + '.' + lMetodo.Name, CodigosDe(lMetodo));
    end;
    Assert.IsTrue(lRevisados > 50,
      Format('Solo se revisaron %d codigos', [lRevisados]));
    Assert.AreEqual('', lMalos.ToString, 'Codigos que no existen');
  finally
    lMalos.Free;
    lValidos.Free;
  end;
end;

procedure TPruebasPermisosControllers.CadaAccionPideSesionOEsPublicaAProposito;
var
  lSueltas: TStringBuilder;
  lTipo: TRttiInstanceType;
  lMetodo: TRttiMethod;
  lNombre: string;
begin
  lSueltas := TStringBuilder.Create;
  try
    for lTipo in Controllers do
      for lMetodo in lTipo.GetDeclaredMethods do
      begin
        if not EsAccion(lMetodo) then
          Continue;
        lNombre := lTipo.Name + '.' + lMetodo.Name;
        if not ClasePideSesion(lTipo) and not PideSesion(lMetodo) and
          not EsPublicaAProposito(lNombre) then
          lSueltas.Append(lNombre).Append('; ');
      end;
    Assert.AreEqual('', lSueltas.ToString,
      'Acciones sin sesion que no estan en ACCIONES_PUBLICAS');
  finally
    lSueltas.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TPruebasPermisosControllers);

end.
