unit Anovo.Presentadores.Principal;

// Presentador de la ventana principal: arma el menu segun los
// permisos de la sesion y mantiene al dia sus contadores.

interface

uses
  Anovo.Api.Intf.Dashboard,
  Anovo.Cancelacion,
  Anovo.Vistas.Intf.Principal;

type
  TPresentadorPrincipal = class
  private
    FVista: IVistaPrincipal;
    FApi: IApiDashboard;
    FCancelacion: ICancelacion;
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
    class function MenuOrdenado(const APermitidas: TSecciones)
      : TArray<TSeccion>;
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.Threading,
  System.Messaging,
  Anovo.Config,
  Anovo.Mensajes,
  Anovo.DTOs.Dashboard,
  Anovo.Sesion;

const
  SIEMPRE = '*';

  PERMISOS_AVISOS: array [0 .. 1] of string = ('cotizaciones.aprobar',
    'cotizaciones.elaborar');

  PERMISOS_SECCION: array [TSeccion] of string = (
     'cotizaciones.aprobar',
     'usuarios.administrar',
     'cotizaciones.ver_aprobadas_propias',
     'cotizaciones.elaborar',
     'solicitudes.ver_propias;cotizaciones.elaborar',
     'cotizaciones.aprobar',
     'cotizaciones.ver_todas',
     'cotizaciones.elaborar',
     'cotizaciones.ver_todas;cotizaciones.ver_aprobadas_propias',
     'clientes.ver',
     'cotizaciones.elaborar;catalogos.editar',
     'reportes.ver',
     'reportes.ver',
     'usuarios.administrar',
     'permisos.ver',
     'auditoria.ver_toda;auditoria.ver_cuentas',
     SIEMPRE);

  ORDEN_MENU: array [0 .. 15] of TSeccion = (secDashboardSupervisor,
    secDashboardCuentas, secDashboardAsesor, secDashboardAsistente,
    secSolicitudes, secBandeja, secCotizaciones,
    secGeneracion, secClientes, secMateriales, secReportes, secGerencia,
    secUsuarios, secRoles, secAuditoria, secConfiguracion);

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
  FCancelacion := TCancelacion.Create;
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
      lCancelacion := FCancelacion;
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
  FCancelacion.Cancelar;
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
      (lCodigos.Split([';'], TStringSplitOptions.ExcludeEmpty)) then
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
  FCancelacion.Cancelar;
  FCancelacion := TCancelacion.Create;
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
  lCancelacion: ICancelacion;
  lApi: IApiDashboard;
begin
  if FConsultando or not TieneAvisos then
    Exit;
  FConsultando := True;
  lCancelacion := FCancelacion;
  lApi := FApi;

  TTask.Run(
    procedure
    var
      lAvisos: TAvisosDTO;
    begin
      lAvisos := nil;
      try
        lAvisos := lApi.Avisos;
      except
        lAvisos := nil;
      end;

      TThread.Queue(nil,
        procedure
        begin
          try
            if lCancelacion.Cancelada then
              Exit;
            FConsultando := False;
            if lAvisos = nil then
              Exit;
            FVista.MostrarAviso(secBandeja, lAvisos.PorAprobar);
            FVista.MostrarAviso(secSolicitudes, lAvisos.PorCotizar);
          finally
            lAvisos.Free;
          end;
        end);
    end);
end;

end.
