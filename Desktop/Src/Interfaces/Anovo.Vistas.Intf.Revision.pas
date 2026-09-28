unit Anovo.Vistas.Intf.Revision;

// Contrato de la ventana de revision de una cotizacion.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Cotizaciones;

type
  TDecision = (dcAprobar, dcDevolver, dcRechazar);

  IVistaRevision = interface
    ['{F952C463-A02D-49E3-B7B1-C9372FCC01BA}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarCotizacion(const ACotizacion: TCotizacionDTO;
      const ALineas: TObjectList<TLineaDTO>);
    procedure MostrarProcesando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure Revisada;
  end;

implementation

end.
