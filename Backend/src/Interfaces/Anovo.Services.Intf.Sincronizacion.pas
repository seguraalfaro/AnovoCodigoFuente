unit Anovo.Services.Intf.Sincronizacion;

// Contrato del servicio de sincronizacion: lo que baja al movil, con las
// solicitudes del asesor que pide.

interface

uses
  MVCFramework.Nullables,
  Anovo.DTOs.Sincronizacion;

type
  ISincronizacionService = interface
    ['{6B2E91D4-3F58-4A07-9C1D-E85A04B7F362}']
    function Bajar(const AAsesorId: Integer;
      const ADesde: NullableTDateTime): TBajadaDTO;
  end;

implementation

end.
