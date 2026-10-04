unit Anovo.Api.Roles;

// Cliente de la API de roles: roles, catalogo de permisos y matriz.

interface

uses
  Anovo.Api.Base,
  Anovo.Api.Intf.Roles,
  Anovo.DTOs.Roles;

type
  TApiRoles = class(TApiBase, IApiRoles)
  public
    function Matriz: TMatrizPermisosDTO;
    procedure CambiarMatriz(const ADto: TCambiosMatrizDTO);
  end;

implementation

uses
  MVCFramework.RESTClient.Intf;

const
  RUTA_ROLES = '/api/roles';
  RUTA_MATRIZ = '/api/roles/matriz';

function TApiRoles.Matriz: TMatrizPermisosDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(RUTA_ROLES);
    end);

  Result := TMatrizPermisosDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

procedure TApiRoles.CambiarMatriz(const ADto: TCambiosMatrizDTO);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False).Put(RUTA_MATRIZ);
    end);
end;

end.
