unit Anovo.DTOs.Sesion;

// Lo que GET /api/sesion le devuelve al cliente para armar el menu.
//
// El rol es el del token, no el de la base: es con el que el servidor autoriza.
// Si se leyera de la base y alguien lo hubiera cambiado, el menu mostraria
// opciones que despues dan 403.

interface

uses
  MVCFramework.Serializer.Commons;

type
  [MVCNameCase(ncSnakeCase)]
  TSesionDTO = class
  private
    fRol: string;
    fPermisos: TArray<string>;
  public
    property Rol: string read fRol write fRol;
    property Permisos: TArray<string> read fPermisos write fPermisos;
  end;

implementation

end.
