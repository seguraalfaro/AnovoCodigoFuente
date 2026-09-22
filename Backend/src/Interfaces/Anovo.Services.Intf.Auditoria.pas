unit Anovo.Services.Intf.Auditoria;

// Contrato del servicio de auditoria.
//
// Detras de interfaz para poder sustituirlo por un doble en las pruebas, igual
// que el de clientes. No sabe nada de HTTP: lanza las excepciones de
// Anovo.Errors y el manejador global las traduce.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Auditoria;

type
  // Las entidades que el filtro admite, cuando se pide una sola.
  TAlcanceAuditoria = (aaTodo, aaSoloCuentas);

  IAuditoriaService = interface
    ['{5D8C41A7-3E02-4B69-8F5A-7C1B9E604D2A}']

    // ATotal sale aparte porque el cliente necesita saber cuantas paginas hay.
    //
    // AAlcance no es un filtro mas: es quien pregunta. aaSoloCuentas es la
    // bitacora de USUARIOS y USUARIOS_CLAVES, que es lo unico que ve quien
    // tiene auditoria.ver_cuentas y no auditoria.ver_toda.
    function Buscar(const AAlcance: TAlcanceAuditoria;
      const ADesde, AHasta: TDateTime; const APagina, APorPagina: Integer;
      const AUsuarioId: Integer; const AEntidad, AAccion, ATexto: string;
      out ATotal: Int64): TObjectList<TAuditoriaDTO>;

    // La bitacora de una fila: quien la toco y cuando. Es lo que pide la ficha
    // del cliente o de la cotizacion.
    function DeLaEntidad(const AEntidad: string; const AEntidadId: Integer)
      : TObjectList<TAuditoriaDTO>;
  end;

implementation

end.
