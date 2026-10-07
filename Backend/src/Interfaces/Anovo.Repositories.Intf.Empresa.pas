unit Anovo.Repositories.Intf.Empresa;

// Contrato del repositorio de EMPRESA, el emisor de la cotizacion.

interface

uses
  MVCFramework.Repository,
  Anovo.Entities.Empresa;

const
  EMPRESA_ID = 1;

type
  IEmpresaRepository = interface(IMVCRepository<TEmpresa>)
    ['{6B1E4F92-3A75-4D08-B2C6-9E81D0F5A437}']
    function VersionEsquema: Integer;
  end;

implementation

end.
