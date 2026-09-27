unit Anovo.Repositories.Intf.Clientes;

// Contratos de los repositorios de clientes, contactos
// y consentimiento.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Clientes;

type
  IClienteRepository = interface(IMVCRepository<TClientes>)
    ['{4C1E7A82-9D53-4F06-B7A4-1E85C3D920B6}']
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False;
      const AConsentimiento: string = ''): TObjectList<TClientes>;

    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False;
      const AConsentimiento: string = ''): Int64;

    function ObtenerPorUuidLocal(const AUuid: string): TClientes;
    function ExitsUuidLocal(const AUuid: string): Integer;
  end;

  IClienteContactoRepository = interface(IMVCRepository<TClienteContactos>)
    ['{E653F53C-69D0-4525-BDBB-5AAA283CD60C}']

    function ContactosDe(const AClienteId: Integer)
      : TObjectList<TClienteContactos>;
    function ContactoDe(const AClienteId, AContactoId: Integer)
      : TClienteContactos;
  end;

  IConsentimientoRepository = interface
    (IMVCRepository<TClienteConsentimientoHistorial>)
    ['{A3119DD7-FEC7-467F-859F-4D0A6EE69C8B}']

    function HistorialDe(const AClienteId: Integer)
      : TObjectList<TClienteConsentimientoHistorial>;
  end;

implementation

end.
