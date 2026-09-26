// ***************************************************************************
//
// Delphi MVC Framework
//
// Copyright (c) 2010-2026 Daniele Teti and the DMVCFramework Team
//
// https://github.com/danieleteti/delphimvcframework
//
// ***************************************************************************

unit Anovo.Config.Servicios;

interface

uses
  MVCFramework.Container;

// Registro de servicios en el contenedor. Los que tocan la base van como
// SingletonPerRequest: la conexion la maneja el middleware por peticion.
// Transient           una instancia por cada resolucion.

procedure RegisterServices(Container: IMVCServiceContainer);

implementation

uses
  MVCFramework.Repository,
  Anovo.Repositories.Intf.Permisos,
  Anovo.Repositories.Permisos,
  Anovo.Services.Intf.Permisos,
  Anovo.Services.Permisos,
  Anovo.Services.Clave,
  Anovo.Repositories.Intf.Clientes,
  Anovo.Repositories.Intf.Auditoria,
  Anovo.Repositories.Auditoria,
  Anovo.Repositories.Clientes,
  Anovo.Services.Intf.Clientes,
  Anovo.Services.Clientes,
  Anovo.Repositories.Intf.Usuarios,
  Anovo.Repositories.Usuarios,
  Anovo.Services.Intf.Auditoria,
  Anovo.Services.Auditoria,
  Anovo.Repositories.Intf.Catalogos,
  Anovo.Repositories.Catalogos,
  Anovo.Services.Intf.Catalogos,
  Anovo.Services.Catalogos,
  Anovo.Repositories.Intf.Solicitudes,
  Anovo.Repositories.Solicitudes,
  Anovo.Services.Intf.Solicitudes,
  Anovo.Services.Solicitudes,
  Anovo.Repositories.Intf.Cotizaciones,
  Anovo.Repositories.Cotizaciones,
  Anovo.Services.Intf.Cotizaciones,
  Anovo.Services.Cotizaciones;

procedure RegisterServices(Container: IMVCServiceContainer);
begin
  // Singleton: solo hashea y compara, no guarda nada ni abre conexiones.
  Container.RegisterType(TClaveService, IClaveService,
    TRegistrationType.Singleton);

  // Clientes. Todos por peticion, no singleton: por dentro usan la conexion
  // que el middleware de ActiveRecord abre y cierra en cada peticion, asi que
  // una instancia que sobreviva a la peticion se queda con una conexion que ya
  // no existe. Un repositorio por tabla; el servicio recibe los tres.
  Container.RegisterType(TClienteRepository, IClienteRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TClienteContactoRepository, IClienteContactoRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TConsentimientoRepository, IConsentimientoRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TClienteService, IClienteService,
    TRegistrationType.SingletonPerRequest);

  // Auditoria. Solo consulta, pero por peticion igual: los repositorios usan
  // la conexion que el middleware abre y cierra en cada peticion. El
  // repositorio de usuarios esta aqui porque la bitacora guarda numeros y
  // quien muestra nombres es el servicio.
  Container.RegisterType(TUsuarioRepository, IUsuarioRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TAuditoriaService, IAuditoriaService,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TAuditoriaRepository, IAuditoriaRepository,
    TRegistrationType.SingletonPerRequest);

  // Catalogos. Ocho repositorios, uno por tabla, y un solo servicio que los
  // junta: el item y su precio se tocan en la misma transaccion. Por peticion
  // como los demas, porque usan la conexion del middleware.
  Container.RegisterType(TMaterialRepository, IMaterialRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TMaterialPrecioRepository, IMaterialPrecioRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TManoObraRepository, IManoObraRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TManoObraPrecioRepository, IManoObraPrecioRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TManoObraCategoriaRepository,
    IManoObraCategoriaRepository, TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TMaquinaRepository, IMaquinaRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TMaquinaPrecioRepository, IMaquinaPrecioRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TTipoTrabajoRepository, ITipoTrabajoRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TCatalogoService, ICatalogoService,
    TRegistrationType.SingletonPerRequest);

  // Solicitudes. El servicio recibe ademas el repositorio de clientes, que ya
  // esta registrado arriba: necesita el nombre del cliente para el listado y
  // comprobar que existe antes de insertar.
  Container.RegisterType(TSolicitudRepository, ISolicitudRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TSolicitudMedidaRepository,
    ISolicitudMedidaRepository, TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TSolicitudAdjuntoRepository,
    ISolicitudAdjuntoRepository, TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TSolicitudService, ISolicitudService,
    TRegistrationType.SingletonPerRequest);

  // Cotizaciones. El servicio recibe ademas los repositorios de solicitudes,
  // clientes y los tres de precios: la cabecera se arrastra de la solicitud y
  // cada linea copia el precio vigente del catalogo. Todos estan registrados
  // arriba.
  Container.RegisterType(TCotizacionRepository, ICotizacionRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TCotizacionDetalleRepository,
    ICotizacionDetalleRepository, TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TCotizacionService, ICotizacionService,
    TRegistrationType.SingletonPerRequest);

  // Permisos. El repositorio por peticion, por lo mismo que clientes: usa la
  // conexion del middleware.
  Container.RegisterType(TPermisoRepository, IPermisoRepository,
    TRegistrationType.SingletonPerRequest);

  // Singleton, al reves que los repositorios: no toca la base, guarda texto, y
  // tiene que sobrevivir a la peticion o no seria cache.
  Container.RegisterType(TPermisoCache, IPermisoCache,
    TRegistrationType.Singleton);

  // Por peticion: lleva dentro el repositorio, que usa la conexion de la
  // peticion. La cache que recibe es la singleton.
  Container.RegisterType(TPermisoService, IPermisoService,
    TRegistrationType.SingletonPerRequest);
end;

end.
