unit Anovo.Repositories.Intf.Solicitudes;

// Contratos de los repositorios de solicitudes,
// medidas y adjuntos.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Solicitudes,
  Anovo.Entities.Vistas.Dashboard;

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

    function PendientesDeCotizar(const AEstado: string)
      : TObjectList<TSolicitudes>;

    function Seguimiento(const AAsesorId: Integer; const ATexto: string;
      const ADesde, AHasta: TDateTime; const APagina, APorPagina: Integer)
      : TObjectList<TSolicitudAsesorVista>;
    function ContarSeguimiento(const AAsesorId: Integer; const ATexto: string;
      const ADesde, AHasta: TDateTime): Int64;
  end;

  ISolicitudMedidaRepository = interface(IMVCRepository<TSolicitudMedidas>)
    ['{4F8A61D3-9C27-4E50-B6A9-2D73E05C1F86}']

    function MedidasDe(const ASolicitudId: Integer)
      : TObjectList<TSolicitudMedidas>;
    function MedidaDe(const ASolicitudId, AMedidaId: Integer)
      : TSolicitudMedidas;
    function MedidasDeCroquis(const ACroquisId: Integer)
      : TObjectList<TSolicitudMedidas>;
    function ObtenerPorUuidLocal(const AUuid: string): TSolicitudMedidas;
  end;

  ISolicitudAdjuntoRepository = interface(IMVCRepository<TSolicitudAdjuntos>)
    ['{6C05B9E1-7D43-42A8-95F0-8B1467A3D29C}']

    function AdjuntosDe(const ASolicitudId: Integer)
      : TObjectList<TSolicitudAdjuntos>;

    function AdjuntoDe(const ASolicitudId, AAdjuntoId: Integer)
      : TSolicitudAdjuntos;

    function CroquisDe(const ASolicitudId: Integer)
      : TObjectList<TSolicitudAdjuntos>;
    function ObtenerPorUuidLocal(const AUuid: string): TSolicitudAdjuntos;
  end;

implementation

end.
