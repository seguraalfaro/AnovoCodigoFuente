unit Anovo.Presentadores.Reportes;

// Presentador de reportes: periodo, vistas segun el permiso y carga del
// reporte de cotizaciones.

interface

uses
  Anovo.Api.Intf.Reportes,
  Anovo.PeriodoBusqueda,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.Reportes;

type
  TPresentadorReportes = class(TPresentadorBase)
  private
    FVista: IVistaReportes;
    FApi: IApiReportes;
    FVistas: TArray<TVistaReporte>;
    FPeriodo: TPeriodoBusqueda;
    procedure Cargar;
  public
    constructor Create(const AVista: IVistaReportes;
      const AApi: IApiReportes);
    procedure Iniciar;
    procedure FiltrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure ElegirVista(const AIndice: Integer);
  end;

implementation

uses
  System.SysUtils,
  Anovo.DTOs.Reportes,
  Anovo.Sesion,
  Anovo.Permisos,
  Anovo.Textos;

const
  ROTULO_VISTA: array [TVistaReporte] of string = (SVistaPorEstado,
    SVistaPorAsesor, SVistaPorTipo, SVistaPorMes);

  VISTAS_TODAS: TArray<TVistaReporte> = [vrEstado, vrAsesor, vrTipo, vrMes];
  VISTAS_PROPIAS: TArray<TVistaReporte> = [vrEstado, vrTipo, vrMes];

constructor TPresentadorReportes.Create(const AVista: IVistaReportes;
  const AApi: IApiReportes);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FPeriodo := TPeriodoBusqueda.De(apEsteMes);
end;

procedure TPresentadorReportes.Iniciar;
var
  lVista: TVistaReporte;
  lRotulos: TArray<string>;
begin
  if TSesion.Tiene(PERMISO_REPORTES_VER) then
    FVistas := VISTAS_TODAS
  else
    FVistas := VISTAS_PROPIAS;

  lRotulos := [];
  for lVista in FVistas do
    lRotulos := lRotulos + [ROTULO_VISTA[lVista]];
  FVista.MostrarVistas(lRotulos);
  FVista.MostrarVista(FVistas[0]);
  FVista.MostrarPeriodo(FPeriodo);
  Cargar;
end;

procedure TPresentadorReportes.FiltrarPeriodo(const APeriodo
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
  Cargar;
end;

procedure TPresentadorReportes.ElegirVista(const AIndice: Integer);
begin
  if (AIndice < 0) or (AIndice > High(FVistas)) then
    Exit;
  FVista.MostrarVista(FVistas[AIndice]);
end;

procedure TPresentadorReportes.Cargar;
var
  lApi: IApiReportes;
  lDesde, lHasta: TDateTime;
begin
  lApi := FApi;
  lDesde := FPeriodo.Desde;
  lHasta := FPeriodo.Hasta;

  EjecutarUltima<TReporteCotizacionesDTO>(SAccionCargarReporte,
    function: TReporteCotizacionesDTO
    begin
      Result := lApi.Cotizaciones(lDesde, lHasta);
    end,
    procedure(AReporte: TReporteCotizacionesDTO)
    var
      lMes: TReporteMesDTO;
      lMaximo: Integer;
    begin
      lMaximo := 0;
      for lMes in AReporte.PorMes do
        if lMes.Cantidad > lMaximo then
          lMaximo := lMes.Cantidad;
      FVista.MostrarReporte(AReporte, lMaximo);
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
