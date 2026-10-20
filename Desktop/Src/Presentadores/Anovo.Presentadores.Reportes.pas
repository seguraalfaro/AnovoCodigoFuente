unit Anovo.Presentadores.Reportes;

// Presentador de reportes: periodo, vistas segun el permiso, cifras con la
// comparacion contra el periodo anterior y las cotizaciones de cada fila.

interface

uses
  Anovo.Api.Intf.Reportes,
  Anovo.DTOs.Reportes,
  Anovo.PeriodoBusqueda,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.Reportes;

type
  TPresentadorReportes = class(TPresentadorBase)
  private
    FVista: IVistaReportes;
    FApi: IApiReportes;
    FVistas: TArray<TVistaReporte>;
    FVistaActual: TVistaReporte;
    FPeriodo: TPeriodoBusqueda;
    FDesde: TDateTime;
    FHasta: TDateTime;
    procedure Cargar;
    function Resumir(const AReporte: TReporteCotizacionesDTO): TResumenReporte;
  public
    constructor Create(const AVista: IVistaReportes;
      const AApi: IApiReportes);
    procedure Iniciar;
    procedure FiltrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure ElegirVista(const AIndice: Integer);
    procedure VerDetalle(const AClave, ARotulo: string);
  end;

implementation

uses
  System.SysUtils,
  System.Math,
  System.Generics.Collections,
  Anovo.DTOs.Cotizaciones,
  Anovo.Formato,
  Anovo.Sesion,
  Anovo.Permisos,
  Anovo.Textos;

const
  ROTULO_VISTA: array [TVistaReporte] of string = (SVistaPorEstado,
    SVistaPorAsesor, SVistaPorTipo, SVistaPorMes, SVistaSinRespuesta);

  VISTA_API: array [TVistaReporte] of string = ('estado', 'asesor', 'tipo',
    'mes', 'cliente');

  VISTAS_TODAS: TArray<TVistaReporte> = [vrEstado, vrAsesor, vrTipo, vrMes,
    vrCliente];
  VISTAS_PROPIAS: TArray<TVistaReporte> = [vrEstado, vrTipo, vrMes];

function Flecha(const ADiferencia: Double): string;
begin
  if ADiferencia > 0 then
    Result := SFlechaSube
  else
    Result := SFlechaBaja;
end;

function VariacionMonto(const AActual, AAntes: Currency): string;
var
  lCambio: Integer;
begin
  if AAntes = 0 then
  begin
    if AActual = 0 then
      Exit(SVariacionIgual);
    Exit(SVariacionSinBase);
  end;
  lCambio := Round((AActual - AAntes) * 100 / AAntes);
  if lCambio = 0 then
    Result := SVariacionIgual
  else
    Result := Format(SVariacionPorcentaje, [Flecha(lCambio), Abs(lCambio)]);
end;

function VariacionPuntos(const AActual, AAntes: Currency;
  const AHayBase: Boolean): string;
begin
  if not AHayBase then
    Exit(SVariacionSinBase);
  if AActual = AAntes then
    Result := SVariacionIgual
  else
    Result := Format(SVariacionPuntos, [Flecha(AActual - AAntes),
      TFormato.Puntos(Abs(AActual - AAntes))]);
end;

function VariacionDias(const AActual, AAntes: Integer;
  const AHayBase: Boolean): string;
begin
  if not AHayBase then
    Exit(SVariacionSinBase);
  if AActual = AAntes then
    Result := SVariacionIgual
  else
    Result := Format(SVariacionDias, [Flecha(AActual - AAntes),
      TFormato.Dias(Abs(AActual - AAntes))]);
end;

function Unir(const APartes: array of string): string;
var
  lParte: string;
begin
  Result := '';
  for lParte in APartes do
    if not lParte.Trim.IsEmpty then
    begin
      if not Result.IsEmpty then
        Result := Result + SReporteSeparador;
      Result := Result + lParte;
    end;
end;

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
  FVistaActual := FVistas[0];
  FVista.MostrarVista(FVistaActual);
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
  FVistaActual := FVistas[AIndice];
  FVista.MostrarVista(FVistaActual);
end;

function TPresentadorReportes.Resumir(const AReporte: TReporteCotizacionesDTO)
  : TResumenReporte;
var
  lAntes: TReporteResumenDTO;
  lHayBase: Boolean;
begin
  lAntes := AReporte.Anterior;
  lHayBase := (lAntes.Total + lAntes.Aprobadas + lAntes.Rechazadas) > 0;

  Result.Rotulos[crEnviadas] := SCifraEnviadas;
  Result.Rotulos[crMontoEnviado] := SCifraMontoEnviado;
  Result.Rotulos[crAprobadas] := SCifraAprobadas;
  Result.Rotulos[crMontoAprobado] := SCifraMontoAprobado;
  Result.Rotulos[crTasa] := SCifraTasa;
  Result.Rotulos[crRespuesta] := SCifraRespuesta;

  Result.Valores[crEnviadas] := AReporte.Total.ToString;
  Result.Valores[crMontoEnviado] := TFormato.Colones(AReporte.MontoTotal);
  Result.Valores[crAprobadas] := AReporte.Aprobadas.ToString;
  Result.Valores[crMontoAprobado] := TFormato.Colones(AReporte.MontoAprobado);
  Result.Valores[crTasa] := TFormato.Tasa(AReporte.TasaAprobacion);
  Result.Valores[crRespuesta] := TFormato.Dias(AReporte.RespuestaMedia);

  Result.Variaciones[crEnviadas] := VariacionMonto(AReporte.Total,
    lAntes.Total);
  Result.Variaciones[crMontoEnviado] := VariacionMonto(AReporte.MontoTotal,
    lAntes.MontoTotal);
  Result.Variaciones[crAprobadas] := VariacionMonto(AReporte.Aprobadas,
    lAntes.Aprobadas);
  Result.Variaciones[crMontoAprobado] :=
    VariacionMonto(AReporte.MontoAprobado, lAntes.MontoAprobado);
  Result.Variaciones[crTasa] := VariacionPuntos(AReporte.TasaAprobacion,
    lAntes.TasaAprobacion, lAntes.Aprobadas + lAntes.Rechazadas > 0);
  Result.Variaciones[crRespuesta] := VariacionDias(AReporte.RespuestaMedia,
    lAntes.RespuestaMedia, lHayBase);

  Result.Comparado := Format(SReporteCompara, [TFormato.Fecha(lAntes.Desde),
    TFormato.Fecha(lAntes.Hasta)]);
  Result.Periodo := Format(SPeriodoEntre, [TFormato.Fecha(AReporte.Desde),
    TFormato.Fecha(AReporte.Hasta)]);
  Result.Empresa := AReporte.EmpresaRazonSocial;
  Result.EmpresaDatos := Unir([AReporte.EmpresaCedula,
    AReporte.EmpresaTelefono, AReporte.EmpresaCorreo]);
  Result.Generado := Format(SReportePdfGenerado, [TSesion.Nombre,
    TFormato.FechaHora(Now)]);
  Result.TasaTotal := Result.Valores[crTasa];
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
      FDesde := AReporte.Desde;
      FHasta := AReporte.Hasta;
      lMaximo := 0;
      for lMes in AReporte.PorMes do
        lMaximo := Max(lMaximo, lMes.Cantidad);
      FVista.MostrarReporte(AReporte, Resumir(AReporte), lMaximo);
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

procedure TPresentadorReportes.VerDetalle(const AClave, ARotulo: string);
var
  lApi: IApiReportes;
  lDesde, lHasta: TDateTime;
  lVista, lClave, lTitulo, lAyuda: string;
begin
  if AClave.IsEmpty or (FDesde = 0) then
    Exit;
  lApi := FApi;
  lDesde := FDesde;
  lHasta := FHasta;
  lVista := VISTA_API[FVistaActual];
  lClave := AClave;
  if FVistaActual = vrEstado then
    lTitulo := Format(SDetalleReporteTitulo, [TFormato.Estado(ARotulo)])
  else
    lTitulo := Format(SDetalleReporteTitulo, [ARotulo]);
  lAyuda := Format(SDetalleReporteAyuda, [ROTULO_VISTA[FVistaActual],
    Format(SPeriodoEntre, [TFormato.Fecha(lDesde), TFormato.Fecha(lHasta)])]);

  EjecutarUltima<TObjectList<TCotizacionDTO>>(SAccionCargarDetalleReporte,
    function: TObjectList<TCotizacionDTO>
    begin
      Result := lApi.Detalle(lDesde, lHasta, lVista, lClave);
    end,
    procedure(AFilas: TObjectList<TCotizacionDTO>)
    begin
      FVista.MostrarDetalle(lTitulo, lAyuda, AFilas);
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
