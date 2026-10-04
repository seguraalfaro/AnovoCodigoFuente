unit Anovo.Services.Intf.Solicitudes;

// Contrato del servicio de solicitudes.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Solicitudes,
  Anovo.DTOs.Dashboard;

type
  ISolicitudService = interface
    ['{A25D8F63-70B4-49C1-8E06-3F91C7A4D052}']

    function Buscar(const ATexto, AEstado: string;
      const ADesde, AHasta: TDateTime; const ARoles: TArray<string>;
      const AAsesorId, APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TSolicitudDTO>;

    function Obtener(const AId: Integer): TSolicitudDTO;

    function Crear(const ADto: TSolicitudNuevaDTO): Integer;

    procedure Actualizar(const AId: Integer; const ADto: TSolicitudEdicionDTO);

    function RegistrarCompleta(const ADto: TSolicitudCompletaDTO): Integer;

    procedure MarcarRecibida(const AId: Integer);

    procedure CambiarEstado(const AId: Integer; const ADto: TCambioEstadoDTO);

    function Seguimiento(const AAsesorId: Integer; const ATexto: string;
      const ASoloMes: Boolean; const APagina, APorPagina: Integer;
      out ADesde, AHasta: TDateTime; out ATotal: Int64)
      : TObjectList<TSolicitudAsesorDTO>;

    function Cola(const ATexto: string; const APagina, APorPagina: Integer;
      out ATotal: Int64): TObjectList<TSolicitudPorCotizarDTO>;
    function EnTrabajo(const AUsuarioId: Integer; const ATexto: string;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TSolicitudEnTrabajoDTO>;

    function Medidas(const AId: Integer): TObjectList<TMedidaDTO>;
    function AgregarMedida(const AId: Integer;
      const ADto: TMedidaNuevaDTO): Integer;
    procedure ActualizarMedida(const AId, AMedidaId: Integer;
      const ADto: TMedidaNuevaDTO);
    procedure EliminarMedida(const AId, AMedidaId: Integer);

    function Adjuntos(const AId: Integer): TObjectList<TAdjuntoDTO>;
    function ObtenerAdjunto(const AId, AAdjuntoId: Integer)
      : TAdjuntoContenidoDTO;
    function AgregarAdjunto(const AId: Integer;
      const ADto: TAdjuntoNuevoDTO): Integer;
    procedure InactivarAdjunto(const AId, AAdjuntoId: Integer);
  end;

implementation

end.
