unit Anovo.Presentadores.Clientes;

// Presentador del listado de clientes.

interface

uses
  Anovo.Api.Intf.Clientes,
  Anovo.Cancelacion,
  Anovo.Vistas.Intf.Clientes;

type
  TPresentadorClientes = class
  private
    FVista: IVistaClientes;
    FApi: IApiClientes;
    FCancelacion: ICancelacion;
    FTexto: string;
    FFiltro: TFiltroConsentimiento;
    FPagina: Integer;
    FTotalPaginas: Integer;
    FSolicitud: Integer;
    FDetalle: Integer;
    procedure Cargar;
  public
    constructor Create(const AVista: IVistaClientes;
      const AApi: IApiClientes);
    destructor Destroy; override;
    procedure Iniciar;
    procedure Buscar(const ATexto: string);
    procedure Limpiar;
    procedure Filtrar(const AFiltro: TFiltroConsentimiento);
    procedure IrAPagina(const APagina: Integer);
    procedure PaginaSiguiente;
    procedure PaginaAnterior;
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
  System.Classes,
  System.Threading,
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.DTOs.Clientes,
  Anovo.Sesion,
  Anovo.Textos;

const

  CONSENTIMIENTO_API: array [TFiltroConsentimiento] of string = ('',
    'firmado', 'pendiente');

  PERMISOS_ACCION: array [TAccionCliente] of string = ('clientes.ver');

function MensajeInesperado: string;
begin
  Result := Format(SErrorInesperado, [SAccionCargarClientes]);
end;

constructor TPresentadorClientes.Create(const AVista: IVistaClientes;
  const AApi: IApiClientes);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCancelacion := TCancelacion.Create;
  FPagina := 1;
end;

destructor TPresentadorClientes.Destroy;
begin
  FCancelacion.Cancelar;
  inherited;
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
  Result := TSesion.Tiene('clientes.crear');
end;

procedure TPresentadorClientes.Iniciar;
begin
  FVista.MostrarAcciones(AccionesPermitidas, PuedeCrear);
  FVista.MostrarBusqueda('', False);
  Cargar;
end;

procedure TPresentadorClientes.Buscar(const ATexto: string);
begin
  FTexto := ATexto.Trim;
  FPagina := 1;
  FVista.MostrarBusqueda(FTexto, not FTexto.IsEmpty);
  Cargar;
end;

procedure TPresentadorClientes.Limpiar;
begin
  Buscar('');
end;

procedure TPresentadorClientes.Filtrar(const AFiltro: TFiltroConsentimiento);
begin
  FFiltro := AFiltro;
  FPagina := 1;
  Cargar;
end;

procedure TPresentadorClientes.IrAPagina(const APagina: Integer);
begin
  if (APagina < 1) or ((FTotalPaginas > 0) and (APagina > FTotalPaginas)) then
    Exit;
  FPagina := APagina;
  Cargar;
end;

procedure TPresentadorClientes.PaginaSiguiente;
begin
  IrAPagina(FPagina + 1);
end;

procedure TPresentadorClientes.PaginaAnterior;
begin
  IrAPagina(FPagina - 1);
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
  lCancelacion: ICancelacion;
  lApi: IApiClientes;
  lNumero: Integer;
  lTexto, lConsentimiento: string;
  lPagina: Integer;
begin
  Inc(FSolicitud);
  lNumero := FSolicitud;
  lCancelacion := FCancelacion;
  lApi := FApi;
  lTexto := FTexto;
  lConsentimiento := CONSENTIMIENTO_API[FFiltro];
  lPagina := FPagina;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lLista: TObjectList<TClienteDTO>;
      lTotal: Int64;
      lError: string;
    begin
      lLista := nil;
      lTotal := 0;
      lError := '';
      try
        lLista := lApi.Buscar(lTexto, lConsentimiento, lPagina,
          CLIENTES_POR_PAGINA, lTotal);
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := MensajeInesperado;
      end;

      TThread.Queue(nil,
        procedure
        begin
          try
            if lCancelacion.Cancelada or (lNumero <> FSolicitud) then
              Exit;

            FVista.MostrarCargando(False);
            if not lError.IsEmpty then
            begin
              FVista.MostrarError(lError);
              Exit;
            end;

            FTotalPaginas := (lTotal + CLIENTES_POR_PAGINA - 1) div
              CLIENTES_POR_PAGINA;
            FVista.MostrarClientes(lLista);
            FVista.MostrarPaginacion(lPagina, FTotalPaginas, lTotal);
          finally
            lLista.Free;
          end;
        end);
    end);
end;

end.
