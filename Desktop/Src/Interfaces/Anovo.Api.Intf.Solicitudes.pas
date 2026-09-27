unit Anovo.Api.Intf.Solicitudes;

// Contrato de la API de solicitudes.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Dashboard;

type
  IApiSolicitudes = interface
    ['{41BE70E3-9D12-4D61-83BE-8604C67E4852}']
    function Seguimiento(const ATexto: string; const AHistorial: Boolean;
      const APagina, APorPagina: Integer; out ATotal: Int64;
      out ADesde: TDateTime): TObjectList<TSolicitudAsesorDTO>;
  end;

implementation

end.
