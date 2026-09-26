unit Anovo.Repositories.Solicitudes;

// Repositorios del modulo de solicitudes. El CRUD lo heredan; aqui estan las
// consultas con nombre propio.
//
// El SQL vive en Anovo.SQL.Solicitudes.

interface

uses
  System.Generics.Collections,
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Solicitudes,
  Anovo.Entities.Solicitudes;

type
  TSolicitudRepository = class(TAnovoRepository<TSolicitudes>,
    ISolicitudRepository)
  private
    function Filtro(const AAsesorId: Integer; const AEstado: string;
      const ADesde, AHasta: TDateTime): string;
    function Parametros(const ATexto: string; const AAsesorId: Integer;
      const AEstado: string; const ADesde, AHasta: TDateTime)
      : TArray<Variant>;
  public
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AAsesorId: Integer = 0; const AEstado: string = '';
      const ADesde: TDateTime = 0; const AHasta: TDateTime = 0)
      : TObjectList<TSolicitudes>;
    function ContarBusqueda(const ATexto: string;
      const AAsesorId: Integer = 0; const AEstado: string = '';
      const ADesde: TDateTime = 0; const AHasta: TDateTime = 0): Int64;
    function ObtenerPorUuidLocal(const AUuid: string): TSolicitudes;
    function ExisteUuidLocal(const AUuid: string): Integer;
    function PendientesDeCotizar(const AEstado: string)
      : TObjectList<TSolicitudes>;
  end;

  TSolicitudMedidaRepository = class(TAnovoRepository<TSolicitudMedidas>,
    ISolicitudMedidaRepository)
  public
    function MedidasDe(const ASolicitudId: Integer)
      : TObjectList<TSolicitudMedidas>;
    function MedidaDe(const ASolicitudId, AMedidaId: Integer)
      : TSolicitudMedidas;
    function MedidasDeCroquis(const ACroquisId: Integer)
      : TObjectList<TSolicitudMedidas>;
    function ObtenerPorUuidLocal(const AUuid: string): TSolicitudMedidas;
  end;

  TSolicitudAdjuntoRepository = class(TAnovoRepository<TSolicitudAdjuntos>,
    ISolicitudAdjuntoRepository)
  public
    function AdjuntosDe(const ASolicitudId: Integer)
      : TObjectList<TSolicitudAdjuntos>;
    function AdjuntoDe(const ASolicitudId, AAdjuntoId: Integer)
      : TSolicitudAdjuntos;
    function CroquisDe(const ASolicitudId: Integer)
      : TObjectList<TSolicitudAdjuntos>;
    function ObtenerPorUuidLocal(const AUuid: string): TSolicitudAdjuntos;
  end;

implementation

uses
  System.SysUtils,
  System.Variants,
  MVCFramework.ActiveRecord,
  Anovo.SQL.Solicitudes;

{ TSolicitudRepository }

function TSolicitudRepository.Filtro(const AAsesorId: Integer;
  const AEstado: string; const ADesde, AHasta: TDateTime): string;
begin
  Result := SOLICITUDES_FILTRO_BUSQUEDA;
  if AAsesorId > 0 then
    Result := Result + SOLICITUDES_DEL_ASESOR;
  if AEstado <> '' then
    Result := Result + SOLICITUDES_POR_ESTADO;
  if (ADesde > 0) and (AHasta > 0) then
    Result := Result + SOLICITUDES_ENTRE_FECHAS;
end;

function TSolicitudRepository.Parametros(const ATexto: string;
  const AAsesorId: Integer; const AEstado: string;
  const ADesde, AHasta: TDateTime): TArray<Variant>;
begin
  // En el mismo orden en que Filtro pone los ?.
  Result := [ATexto, ATexto];
  if AAsesorId > 0 then
    Result := Result + [Variant(AAsesorId)];
  if AEstado <> '' then
    Result := Result + [Variant(AEstado)];
  if (ADesde > 0) and (AHasta > 0) then
    Result := Result + [Variant(ADesde), Variant(AHasta)];
end;

function TSolicitudRepository.Buscar(const ATexto: string;
  const APagina, APorPagina: Integer; const AAsesorId: Integer;
  const AEstado: string; const ADesde, AHasta: TDateTime)
  : TObjectList<TSolicitudes>;
var
  lDesde, lHasta: Integer;
begin
  lDesde := ((APagina - 1) * APorPagina) + 1;
  lHasta := APagina * APorPagina;
  Result := GetWhere(Filtro(AAsesorId, AEstado, ADesde, AHasta) +
    SOLICITUDES_ORDEN_Y_PAGINA,
    Parametros(ATexto, AAsesorId, AEstado, ADesde, AHasta) +
    [Variant(lDesde), Variant(lHasta)]);
end;

function TSolicitudRepository.ContarBusqueda(const ATexto: string;
  const AAsesorId: Integer; const AEstado: string;
  const ADesde, AHasta: TDateTime): Int64;
begin
  Result := GetConnection.ExecSQLScalar(SOLICITUDES_CONTAR +
    Filtro(AAsesorId, AEstado, ADesde, AHasta),
    Parametros(ATexto, AAsesorId, AEstado, ADesde, AHasta));
end;

function TSolicitudRepository.ObtenerPorUuidLocal(const AUuid: string)
  : TSolicitudes;
begin
  Result := GetOneByWhere(SOLICITUDES_POR_UUID_LOCAL, [AUuid], False);
end;

function TSolicitudRepository.ExisteUuidLocal(const AUuid: string): Integer;
var
  lId: Variant;
begin
  lId := GetConnection.ExecSQLScalar(SOLICITUDES_ID_POR_UUID_LOCAL, [AUuid]);
  if VarIsNull(lId) then
    Result := 0
  else
    Result := lId;
end;

function TSolicitudRepository.PendientesDeCotizar(const AEstado: string)
  : TObjectList<TSolicitudes>;
begin
  Result := GetWhere(SOLICITUDES_PENDIENTES_DE_COTIZAR, [AEstado]);
end;

{ TSolicitudMedidaRepository }

function TSolicitudMedidaRepository.MedidasDe(const ASolicitudId: Integer)
  : TObjectList<TSolicitudMedidas>;
begin
  Result := GetWhere(MEDIDAS_DE_SOLICITUD, [ASolicitudId]);
end;

function TSolicitudMedidaRepository.MedidaDe(const ASolicitudId,
  AMedidaId: Integer): TSolicitudMedidas;
begin
  Result := GetOneByWhere(MEDIDA_DE_SOLICITUD, [AMedidaId, ASolicitudId],
    False);
end;

function TSolicitudMedidaRepository.MedidasDeCroquis(const ACroquisId: Integer)
  : TObjectList<TSolicitudMedidas>;
begin
  Result := GetWhere(MEDIDAS_DE_CROQUIS, [ACroquisId]);
end;

function TSolicitudMedidaRepository.ObtenerPorUuidLocal(const AUuid: string)
  : TSolicitudMedidas;
begin
  Result := GetOneByWhere(MEDIDAS_POR_UUID_LOCAL, [AUuid], False);
end;

{ TSolicitudAdjuntoRepository }

function TSolicitudAdjuntoRepository.AdjuntosDe(const ASolicitudId: Integer)
  : TObjectList<TSolicitudAdjuntos>;
begin
  // La consulta deja fuera los dos BLOB; sin loIgnoreNotExistentFields la
  // carga fallaria por esas columnas. En la entidad queda el stream vacio: una
  // entidad cargada asi no se guarda.
  Result := SelectConOpciones(ADJUNTOS_DE_SOLICITUD, [ASolicitudId],
    [loIgnoreNotExistentFields]);
end;

function TSolicitudAdjuntoRepository.AdjuntoDe(const ASolicitudId,
  AAdjuntoId: Integer): TSolicitudAdjuntos;
begin
  Result := GetOneByWhere(ADJUNTO_DE_SOLICITUD, [AAdjuntoId, ASolicitudId],
    False);
end;

function TSolicitudAdjuntoRepository.CroquisDe(const ASolicitudId: Integer)
  : TObjectList<TSolicitudAdjuntos>;
begin
  Result := GetWhere(CROQUIS_DE_SOLICITUD, [ASolicitudId]);
end;

function TSolicitudAdjuntoRepository.ObtenerPorUuidLocal(const AUuid: string)
  : TSolicitudAdjuntos;
begin
  Result := GetOneByWhere(ADJUNTOS_POR_UUID_LOCAL, [AUuid], False);
end;

end.
