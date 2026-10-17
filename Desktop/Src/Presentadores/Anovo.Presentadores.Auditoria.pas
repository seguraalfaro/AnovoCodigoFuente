unit Anovo.Presentadores.Auditoria;

// Presentador de la bitacora de auditoria.

interface

uses
  Anovo.Api.Intf.Auditoria,
  Anovo.PeriodoBusqueda,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.Auditoria,
  Anovo.Permisos;

type
  TPresentadorAuditoria = class(TPresentadorBase)
  private
    FVista: IVistaAuditoria;
    FApi: IApiAuditoria;
    FSoloCuentas: Boolean;
    FPeriodo: TPeriodoBusqueda;
    FFiltro: TFiltroEntidad;
    FFiltros: TFiltrosEntidad;
    FTexto: string;
    FPagina: Integer;
    FTotalPaginas: Integer;
    function EntidadPedida: string;
    function Rotulos: TArray<string>;
    function HayFiltro: Boolean;
    procedure Cargar;
    class function PeriodoInicial: TPeriodoBusqueda; static;
  public
    constructor Create(const AVista: IVistaAuditoria;
      const AApi: IApiAuditoria);
    procedure Iniciar;
    procedure Buscar(const ATexto: string);
    procedure Limpiar;
    procedure Filtrar(const AIndice: Integer);
    procedure FiltrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure IrAPagina(const APagina: Integer);
    procedure PaginaSiguiente;
    procedure PaginaAnterior;
    class function PuedeVerTodo: Boolean;
  end;

const
  AUDITORIA_POR_PAGINA = 50;
  DIAS_POR_DEFECTO = 30;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  System.Generics.Collections,
  Anovo.DTOs.Auditoria,
  Anovo.Sesion,
  Anovo.Textos;

const
  ENTIDAD_API: array [TFiltroEntidad] of string = ('', 'CLIENTES',
    'COTIZACIONES', 'CUENTAS', 'USUARIOS', 'USUARIOS_CLAVES', 'ROLES_PERMISOS',
    'USUARIOS_PERMISOS');

  ROTULO_FILTRO: array [TFiltroEntidad] of string = (SFiltroTodo,
    SFiltroClientes, SFiltroCotizaciones, SFiltroCuentas, SFiltroUsuarios,
    SFiltroClaves, SFiltroMatrizRoles, SFiltroPermisosPersona);

  FILTROS_TODA: TFiltrosEntidad = [feTodo, feClientes, feCotizaciones,
    feCuentas];
  FILTROS_CUENTAS: TFiltrosEntidad = [feCuentas, feUsuarios, feClaves,
    feMatrizRoles, fePermisosPersona];

constructor TPresentadorAuditoria.Create(const AVista: IVistaAuditoria;
  const AApi: IApiAuditoria);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FPagina := 1;
  FPeriodo := PeriodoInicial;
end;

class function TPresentadorAuditoria.PeriodoInicial: TPeriodoBusqueda;
begin
  Result := TPeriodoBusqueda.Personalizado(IncDay(Date, -DIAS_POR_DEFECTO),
    Date);
end;

class function TPresentadorAuditoria.PuedeVerTodo: Boolean;
begin
  Result := TSesion.Tiene(PERMISO_AUDITORIA_VER_TODA);
end;

function TPresentadorAuditoria.Rotulos: TArray<string>;
var
  lFiltro: TFiltroEntidad;
begin
  Result := [];
  for lFiltro in FFiltros do
    Result := Result + [ROTULO_FILTRO[lFiltro]];
  Result[0] := SFiltroTodo;
end;

function TPresentadorAuditoria.EntidadPedida: string;
begin
  Result := ENTIDAD_API[FFiltro];
end;

procedure TPresentadorAuditoria.Iniciar;
begin
  FSoloCuentas := not PuedeVerTodo;
  if FSoloCuentas then
    FFiltros := FILTROS_CUENTAS
  else
    FFiltros := FILTROS_TODA;
  FFiltro := FFiltros[0];
  FVista.MostrarFiltros(Rotulos);
  FVista.MostrarPeriodo(FPeriodo);
  FVista.MostrarBusqueda(FTexto, HayFiltro);
  Cargar;
end;

procedure TPresentadorAuditoria.Buscar(const ATexto: string);
begin
  FTexto := ATexto.Trim;
  FPagina := 1;
  FVista.MostrarBusqueda(FTexto, HayFiltro);
  Cargar;
end;

function TPresentadorAuditoria.HayFiltro: Boolean;
begin
  Result := not FTexto.IsEmpty or not FPeriodo.Igual(PeriodoInicial);
end;

procedure TPresentadorAuditoria.Limpiar;
begin
  FPeriodo := PeriodoInicial;
  FVista.MostrarPeriodo(FPeriodo);
  Buscar('');
end;

procedure TPresentadorAuditoria.Filtrar(const AIndice: Integer);
begin
  if (AIndice < 0) or (AIndice > High(FFiltros)) then
    Exit;
  FFiltro := FFiltros[AIndice];
  FPagina := 1;
  Cargar;
end;

procedure TPresentadorAuditoria.FiltrarPeriodo(const APeriodo
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

procedure TPresentadorAuditoria.IrAPagina(const APagina: Integer);
begin
  if (APagina < 1) or ((FTotalPaginas > 0) and (APagina > FTotalPaginas)) then
    Exit;
  FPagina := APagina;
  Cargar;
end;

procedure TPresentadorAuditoria.PaginaSiguiente;
begin
  IrAPagina(FPagina + 1);
end;

procedure TPresentadorAuditoria.PaginaAnterior;
begin
  IrAPagina(FPagina - 1);
end;

procedure TPresentadorAuditoria.Cargar;
var
  lApi: IApiAuditoria;
  lSoloCuentas: Boolean;
  lDesde, lHasta: TDateTime;
  lEntidad, lTexto: string;
  lPagina: Integer;
  lTotal: Int64;
begin
  lApi := FApi;
  lSoloCuentas := FSoloCuentas;
  lDesde := FPeriodo.Desde;
  lHasta := FPeriodo.Hasta;
  lEntidad := EntidadPedida;
  lTexto := FTexto;
  lPagina := FPagina;
  lTotal := 0;

  EjecutarUltima<TObjectList<TAuditoriaDTO>>(SAccionCargarBitacora,
    function: TObjectList<TAuditoriaDTO>
    begin
      Result := lApi.Buscar(lSoloCuentas, lDesde, lHasta, lEntidad, '',
        lTexto, lPagina, AUDITORIA_POR_PAGINA, lTotal);
    end,
    procedure(ALista: TObjectList<TAuditoriaDTO>)
    begin
      FTotalPaginas := (lTotal + AUDITORIA_POR_PAGINA - 1) div
        AUDITORIA_POR_PAGINA;
      FVista.MostrarAuditoria(ALista);
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
