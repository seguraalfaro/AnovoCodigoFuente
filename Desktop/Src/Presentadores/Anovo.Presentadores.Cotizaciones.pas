unit Anovo.Presentadores.Cotizaciones;

// Presentador del listado de cotizaciones: busqueda, filtro por estado
// y paginacion. Que filas ve cada quien lo decide el servidor.

interface

uses
  Anovo.Api.Intf.Cotizaciones,
  Anovo.PeriodoBusqueda,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.Cotizaciones;

type
  TPresentadorCotizaciones = class(TPresentadorBase)
  private
    FVista: IVistaCotizaciones;
    FApi: IApiCotizaciones;
    FTexto: string;
    FFiltro: TFiltroCotizaciones;
    FPeriodo: TPeriodoBusqueda;
    FPagina: Integer;
    FTotalPaginas: Integer;
    procedure Cargar;
    function HayFiltro: Boolean;
    class function PeriodoInicial: TPeriodoBusqueda; static;
  public
    constructor Create(const AVista: IVistaCotizaciones;
      const AApi: IApiCotizaciones);
    procedure Iniciar(const ACargar: Boolean = True);
    procedure Recargar;
    procedure Buscar(const ATexto: string);
    procedure Limpiar;
    procedure FiltrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure Filtrar(const AFiltro: TFiltroCotizaciones);
    procedure IrAPagina(const APagina: Integer);
    procedure PaginaSiguiente;
    procedure PaginaAnterior;
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
    'pendiente', 'devuelta', 'visto_bueno', 'enviada', 'aprobada', 'rechazada');

constructor TPresentadorCotizaciones.Create(const AVista: IVistaCotizaciones;
  const AApi: IApiCotizaciones);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FPagina := 1;
  FPeriodo := PeriodoInicial;
end;

class function TPresentadorCotizaciones.PeriodoInicial: TPeriodoBusqueda;
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

procedure TPresentadorCotizaciones.Recargar;
begin
  Cargar;
end;

procedure TPresentadorCotizaciones.Buscar(const ATexto: string);
begin
  FTexto := ATexto.Trim;
  FPagina := 1;
  FVista.MostrarBusqueda(FTexto, HayFiltro);
  Cargar;
end;

function TPresentadorCotizaciones.HayFiltro: Boolean;
begin
  Result := not FTexto.IsEmpty or not FPeriodo.Igual(PeriodoInicial);
end;

procedure TPresentadorCotizaciones.Limpiar;
begin
  FPeriodo := PeriodoInicial;
  FVista.MostrarPeriodo(FPeriodo);
  Buscar('');
end;

procedure TPresentadorCotizaciones.FiltrarPeriodo(const APeriodo
  : TPeriodoBusqueda);
var
  lMensaje: string;
begin
  if not APeriodo.Validar(lMensaje) then
  begin
    FVista.MostrarError(lMensaje);
    FVista.MostrarPeriodo(FPeriodo);
    Exit;
  end;
  FPeriodo := APeriodo;
  FPagina := 1;
  FVista.MostrarBusqueda(FTexto, HayFiltro);
  Cargar;
end;

procedure TPresentadorCotizaciones.Filtrar(const AFiltro: TFiltroCotizaciones);
begin
  FFiltro := AFiltro;
  FPagina := 1;
  Cargar;
end;

procedure TPresentadorCotizaciones.IrAPagina(const APagina: Integer);
begin
  if (APagina < 1) or ((FTotalPaginas > 0) and (APagina > FTotalPaginas)) then
    Exit;
  FPagina := APagina;
  Cargar;
end;

procedure TPresentadorCotizaciones.PaginaSiguiente;
begin
  IrAPagina(FPagina + 1);
end;

procedure TPresentadorCotizaciones.PaginaAnterior;
begin
  IrAPagina(FPagina - 1);
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
