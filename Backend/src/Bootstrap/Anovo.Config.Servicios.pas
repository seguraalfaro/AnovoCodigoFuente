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

end;

end.
