unit Anovo.Repositories.Empresa;

// Repositorio de EMPRESA: una sola fila con los datos del emisor.

interface

uses
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Empresa,
  Anovo.Entities.Empresa;

type
  TEmpresaRepository = class(TAnovoRepository<TEmpresa>, IEmpresaRepository)
  public
    function VersionEsquema: Integer;
  end;

implementation

uses
  Anovo.Entities.Vistas.Lectura;

function TEmpresaRepository.VersionEsquema: Integer;
var
  lVersion: TVVersionEsquema;
begin
  lVersion := LeerVistaUnica<TVVersionEsquema>;
  try
    if lVersion = nil then
      Exit(0);
    Result := lVersion.Numero.ValueOrDefault;
  finally
    lVersion.Free;
  end;
end;

end.
