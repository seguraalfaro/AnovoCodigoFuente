unit Anovo.Presentadores.Principal;

// Presentador de la ventana principal: arma el menu
// segun los permisos de la sesion.

interface

uses
  Anovo.Vistas.Intf.Principal;

type
  TPresentadorPrincipal = class
  private
    FVista: IVistaPrincipal;
    FPermitidas: TSecciones;
  public
    constructor Create(const AVista: IVistaPrincipal);
    procedure Iniciar;
    procedure Navegar(const ASeccion: TSeccion);
    class function SeccionesPermitidas: TSecciones;
    class function MenuOrdenado(const APermitidas: TSecciones)
      : TArray<TSeccion>;
  end;

implementation

uses
  System.SysUtils,
  Anovo.Sesion;

const
  SIEMPRE = '*';

  PERMISOS_SECCION: array [TSeccion] of string = (
     'cotizaciones.ver_todas',
     'usuarios.administrar',
     'cotizaciones.ver_aprobadas_propias',
     'solicitudes.ver_propias',
     'cotizaciones.elaborar;cotizaciones.aprobar',
     'cotizaciones.ver_todas',
     'cotizaciones.elaborar',
     'cotizaciones.ver_todas;cotizaciones.ver_aprobadas_propias',
     'clientes.ver',
     'cotizaciones.elaborar;catalogos.editar',
     'reportes.ver',
     'auditoria.ver_toda',
     'usuarios.administrar',
     'permisos.ver',
     'auditoria.ver_toda;auditoria.ver_cuentas',
     SIEMPRE);

  ORDEN_MENU: array [0 .. 14] of TSeccion = (secDashboard, secDashboardCuentas,
    secDashboardAsesor, secSolicitudes, secBandeja, secCotizaciones,
    secGeneracion, secClientes, secMateriales, secReportes, secGerencia,
    secUsuarios, secRoles, secAuditoria, secConfiguracion);

  ORDEN_INICIO: array [0 .. 4] of TSeccion = (secDashboard, secDashboardCuentas,
    secDashboardAsesor, secUsuarios, secConfiguracion);

constructor TPresentadorPrincipal.Create(const AVista: IVistaPrincipal);
begin
  inherited Create;
  FVista := AVista;
end;

class function TPresentadorPrincipal.SeccionesPermitidas: TSecciones;
var
  lSeccion: TSeccion;
  lCodigos: string;
begin
  Result := [];
  for lSeccion := Low(TSeccion) to High(TSeccion) do
  begin
    lCodigos := PERMISOS_SECCION[lSeccion];
    if (lCodigos = SIEMPRE) or TSesion.TieneAlguno
      (lCodigos.Split([';'], TStringSplitOptions.ExcludeEmpty)) then
      Include(Result, lSeccion);
  end;
end;

class function TPresentadorPrincipal.MenuOrdenado(const APermitidas: TSecciones)
  : TArray<TSeccion>;
var
  lSeccion: TSeccion;
begin
  Result := nil;
  for lSeccion in ORDEN_MENU do
    if lSeccion in APermitidas then
      Result := Result + [lSeccion];
end;

procedure TPresentadorPrincipal.Iniciar;
var
  lSeccion: TSeccion;
begin
  FPermitidas := SeccionesPermitidas;
  FVista.MostrarUsuario(TSesion.Nombre, NombreDeRol(TSesion.Rol),
    InicialesDe(TSesion.Nombre));
  FVista.MostrarSecciones(MenuOrdenado(FPermitidas));

  for lSeccion in ORDEN_INICIO do
    if lSeccion in FPermitidas then
    begin
      FVista.AbrirSeccion(lSeccion);
      Exit;
    end;
end;

procedure TPresentadorPrincipal.Navegar(const ASeccion: TSeccion);
begin
  if ASeccion in FPermitidas then
    FVista.AbrirSeccion(ASeccion);
end;

end.
