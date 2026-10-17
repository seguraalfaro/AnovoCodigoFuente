unit Anovo.Vistas.Intf.Auditoria;

// Contrato de la vista de la bitacora de auditoria.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Auditoria,
  Anovo.PeriodoBusqueda;

type
  TFiltroEntidad = (feTodo, feClientes, feCotizaciones, feCuentas, feUsuarios,
    feClaves, feMatrizRoles, fePermisosPersona);
  TFiltrosEntidad = TArray<TFiltroEntidad>;

  IVistaAuditoria = interface
    ['{3B8D06F1-5C27-4E94-A6B0-D174E9C2538A}']

    procedure MostrarFiltros(const ARotulos: TArray<string>);
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure MostrarBusqueda(const ATexto: string;
      const APuedeLimpiar: Boolean);
    procedure MostrarAuditoria(const AFilas: TObjectList<TAuditoriaDTO>);
    procedure MostrarPaginacion(const APagina, ATotalPaginas: Integer;
      const ATotal: Int64);
    procedure MostrarError(const AMensaje: string);
  end;

implementation

end.
