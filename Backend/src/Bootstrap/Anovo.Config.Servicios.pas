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
procedure RegisterServices(Container: IMVCServiceContainer);

implementation

procedure RegisterServices(Container: IMVCServiceContainer);
begin

end;

end.
