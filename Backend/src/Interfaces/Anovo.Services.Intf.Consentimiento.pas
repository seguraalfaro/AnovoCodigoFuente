unit Anovo.Services.Intf.Consentimiento;

// Contrato del servicio de textos del consentimiento informado (Ley 8968).

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Clientes;

type
  IConsentimientoTextoService = interface
    ['{4D1C8B27-6E93-4A05-9F12-B7E3A0D56C84}']
    function Vigente: TConsentimientoTextoDTO;
    function Version(const AVersion: string): TConsentimientoTextoDTO;
    function Versiones: TObjectList<TConsentimientoTextoDTO>;
    function Publicar(const ADto: TConsentimientoTextoNuevoDTO;
      const AUsuarioId: Integer): Integer;
  end;

implementation

end.
