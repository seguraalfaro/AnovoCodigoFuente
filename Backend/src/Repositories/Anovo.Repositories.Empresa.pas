unit Anovo.Repositories.Empresa;

// Repositorio de EMPRESA: una sola fila con los datos del emisor.

interface

uses
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Empresa,
  Anovo.Entities.Empresa;

type
  TEmpresaRepository = class(TAnovoRepository<TEmpresa>, IEmpresaRepository)
  end;

implementation

end.
