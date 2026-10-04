unit Anovo.Presentadores.Auditoria;

// Presentador de la bitacora de auditoria.

interface

uses
  Anovo.Api.Intf.Auditoria,
  Anovo.Cancelacion,
  Anovo.Vistas.Intf.Auditoria,
  Anovo.Permisos;

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
    FFiltros: TFiltrosEntidad;
    FTexto: string;
    FPagina: Integer;
    FTotalPaginas: Integer;
    FSolicitud: Integer;
    function EntidadPedida: string;
    function Rotulos: TArray<string>;
    procedure Cargar;
  public
    constructor Create(const AVista: IVistaAuditoria;
      const AApi: IApiAuditoria);
    destructor Destroy; override;
    procedure Iniciar;
    procedure Buscar(const ATexto: string);
    procedure Limpiar;
    procedure Filtrar(const AIndice: Integer);
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
    'COTIZACIONES', 'CUENTAS', 'USUARIOS', 'USUARIOS_CLAVES', 'ROLES_PERMISOS',
    'USUARIOS_PERMISOS');

  ROTULO_FILTRO: array [TFiltroEntidad] of string = (SFiltroTodo,
    SFiltroClientes, SFiltroCotizaciones, SFiltroCuentas, SFiltroUsuarios,
    SFiltroClaves, SFiltroMatrizRoles, SFiltroPermisosPersona);

  FILTROS_TODA: TFiltrosEntidad = [feTodo, feClientes, feCotizaciones,
    feCuentas];
  FILTROS_CUENTAS: TFiltrosEntidad = [feCuentas, feUsuarios, feClaves,
    feMatrizRoles, fePermisosPersona];

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
  Result := TSesion.Tiene(PERMISO_AUDITORIA_VER_TODA);
end;

class function TPresentadorAuditoria.PuedeVerCuentas: Boolean;
begin
  Result := TSesion.Tiene(PERMISO_AUDITORIA_VER_CUENTAS);
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

procedure TPresentadorAuditoria.Filtrar(const AIndice: Integer);
begin
  if (AIndice < 0) or (AIndice > High(FFiltros)) then
    Exit;
  FFiltro := FFiltros[AIndice];
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
