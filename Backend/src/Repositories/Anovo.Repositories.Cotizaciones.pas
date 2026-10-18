unit Anovo.Repositories.Cotizaciones;

// Repositorios de cotizaciones y su detalle.

interface

uses
  System.Generics.Collections,
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Cotizaciones,
  Anovo.Entities.Cotizaciones,
  Anovo.Entities.Vistas.Lectura,
  Anovo.Entities.Consultas;

type
  TCotizacionRepository = class(TAnovoRepository<TCotizaciones>,
    ICotizacionRepository)
  private
    function Filtro(const AEstado: string;
      const AClienteId, AAsesorId: Integer;
      const ADesde, AHasta: TDateTime; const AElaboradaPor: Integer): string;
    function Parametros(const ATexto, AEstado: string;
      const AClienteId, AAsesorId: Integer;
      const ADesde, AHasta: TDateTime;
      const AElaboradaPor: Integer): TArray<Variant>;
  public
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AEstado: string = ''; const AClienteId: Integer = 0;
      const AAsesorId: Integer = 0; const ADesde: TDateTime = 0;
      const AHasta: TDateTime = 0; const AElaboradaPor: Integer = 0)
      : TObjectList<TCotizaciones>;
    function ContarBusqueda(const ATexto: string; const AEstado: string = '';
      const AClienteId: Integer = 0; const AAsesorId: Integer = 0;
      const ADesde: TDateTime = 0; const AHasta: TDateTime = 0;
      const AElaboradaPor: Integer = 0): Int64;
    function ObtenerPorNumero(const ANumero: Integer): TCotizaciones;
    function SiguienteNumero: Integer;
    function EnviadasSinRespuesta(const ADias: Integer)
      : TObjectList<TCotizaciones>;
    function Bandeja(const AUsuarioId: Integer; const ATexto: string;
      const ADesde, AHasta: TDateTime; const APagina, APorPagina: Integer)
      : TObjectList<TBandejaCotizaciones>;
    function ContarBandeja(const AUsuarioId: Integer; const ATexto: string;
      const ADesde, AHasta: TDateTime): Int64;
    function ResumenBandeja(const AUsuarioId: Integer)
      : TTrabajoUsuario;
    function TieneEnCurso(const ASolicitudId: Integer): Boolean;
    function VistaDe(const AId: Integer): TCotizacionConNombres;
    function VistasDe(const AIds: TArray<Integer>)
      : TObjectList<TCotizacionConNombres>;
    function HistorialDe(const AId: Integer): TObjectList<THistorialCotizacion>;
  end;

  TCotizacionDetalleRepository = class(TAnovoRepository<TCotizacionDetalle>,
    ICotizacionDetalleRepository)
  public
    function DetalleDe(const ACotizacionId: Integer)
      : TObjectList<TCotizacionDetalle>;
    function LineaDe(const ACotizacionId, ALineaId: Integer)
      : TCotizacionDetalle;
    function SiguienteOrden(const ACotizacionId: Integer): Integer;
    procedure SubtotalesDe(const ACotizacionId: Integer;
      out AMateriales, AManoObra, AMaquina: Currency);
  end;

  TCotizacionEnvioRepository = class(TAnovoRepository<TCotizacionEnvios>,
    ICotizacionEnvioRepository)
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  System.Variants,
  Anovo.SQL.Cotizaciones;

const
  TIPO_MATERIAL = 'material';
  TIPO_MANO_OBRA = 'mano_obra';
  TIPO_MAQUINA = 'maquina';

function TCotizacionRepository.Filtro(const AEstado: string;
  const AClienteId, AAsesorId: Integer;
  const ADesde, AHasta: TDateTime; const AElaboradaPor: Integer): string;
begin
  Result := COTIZACIONES_FILTRO_BUSQUEDA;
  if AEstado <> '' then
    Result := Result + COTIZACIONES_POR_ESTADO;
  if AClienteId > 0 then
    Result := Result + COTIZACIONES_DEL_CLIENTE;
  if AAsesorId > 0 then
    Result := Result + COTIZACIONES_DEL_ASESOR;
  if (ADesde > 0) and (AHasta > 0) then
    Result := Result + COTIZACIONES_EN_PERIODO;
  if AElaboradaPor > 0 then
    Result := Result + COTIZACIONES_ELABORADAS_POR;
end;

function TCotizacionRepository.Parametros(const ATexto, AEstado: string;
  const AClienteId, AAsesorId: Integer; const ADesde, AHasta: TDateTime;
  const AElaboradaPor: Integer): TArray<Variant>;
begin
  Result := [ATexto];
  if AEstado <> '' then
    Result := Result + [Variant(AEstado)];
  if AClienteId > 0 then
    Result := Result + [Variant(AClienteId)];
  if AAsesorId > 0 then
    Result := Result + [Variant(AAsesorId)];
  if (ADesde > 0) and (AHasta > 0) then
    Result := Result + [Variant(ADesde), Variant(AHasta)];
  if AElaboradaPor > 0 then
    Result := Result + [Variant(AElaboradaPor)];
end;

function TCotizacionRepository.Buscar(const ATexto: string;
  const APagina, APorPagina: Integer; const AEstado: string;
  const AClienteId, AAsesorId: Integer; const ADesde, AHasta: TDateTime;
  const AElaboradaPor: Integer): TObjectList<TCotizaciones>;
var
  lDesde, lHasta: Integer;
begin
  lDesde := ((APagina - 1) * APorPagina) + 1;
  lHasta := APagina * APorPagina;
  Result := GetWhere(Filtro(AEstado, AClienteId, AAsesorId, ADesde, AHasta,
    AElaboradaPor) + COTIZACIONES_ORDEN_Y_PAGINA,
    Parametros(ATexto, AEstado, AClienteId, AAsesorId, ADesde, AHasta,
    AElaboradaPor) +
    [Variant(lDesde), Variant(lHasta)]);
end;

function TCotizacionRepository.ContarBusqueda(const ATexto, AEstado: string;
  const AClienteId, AAsesorId: Integer;
  const ADesde, AHasta: TDateTime; const AElaboradaPor: Integer): Int64;
begin
  Result := ContarPorFiltro(Filtro(AEstado, AClienteId, AAsesorId, ADesde,
    AHasta, AElaboradaPor), Parametros(ATexto, AEstado, AClienteId, AAsesorId,
    ADesde, AHasta, AElaboradaPor));
end;

function TCotizacionRepository.Bandeja(const AUsuarioId: Integer;
  const ATexto: string; const ADesde, AHasta: TDateTime;
  const APagina, APorPagina: Integer): TObjectList<TBandejaCotizaciones>;
begin
  if (ADesde > 0) and (AHasta > 0) then
    Result := ListarConsulta<TBandejaCotizaciones>(CONSULTA_ENTRE,
      [AUsuarioId, FechaParaRQL(ADesde), FechaParaRQL(AHasta),
      TextoParaRQL(ATexto), TextoParaRQL(ATexto), (APagina - 1) * APorPagina,
      APorPagina])
  else
    Result := ListarConsulta<TBandejaCotizaciones>(CONSULTA_DE_OTROS,
      [AUsuarioId, TextoParaRQL(ATexto), TextoParaRQL(ATexto),
      (APagina - 1) * APorPagina, APorPagina]);
end;

function TCotizacionRepository.ContarBandeja(const AUsuarioId: Integer;
  const ATexto: string; const ADesde, AHasta: TDateTime): Int64;
begin
  if (ADesde > 0) and (AHasta > 0) then
    Result := ContarConsulta<TBandejaCotizaciones>(CONSULTA_ENTRE,
      [AUsuarioId, FechaParaRQL(ADesde), FechaParaRQL(AHasta),
      TextoParaRQL(ATexto), TextoParaRQL(ATexto), 0, 0])
  else
    Result := ContarConsulta<TBandejaCotizaciones>(CONSULTA_DE_OTROS,
      [AUsuarioId, TextoParaRQL(ATexto), TextoParaRQL(ATexto), 0, 0]);
end;

function TCotizacionRepository.ResumenBandeja(const AUsuarioId: Integer)
  : TTrabajoUsuario;
begin
  Result := PrimeraFilaDeConsulta<TTrabajoUsuario>(CONSULTA_DE_USUARIO, [AUsuarioId]);
end;

function TCotizacionRepository.TieneEnCurso(const ASolicitudId: Integer)
  : Boolean;
begin
  Result := ContarPorFiltro(COTIZACIONES_EN_CURSO_DE_SOLICITUD,
    [ASolicitudId]) > 0;
end;

function TCotizacionRepository.VistaDe(const AId: Integer)
  : TCotizacionConNombres;
begin
  Result := PrimeraFilaDeConsulta<TCotizacionConNombres>(CONSULTA_POR_ID, [AId]);
end;

function TCotizacionRepository.VistasDe(const AIds: TArray<Integer>)
  : TObjectList<TCotizacionConNombres>;
var
  lId: Integer;
  lLista: string;
begin
  if Length(AIds) = 0 then
    Exit(TObjectList<TCotizacionConNombres>.Create(True));
  lLista := '';
  for lId in AIds do
  begin
    if lLista <> '' then
      lLista := lLista + ',';
    lLista := lLista + lId.ToString;
  end;
  Result := ListarConsulta<TCotizacionConNombres>(CONSULTA_DE_IDS, [lLista],
    SIN_LIMITE);
end;

function TCotizacionRepository.HistorialDe(const AId: Integer)
  : TObjectList<THistorialCotizacion>;
begin
  Result := ListarConsulta<THistorialCotizacion>(CONSULTA_HISTORIAL_DE, [AId],
    SIN_LIMITE);
end;

function TCotizacionRepository.ObtenerPorNumero(const ANumero: Integer)
  : TCotizaciones;
begin
  Result := GetOneByWhere(COTIZACIONES_POR_NUMERO, [ANumero], False);
end;

function TCotizacionRepository.SiguienteNumero: Integer;
begin
  Result := GetConnection.ExecSQLScalar(COTIZACIONES_SIGUIENTE_NUMERO);
end;

function TCotizacionRepository.EnviadasSinRespuesta(const ADias: Integer)
  : TObjectList<TCotizaciones>;
begin
  Result := GetWhere(COTIZACIONES_ENVIADAS_SIN_RESPUESTA, [IncDay(Now, -ADias)]);
end;

function TCotizacionDetalleRepository.DetalleDe(const ACotizacionId: Integer)
  : TObjectList<TCotizacionDetalle>;
begin
  Result := GetWhere(COTIZACION_DETALLE_DE, [ACotizacionId]);
end;

function TCotizacionDetalleRepository.LineaDe(const ACotizacionId,
  ALineaId: Integer): TCotizacionDetalle;
begin
  Result := GetOneByWhere(COTIZACION_LINEA_DE, [ALineaId, ACotizacionId],
    False);
end;

function TCotizacionDetalleRepository.SiguienteOrden(const ACotizacionId
  : Integer): Integer;
begin
  Result := GetConnection.ExecSQLScalar(COTIZACION_SIGUIENTE_ORDEN,
    [ACotizacionId]);
end;

procedure TCotizacionDetalleRepository.SubtotalesDe(const ACotizacionId
  : Integer; out AMateriales, AManoObra, AMaquina: Currency);
begin
  AMateriales := GetConnection.ExecSQLScalar(COTIZACION_SUBTOTAL_DE_TIPO,
    [ACotizacionId, TIPO_MATERIAL]);
  AManoObra := GetConnection.ExecSQLScalar(COTIZACION_SUBTOTAL_DE_TIPO,
    [ACotizacionId, TIPO_MANO_OBRA]);
  AMaquina := GetConnection.ExecSQLScalar(COTIZACION_SUBTOTAL_DE_TIPO,
    [ACotizacionId, TIPO_MAQUINA]);
end;

end.
