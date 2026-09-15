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
  Anovo.Services.Clave;

procedure RegisterServices(Container: IMVCServiceContainer);
begin
  // Singleton: solo hashea y compara, no guarda nada ni abre conexiones.
  Container.RegisterType(TClaveService, IClaveService,
    TRegistrationType.Singleton);

end;

end.
