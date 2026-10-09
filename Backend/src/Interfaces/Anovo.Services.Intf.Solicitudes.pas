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

    function Obtener(const AId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>): TSolicitudDTO;

    function Crear(const ADto: TSolicitudNuevaDTO; const AUsuarioId: Integer; const ARoles: TArray<string>): Integer;

    procedure Actualizar(const AId: Integer; const ADto: TSolicitudEdicionDTO; const AUsuarioId: Integer; const ARoles: TArray<string>);

    function RegistrarCompleta(const ADto: TSolicitudCompletaDTO; const AUsuarioId: Integer; const ARoles: TArray<string>): Integer;

    procedure MarcarRecibida(const AId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>);

    procedure CambiarEstado(const AId: Integer; const ADto: TCambioEstadoDTO; const AUsuarioId: Integer; const ARoles: TArray<string>);

    function Seguimiento(const AAsesorId: Integer; const ATexto: string;
      const ASoloMes: Boolean; const APagina, APorPagina: Integer;
      out ADesde, AHasta: TDateTime; out ATotal: Int64)
      : TObjectList<TSolicitudAsesorDTO>;

    function Cola(const ATexto: string; const APagina, APorPagina: Integer;
      out ATotal: Int64): TObjectList<TSolicitudPorCotizarDTO>;
    function EnTrabajo(const AUsuarioId: Integer; const ATexto: string;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TSolicitudEnTrabajoDTO>;

    function Medidas(const AId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>): TObjectList<TMedidaDTO>;
    function AgregarMedida(const AId: Integer;
      const ADto: TMedidaNuevaDTO; const AUsuarioId: Integer; const ARoles: TArray<string>): Integer;
    procedure ActualizarMedida(const AId, AMedidaId: Integer;
      const ADto: TMedidaNuevaDTO; const AUsuarioId: Integer; const ARoles: TArray<string>);
    procedure EliminarMedida(const AId, AMedidaId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>);

    function Adjuntos(const AId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>): TObjectList<TAdjuntoDTO>;
    function ObtenerAdjunto(const AId, AAdjuntoId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>)
      : TAdjuntoContenidoDTO;
    function AgregarAdjunto(const AId: Integer;
      const ADto: TAdjuntoNuevoDTO; const AUsuarioId: Integer; const ARoles: TArray<string>): Integer;
    procedure InactivarAdjunto(const AId, AAdjuntoId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>);
  end;

implementation

end.
