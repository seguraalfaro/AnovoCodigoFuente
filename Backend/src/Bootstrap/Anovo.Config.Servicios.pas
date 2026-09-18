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
  Anovo.Repositories.Clientes,
  Anovo.Services.Intf.Clientes,
  Anovo.Services.Clientes;

procedure RegisterServices(Container: IMVCServiceContainer);
begin
  // Singleton: solo hashea y compara, no guarda nada ni abre conexiones.
  Container.RegisterType(TClaveService, IClaveService,
    TRegistrationType.Singleton);

  // Clientes. Los dos por peticion, no singleton: por dentro usan la conexion
  // que el middleware de ActiveRecord abre y cierra en cada peticion, asi que
  // una instancia que sobreviva a la peticion se queda con una conexion que ya
  // no existe.
  Container.RegisterType(TClienteRepository, IClienteRepository,
    TRegistrationType.SingletonPerRequest);
  Container.RegisterType(TClienteService, IClienteService,
    TRegistrationType.SingletonPerRequest);
  // Por peticion, por lo mismo que clientes: usa la conexion del middleware.
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
