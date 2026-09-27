unit Anovo.Api.Intf.Auditoria;

// Contrato de la API de auditoria.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Auditoria;

type
  IApiAuditoria = interface
    ['{9C4E7B03-1A58-4F26-B8D1-6E05A93C7F24}']

    function Buscar(const ASoloCuentas: Boolean;
      const ADesde, AHasta: TDateTime;
      const AEntidad, AAccion, ATexto: string;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TAuditoriaDTO>;

    function DeLaEntidad(const AEntidad: string; const AEntidadId: Integer)
      : TObjectList<TAuditoriaDTO>;
  end;

implementation

end.
