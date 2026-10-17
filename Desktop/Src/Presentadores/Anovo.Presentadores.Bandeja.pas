unit Anovo.Presentadores.Bandeja;

// Presentador de la bandeja de aprobacion.

interface

uses
  Anovo.Api.Intf.Cotizaciones,
  Anovo.Presentadores.Base,
  Anovo.Presentadores.Listado,
  Anovo.Vistas.Intf.Bandeja,
  Anovo.Permisos;

type
  TPresentadorBandeja = class(TPresentadorListado)
  private
    FVista: IVistaBandeja;
    FApi: IApiCotizaciones;
  protected
    procedure Cargar; override;
  public
    constructor Create(const AVista: IVistaBandeja;
      const AApi: IApiCotizaciones);
    procedure Iniciar;
    class function AccionesPermitidas: TAccionesBandeja;
    procedure Revisar(const AId: Integer);
  end;

const
  BANDEJA_POR_PAGINA = 50;

implementation

uses
  System.SysUtils,
  Anovo.DTOs.Cotizaciones,
  Anovo.Sesion,
  Anovo.Textos;

constructor TPresentadorBandeja.Create(const AVista: IVistaBandeja;
  const AApi: IApiCotizaciones);
begin
  inherited Create(AVista);
  FVista := AVista;
  FApi := AApi;
end;

class function TPresentadorBandeja.AccionesPermitidas: TAccionesBandeja;
begin
  Result := [];
  if TSesion.Tiene(PERMISO_COTIZACIONES_APROBAR) then
    Include(Result, abRevisar);
end;

procedure TPresentadorBandeja.Iniciar;
begin
  FVista.MostrarAcciones(AccionesPermitidas);
  FVista.MostrarBusqueda('', False);
  Cargar;
end;

procedure TPresentadorBandeja.Revisar(const AId: Integer);
begin
  if (AId <= 0) or not (abRevisar in AccionesPermitidas) then
    Exit;
  if FVista.MostrarRevision(AId) then
    Recargar;
end;

procedure TPresentadorBandeja.Cargar;
var
  lApi: IApiCotizaciones;
  lTexto: string;
  lPagina: Integer;
begin
  lApi := FApi;
  lTexto := FTexto;
  lPagina := FPagina;

  EjecutarUltima<TBandejaPaginaDTO>(SAccionCargarBandeja,
    function: TBandejaPaginaDTO
    begin
      Result := lApi.Bandeja(lTexto, lPagina, BANDEJA_POR_PAGINA);
    end,
    procedure(ADatos: TBandejaPaginaDTO)
    begin
      FTotalPaginas := (ADatos.Total + BANDEJA_POR_PAGINA - 1) div
        BANDEJA_POR_PAGINA;
      FVista.MostrarBandeja(ADatos);
      FVista.MostrarPaginacion(lPagina, FTotalPaginas, ADatos.Total);
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
