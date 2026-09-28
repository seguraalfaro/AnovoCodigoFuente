unit Anovo.Api.Intf.Cotizaciones;

// Contrato de la API de cotizaciones.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Cotizaciones;

type
  IApiCotizaciones = interface
    ['{A6067ECA-19E0-45C5-AFB7-6AD23A448B45}']
    function Bandeja(const ATexto: string; const APagina, APorPagina: Integer)
      : TBandejaPaginaDTO;
    function Obtener(const AId: Integer): TCotizacionDTO;
    function Detalle(const AId: Integer): TObjectList<TLineaDTO>;
    procedure Aprobar(const AId: Integer);
    procedure Devolver(const AId: Integer; const AMotivo: string);
    procedure Rechazar(const AId: Integer; const AMotivo: string);
    procedure Tomar(const ASolicitudId: Integer);
  end;

implementation

end.
