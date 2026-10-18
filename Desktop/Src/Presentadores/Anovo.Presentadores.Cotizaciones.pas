unit Anovo.Presentadores.Cotizaciones;

// Presentador del listado de cotizaciones: busqueda, filtro por estado
// y paginacion. Que filas ve cada quien lo decide el servidor.

interface

uses
  Anovo.Api.Intf.Cotizaciones,
  Anovo.PeriodoBusqueda,
  Anovo.Presentadores.Base,
  Anovo.Presentadores.Listado,
  Anovo.Vistas.Intf.Cotizaciones;

type
  TPresentadorCotizaciones = class(TPresentadorListado)
  private
    FVista: IVistaCotizaciones;
    FApi: IApiCotizaciones;
    FFiltro: TFiltroCotizaciones;
  protected
    procedure Cargar; override;
    function UsaPeriodo: Boolean; override;
    function PeriodoInicial: TPeriodoBusqueda; override;
    procedure PintarPeriodo; override;
  public
    constructor Create(const AVista: IVistaCotizaciones;
      const AApi: IApiCotizaciones);
    procedure Iniciar(const ACargar: Boolean = True);
    procedure Filtrar(const AFiltro: TFiltroCotizaciones);
    procedure Abrir(const AId: Integer);
  end;

const
  COTIZACIONES_POR_PAGINA = 50;

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
  Anovo.DTOs.Cotizaciones,
  Anovo.Textos;

const
  ESTADO_API: array [TFiltroCotizaciones] of string = ('', 'borrador',
    'pendiente', 'devuelta', 'visto_bueno', 'enviada', 'aprobada', 'rechazada',
    'descartada');

constructor TPresentadorCotizaciones.Create(const AVista: IVistaCotizaciones;
  const AApi: IApiCotizaciones);
begin
  inherited Create(AVista);
  FVista := AVista;
  FApi := AApi;
end;

function TPresentadorCotizaciones.UsaPeriodo: Boolean;
begin
  Result := True;
end;

procedure TPresentadorCotizaciones.PintarPeriodo;
begin
  FVista.MostrarPeriodo(FPeriodo);
end;

function TPresentadorCotizaciones.PeriodoInicial: TPeriodoBusqueda;
begin
  Result := TPeriodoBusqueda.De(apEsteMes);
end;

procedure TPresentadorCotizaciones.Iniciar(const ACargar: Boolean);
begin
  FVista.MostrarAcciones([alcAbrir]);
  FVista.MostrarPeriodo(FPeriodo);
  FVista.MostrarBusqueda(FTexto, HayFiltro);
  if ACargar then
    Cargar;
end;

procedure TPresentadorCotizaciones.Filtrar(const AFiltro: TFiltroCotizaciones);
begin
  FFiltro := AFiltro;
  FPagina := 1;
  Cargar;
end;

procedure TPresentadorCotizaciones.Abrir(const AId: Integer);
begin
  if AId > 0 then
    FVista.AbrirCotizacion(AId);
end;

procedure TPresentadorCotizaciones.Cargar;
var
  lApi: IApiCotizaciones;
  lTexto, lEstado: string;
  lPagina: Integer;
  lTotal: Int64;
  lFiltroDesde, lFiltroHasta: TDateTime;
begin
  lApi := FApi;
  lTexto := FTexto;
  lEstado := ESTADO_API[FFiltro];
  lFiltroDesde := FPeriodo.Desde;
  lFiltroHasta := FPeriodo.Hasta;
  lPagina := FPagina;
  lTotal := 0;

  EjecutarUltima<TObjectList<TCotizacionDTO>>(SAccionCargarCotizaciones,
    function: TObjectList<TCotizacionDTO>
    begin
      Result := lApi.Listar(lTexto, lEstado, 0, lFiltroDesde, lFiltroHasta,
        lPagina, COTIZACIONES_POR_PAGINA, lTotal);
    end,
    procedure(ALista: TObjectList<TCotizacionDTO>)
    begin
      FTotalPaginas := (lTotal + COTIZACIONES_POR_PAGINA - 1) div
        COTIZACIONES_POR_PAGINA;
      FVista.MostrarCotizaciones(ALista);
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
