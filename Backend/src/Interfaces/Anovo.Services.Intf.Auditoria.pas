unit Anovo.Services.Intf.Auditoria;

// Contrato del servicio de auditoria.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Auditoria;

type
  TAlcanceAuditoria = (aaTodo, aaSoloCuentas);

  IAuditoriaService = interface
    ['{5D8C41A7-3E02-4B69-8F5A-7C1B9E604D2A}']

    function Buscar(const AAlcance: TAlcanceAuditoria;
      const ADesde, AHasta: TDateTime; const APagina, APorPagina: Integer;
      const AUsuarioId: Integer; const AEntidad, AAccion, ATexto: string;
      out ATotal: Int64): TObjectList<TAuditoriaDTO>;

    function DeLaEntidad(const AEntidad: string; const AEntidadId: Integer)
      : TObjectList<TAuditoriaDTO>;
  end;

implementation

end.
