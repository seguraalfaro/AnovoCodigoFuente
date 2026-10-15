unit Anovo.Config.Servicios;

// Registro de repositorios y servicios en el contenedor.
// Los que usan la base van por peticion.

interface

uses
  MVCFramework.Container;

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
  Anovo.Services.Cotizaciones,
  Anovo.Services.Intf.Documento,
  Anovo.Services.Documento,
  Anovo.Services.Intf.Correo,
  Anovo.Services.Correo,
  Anovo.Services.Intf.EnvioCotizacion,
  Anovo.Services.EnvioCotizacion,
  Anovo.Repositories.Dashboard,
  Anovo.Services.Dashboard,
  Anovo.Repositories.Intf.Dashboard,
  Anovo.Services.Intf.Dashboard,
  Anovo.Repositories.Intf.Reportes,
  Anovo.Repositories.Reportes,
  Anovo.Repositories.Intf.Empresa,
  Anovo.Repositories.Empresa,
  Anovo.Services.Intf.Reportes,
  Anovo.Services.Reportes,
  Anovo.Services.Intf.Importacion,
  Anovo.Services.Importacion,
  Anovo.Services.Intf.Empresa,
  Anovo.Services.Empresa,
  Anovo.Services.Intf.Sesion,
  Anovo.Services.Sesion,
  Anovo.Services.Intf.Roles,
  Anovo.Services.Roles,
  Anovo.Services.Intf.Usuarios,
  Anovo.Services.Usuarios,
  Anovo.Services.Intf.Dispositivos,
  Anovo.Services.Dispositivos,
  Anovo.Services.Intf.Sincronizacion,
  Anovo.Services.Sincronizacion;

procedure RegisterServices(Container: IMVCServiceContainer);
begin
  Container.RegisterType(TClaveService, IClaveService,
    TRegistrationType.Singleton);

  Container.RegisterType(TClienteRepository, IClienteRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TClienteContactoRepository, IClienteContactoRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TConsentimientoRepository, IConsentimientoRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TClienteService, IClienteService,
    TRegistrationType.SingletonPerRequest);

  Container.RegisterType(TUsuarioRepository, IUsuarioRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TAuditoriaService, IAuditoriaService,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TAuditoriaRepository, IAuditoriaRepository,
    TRegistrationType.SingletonPerRequest);

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
  Container.RegisterType(TTipoMaterialRepository, ITipoMaterialRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TAcabadoRepository, IAcabadoRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TUnidadMedidaRepository, IUnidadMedidaRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TPrecioProgramadoRepository,
    IPrecioProgramadoRepository, TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TCatalogoTodosRepository, ICatalogoTodosRepository,
    TRegistrationType.SingletonPerRequest);

  Container.RegisterType(TDashboardRepository, IDashboardRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TDashboardService, IDashboardService,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TReporteRepository, IReporteRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TReporteService, IReporteService,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TCatalogoService, ICatalogoService,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TImportacionService, IImportacionService,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TEmpresaService, IEmpresaService,
    TRegistrationType.SingletonPerRequest);

  Container.RegisterType(TSolicitudRepository, ISolicitudRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TSolicitudMedidaRepository,
    ISolicitudMedidaRepository, TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TSolicitudAdjuntoRepository,
    ISolicitudAdjuntoRepository, TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TSolicitudPiezaRepository,
    ISolicitudPiezaRepository, TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TSolicitudService, ISolicitudService,
    TRegistrationType.SingletonPerRequest);

  Container.RegisterType(TCotizacionRepository, ICotizacionRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TCotizacionDetalleRepository,
    ICotizacionDetalleRepository, TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TEmpresaRepository, IEmpresaRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TCotizacionService, ICotizacionService,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TCotizacionDocumentoService,
    ICotizacionDocumentoService, TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TCorreoService, ICorreoService,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TEnvioCotizacionService, IEnvioCotizacionService,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TCotizacionEnvioRepository,
    ICotizacionEnvioRepository, TRegistrationType.SingletonPerRequest);

  Container.RegisterType(TUsuarioClaveRepository, IUsuarioClaveRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TRolRepository, IRolRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TSesionService, ISesionService,
    TRegistrationType.SingletonPerRequest);

  Container.RegisterType(TPermisoRepository, IPermisoRepository,
    TRegistrationType.SingletonPerRequest);

  Container.RegisterType(TPermisoCache, IPermisoCache,
    TRegistrationType.Singleton);

  Container.RegisterType(TPermisoService, IPermisoService,
    TRegistrationType.SingletonPerRequest);

  Container.RegisterType(TPermisoCatalogoRepository, IPermisoCatalogoRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TRolService, IRolService,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TUsuarioPermisoRepository, IUsuarioPermisoRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TUsuarioService, IUsuarioService,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TDispositivoRepository, IDispositivoRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TDispositivoService, IDispositivoService,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TSincronizacionService, ISincronizacionService,
    TRegistrationType.SingletonPerRequest);
end;

end.
