unit Anovo.Presentadores.SolicitudesAsistente;

// Presentador de las solicitudes del asistente: la cola comun,
// las que tomo y la accion de tomar.

interface

uses
  Anovo.Api.Intf.Solicitudes,
  Anovo.Api.Intf.Cotizaciones,
  Anovo.Presentadores.Base,
  Anovo.Presentadores.Listado,
  Anovo.Vistas.Intf.SolicitudesAsistente,
  Anovo.Permisos;

type
  TPresentadorSolicitudesAsistente = class(TPresentadorListado)
  private
    FVista: IVistaSolicitudesAsistente;
    FApi: IApiSolicitudes;
    FCotizaciones: IApiCotizaciones;
    FModo: TModoSolicitudes;
    procedure PublicarAcciones;
  protected
    procedure Cargar; override;
  public
    constructor Create(const AVista: IVistaSolicitudesAsistente;
      const AApi: IApiSolicitudes; const ACotizaciones: IApiCotizaciones);
    procedure Iniciar;
    class function AccionesPermitidas: TAccionesCola;
    procedure CambiarModo(const AModo: TModoSolicitudes);
    procedure Tomar(const ASolicitudId: Integer; const ACliente: string);
    procedure Abrir(const ACotizacionId: Integer);
  end;

const
  SOLICITUDES_POR_PAGINA = 50;

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
  Anovo.DTOs.Dashboard,
  Anovo.DTOs.Solicitudes,
  Anovo.Mensajes,
  Anovo.Sesion,
  Anovo.Textos;

constructor TPresentadorSolicitudesAsistente.Create(const AVista
  : IVistaSolicitudesAsistente; const AApi: IApiSolicitudes;
  const ACotizaciones: IApiCotizaciones);
begin
  inherited Create(AVista);
  FVista := AVista;
  FApi := AApi;
  FCotizaciones := ACotizaciones;
end;

class function TPresentadorSolicitudesAsistente.AccionesPermitidas
  : TAccionesCola;
begin
  Result := [acAbrir];
  if TSesion.Tiene(PERMISO_COTIZACIONES_ELABORAR) then
    Include(Result, acTomar);
end;

procedure TPresentadorSolicitudesAsistente.PublicarAcciones;
begin
  if FModo = msCola then
    FVista.MostrarAcciones(AccionesPermitidas * [acTomar])
  else
    FVista.MostrarAcciones(AccionesPermitidas * [acAbrir]);
end;

procedure TPresentadorSolicitudesAsistente.Abrir(const ACotizacionId: Integer);
begin
  if (FModo = msEnTrabajo) and (ACotizacionId > 0) then
    FVista.AbrirCotizacion(ACotizacionId);
end;

procedure TPresentadorSolicitudesAsistente.Iniciar;
begin
  PublicarAcciones;
  FVista.MostrarModo(FModo);
  FVista.MostrarBusqueda('', False);
  Cargar;
end;

procedure TPresentadorSolicitudesAsistente.CambiarModo(const AModo
  : TModoSolicitudes);
begin
  if AModo = FModo then
    Exit;
  FModo := AModo;
  FPagina := 1;
  PublicarAcciones;
  FVista.MostrarModo(FModo);
  Cargar;
end;

procedure TPresentadorSolicitudesAsistente.Cargar;
var
  lApi: IApiSolicitudes;
  lTexto: string;
  lPagina: Integer;
  lTotal: Int64;
begin
  lApi := FApi;
  lTexto := FTexto;
  lPagina := FPagina;
  lTotal := 0;

  if FModo = msCola then
    EjecutarUltima<TObjectList<TSolicitudPorCotizarDTO>>
      (SAccionCargarSolicitudes,
      function: TObjectList<TSolicitudPorCotizarDTO>
      begin
        Result := lApi.Cola(lTexto, lPagina, SOLICITUDES_POR_PAGINA, lTotal);
      end,
      procedure(ALista: TObjectList<TSolicitudPorCotizarDTO>)
      begin
        FVista.MostrarCola(ALista);
        MostrarPagina(lPagina, lTotal, SOLICITUDES_POR_PAGINA);
      end, MostrarError, MostrarCargando)
  else
    EjecutarUltima<TObjectList<TSolicitudEnTrabajoDTO>>
      (SAccionCargarSolicitudes,
      function: TObjectList<TSolicitudEnTrabajoDTO>
      begin
        Result := lApi.EnTrabajo(lTexto, lPagina, SOLICITUDES_POR_PAGINA,
          lTotal);
      end,
      procedure(ALista: TObjectList<TSolicitudEnTrabajoDTO>)
      begin
        FVista.MostrarEnTrabajo(ALista);
        MostrarPagina(lPagina, lTotal, SOLICITUDES_POR_PAGINA);
      end, MostrarError, MostrarCargando);
end;

procedure TPresentadorSolicitudesAsistente.Tomar(const ASolicitudId: Integer;
  const ACliente: string);
var
  lApi: IApiCotizaciones;
begin
  if (ASolicitudId <= 0) or (FModo <> msCola) or
    not (acTomar in AccionesPermitidas) then
    Exit;
  if not FVista.Confirmar(Format(SConfirmarTomar, [ACliente])) then
    Exit;
  lApi := FCotizaciones;

  Ejecutar(SAccionTomarSolicitud,
    procedure
    begin
      lApi.Tomar(ASolicitudId);
    end,
    procedure
    begin
      AvisarCambioEnAvisos;
      FModo := msEnTrabajo;
      FPagina := 1;
      PublicarAcciones;
      FVista.MostrarModo(FModo);
      Cargar;
    end,
    procedure(AMensaje: string)
    begin
      AvisarCambioEnAvisos;
      FVista.MostrarError(AMensaje);
      Cargar;
    end, MostrarCargando);
end;

end.
