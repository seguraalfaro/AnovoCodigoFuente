unit Anovo.Api.Intf.Solicitudes;

// Contrato de la API de solicitudes.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Dashboard,
  Anovo.DTOs.Solicitudes;

type
  IApiSolicitudes = interface
    ['{41BE70E3-9D12-4D61-83BE-8604C67E4852}']
    function Seguimiento(const ATexto: string; const AHistorial: Boolean;
      const AFiltroDesde, AFiltroHasta: TDateTime;
      const APagina, APorPagina: Integer; out ATotal: Int64;
      out ADesde: TDateTime): TObjectList<TSolicitudAsesorDTO>;
    function Cola(const ATexto: string;
      const AFiltroDesde, AFiltroHasta: TDateTime;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TSolicitudPorCotizarDTO>;
    function EnTrabajo(const ATexto: string;
      const AFiltroDesde, AFiltroHasta: TDateTime;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TSolicitudEnTrabajoDTO>;
    function Obtener(const AId: Integer): TSolicitudDTO;
    function Piezas(const AId: Integer): TObjectList<TPiezaDTO>;
    function Medidas(const AId: Integer): TObjectList<TMedidaDTO>;
    function Adjuntos(const AId: Integer): TObjectList<TAdjuntoDTO>;
    function Adjunto(const AId, AAdjuntoId: Integer): TAdjuntoContenidoDTO;
    function RegistrarEnOficina(const ADto: TSolicitudCompletaDTO): Integer;
  end;

implementation

end.
