unit Anovo.Vistas.Intf.Auditoria;

// Contrato de la vista de la bitacora de auditoria.

interface

uses
  Anovo.Vistas.Intf.Listado,
  System.Generics.Collections,
  Anovo.DTOs.Auditoria,
  Anovo.PeriodoBusqueda;

type
  TFiltroEntidad = (feTodo, feClientes, feCotizaciones, feCuentas, feUsuarios,
    feClaves, feMatrizRoles, fePermisosPersona);
  TFiltrosEntidad = TArray<TFiltroEntidad>;

  IVistaAuditoria = interface(IVistaListado)
    ['{3B8D06F1-5C27-4E94-A6B0-D174E9C2538A}']

    procedure MostrarFiltros(const ARotulos: TArray<string>);
    procedure MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure MostrarAuditoria(const AFilas: TObjectList<TAuditoriaDTO>);
  end;

implementation

end.
