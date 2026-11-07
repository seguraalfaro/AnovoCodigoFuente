unit Anovo.Vistas.Intf.ClienteDatos;

// Contrato de la vista de la ficha del cliente.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Clientes,
  Anovo.DTOs.Cotizaciones,
  Anovo.PeriodoBusqueda;

type
  TPestanaCliente = (pcDatos, pcContactos, pcConsentimiento, pcCotizaciones);

  TAccionContacto = (acoEditar, acoAnonimizar, acoQuitar);
  TAccionesContacto = set of TAccionContacto;

  TAccionCotizacionCliente = (accVer);
  TAccionesCotizacionCliente = set of TAccionCotizacionCliente;

  IVistaClienteDatos = interface
    ['{5C8E2A17-4D63-4F90-B1A5-9E70C3D84B26}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure MostrarCliente(const ACliente: TClienteDTO);
    procedure MostrarUbicacion(const ATexto, AUrlMapa: string);
    procedure MostrarContactos(const AContactos: TObjectList<TContactoDTO>);
    procedure MostrarCotizaciones(const ACotizaciones
      : TObjectList<TCotizacionDTO>);
    procedure MostrarPeriodoCotizaciones(const APeriodo: TPeriodoBusqueda);
    procedure MostrarConsentimientos(const AConsentimientos
      : TObjectList<TConsentimientoDTO>; const ARecogido: string);
    procedure MostrarAcciones(const APuedeEditar, APuedeRevocar,
      APuedeVerCotizaciones: Boolean; const AContacto: TAccionesContacto;
      const ACotizacion: TAccionesCotizacionCliente);
    procedure MostrarModoEdicion(const AActivo: Boolean);
    procedure MostrarAnonimizacion(const AVisible, AHabilitado: Boolean);
    procedure MostrarNuevaSolicitud(const AVisible: Boolean);
    function PedirMotivoAnonimizacion(out AMotivo: string): Boolean;
    function PedirMotivoContacto(const ANombre: string;
      out AMotivo: string): Boolean;
    function ConfirmarQuitarContacto(const ANombre: string): Boolean;
    procedure MostrarRevocacion(const AHabilitado: Boolean);
    function PedirRevocante(const ACliente: string;
      var ANombre, AIdentificacion: string): Boolean;
  end;

implementation

end.
