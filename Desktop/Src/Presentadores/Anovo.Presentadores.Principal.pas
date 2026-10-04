unit Anovo.Presentadores.Principal;

// Presentador de la ventana principal: arma el menu segun los
// permisos de la sesion y mantiene al dia sus contadores.

interface

uses
  Anovo.Api.Intf.Dashboard,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.Principal,
  Anovo.Permisos;

type
  TPresentadorPrincipal = class(TPresentadorBase)
  private
    FVista: IVistaPrincipal;
    FApi: IApiDashboard;
    FPermitidas: TSecciones;
    FConsultando: Boolean;
    FSuscripcion: Integer;
    FSuscripcionNavegar: Integer;
    function TieneAvisos: Boolean;
  public
    constructor Create(const AVista: IVistaPrincipal;
      const AApi: IApiDashboard);
    destructor Destroy; override;
    procedure Iniciar;
    procedure Navegar(const ASeccion: TSeccion);
    procedure CerrarSesion;
    procedure RefrescarAvisos;
    class function SeccionesPermitidas: TSecciones;
    class function SolicitudesDelAsesor: Boolean;
    class function MenuOrdenado(const APermitidas: TSecciones)
      : TArray<TSeccion>;
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.Messaging,
  Anovo.Cancelacion,
  Anovo.Config,
  Anovo.Mensajes,
  Anovo.DTOs.Dashboard,
  Anovo.Sesion;

const
  SIEMPRE = '*';
  SEPARADOR = ';';

  PERMISOS_AVISOS: array [0 .. 1] of string = (PERMISO_COTIZACIONES_APROBAR,
    PERMISO_COTIZACIONES_ELABORAR);

  PERMISOS_SECCION: array [TSeccion] of string = (
     PERMISO_COTIZACIONES_APROBAR,
     PERMISO_USUARIOS_ADMINISTRAR,
     PERMISO_COTIZACIONES_VER_APROBADAS_PROPIAS,
     PERMISO_COTIZACIONES_ELABORAR,
     PERMISO_SOLICITUDES_VER_PROPIAS + SEPARADOR + PERMISO_COTIZACIONES_ELABORAR,
     PERMISO_COTIZACIONES_APROBAR,
     PERMISO_COTIZACIONES_VER_TODAS,
     PERMISO_COTIZACIONES_ELABORAR,
     PERMISO_COTIZACIONES_VER_TODAS + SEPARADOR +
     PERMISO_COTIZACIONES_VER_APROBADAS_PROPIAS,
     PERMISO_CLIENTES_VER,
     PERMISO_COTIZACIONES_ELABORAR + SEPARADOR + PERMISO_CATALOGOS_EDITAR,
     PERMISO_REPORTES_VER,
     PERMISO_REPORTES_VER,
     PERMISO_USUARIOS_ADMINISTRAR,
     PERMISO_PERMISOS_VER,
     PERMISO_AUDITORIA_VER_TODA + SEPARADOR + PERMISO_AUDITORIA_VER_CUENTAS,
     SIEMPRE);

  ORDEN_MENU: array [0 .. 14] of TSeccion = (secDashboardSupervisor,
    secDashboardCuentas, secDashboardAsesor, secDashboardAsistente,
    secSolicitudes, secBandeja, secCotizaciones, secClientes, secMateriales,
    secReportes, secGerencia, secUsuarios, secRoles, secAuditoria,
    secConfiguracion);

  ORDEN_INICIO: array [0 .. 6] of TSeccion = (secGerencia,
    secDashboardSupervisor,
    secDashboardCuentas, secDashboardAsesor, secDashboardAsistente,
    secUsuarios, secConfiguracion);

constructor TPresentadorPrincipal.Create(const AVista: IVistaPrincipal;
  const AApi: IApiDashboard);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FSuscripcion := TMessageManager.DefaultManager.SubscribeToMessage
    (TMensajeAvisos,
    procedure(const Sender: TObject; const AMensaje: TMessage)
    begin
      RefrescarAvisos;
    end);
  FSuscripcionNavegar := TMessageManager.DefaultManager.SubscribeToMessage
    (TMensajeNavegar,
    procedure(const Sender: TObject; const AMensaje: TMessage)
    var
      lSeccion: TSeccion;
      lCancelacion: ICancelacion;
    begin
      lSeccion := TMensajeNavegar(AMensaje).Value;
      lCancelacion := Cancelacion;
      TThread.ForceQueue(nil,
        procedure
        begin
          if not lCancelacion.Cancelada then
            Navegar(lSeccion);
        end);
    end);
end;

destructor TPresentadorPrincipal.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TMensajeAvisos, FSuscripcion);
  TMessageManager.DefaultManager.Unsubscribe(TMensajeNavegar,
    FSuscripcionNavegar);
  inherited;
end;

function TPresentadorPrincipal.TieneAvisos: Boolean;
begin
  Result := TSesion.TieneAlguno(PERMISOS_AVISOS);
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
      (lCodigos.Split([SEPARADOR], TStringSplitOptions.ExcludeEmpty)) then
      Include(Result, lSeccion);
  end;
  if secDashboardSupervisor in Result then
    Exclude(Result, secDashboardAsistente);
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

class function TPresentadorPrincipal.SolicitudesDelAsesor: Boolean;
begin
  Result := TSesion.Tiene(PERMISO_SOLICITUDES_VER_PROPIAS);
end;

procedure TPresentadorPrincipal.Iniciar;
var
  lSeccion: TSeccion;
begin
  FPermitidas := SeccionesPermitidas;
  FVista.MostrarUsuario(TSesion.Nombre, NombreDeRol(TSesion.Rol),
    InicialesDe(TSesion.Nombre));
  FVista.MostrarSecciones(MenuOrdenado(FPermitidas));

  if TieneAvisos then
  begin
    FVista.ProgramarAvisos(TConfig.MinutosAvisos);
    RefrescarAvisos;
  end;

  for lSeccion in ORDEN_INICIO do
    if lSeccion in FPermitidas then
    begin
      FVista.AbrirSeccion(lSeccion);
      Exit;
    end;
end;

procedure TPresentadorPrincipal.CerrarSesion;
begin
  CancelarPendientes;
  FConsultando := False;
  FPermitidas := [];
  TSesion.Cerrar;
end;

procedure TPresentadorPrincipal.Navegar(const ASeccion: TSeccion);
begin
  if not(ASeccion in FPermitidas) then
    Exit;
  FVista.AbrirSeccion(ASeccion);
  if ASeccion in [secBandeja, secSolicitudes] then
    RefrescarAvisos;
end;

procedure TPresentadorPrincipal.RefrescarAvisos;
var
  lApi: IApiDashboard;
begin
  if FConsultando or not TieneAvisos then
    Exit;
  FConsultando := True;
  lApi := FApi;

  Ejecutar<TAvisosDTO>('',
    function: TAvisosDTO
    begin
      Result := lApi.Avisos;
    end,
    procedure(AAvisos: TAvisosDTO)
    begin
      FConsultando := False;
      FVista.MostrarAviso(secBandeja, AAvisos.PorAprobar);
      FVista.MostrarAviso(secSolicitudes, AAvisos.PorCotizar);
    end,
    procedure(AMensaje: string)
    begin
      FConsultando := False;
    end);
end;

end.
