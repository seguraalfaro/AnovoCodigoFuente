unit Anovo.Presentadores.SolicitudesAsistente;

// Presentador de las solicitudes de la oficina: la cola comun (con
// solicitudes.ver_todas) y tomar una (con solicitudes.tomar).

interface

uses
  Anovo.Api.Intf.Solicitudes,
  Anovo.Api.Intf.Cotizaciones,
  Anovo.PeriodoBusqueda,
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
  protected
    procedure Cargar; override;
    function UsaPeriodo: Boolean; override;
    procedure PintarPeriodo; override;
  public
    constructor Create(const AVista: IVistaSolicitudesAsistente;
      const AApi: IApiSolicitudes; const ACotizaciones: IApiCotizaciones);
    procedure Iniciar;
    class function AccionesPermitidas: TAccionesCola;
    procedure Tomar(const ASolicitudId: Integer; const ACliente: string);
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
  Result := [];
  if TSesion.Tiene(PERMISO_SOLICITUDES_TOMAR) then
    Include(Result, acTomar);
end;

function TPresentadorSolicitudesAsistente.UsaPeriodo: Boolean;
begin
  Result := True;
end;

procedure TPresentadorSolicitudesAsistente.PintarPeriodo;
begin
  FVista.MostrarPeriodo(FPeriodo);
end;

procedure TPresentadorSolicitudesAsistente.Iniciar;
begin
  FVista.MostrarPeriodo(FPeriodo);
  FVista.MostrarAcciones(AccionesPermitidas);
  FVista.MostrarBusqueda('', False);
  Cargar;
end;

procedure TPresentadorSolicitudesAsistente.Cargar;
var
  lApi: IApiSolicitudes;
  lTexto: string;
  lFiltroDesde, lFiltroHasta: TDateTime;
  lPagina: Integer;
  lTotal: Int64;
begin
  lApi := FApi;
  lTexto := FTexto;
  lFiltroDesde := FPeriodo.Desde;
  lFiltroHasta := FPeriodo.Hasta;
  lPagina := FPagina;
  lTotal := 0;

  EjecutarUltima<TObjectList<TSolicitudPorCotizarDTO>>
    (SAccionCargarSolicitudes,
    function: TObjectList<TSolicitudPorCotizarDTO>
    begin
      Result := lApi.Cola(lTexto, lFiltroDesde, lFiltroHasta, lPagina,
        SOLICITUDES_POR_PAGINA, lTotal);
    end,
    procedure(ALista: TObjectList<TSolicitudPorCotizarDTO>)
    begin
      FVista.MostrarCola(ALista);
      MostrarPagina(lPagina, lTotal, SOLICITUDES_POR_PAGINA);
    end, MostrarError, MostrarCargando);
end;

procedure TPresentadorSolicitudesAsistente.Tomar(const ASolicitudId: Integer;
  const ACliente: string);
var
  lApi: IApiCotizaciones;
  lCotizacionId: Integer;
begin
  if (ASolicitudId <= 0) or not (acTomar in AccionesPermitidas) then
    Exit;
  if not FVista.Confirmar(Format(SConfirmarTomar, [ACliente])) then
    Exit;
  lApi := FCotizaciones;
  lCotizacionId := 0;

  Ejecutar(SAccionTomarSolicitud,
    procedure
    begin
      lCotizacionId := lApi.Tomar(ASolicitudId);
    end,
    procedure
    begin
      AvisarCambioEnAvisos;
      Cargar;
      if lCotizacionId > 0 then
        FVista.AbrirCotizacion(lCotizacionId);
    end,
    procedure(AMensaje: string)
    begin
      AvisarCambioEnAvisos;
      FVista.MostrarError(AMensaje);
      Cargar;
    end, MostrarCargando);
end;

end.
