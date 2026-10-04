unit Anovo.Services.Intf.Roles;

// Contrato del servicio de roles y permisos.

interface

uses
  Anovo.DTOs.Roles;

type
  IRolService = interface
    ['{030E0993-56AA-42F6-928D-ADC8C4A2EC67}']
    function Matriz: TMatrizPermisosDTO;
    procedure CambiarMatriz(const ADto: TCambiosMatrizDTO);
  end;

implementation

end.
