unit Anovo.Repositories.Intf.Clientes;

// Contratos de los repositorios de clientes, contactos
// y consentimiento.

interface

uses
  System.Generics.Collections,
  MVCFramework.Nullables,
  MVCFramework.Repository,
  Anovo.Entities.Clientes,
  Anovo.Entities.Consultas;

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
    function NombreRepetido(const ANombre: string;
      const AExcluirId: Integer): Boolean;
    function ConIdentificacion(const ATipo: Integer;
      const ANumero: string; const AExcluirId: Integer): TClientes;
    function ParaBajar(const ADesde: NullableTDateTime;
      const AConUuid: Boolean = False): TObjectList<TClientes>;
  end;

  IClienteContactoRepository = interface(IMVCRepository<TClienteContactos>)
    ['{E653F53C-69D0-4525-BDBB-5AAA283CD60C}']

    function ContactosDe(const AClienteId: Integer)
      : TObjectList<TClienteContactos>;
    function ContactoDe(const AClienteId, AContactoId: Integer)
      : TClienteContactos;
    function TodosDe(const AClienteId: Integer): TObjectList<TClienteContactos>;
    function PorUuidLocal(const AUuid: string): TClienteContactos;
    function ParaBajar(const ADesde: NullableTDateTime;
      const AConUuid: Boolean = False): TObjectList<TClienteContactos>;
  end;

  IConsentimientoRepository = interface
    (IMVCRepository<TClienteConsentimientoHistorial>)
    ['{A3119DD7-FEC7-467F-859F-4D0A6EE69C8B}']

    function HistorialDe(const AClienteId: Integer)
      : TObjectList<TConsentimientosDeCliente>;
  end;

  IConsentimientoTextoRepository = interface
    (IMVCRepository<TConsentimientoTextos>)
    ['{9B2E5F14-3C7A-4D68-A01B-6E8F2C4D9A37}']
    function Todas: TObjectList<TConsentimientoTextos>;
    function Vigente: TConsentimientoTextos;
    function PorVersion(const AVersion: string): TConsentimientoTextos;
  end;

implementation

end.
