unit Anovo.Vistas.Intf.ClienteDatos;

// Lo que el presentador de la ficha del cliente necesita de la pantalla.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Clientes;

type
  // En el orden de las pestanas del frame.
  TPestanaCliente = (pcDatos, pcContactos, pcConsentimiento, pcCotizaciones);

  IVistaClienteDatos = interface
    ['{5C8E2A17-4D63-4F90-B1A5-9E70C3D84B26}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    // Los tres reciben datos del presentador y los libera el al volver: la
    // vista copia lo que necesita y no se queda con ellos.
    procedure MostrarCliente(const ACliente: TClienteDTO);
    procedure MostrarContactos(const AContactos: TObjectList<TContactoDTO>);
    procedure MostrarConsentimientos(const AConsentimientos
      : TObjectList<TConsentimientoDTO>);
    // Que puede hacer quien esta en pantalla, segun sus permisos. De esto
    // dependen los botones y las acciones de cada rejilla.
    procedure MostrarAcciones(const APuedeEditar, APuedeRevocar,
      APuedeVerCotizaciones: Boolean);
    // Consulta o edicion: de esto dependen los campos y los tres botones.
    procedure MostrarModoEdicion(const AActivo: Boolean);
  end;

implementation

end.
