unit Anovo.Presentadores.Auditoria;

// Presentador de la bitacora de auditoria.

interface

uses
  Anovo.Api.Intf.Auditoria,
  Anovo.Cancelacion,
  Anovo.Vistas.Intf.Auditoria;

type
  TPresentadorAuditoria = class
  private
    FVista: IVistaAuditoria;
    FApi: IApiAuditoria;
    FCancelacion: ICancelacion;
    FSoloCuentas: Boolean;
    FDesde: TDateTime;
    FHasta: TDateTime;
    FFiltro: TFiltroEntidad;
    FTexto: string;
    FPagina: Integer;
    FTotalPaginas: Integer;
    FSolicitud: Integer;
    function EntidadPedida: string;
    procedure Cargar;
  public
    constructor Create(const AVista: IVistaAuditoria;
      const AApi: IApiAuditoria);
    destructor Destroy; override;
    procedure Iniciar;
    procedure Buscar(const ATexto: string);
    procedure Limpiar;
    procedure Filtrar(const AFiltro: TFiltroEntidad);
    procedure CambiarPeriodo(const ADesde, AHasta: TDateTime);
    procedure IrAPagina(const APagina: Integer);
    procedure PaginaSiguiente;
    procedure PaginaAnterior;
    class function PuedeVerTodo: Boolean;
    class function PuedeVerCuentas: Boolean;
  end;

const
  AUDITORIA_POR_PAGINA = 50;
  DIAS_POR_DEFECTO = 30;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  System.Threading,
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.DTOs.Auditoria,
  Anovo.Sesion,
  Anovo.Textos;

const

  ENTIDAD_API: array [TFiltroEntidad] of string = ('', 'CLIENTES',
    'COTIZACIONES', 'USUARIOS');

function MensajeInesperado: string;
begin
  Result := Format(SErrorInesperado, [SAccionCargarBitacora]);
end;

constructor TPresentadorAuditoria.Create(const AVista: IVistaAuditoria;
  const AApi: IApiAuditoria);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCancelacion := TCancelacion.Create;
  FPagina := 1;
  FHasta := Date;
  FDesde := IncDay(FHasta, -DIAS_POR_DEFECTO);
end;

destructor TPresentadorAuditoria.Destroy;
begin
  FCancelacion.Cancelar;
  inherited;
end;

class function TPresentadorAuditoria.PuedeVerTodo: Boolean;
begin
  Result := TSesion.Tiene('auditoria.ver_toda');
end;

class function TPresentadorAuditoria.PuedeVerCuentas: Boolean;
begin
  Result := TSesion.Tiene('auditoria.ver_cuentas');
end;

function TPresentadorAuditoria.EntidadPedida: string;
begin
  if FSoloCuentas then
    Result := ''
  else
    Result := ENTIDAD_API[FFiltro];
end;

procedure TPresentadorAuditoria.Iniciar;
begin
  FSoloCuentas := not PuedeVerTodo;
  FVista.MostrarAlcance(not FSoloCuentas);
  FVista.MostrarPeriodo(FDesde, FHasta);
  FVista.MostrarBusqueda('', False);
  Cargar;
end;

procedure TPresentadorAuditoria.Buscar(const ATexto: string);
begin
  FTexto := ATexto.Trim;
  FPagina := 1;
  FVista.MostrarBusqueda(FTexto, not FTexto.IsEmpty);
  Cargar;
end;

procedure TPresentadorAuditoria.Limpiar;
begin
  Buscar('');
end;

procedure TPresentadorAuditoria.Filtrar(const AFiltro: TFiltroEntidad);
begin
  FFiltro := AFiltro;
  FPagina := 1;
  Cargar;
end;

procedure TPresentadorAuditoria.CambiarPeriodo(const ADesde, AHasta: TDateTime);
begin
  if ADesde > AHasta then
  begin
    FVista.MostrarError(SPeriodoInvertido);
    FVista.MostrarPeriodo(FDesde, FHasta);
    Exit;
  end;

  FDesde := ADesde;
  FHasta := AHasta;
  FPagina := 1;
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
  lCancelacion: ICancelacion;
  lApi: IApiAuditoria;
  lNumero: Integer;
  lSoloCuentas: Boolean;
  lDesde, lHasta: TDateTime;
  lEntidad, lTexto: string;
  lPagina: Integer;
begin
  Inc(FSolicitud);
  lNumero := FSolicitud;
  lCancelacion := FCancelacion;
  lApi := FApi;
  lSoloCuentas := FSoloCuentas;
  lDesde := FDesde;
  lHasta := FHasta;
  lEntidad := EntidadPedida;
  lTexto := FTexto;
  lPagina := FPagina;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lLista: TObjectList<TAuditoriaDTO>;
      lTotal: Int64;
      lError: string;
    begin
      lLista := nil;
      lTotal := 0;
      lError := '';
      try
        lLista := lApi.Buscar(lSoloCuentas, lDesde, lHasta, lEntidad, '',
          lTexto, lPagina, AUDITORIA_POR_PAGINA, lTotal);
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

            FTotalPaginas := (lTotal + AUDITORIA_POR_PAGINA - 1) div
              AUDITORIA_POR_PAGINA;
            FVista.MostrarAuditoria(lLista);
            FVista.MostrarPaginacion(lPagina, FTotalPaginas, lTotal);
          finally
            lLista.Free;
          end;
        end);
    end);
end;

end.
