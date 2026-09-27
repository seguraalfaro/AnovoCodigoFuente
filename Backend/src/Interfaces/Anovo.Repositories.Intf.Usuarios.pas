unit Anovo.Repositories.Intf.Usuarios;

// Contratos de los repositorios de usuarios y claves.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Usuarios;

type
  IUsuarioRepository = interface(IMVCRepository<TUsuarios>)
    ['{6F2A1C94-8E3B-4D57-9A16-C0B4E7D82F35}']

    function NombresDe(const AIds: TArray<Integer>)
      : TDictionary<Integer, string>;
  end;

  IUsuarioClaveRepository = interface(IMVCRepository<TUsuariosClaves>)
    ['{C4E81A27-9D3B-4F65-B2A0-5E7C1D93F648}']
    function ClaveActivaDe(const AUsuarioId: Integer): TUsuariosClaves;
  end;

implementation

end.
