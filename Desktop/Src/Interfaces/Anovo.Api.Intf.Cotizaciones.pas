unit Anovo.Api.Intf.Cotizaciones;

// Contrato de la API de cotizaciones.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Correo,
  Anovo.DTOs.Cotizaciones,
  Anovo.DTOs.Documento;

type
  IApiCotizaciones = interface
    ['{A6067ECA-19E0-45C5-AFB7-6AD23A448B45}']
    function Bandeja(const ATexto: string; const APagina, APorPagina: Integer)
      : TBandejaPaginaDTO;
    function Obtener(const AId: Integer): TCotizacionDTO;
    function Documento(const AId: Integer): TCotizacionDocumentoDTO;
    function EstadoCorreo: TEstadoCorreoDTO;
    procedure EnviarPorCorreo(const AId: Integer; const ADto: TEnvioCorreoDTO);
    function Detalle(const AId: Integer): TObjectList<TLineaDTO>;
    function SinRespuesta: TObjectList<TCotizacionDTO>;
    function Estados(const AId: Integer): TObjectList<TEstadoCotizacionDTO>;
    procedure DarVistoBueno(const AId: Integer);
    procedure Devolver(const AId: Integer; const AMotivo: string);
    procedure RegistrarRespuesta(const AId: Integer; const AAceptada: Boolean);
    procedure Tomar(const ASolicitudId: Integer);
    function Listar(const ATexto, AEstado: string; const AClienteId: Integer;
      const ADesde, AHasta: TDateTime; const APagina, APorPagina: Integer;
      out ATotal: Int64)
      : TObjectList<TCotizacionDTO>;
    procedure Actualizar(const AId: Integer; const ADto: TCotizacionEdicionDTO);
    function AgregarLinea(const AId: Integer;
      const ADto: TLineaNuevaDTO): Integer;
    procedure ActualizarLinea(const AId, ALineaId: Integer;
      const ADto: TLineaNuevaDTO);
    procedure QuitarLinea(const AId, ALineaId: Integer);
    procedure AplicarAjuste(const AId: Integer; const ADto: TAjusteDTO);
    procedure Presentar(const AId: Integer);
    procedure Enviar(const AId: Integer);
  end;

implementation

end.
