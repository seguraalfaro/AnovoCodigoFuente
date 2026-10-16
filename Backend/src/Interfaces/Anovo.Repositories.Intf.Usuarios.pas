unit Anovo.Repositories.Intf.Usuarios;

// Contratos de los repositorios de usuarios, claves, roles y
// excepciones de permisos por usuario.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Usuarios,
  Anovo.Entities.Consultas;

const
  ESTADO_USUARIOS_ACTIVOS = 'activos';
  ESTADO_USUARIOS_INACTIVOS = 'inactivos';
  ESTADO_USUARIOS_CLAVE_PENDIENTE = 'clave_pendiente';
  ESTADO_USUARIOS_CON_ADICIONALES = 'con_adicionales';

type
  IUsuarioRepository = interface(IMVCRepository<TUsuarios>)
    ['{6F2A1C94-8E3B-4D57-9A16-C0B4E7D82F35}']

    function NombresDe(const AIds: TArray<Integer>)
      : TDictionary<Integer, string>;
    function IdSistema: Integer;
    function PorCorreo(const ACorreo: string): TUsuarios;
    function Buscar(const ATexto, AEstado: string;
      const APagina, APorPagina: Integer): TObjectList<TUsuariosBuscados>;
    function ContarBusqueda(const ATexto, AEstado: string): Int64;
    function Vista(const AId: Integer): TUsuariosBuscados;
    function ExisteCorreo(const ACorreo: string;
      const AExcluirId: Integer): Boolean;
    function DeRol(const ARolId: Integer): TObjectList<TUsuarios>;
  end;

  IUsuarioClaveRepository = interface(IMVCRepository<TUsuariosClaves>)
    ['{C4E81A27-9D3B-4F65-B2A0-5E7C1D93F648}']
    function ClaveActivaDe(const AUsuarioId: Integer): TUsuariosClaves;
  end;

  IRolRepository = interface(IMVCRepository<TRoles>)
    ['{D2183598-13C0-459A-89E3-6542505C6F44}']
    function Resumen: TObjectList<TRolesOrdenados>;
  end;

  IDispositivoRepository = interface(IMVCRepository<TUsuariosDispositivos>)
    ['{5E9C2B71-4A3D-4F86-8B12-D7A06E3C9F24}']
    function ActivosDe(const AUuidDispositivo: string)
      : TObjectList<TUsuariosDispositivos>;
    function PorLlaveAnterior(const ALlaveHash: string): TUsuariosDispositivos;
    function DeUsuario(const AUsuarioId: Integer)
      : TObjectList<TUsuariosDispositivos>;
  end;

  IUsuarioPermisoRepository = interface(IMVCRepository<TUsuariosPermisos>)
    ['{8B1F4E62-3C9A-4D07-A5E8-6F2B0C71D493}']
    function ExcepcionesDe(const AUsuarioId: Integer)
      : TObjectList<TExcepcionesDePermisos>;
    function DeUsuario(const AUsuarioId: Integer)
      : TObjectList<TUsuariosPermisos>;
    function Una(const AUsuarioId, APermisoId: Integer): TUsuariosPermisos;
  end;

implementation

end.
