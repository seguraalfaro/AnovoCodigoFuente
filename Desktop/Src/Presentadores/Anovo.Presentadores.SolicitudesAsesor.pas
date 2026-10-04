unit Anovo.Presentadores.SolicitudesAsesor;

// Presentador de la seccion Solicitudes del asesor.

interface

uses
  Anovo.Api.Intf.Solicitudes,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.SolicitudesAsesor;

type
  TPresentadorSolicitudesAsesor = class(TPresentadorBase)
  private
    FVista: IVistaSolicitudesAsesor;
    FApi: IApiSolicitudes;
    FTexto: string;
    FHistorial: Boolean;
    FPagina: Integer;
    FTotalPaginas: Integer;
    procedure Cargar;
  public
    constructor Create(const AVista: IVistaSolicitudesAsesor;
      const AApi: IApiSolicitudes);
    procedure Iniciar;
    procedure Buscar(const ATexto: string);
    procedure Limpiar;
    procedure VerHistorial(const AHistorial: Boolean);
    procedure IrAPagina(const APagina: Integer);
    procedure PaginaSiguiente;
    procedure PaginaAnterior;
  end;

const
  SOLICITUDES_POR_PAGINA = 50;

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
  Anovo.DTOs.Dashboard,
  Anovo.Textos;

constructor TPresentadorSolicitudesAsesor.Create(const AVista: IVistaSolicitudesAsesor;
  const AApi: IApiSolicitudes);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FHistorial := False;
  FPagina := 1;
end;

procedure TPresentadorSolicitudesAsesor.Iniciar;
begin
  FVista.MostrarBusqueda('', False);
  Cargar;
end;

procedure TPresentadorSolicitudesAsesor.Buscar(const ATexto: string);
begin
  FTexto := Trim(ATexto);
  FPagina := 1;
  FVista.MostrarBusqueda(FTexto, not FTexto.IsEmpty);
  Cargar;
end;

procedure TPresentadorSolicitudesAsesor.Limpiar;
begin
  Buscar('');
end;

procedure TPresentadorSolicitudesAsesor.VerHistorial(const AHistorial: Boolean);
begin
  if AHistorial = FHistorial then
    Exit;
  FHistorial := AHistorial;
  FPagina := 1;
  Cargar;
end;

procedure TPresentadorSolicitudesAsesor.IrAPagina(const APagina: Integer);
begin
  if (APagina < 1) or ((FTotalPaginas > 0) and (APagina > FTotalPaginas)) then
    Exit;
  FPagina := APagina;
  Cargar;
end;

procedure TPresentadorSolicitudesAsesor.PaginaSiguiente;
begin
  IrAPagina(FPagina + 1);
end;

procedure TPresentadorSolicitudesAsesor.PaginaAnterior;
begin
  IrAPagina(FPagina - 1);
end;

procedure TPresentadorSolicitudesAsesor.Cargar;
var
  lApi: IApiSolicitudes;
  lPagina: Integer;
  lTexto: string;
  lHistorial: Boolean;
  lTotal: Int64;
  lDesde: TDateTime;
begin
  lApi := FApi;
  lTexto := FTexto;
  lPagina := FPagina;
  lHistorial := FHistorial;
  lTotal := 0;
  lDesde := 0;

  EjecutarUltima<TObjectList<TSolicitudAsesorDTO>>(SAccionCargarSolicitudes,
    function: TObjectList<TSolicitudAsesorDTO>
    begin
      Result := lApi.Seguimiento(lTexto, lHistorial, lPagina,
        SOLICITUDES_POR_PAGINA, lTotal, lDesde);
    end,
    procedure(ALista: TObjectList<TSolicitudAsesorDTO>)
    begin
      FTotalPaginas := (lTotal + SOLICITUDES_POR_PAGINA - 1) div
        SOLICITUDES_POR_PAGINA;
      FVista.MostrarPeriodo(lHistorial, lDesde);
      FVista.MostrarSolicitudes(ALista);
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
