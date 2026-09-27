unit Anovo.Vistas.Intf.ClienteDatos;

// Contrato de la vista de la ficha del cliente.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Clientes;

type
  TPestanaCliente = (pcDatos, pcContactos, pcConsentimiento, pcCotizaciones);

  IVistaClienteDatos = interface
    ['{5C8E2A17-4D63-4F90-B1A5-9E70C3D84B26}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure MostrarCliente(const ACliente: TClienteDTO);
    procedure MostrarContactos(const AContactos: TObjectList<TContactoDTO>);
    procedure MostrarConsentimientos(const AConsentimientos
      : TObjectList<TConsentimientoDTO>);
    procedure MostrarAcciones(const APuedeEditar, APuedeRevocar,
      APuedeVerCotizaciones: Boolean);
    procedure MostrarModoEdicion(const AActivo: Boolean);
  end;

implementation

end.
