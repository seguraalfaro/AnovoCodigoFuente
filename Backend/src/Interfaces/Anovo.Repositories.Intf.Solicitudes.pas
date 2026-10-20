unit Anovo.Repositories.Intf.Solicitudes;

// Contratos de los repositorios de solicitudes,
// piezas, medidas y adjuntos.

interface

uses
  System.Generics.Collections,
  MVCFramework.Nullables,
  MVCFramework.Repository,
  Anovo.Entities.Solicitudes,
  Anovo.Entities.Vistas.Lectura,
  Anovo.Entities.Consultas;

type
  ISolicitudRepository = interface(IMVCRepository<TSolicitudes>)
    ['{B7E2049C-3A61-4D85-92F7-05C8B1E6A374}']

    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AAsesorId: Integer = 0; const AEstado: string = '';
      const ADesde: TDateTime = 0; const AHasta: TDateTime = 0)
      : TObjectList<TSolicitudes>;

    function ContarBusqueda(const ATexto: string;
      const AAsesorId: Integer = 0; const AEstado: string = '';
      const ADesde: TDateTime = 0; const AHasta: TDateTime = 0): Int64;

    function ObtenerPorUuidLocal(const AUuid: string): TSolicitudes;
    function ExisteUuidLocal(const AUuid: string): Integer;

    function Seguimiento(const AAsesorId: Integer; const ATexto: string;
      const ADesde, AHasta: TDateTime; const APagina, APorPagina: Integer)
      : TObjectList<TSeguimientoAsesor>;
    function ContarSeguimiento(const AAsesorId: Integer; const ATexto: string;
      const ADesde, AHasta: TDateTime): Int64;
    function SeguimientoParaBajar(const AAsesorId: Integer;
      const ADesde: NullableTDateTime): TObjectList<TSeguimientoAsesor>;
    function PeriodoActual: TVPeriodoActual;
    function Cola(const ATexto: string; const ADesde, AHasta: TDateTime;
      const APagina, APorPagina: Integer): TObjectList<TColaSolicitudes>;
    function ContarCola(const ATexto: string;
      const ADesde, AHasta: TDateTime): Int64;
    function EnTrabajo(const AUsuarioId: Integer; const ATexto: string;
      const ADesde, AHasta: TDateTime; const APagina, APorPagina: Integer)
      : TObjectList<TCotizacionesEnTrabajo>;
    function ContarEnTrabajo(const AUsuarioId: Integer; const ATexto: string;
      const ADesde, AHasta: TDateTime): Int64;
  end;

  ISolicitudMedidaRepository = interface(IMVCRepository<TSolicitudMedidas>)
    ['{4F8A61D3-9C27-4E50-B6A9-2D73E05C1F86}']

    function MedidasDe(const ASolicitudId: Integer)
      : TObjectList<TMedidasDeSolicitud>;
    function MedidaDe(const ASolicitudId, AMedidaId: Integer)
      : TSolicitudMedidas;
    function ObtenerPorUuidLocal(const AUuid: string): TSolicitudMedidas;
    function UnidadDeMedida(const AAbreviatura: string): Integer;
  end;

  ISolicitudPiezaRepository = interface(IMVCRepository<TSolicitudPiezas>)
    ['{9A3E5C21-6B84-4F0D-A7E2-31C58D90B4F7}']

    function PiezasDe(const ASolicitudId: Integer)
      : TObjectList<TPiezasDeSolicitud>;
    function PiezaDe(const ASolicitudId, APiezaId: Integer): TSolicitudPiezas;
    function ObtenerPorUuidLocal(const AUuid: string): TSolicitudPiezas;
  end;

  ISolicitudAdjuntoRepository = interface(IMVCRepository<TSolicitudAdjuntos>)
    ['{6C05B9E1-7D43-42A8-95F0-8B1467A3D29C}']

    function AdjuntosDe(const ASolicitudId: Integer)
      : TObjectList<TAdjuntosDeSolicitud>;

    function AdjuntoDe(const ASolicitudId, AAdjuntoId: Integer)
      : TSolicitudAdjuntos;

    function ObtenerPorUuidLocal(const AUuid: string): TSolicitudAdjuntos;
    function DeCliente(const AClienteId: Integer)
      : TObjectList<TSolicitudAdjuntos>;
  end;

implementation

end.
