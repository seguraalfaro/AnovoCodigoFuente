unit Anovo.Presentadores.SolicitudesAsesor;

// Presentador de la seccion Solicitudes del asesor.

interface

uses
  Anovo.Api.Intf.Solicitudes,
  Anovo.PeriodoBusqueda,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.SolicitudesAsesor;

type
  TPresentadorSolicitudesAsesor = class(TPresentadorBase)
  private
    FVista: IVistaSolicitudesAsesor;
    FApi: IApiSolicitudes;
    FTexto: string;
    FHistorial: Boolean;
    FPeriodo: TPeriodoBusqueda;
    FPagina: Integer;
    FTotalPaginas: Integer;
    procedure Cargar;
    function HayFiltro: Boolean;
    class function PeriodoInicial: TPeriodoBusqueda; static;
  public
    constructor Create(const AVista: IVistaSolicitudesAsesor;
      const AApi: IApiSolicitudes);
    procedure Iniciar;
    procedure Buscar(const ATexto: string);
    procedure Limpiar;
    procedure FiltrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure VerHistorial(const AHistorial: Boolean);
    procedure IrAPagina(const APagina: Integer);
    procedure PaginaSiguiente;
    procedure PaginaAnterior;
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
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FHistorial := False;
  FPagina := 1;
  FPeriodo := PeriodoInicial;
end;

class function TPresentadorSolicitudesAsesor.PeriodoInicial: TPeriodoBusqueda;
begin
  Result := TPeriodoBusqueda.De(apEsteMes);
end;

procedure TPresentadorSolicitudesAsesor.Iniciar;
begin
  FVista.MostrarPeriodo(FPeriodo);
  FVista.MostrarBusqueda(FTexto, HayFiltro);
  Cargar;
end;

procedure TPresentadorSolicitudesAsesor.Buscar(const ATexto: string);
begin
  FTexto := Trim(ATexto);
  FPagina := 1;
  FVista.MostrarBusqueda(FTexto, HayFiltro);
  Cargar;
end;

function TPresentadorSolicitudesAsesor.HayFiltro: Boolean;
begin
  Result := not FTexto.IsEmpty or not FPeriodo.Igual(PeriodoInicial);
end;

procedure TPresentadorSolicitudesAsesor.Limpiar;
begin
  FPeriodo := PeriodoInicial;
  FVista.MostrarPeriodo(FPeriodo);
  Buscar('');
end;

procedure TPresentadorSolicitudesAsesor.FiltrarPeriodo(const APeriodo
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

procedure TPresentadorSolicitudesAsesor.VerHistorial(const AHistorial: Boolean);
begin
  if AHistorial = FHistorial then
    Exit;
  FHistorial := AHistorial;
  FPagina := 1;
  Cargar;
end;

procedure TPresentadorSolicitudesAsesor.IrAPagina(const APagina: Integer);
begin
  if (APagina < 1) or ((FTotalPaginas > 0) and (APagina > FTotalPaginas)) then
    Exit;
  FPagina := APagina;
  Cargar;
end;

procedure TPresentadorSolicitudesAsesor.PaginaSiguiente;
begin
  IrAPagina(FPagina + 1);
end;

procedure TPresentadorSolicitudesAsesor.PaginaAnterior;
begin
  IrAPagina(FPagina - 1);
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
  lHistorial := FHistorial;
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
