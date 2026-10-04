unit Anovo.Presentadores.Bandeja;

// Presentador de la bandeja de aprobacion.

interface

uses
  Anovo.Api.Intf.Cotizaciones,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.Bandeja,
  Anovo.Permisos;

type
  TPresentadorBandeja = class(TPresentadorBase)
  private
    FVista: IVistaBandeja;
    FApi: IApiCotizaciones;
    FTexto: string;
    FPagina: Integer;
    FTotalPaginas: Integer;
    procedure Cargar;
  public
    constructor Create(const AVista: IVistaBandeja;
      const AApi: IApiCotizaciones);
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
  Anovo.DTOs.Cotizaciones,
  Anovo.Sesion,
  Anovo.Textos;

constructor TPresentadorBandeja.Create(const AVista: IVistaBandeja;
  const AApi: IApiCotizaciones);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FPagina := 1;
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
