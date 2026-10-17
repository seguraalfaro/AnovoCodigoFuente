unit Anovo.Vistas.Intf.Bandeja;

// Contrato de la vista de la bandeja de aprobacion.

interface

uses
  Anovo.Vistas.Intf.Listado,
  Anovo.DTOs.Cotizaciones;

type
  TAccionBandeja = (abRevisar);
  TAccionesBandeja = set of TAccionBandeja;

  IVistaBandeja = interface(IVistaListado)
    ['{858BB0F1-3F49-4843-8716-E32F4C57192F}']
    procedure MostrarAcciones(const AAcciones: TAccionesBandeja);
    procedure MostrarBandeja(const ADatos: TBandejaPaginaDTO);
    function MostrarRevision(const AId: Integer): Boolean;
  end;

implementation

end.
