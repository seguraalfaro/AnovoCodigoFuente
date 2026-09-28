unit Anovo.Vistas.Intf.Bandeja;

// Contrato de la vista de la bandeja de aprobacion.

interface

uses
  Anovo.DTOs.Cotizaciones;

type
  IVistaBandeja = interface
    ['{858BB0F1-3F49-4843-8716-E32F4C57192F}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarBusqueda(const ATexto: string;
      const APuedeLimpiar: Boolean);
    procedure MostrarBandeja(const ADatos: TBandejaPaginaDTO);
    procedure MostrarPaginacion(const APagina, ATotalPaginas: Integer;
      const ATotal: Int64);
    procedure MostrarError(const AMensaje: string);
  end;

implementation

end.
