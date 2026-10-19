unit Anovo.Presentadores.SolicitudesAsesor;

// Presentador de la seccion Solicitudes del asesor.

interface

uses
  Anovo.Api.Intf.Solicitudes,
  Anovo.PeriodoBusqueda,
  Anovo.Presentadores.Base,
  Anovo.Presentadores.Listado,
  Anovo.Vistas.Intf.SolicitudesAsesor;

type
  TPresentadorSolicitudesAsesor = class(TPresentadorListado)
  private
    FVista: IVistaSolicitudesAsesor;
    FApi: IApiSolicitudes;
  protected
    procedure Cargar; override;
    function UsaPeriodo: Boolean; override;
    function PeriodoInicial: TPeriodoBusqueda; override;
    procedure PintarPeriodo; override;
  public
    constructor Create(const AVista: IVistaSolicitudesAsesor;
      const AApi: IApiSolicitudes);
    procedure Iniciar;
    class function AccionesPermitidas: TAccionesSolicitudAsesor;
    procedure Abrir(const ACotizacionId: Integer);
  end;

const
  SOLICITUDES_POR_PAGINA = 50;

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
  Anovo.DTOs.Dashboard,
  Anovo.Textos;

constructor TPresentadorSolicitudesAsesor.Create(const AVista: IVistaSolicitudesAsesor;
  const AApi: IApiSolicitudes);
begin
  inherited Create(AVista);
  FVista := AVista;
  FApi := AApi;
end;

function TPresentadorSolicitudesAsesor.UsaPeriodo: Boolean;
begin
  Result := True;
end;

procedure TPresentadorSolicitudesAsesor.PintarPeriodo;
begin
  FVista.MostrarPeriodo(FPeriodo);
end;

function TPresentadorSolicitudesAsesor.PeriodoInicial: TPeriodoBusqueda;
begin
  Result := TPeriodoBusqueda.De(apEsteMes);
end;

class function TPresentadorSolicitudesAsesor.AccionesPermitidas
  : TAccionesSolicitudAsesor;
begin
  Result := [asaVer];
end;

procedure TPresentadorSolicitudesAsesor.Abrir(const ACotizacionId: Integer);
begin
  if (ACotizacionId > 0) and (asaVer in AccionesPermitidas) then
    FVista.AbrirCotizacion(ACotizacionId);
end;

procedure TPresentadorSolicitudesAsesor.Iniciar;
begin
  FVista.MostrarAcciones(AccionesPermitidas);
  FVista.MostrarPeriodo(FPeriodo);
  FVista.MostrarBusqueda(FTexto, HayFiltro);
  Cargar;
end;

procedure TPresentadorSolicitudesAsesor.Cargar;
var
  lApi: IApiSolicitudes;
  lPagina: Integer;
  lTexto: string;
  lHistorial: Boolean;
  lTotal: Int64;
  lDesde, lFiltroDesde, lFiltroHasta: TDateTime;
begin
  lApi := FApi;
  lTexto := FTexto;
  lPagina := FPagina;
  lHistorial := FPeriodo.Atajo = apTodas;
  lFiltroDesde := FPeriodo.Desde;
  lFiltroHasta := FPeriodo.Hasta;
  lTotal := 0;
  lDesde := 0;

  EjecutarUltima<TObjectList<TSolicitudAsesorDTO>>(SAccionCargarSolicitudes,
    function: TObjectList<TSolicitudAsesorDTO>
    begin
      Result := lApi.Seguimiento(lTexto, lHistorial, lFiltroDesde,
        lFiltroHasta, lPagina, SOLICITUDES_POR_PAGINA, lTotal, lDesde);
    end,
    procedure(ALista: TObjectList<TSolicitudAsesorDTO>)
    begin
      FTotalPaginas := (lTotal + SOLICITUDES_POR_PAGINA - 1) div
        SOLICITUDES_POR_PAGINA;
      FVista.MostrarSolicitudes(ALista);
      FVista.MostrarPaginacion(lPagina, FTotalPaginas, lTotal);
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarCargando(AActivo);
    end);
end;

end.
