unit Anovo.Vistas.Intf.Consentimiento;

// Contrato de la ventana de textos del consentimiento: las versiones
// publicadas y el registro de una nueva.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Clientes;

type
  IVistaConsentimiento = interface
    ['{C3E81A57-2D49-4B60-8F17-9A4D6E2B1C05}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    function Confirmar(const AMensaje: string): Boolean;
    procedure MostrarVersiones(const AVersiones
      : TObjectList<TConsentimientoTextoDTO>);
    procedure Publicado;
  end;

implementation

end.
