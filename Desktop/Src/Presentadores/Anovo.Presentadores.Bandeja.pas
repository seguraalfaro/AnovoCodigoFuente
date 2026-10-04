unit Anovo.Presentadores.Bandeja;

// Presentador de la bandeja de aprobacion.

interface

uses
  Anovo.Api.Intf.Cotizaciones,
  Anovo.Cancelacion,
  Anovo.Vistas.Intf.Bandeja;

type
  TPresentadorBandeja = class
  private
    FVista: IVistaBandeja;
    FApi: IApiCotizaciones;
    FCancelacion: ICancelacion;
    FTexto: string;
    FPagina: Integer;
    FTotalPaginas: Integer;
    FSolicitud: Integer;
    procedure Cargar;
  public
    constructor Create(const AVista: IVistaBandeja;
      const AApi: IApiCotizaciones);
    destructor Destroy; override;
    procedure Iniciar;
    class function AccionesPermitidas: TAccionesBandeja;
    procedure Recargar;
    procedure Buscar(const ATexto: string);
    procedure Limpiar;
    procedure IrAPagina(const APagina: Integer);
    procedure PaginaSiguiente;
    procedure PaginaAnterior;
  end;

const
  BANDEJA_POR_PAGINA = 50;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.Threading,
  Anovo.Api.Base,
  Anovo.DTOs.Cotizaciones,
  Anovo.Sesion,
  Anovo.Textos;

const
  PERMISO_APROBAR = 'cotizaciones.aprobar';

function MensajeInesperado: string;
begin
  Result := Format(SErrorInesperado, [SAccionCargarBandeja]);
end;

constructor TPresentadorBandeja.Create(const AVista: IVistaBandeja;
  const AApi: IApiCotizaciones);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCancelacion := TCancelacion.Create;
  FPagina := 1;
end;

destructor TPresentadorBandeja.Destroy;
begin
  FCancelacion.Cancelar;
  inherited;
end;

class function TPresentadorBandeja.AccionesPermitidas: TAccionesBandeja;
begin
  Result := [];
  if TSesion.Tiene(PERMISO_APROBAR) then
    Include(Result, abRevisar);
end;

procedure TPresentadorBandeja.Iniciar;
begin
  FVista.MostrarAcciones(AccionesPermitidas);
  FVista.MostrarBusqueda('', False);
  Cargar;
end;

procedure TPresentadorBandeja.Recargar;
begin
  Cargar;
end;

procedure TPresentadorBandeja.Buscar(const ATexto: string);
begin
  FTexto := ATexto.Trim;
  FPagina := 1;
  FVista.MostrarBusqueda(FTexto, not FTexto.IsEmpty);
  Cargar;
end;

procedure TPresentadorBandeja.Limpiar;
begin
  Buscar('');
end;

procedure TPresentadorBandeja.IrAPagina(const APagina: Integer);
begin
  if (APagina < 1) or ((FTotalPaginas > 0) and (APagina > FTotalPaginas)) then
    Exit;
  FPagina := APagina;
  Cargar;
end;

procedure TPresentadorBandeja.PaginaSiguiente;
begin
  IrAPagina(FPagina + 1);
end;

procedure TPresentadorBandeja.PaginaAnterior;
begin
  IrAPagina(FPagina - 1);
end;

procedure TPresentadorBandeja.Cargar;
var
  lCancelacion: ICancelacion;
  lApi: IApiCotizaciones;
  lNumero: Integer;
  lTexto: string;
  lPagina: Integer;
begin
  Inc(FSolicitud);
  lNumero := FSolicitud;
  lCancelacion := FCancelacion;
  lApi := FApi;
  lTexto := FTexto;
  lPagina := FPagina;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lDatos: TBandejaPaginaDTO;
      lError: string;
    begin
      lDatos := nil;
      lError := '';
      try
        lDatos := lApi.Bandeja(lTexto, lPagina, BANDEJA_POR_PAGINA);
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

            FTotalPaginas := (lDatos.Total + BANDEJA_POR_PAGINA - 1) div
              BANDEJA_POR_PAGINA;
            FVista.MostrarBandeja(lDatos);
            FVista.MostrarPaginacion(lPagina, FTotalPaginas, lDatos.Total);
          finally
            lDatos.Free;
          end;
        end);
    end);
end;

end.
