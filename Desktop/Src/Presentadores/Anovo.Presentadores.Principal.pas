unit Anovo.Presentadores.Principal;

// Presentador de la ventana principal: arma el menu segun los
// permisos de la sesion y mantiene al dia sus contadores.

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Anovo.DTOs.Cotizaciones,
  Anovo.Api.Intf.Dashboard,
  Anovo.Api.Intf.Cotizaciones,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.Principal,
  Anovo.Permisos;

type
  TPresentadorPrincipal = class(TPresentadorBase)
  private
    FVista: IVistaPrincipal;
    FApi: IApiDashboard;
    FApiCotizaciones: IApiCotizaciones;
    FRecordar: Boolean;
    FRevisando: Boolean;
    FPermitidas: TSecciones;
    FConsultando: Boolean;
    FAvisosPendientes: Boolean;
    FSuscripcion: Integer;
    FSuscripcionNavegar: Integer;
    FSuscripcionCotizacion: Integer;
    function TieneAvisos: Boolean;
    function SigueSinRespuesta: Boolean;
    function AccionesNotificacion: TAccionesNotificacion;
    procedure MostrarLista(const ACotizaciones: TObjectList<TCotizacionDTO>;
      const APreguntar: Boolean);
  public
    constructor Create(const AVista: IVistaPrincipal;
      const AApi: IApiDashboard; const AApiCotizaciones: IApiCotizaciones);
    destructor Destroy; override;
    procedure Iniciar;
    procedure Navegar(const ASeccion: TSeccion);
    procedure CerrarSesion;
    procedure RefrescarAvisos;
    procedure RevisarSinRespuesta;
    procedure VerNotificaciones;
    procedure Descartar(const AId, ANumero: Integer; const AListo: TProc;
      const AOcupado: TProc<Boolean>);
    procedure RefrescarTodo;
    procedure AbrirCotizacion(const AId: Integer);
    class function SeccionesPermitidas: TSecciones;
    class function SolicitudesDelAsesor: Boolean;
    class function MenuOrdenado(const APermitidas: TSecciones)
      : TArray<TSeccion>;
  end;

implementation

uses
  System.Classes,
  System.Messaging,
  Anovo.Cancelacion,
  Anovo.Config,
  Anovo.Mensajes,
  Anovo.DTOs.Dashboard,
  Anovo.Sesion,
  Anovo.Textos;

const
  SIEMPRE = '*';
  SEPARADOR = ';';

  PERMISOS_AVISOS: array [0 .. 4] of string = (PERMISO_COTIZACIONES_APROBAR,
    PERMISO_COTIZACIONES_RESPONDER, PERMISO_SOLICITUDES_TOMAR,
    PERMISO_COTIZACIONES_ELABORAR, PERMISO_COTIZACIONES_ELABORAR_PROPIAS);

  PERMISOS_SECCION: array [TSeccion] of string = (
     PERMISO_COTIZACIONES_APROBAR,
     PERMISO_USUARIOS_ADMINISTRAR,
     PERMISO_COTIZACIONES_VER_APROBADAS_PROPIAS,
     PERMISO_COTIZACIONES_ELABORAR + SEPARADOR +
     PERMISO_COTIZACIONES_ELABORAR_PROPIAS,
     PERMISO_SOLICITUDES_VER_PROPIAS + SEPARADOR + PERMISO_SOLICITUDES_VER_TODAS,
     PERMISO_COTIZACIONES_APROBAR,
     PERMISO_COTIZACIONES_VER_TODAS + SEPARADOR +
     PERMISO_COTIZACIONES_VER_PROPIAS,
     PERMISO_COTIZACIONES_ELABORAR + SEPARADOR +
     PERMISO_COTIZACIONES_ELABORAR_PROPIAS,
     PERMISO_COTIZACIONES_VER_TODAS + SEPARADOR +
     PERMISO_COTIZACIONES_VER_PROPIAS + SEPARADOR +
     PERMISO_COTIZACIONES_VER_APROBADAS_PROPIAS,
     PERMISO_CLIENTES_VER,
     PERMISO_COTIZACIONES_ELABORAR + SEPARADOR +
     PERMISO_COTIZACIONES_ELABORAR_PROPIAS + SEPARADOR + PERMISO_CATALOGOS_EDITAR,
     PERMISO_REPORTES_VER + SEPARADOR + PERMISO_REPORTES_VER_PROPIOS,
     PERMISO_REPORTES_VER,
     PERMISO_USUARIOS_ADMINISTRAR,
     PERMISO_PERMISOS_VER,
     PERMISO_AUDITORIA_VER_TODA + SEPARADOR + PERMISO_AUDITORIA_VER_CUENTAS,
     SIEMPRE);

  ORDEN_MENU: array [0 .. 14] of TSeccion = (secGerencia,
    secDashboardSupervisor, secDashboardCuentas, secDashboardAsesor,
    secDashboardAsistente, secSolicitudes, secBandeja, secCotizaciones,
    secClientes, secMateriales, secReportes, secUsuarios, secRoles,
    secAuditoria, secConfiguracion);

  ORDEN_INICIO: array [0 .. 6] of TSeccion = (secGerencia,
    secDashboardSupervisor,
    secDashboardCuentas, secDashboardAsesor, secDashboardAsistente,
    secUsuarios, secConfiguracion);

constructor TPresentadorPrincipal.Create(const AVista: IVistaPrincipal;
  const AApi: IApiDashboard; const AApiCotizaciones: IApiCotizaciones);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FApiCotizaciones := AApiCotizaciones;
  FSuscripcion := TMessageManager.DefaultManager.SubscribeToMessage
    (TMensajeAvisos,
    procedure(const Sender: TObject; const AMensaje: TMessage)
    begin
      RefrescarAvisos;
    end);
  FSuscripcionCotizacion := TMessageManager.DefaultManager.SubscribeToMessage
    (TMensajeAbrirCotizacion,
    procedure(const Sender: TObject; const AMensaje: TMessage)
    var
      lId: Integer;
      lCancelacion: ICancelacion;
    begin
      lId := TMensajeAbrirCotizacion(AMensaje).Value;
      lCancelacion := Cancelacion;
      TThread.ForceQueue(nil,
        procedure
        begin
          if not lCancelacion.Cancelada then
            AbrirCotizacion(lId);
        end);
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
  TMessageManager.DefaultManager.Unsubscribe(TMensajeAbrirCotizacion,
    FSuscripcionCotizacion);
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
  if TSesion.Rol <> rolGerencia then
    Exclude(Result, secGerencia);
  if secGerencia in Result then
    Result := Result - [secDashboardSupervisor, secDashboardAsistente]
  else if secDashboardSupervisor in Result then
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

  FRecordar := True;
  FVista.MostrarCampana(SigueSinRespuesta);
  if TieneAvisos then
  begin
    FVista.ProgramarAvisos(TConfig.MinutosAvisos);
    RefrescarTodo;
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
  FAvisosPendientes := False;
  FRevisando := False;
  FRecordar := False;
  FPermitidas := [];
  TSesion.Cerrar;
end;

procedure TPresentadorPrincipal.Navegar(const ASeccion: TSeccion);
begin
  if not(ASeccion in FPermitidas) then
    Exit;
  FVista.AbrirSeccion(ASeccion);
end;

procedure TPresentadorPrincipal.RefrescarTodo;
begin
  RefrescarAvisos;
  RevisarSinRespuesta;
end;

procedure TPresentadorPrincipal.RefrescarAvisos;
var
  lApi: IApiDashboard;
begin
  if not TieneAvisos then
    Exit;
  if FConsultando then
  begin
    FAvisosPendientes := True;
    Exit;
  end;
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
      FVista.MostrarAviso(secCotizaciones, AAvisos.EnCurso);
      if FAvisosPendientes then
      begin
        FAvisosPendientes := False;
        RefrescarAvisos;
      end;
    end,
    procedure(AMensaje: string)
    begin
      FConsultando := False;
      FAvisosPendientes := False;
    end);
end;

function TPresentadorPrincipal.SigueSinRespuesta: Boolean;
begin
  Result := TSesion.Tiene(PERMISO_COTIZACIONES_RESPONDER);
end;

function TPresentadorPrincipal.AccionesNotificacion: TAccionesNotificacion;
begin
  Result := [anDescartar];
  if secCotizaciones in FPermitidas then
    Include(Result, anAbrir);
end;

procedure TPresentadorPrincipal.MostrarLista(const ACotizaciones
  : TObjectList<TCotizacionDTO>; const APreguntar: Boolean);
begin
  Diferir(
    procedure
    begin
      if APreguntar and not FVista.PreguntarNotificaciones
        (ACotizaciones.Count) then
        Exit;
      AbrirCotizacion(FVista.AbrirNotificaciones(ACotizaciones,
        AccionesNotificacion));
    end,
    procedure
    begin
      ACotizaciones.Free;
    end);
end;

procedure TPresentadorPrincipal.RevisarSinRespuesta;
var
  lApi: IApiCotizaciones;
  lLista: TObjectList<TCotizacionDTO>;
begin
  if FRevisando or not SigueSinRespuesta then
    Exit;
  FRevisando := True;
  lApi := FApiCotizaciones;

  lLista := nil;
  Ejecutar('',
    procedure
    begin
      lLista := lApi.SinRespuesta;
    end,
    procedure
    var
      lMostrar: Boolean;
      lTomada: TObjectList<TCotizacionDTO>;
    begin
      FRevisando := False;
      FVista.MostrarNotificaciones(lLista.Count);
      lMostrar := FRecordar and (lLista.Count > 0);
      FRecordar := False;
      if not lMostrar then
        Exit;
      lTomada := lLista;
      lLista := nil;
      MostrarLista(lTomada, True);
    end,
    procedure(AMensaje: string)
    begin
      FRevisando := False;
      FRecordar := False;
    end, nil,
    procedure
    begin
      lLista.Free;
    end);
end;

procedure TPresentadorPrincipal.VerNotificaciones;
var
  lApi: IApiCotizaciones;
  lLista: TObjectList<TCotizacionDTO>;
begin
  if FRevisando or not SigueSinRespuesta then
    Exit;
  lApi := FApiCotizaciones;
  lLista := nil;
  Ejecutar('',
    procedure
    begin
      lLista := lApi.SinRespuesta;
    end,
    procedure
    var
      lTomada: TObjectList<TCotizacionDTO>;
    begin
      FVista.MostrarNotificaciones(lLista.Count);
      lTomada := lLista;
      lLista := nil;
      MostrarLista(lTomada, False);
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarCampanaOcupada(AActivo);
    end,
    procedure
    begin
      lLista.Free;
    end);
end;

procedure TPresentadorPrincipal.Descartar(const AId, ANumero: Integer;
  const AListo: TProc; const AOcupado: TProc<Boolean>);
var
  lApi: IApiCotizaciones;
begin
  if not SigueSinRespuesta or
    not FVista.Confirmar(Format(SConfirmarDescartar, [ANumero])) then
    Exit;
  lApi := FApiCotizaciones;
  Ejecutar('',
    procedure
    begin
      lApi.Descartar(AId);
    end,
    procedure
    begin
      AListo;
      RevisarSinRespuesta;
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end, AOcupado);
end;

procedure TPresentadorPrincipal.AbrirCotizacion(const AId: Integer);
begin
  if (AId <= 0) or not(secCotizaciones in FPermitidas) then
    Exit;
  FVista.AbrirCotizacion(AId);
end;

end.
