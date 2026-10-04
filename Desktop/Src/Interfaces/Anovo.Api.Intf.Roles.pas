unit Anovo.Api.Intf.Roles;

// Contrato de la API de roles y de la matriz de permisos.

interface

uses
  Anovo.DTOs.Roles;

type
  IApiRoles = interface
    ['{B3E50F27-9A84-4C16-8D2E-71F6A0C95B34}']
    function Matriz: TMatrizPermisosDTO;
    procedure CambiarMatriz(const ADto: TCambiosMatrizDTO);
  end;

implementation

end.
