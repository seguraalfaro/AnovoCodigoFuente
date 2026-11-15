unit Anovo.Presentadores.Listado;

// Base de los presentadores de listado: texto buscado, periodo opcional,
// pagina actual y total de paginas.

interface

uses
  Anovo.Presentadores.Base,
  Anovo.PeriodoBusqueda,
  Anovo.Vistas.Intf.Listado;

type
  TPresentadorListado = class(TPresentadorBase)
  private
    FVistaListado: IVistaListado;
  protected
    FTexto: string;
    FPeriodo: TPeriodoBusqueda;
    FPagina: Integer;
    FTotalPaginas: Integer;
    procedure Cargar; virtual; abstract;
    function UsaPeriodo: Boolean; virtual;
    function PeriodoInicial: TPeriodoBusqueda; virtual;
    procedure PintarPeriodo; virtual;
    function HayFiltro: Boolean; virtual;
    procedure PintarBusqueda;
    procedure MostrarPagina(const APagina: Integer; const ATotal: Int64;
      const APorPagina: Integer);
    procedure MostrarError(AMensaje: string);
    procedure MostrarCargando(AActivo: Boolean);
  public
    constructor Create(const AVista: IVistaListado);
    procedure Recargar;
    procedure Buscar(const ATexto: string);
    procedure Limpiar; virtual;
    procedure FiltrarPeriodo(const APeriodo: TPeriodoBusqueda); virtual;
    procedure IrAPagina(const APagina: Integer);
    procedure PaginaSiguiente;
    procedure PaginaAnterior;
  end;

implementation

uses
  System.SysUtils;

constructor TPresentadorListado.Create(const AVista: IVistaListado);
begin
  inherited Create;
  FVistaListado := AVista;
  FPagina := 1;
  FPeriodo := PeriodoInicial;
end;

function TPresentadorListado.UsaPeriodo: Boolean;
begin
  Result := False;
end;

function TPresentadorListado.PeriodoInicial: TPeriodoBusqueda;
begin
  Result := TPeriodoBusqueda.De(apTodas);
end;

procedure TPresentadorListado.PintarPeriodo;
begin
end;

function TPresentadorListado.HayFiltro: Boolean;
begin
  Result := not FTexto.IsEmpty or
    (UsaPeriodo and not FPeriodo.Igual(PeriodoInicial));
end;

procedure TPresentadorListado.PintarBusqueda;
begin
  FVistaListado.MostrarBusqueda(FTexto, HayFiltro);
end;

procedure TPresentadorListado.MostrarPagina(const APagina: Integer;
  const ATotal: Int64; const APorPagina: Integer);
begin
  FTotalPaginas := (ATotal + APorPagina - 1) div APorPagina;
  FVistaListado.MostrarPaginacion(APagina, FTotalPaginas, ATotal);
end;

procedure TPresentadorListado.MostrarError(AMensaje: string);
begin
  FVistaListado.MostrarError(AMensaje);
end;

procedure TPresentadorListado.MostrarCargando(AActivo: Boolean);
begin
  FVistaListado.MostrarCargando(AActivo);
end;

procedure TPresentadorListado.Recargar;
begin
  Cargar;
end;

procedure TPresentadorListado.Buscar(const ATexto: string);
begin
  FTexto := Trim(ATexto);
  FPagina := 1;
  PintarBusqueda;
  Cargar;
end;

procedure TPresentadorListado.Limpiar;
begin
  if UsaPeriodo then
  begin
    FPeriodo := PeriodoInicial;
    PintarPeriodo;
  end;
  Buscar('');
end;

procedure TPresentadorListado.FiltrarPeriodo(const APeriodo: TPeriodoBusqueda);
var
  lMensaje: string;
begin
  if not APeriodo.Validar(lMensaje) then
  begin
    MostrarError(lMensaje);
    PintarPeriodo;
    Exit;
  end;
  FPeriodo := APeriodo;
  FPagina := 1;
  PintarBusqueda;
  Cargar;
end;

procedure TPresentadorListado.IrAPagina(const APagina: Integer);
begin
  if (APagina < 1) or ((FTotalPaginas > 0) and (APagina > FTotalPaginas)) then
    Exit;
  FPagina := APagina;
  Cargar;
end;

procedure TPresentadorListado.PaginaSiguiente;
begin
  IrAPagina(FPagina + 1);
end;

procedure TPresentadorListado.PaginaAnterior;
begin
  IrAPagina(FPagina - 1);
end;

end.
