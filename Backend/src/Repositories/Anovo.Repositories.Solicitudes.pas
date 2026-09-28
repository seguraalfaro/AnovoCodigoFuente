unit Anovo.Repositories.Solicitudes;

// Repositorios de solicitudes, medidas y adjuntos.

interface

uses
  System.Generics.Collections,
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Solicitudes,
  Anovo.Entities.Solicitudes,
  Anovo.Entities.Vistas.Lectura,
  Anovo.Entities.Consultas;

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
    function ExisteUuidLocal(const AUuid: string): Integer;    function Seguimiento(const AAsesorId: Integer; const ATexto: string;
      const ADesde, AHasta: TDateTime; const APagina, APorPagina: Integer)
      : TObjectList<TSeguimientoAsesor>;
    function ContarSeguimiento(const AAsesorId: Integer; const ATexto: string;
      const ADesde, AHasta: TDateTime): Int64;
    function Cola(const ATexto: string; const APagina, APorPagina: Integer)
      : TObjectList<TColaSolicitudes>;
    function ContarCola(const ATexto: string): Int64;
    function EnTrabajo(const AUsuarioId: Integer; const ATexto: string;
      const APagina, APorPagina: Integer)
      : TObjectList<TCotizacionesEnTrabajo>;
    function ContarEnTrabajo(const AUsuarioId: Integer;
      const ATexto: string): Int64;
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
      : TObjectList<TAdjuntosDeSolicitud>;
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
  Result := ContarPorFiltro(Filtro(AAsesorId, AEstado, ADesde, AHasta),
    Parametros(ATexto, AAsesorId, AEstado, ADesde, AHasta));
end;

function TSolicitudRepository.ObtenerPorUuidLocal(const AUuid: string)
  : TSolicitudes;
begin
  Result := GetOneByWhere(SOLICITUDES_POR_UUID_LOCAL, [AUuid], False);
end;

function TSolicitudRepository.ExisteUuidLocal(const AUuid: string): Integer;
var
  lSolicitud: TSolicitudes;
begin
  lSolicitud := ObtenerPorUuidLocal(AUuid);
  try
    Result := 0;
    if Assigned(lSolicitud) then
      Result := lSolicitud.ID.ValueOrDefault;
  finally
    lSolicitud.Free;
  end;
end;

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

function TSolicitudAdjuntoRepository.AdjuntosDe(const ASolicitudId: Integer)
  : TObjectList<TAdjuntosDeSolicitud>;
begin
  Result := ListarConsulta<TAdjuntosDeSolicitud>(CONSULTA_DE_SOLICITUD,
    [ASolicitudId], SIN_LIMITE);
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

function TSolicitudRepository.Seguimiento(const AAsesorId: Integer;
  const ATexto: string; const ADesde, AHasta: TDateTime;
  const APagina, APorPagina: Integer): TObjectList<TSeguimientoAsesor>;
begin
  if (ADesde > 0) and (AHasta > 0) then
    Result := ListarConsulta<TSeguimientoAsesor>(CONSULTA_DE_ASESOR_ENTRE,
      [AAsesorId, FechaParaRQL(ADesde), FechaParaRQL(AHasta), TextoParaRQL(ATexto),
      TextoParaRQL(ATexto), (APagina - 1) * APorPagina, APorPagina])
  else
    Result := ListarConsulta<TSeguimientoAsesor>(CONSULTA_DE_ASESOR,
      [AAsesorId, TextoParaRQL(ATexto), TextoParaRQL(ATexto),
      (APagina - 1) * APorPagina, APorPagina]);
end;

function TSolicitudRepository.ContarSeguimiento(const AAsesorId: Integer;
  const ATexto: string; const ADesde, AHasta: TDateTime): Int64;
begin
  if (ADesde > 0) and (AHasta > 0) then
    Result := ContarConsulta<TSeguimientoAsesor>(CONSULTA_DE_ASESOR_ENTRE,
      [AAsesorId, FechaParaRQL(ADesde), FechaParaRQL(AHasta), TextoParaRQL(ATexto),
      TextoParaRQL(ATexto), 0, 0])
  else
    Result := ContarConsulta<TSeguimientoAsesor>(CONSULTA_DE_ASESOR,
      [AAsesorId, TextoParaRQL(ATexto), TextoParaRQL(ATexto), 0, 0]);
end;

function TSolicitudRepository.Cola(const ATexto: string;
  const APagina, APorPagina: Integer): TObjectList<TColaSolicitudes>;
begin
  Result := ListarConsulta<TColaSolicitudes>(CONSULTA_BUSCAR,
    [TextoParaRQL(ATexto), TextoParaRQL(ATexto), (APagina - 1) * APorPagina, APorPagina]);
end;

function TSolicitudRepository.ContarCola(const ATexto: string): Int64;
begin
  Result := ContarConsulta<TColaSolicitudes>(CONSULTA_BUSCAR,
    [TextoParaRQL(ATexto), TextoParaRQL(ATexto), 0, 0]);
end;

function TSolicitudRepository.EnTrabajo(const AUsuarioId: Integer;
  const ATexto: string; const APagina, APorPagina: Integer)
  : TObjectList<TCotizacionesEnTrabajo>;
begin
  Result := ListarConsulta<TCotizacionesEnTrabajo>(CONSULTA_DE_USUARIO,
    [AUsuarioId, TextoParaRQL(ATexto), TextoParaRQL(ATexto), (APagina - 1) * APorPagina,
    APorPagina]);
end;

function TSolicitudRepository.ContarEnTrabajo(const AUsuarioId: Integer;
  const ATexto: string): Int64;
begin
  Result := ContarConsulta<TCotizacionesEnTrabajo>(CONSULTA_DE_USUARIO,
    [AUsuarioId, TextoParaRQL(ATexto), TextoParaRQL(ATexto), 0, 0]);
end;

end.
