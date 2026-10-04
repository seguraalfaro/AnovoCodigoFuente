unit Anovo.Vistas.Intf.ClienteDatos;

// Contrato de la vista de la ficha del cliente.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Clientes;

type
  TPestanaCliente = (pcDatos, pcContactos, pcConsentimiento, pcCotizaciones);

  TAccionContacto = (acoEditar, acoQuitar);
  TAccionesContacto = set of TAccionContacto;

  TAccionCotizacionCliente = (accVer);
  TAccionesCotizacionCliente = set of TAccionCotizacionCliente;

  IVistaClienteDatos = interface
    ['{5C8E2A17-4D63-4F90-B1A5-9E70C3D84B26}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure MostrarCliente(const ACliente: TClienteDTO);
    procedure MostrarContactos(const AContactos: TObjectList<TContactoDTO>);
    procedure MostrarConsentimientos(const AConsentimientos
      : TObjectList<TConsentimientoDTO>);
    procedure MostrarAcciones(const APuedeEditar, APuedeRevocar,
      APuedeVerCotizaciones: Boolean; const AContacto: TAccionesContacto;
      const ACotizacion: TAccionesCotizacionCliente);
    procedure MostrarModoEdicion(const AActivo: Boolean);
  end;

implementation

end.
