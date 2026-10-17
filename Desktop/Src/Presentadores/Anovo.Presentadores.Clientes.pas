unit Anovo.Presentadores.Clientes;

// Presentador del listado de clientes.

interface

uses
  Anovo.Api.Intf.Clientes,
  Anovo.Presentadores.Base,
  Anovo.Presentadores.Listado,
  Anovo.Vistas.Intf.Clientes,
  Anovo.Permisos;

type
  TPresentadorClientes = class(TPresentadorListado)
  private
    FVista: IVistaClientes;
    FApi: IApiClientes;
    FFiltro: TFiltroConsentimiento;
    FDetalle: Integer;
  protected
    procedure Cargar; override;
  public
    constructor Create(const AVista: IVistaClientes;
      const AApi: IApiClientes);
    procedure Iniciar;
    procedure Filtrar(const AFiltro: TFiltroConsentimiento);
    procedure VerDetalle(const AId: Integer);
    procedure VolverAlListado;
    class function AccionesPermitidas: TAccionesCliente;
    class function PuedeCrear: Boolean;
  end;

const
  CLIENTES_POR_PAGINA = 50;

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
  Anovo.DTOs.Clientes,
  Anovo.Sesion,
  Anovo.Textos;

const
  CONSENTIMIENTO_API: array [TFiltroConsentimiento] of string = ('',
    'firmado', 'pendiente');

  PERMISOS_ACCION: array [TAccionCliente] of string = (PERMISO_CLIENTES_VER);

constructor TPresentadorClientes.Create(const AVista: IVistaClientes;
  const AApi: IApiClientes);
begin
  inherited Create(AVista);
  FVista := AVista;
  FApi := AApi;
end;

class function TPresentadorClientes.AccionesPermitidas: TAccionesCliente;
var
  lAccion: TAccionCliente;
begin
  Result := [];
  for lAccion := Low(TAccionCliente) to High(TAccionCliente) do
    if TSesion.TieneAlguno(PERMISOS_ACCION[lAccion].Split([';'])) then
      Include(Result, lAccion);
end;

class function TPresentadorClientes.PuedeCrear: Boolean;
begin
  Result := TSesion.Tiene(PERMISO_CLIENTES_CREAR);
end;

procedure TPresentadorClientes.Iniciar;
begin
  FVista.MostrarAcciones(AccionesPermitidas, PuedeCrear);
  FVista.MostrarBusqueda('', False);
  Cargar;
end;

procedure TPresentadorClientes.Filtrar(const AFiltro: TFiltroConsentimiento);
begin
  FFiltro := AFiltro;
  FPagina := 1;
  Cargar;
end;

procedure TPresentadorClientes.VerDetalle(const AId: Integer);
begin
  if AId <= 0 then
    Exit;
  FDetalle := AId;
  FVista.MostrarDetalle(AId);
end;

procedure TPresentadorClientes.VolverAlListado;
begin
  FDetalle := 0;
  FVista.MostrarListado;
end;

procedure TPresentadorClientes.Cargar;
var
  lApi: IApiClientes;
  lTexto, lConsentimiento: string;
  lPagina: Integer;
  lTotal: Int64;
begin
  lApi := FApi;
  lTexto := FTexto;
  lConsentimiento := CONSENTIMIENTO_API[FFiltro];
  lPagina := FPagina;
  lTotal := 0;

  EjecutarUltima<TObjectList<TClienteDTO>>(SAccionCargarClientes,
    function: TObjectList<TClienteDTO>
    begin
      Result := lApi.Buscar(lTexto, lConsentimiento, lPagina,
        CLIENTES_POR_PAGINA, lTotal);
    end,
    procedure(ALista: TObjectList<TClienteDTO>)
    begin
      FTotalPaginas := (lTotal + CLIENTES_POR_PAGINA - 1) div
        CLIENTES_POR_PAGINA;
      FVista.MostrarClientes(ALista);
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
