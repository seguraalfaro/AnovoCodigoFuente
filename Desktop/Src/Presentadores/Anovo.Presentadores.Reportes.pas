unit Anovo.Presentadores.Reportes;

// Presentador de reportes: periodo, vistas segun el permiso y carga del
// reporte de cotizaciones.

interface

uses
  Anovo.Api.Intf.Reportes,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.Reportes;

type
  TPresentadorReportes = class(TPresentadorBase)
  private
    FVista: IVistaReportes;
    FApi: IApiReportes;
    FVistas: TArray<TVistaReporte>;
    FDesde: TDateTime;
    FHasta: TDateTime;
    procedure Cargar;
  public
    constructor Create(const AVista: IVistaReportes;
      const AApi: IApiReportes);
    procedure Iniciar;
    procedure ElegirPeriodo(const AIndice: Integer);
    procedure Consultar(const ADesde, AHasta: TDateTime);
    procedure ElegirVista(const AIndice: Integer);
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
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
  ElegirPeriodo(Ord(prEsteMes));
end;

procedure TPresentadorReportes.ElegirPeriodo(const AIndice: Integer);
var
  lHoy: TDateTime;
begin
  if (AIndice < Ord(Low(TPeriodoReporte))) or
    (AIndice > Ord(High(TPeriodoReporte))) then
    Exit;

  lHoy := Date;
  FHasta := lHoy;
  case TPeriodoReporte(AIndice) of
    prEsteMes:
      FDesde := StartOfTheMonth(lHoy);
    prMesAnterior:
      begin
        FDesde := StartOfTheMonth(IncMonth(lHoy, -1));
        FHasta := DateOf(EndOfTheMonth(FDesde));
      end;
    prTrimestre:
      FDesde := StartOfTheMonth(IncMonth(lHoy, -2));
    prAnio:
      FDesde := StartOfTheYear(lHoy);
  end;

  FVista.MostrarPeriodo(FDesde, FHasta, AIndice);
  Cargar;
end;

procedure TPresentadorReportes.Consultar(const ADesde, AHasta: TDateTime);
begin
  if DateOf(ADesde) > DateOf(AHasta) then
  begin
    FVista.MostrarError(SPeriodoInvertido);
    Exit;
  end;

  FDesde := DateOf(ADesde);
  FHasta := DateOf(AHasta);
  FVista.MostrarPeriodo(FDesde, FHasta, -1);
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
  lDesde := FDesde;
  lHasta := FHasta;

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
