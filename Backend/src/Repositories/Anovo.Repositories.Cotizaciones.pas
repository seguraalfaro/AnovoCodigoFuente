unit Anovo.Repositories.Cotizaciones;

// Repositorios de cotizaciones. El CRUD lo heredan; aqui estan las consultas
// con nombre propio.
//
// El SQL vive en Anovo.SQL.Cotizaciones.

interface

uses
  System.Generics.Collections,
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Cotizaciones,
  Anovo.Entities.Cotizaciones;

type
  TCotizacionRepository = class(TAnovoRepository<TCotizaciones>,
    ICotizacionRepository)
  private
    function Filtro(const AEstado: string;
      const AClienteId, AElaboradaPor: Integer;
      const ADesde, AHasta: TDateTime): string;
    function Parametros(const ATexto, AEstado: string;
      const AClienteId, AElaboradaPor: Integer;
      const ADesde, AHasta: TDateTime): TArray<Variant>;
  public
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AEstado: string = ''; const AClienteId: Integer = 0;
      const AElaboradaPor: Integer = 0; const ADesde: TDateTime = 0;
      const AHasta: TDateTime = 0): TObjectList<TCotizaciones>;
    function ContarBusqueda(const ATexto: string; const AEstado: string = '';
      const AClienteId: Integer = 0; const AElaboradaPor: Integer = 0;
      const ADesde: TDateTime = 0; const AHasta: TDateTime = 0): Int64;
    function ObtenerPorNumero(const ANumero: Integer): TCotizaciones;
    function SiguienteNumero: Integer;
    function DeSolicitud(const ASolicitudId: Integer)
      : TObjectList<TCotizaciones>;
    function EnviadasSinRespuesta(const ADias: Integer)
      : TObjectList<TCotizaciones>;
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

implementation

uses
  System.SysUtils,
  System.Variants,
  Anovo.SQL.Cotizaciones;

const
  // Los tipos de linea, tal como los escribe CK_DETALLE_TIPO.
  TIPO_MATERIAL = 'material';
  TIPO_MANO_OBRA = 'mano_obra';
  TIPO_MAQUINA = 'maquina';

{ TCotizacionRepository }

function TCotizacionRepository.Filtro(const AEstado: string;
  const AClienteId, AElaboradaPor: Integer;
  const ADesde, AHasta: TDateTime): string;
begin
  Result := COTIZACIONES_FILTRO_BUSQUEDA;
  if AEstado <> '' then
    Result := Result + COTIZACIONES_POR_ESTADO;
  if AClienteId > 0 then
    Result := Result + COTIZACIONES_DEL_CLIENTE;
  if AElaboradaPor > 0 then
    Result := Result + COTIZACIONES_ELABORADAS_POR;
  if (ADesde > 0) and (AHasta > 0) then
    Result := Result + COTIZACIONES_ENTRE_FECHAS;
end;

function TCotizacionRepository.Parametros(const ATexto, AEstado: string;
  const AClienteId, AElaboradaPor: Integer; const ADesde, AHasta: TDateTime)
  : TArray<Variant>;
begin
  // En el mismo orden en que Filtro pone los ?.
  Result := [ATexto];
  if AEstado <> '' then
    Result := Result + [Variant(AEstado)];
  if AClienteId > 0 then
    Result := Result + [Variant(AClienteId)];
  if AElaboradaPor > 0 then
    Result := Result + [Variant(AElaboradaPor)];
  if (ADesde > 0) and (AHasta > 0) then
    Result := Result + [Variant(ADesde), Variant(AHasta)];
end;

function TCotizacionRepository.Buscar(const ATexto: string;
  const APagina, APorPagina: Integer; const AEstado: string;
  const AClienteId, AElaboradaPor: Integer; const ADesde, AHasta: TDateTime)
  : TObjectList<TCotizaciones>;
var
  lDesde, lHasta: Integer;
begin
  lDesde := ((APagina - 1) * APorPagina) + 1;
  lHasta := APagina * APorPagina;
  Result := GetWhere(Filtro(AEstado, AClienteId, AElaboradaPor, ADesde, AHasta)
    + COTIZACIONES_ORDEN_Y_PAGINA,
    Parametros(ATexto, AEstado, AClienteId, AElaboradaPor, ADesde, AHasta) +
    [Variant(lDesde), Variant(lHasta)]);
end;

function TCotizacionRepository.ContarBusqueda(const ATexto, AEstado: string;
  const AClienteId, AElaboradaPor: Integer;
  const ADesde, AHasta: TDateTime): Int64;
begin
  Result := GetConnection.ExecSQLScalar(COTIZACIONES_CONTAR +
    Filtro(AEstado, AClienteId, AElaboradaPor, ADesde, AHasta),
    Parametros(ATexto, AEstado, AClienteId, AElaboradaPor, ADesde, AHasta));
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

function TCotizacionRepository.DeSolicitud(const ASolicitudId: Integer)
  : TObjectList<TCotizaciones>;
begin
  Result := GetWhere(COTIZACIONES_DE_SOLICITUD, [ASolicitudId]);
end;

function TCotizacionRepository.EnviadasSinRespuesta(const ADias: Integer)
  : TObjectList<TCotizaciones>;
begin
  // La fecha limite se calcula aqui y viaja como parametro: asi la consulta no
  // depende de la hora del servidor de base de datos.
  Result := GetWhere(COTIZACIONES_ENVIADAS_SIN_RESPUESTA, [Now - ADias]);
end;

{ TCotizacionDetalleRepository }

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
