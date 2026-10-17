unit Anovo.Presentadores.Auditoria;

// Presentador de la bitacora de auditoria.

interface

uses
  Anovo.Api.Intf.Auditoria,
  Anovo.PeriodoBusqueda,
  Anovo.Presentadores.Base,
  Anovo.Presentadores.Listado,
  Anovo.Vistas.Intf.Auditoria,
  Anovo.Permisos;

type
  TPresentadorAuditoria = class(TPresentadorListado)
  private
    FVista: IVistaAuditoria;
    FApi: IApiAuditoria;
    FSoloCuentas: Boolean;
    FFiltro: TFiltroEntidad;
    FFiltros: TFiltrosEntidad;
    function EntidadPedida: string;
    function Rotulos: TArray<string>;
  protected
    procedure Cargar; override;
    function UsaPeriodo: Boolean; override;
    function PeriodoInicial: TPeriodoBusqueda; override;
    procedure PintarPeriodo; override;
  public
    constructor Create(const AVista: IVistaAuditoria;
      const AApi: IApiAuditoria);
    procedure Iniciar;
    procedure Filtrar(const AIndice: Integer);
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
  inherited Create(AVista);
  FVista := AVista;
  FApi := AApi;
end;

function TPresentadorAuditoria.UsaPeriodo: Boolean;
begin
  Result := True;
end;

procedure TPresentadorAuditoria.PintarPeriodo;
begin
  FVista.MostrarPeriodo(FPeriodo);
end;

function TPresentadorAuditoria.PeriodoInicial: TPeriodoBusqueda;
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

procedure TPresentadorAuditoria.Filtrar(const AIndice: Integer);
begin
  if (AIndice < 0) or (AIndice > High(FFiltros)) then
    Exit;
  FFiltro := FFiltros[AIndice];
  FPagina := 1;
  Cargar;
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
