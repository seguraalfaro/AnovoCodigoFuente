unit Anovo.Services.Intf.Empresa;

// Contrato del servicio de los datos de la empresa.

interface

uses
  Anovo.DTOs.Empresa;

type
  IEmpresaService = interface
    ['{2E7C5A91-6B3D-4F08-9D14-A85F0C3B6E27}']
    function Obtener: TEmpresaDTO;
    procedure Actualizar(const ADto: TEmpresaDTO);
  end;

implementation

end.
