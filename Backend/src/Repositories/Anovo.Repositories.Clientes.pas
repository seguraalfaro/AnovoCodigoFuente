unit Anovo.Repositories.Clientes;

// Repositorio de clientes.
//
// Desciende de TMVCRepository<TClientes>, asi que el CRUD directo lo hereda
// hecho y aqui solo estan las cuatro consultas del dominio.
//
// El SQL no vive aqui: esta en Anovo.SQL.Clientes, para que un cambio de
// columna se haga una vez. Lo que se lee en este archivo es que hace cada
// metodo y por que; el como, alla.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Repositories.Intf.Clientes,
  Anovo.Entities.Clientes;

type
  TClienteRepository = class(TMVCRepository<TClientes>, IClienteRepository)
  private
    function FiltroSegun(const AIncluirInactivos: Boolean): string;
  public
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False): TObjectList<TClientes>;
    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False): Int64;
    function ObtenerPorUuidLocal(const AUuid: string): TClientes;
    function ContactosDe(const AClienteId: Integer)
      : TObjectList<TClienteContactos>;
    procedure InsertarContacto(const AContacto: TClienteContactos);
    procedure InsertarFirma(const AFirma: TClienteConsentimientoHistorial);
  end;

implementation

uses
  System.SysUtils,
  MVCFramework.ActiveRecord,
  Anovo.SQL.Clientes;

function TClienteRepository.FiltroSegun(const AIncluirInactivos
  : Boolean): string;
begin
  // Lo usan Buscar y ContarBusqueda, y tienen que filtrar igual: si uno cuenta
  // sobre un conjunto y el otro lista sobre otro, el total no cuadra con las
  // paginas y no se nota hasta que alguien llega a la ultima.
  Result := CLIENTES_FILTRO_BUSQUEDA;
  if not AIncluirInactivos then
    Result := Result + CLIENTES_SOLO_ACTIVOS;
end;

procedure TClienteRepository.InsertarContacto(const AContacto
  : TClienteContactos);
begin
  AContacto.Insert;
end;

procedure TClienteRepository.InsertarFirma(const AFirma
  : TClienteConsentimientoHistorial);
begin
  AFirma.Insert;
end;

function TClienteRepository.Buscar(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean)
  : TObjectList<TClientes>;
var
  lDesde, lHasta: Integer;
begin
  lDesde := ((APagina - 1) * APorPagina) + 1;
  lHasta := APagina * APorPagina;

  Result := TMVCActiveRecord.Where<TClientes>(FiltroSegun(AIncluirInactivos) +
    CLIENTES_ORDEN_Y_PAGINA, [ATexto, ATexto, ATexto, ATexto, lDesde, lHasta]);
end;

function TClienteRepository.ContarBusqueda(const ATexto: string;
  const AIncluirInactivos: Boolean): Int64;
begin
  Result := TMVCActiveRecord.CurrentConnection.ExecSQLScalar
    (CLIENTES_CONTAR + FiltroSegun(AIncluirInactivos),
    [ATexto, ATexto, ATexto, ATexto]);
end;

function TClienteRepository.ObtenerPorUuidLocal(const AUuid: string): TClientes;
begin
  // El False del final es RaiseExceptionIfNotFound: aqui no encontrarlo es el
  // caso normal -significa que el alta todavia no habia subido-, no un error.
  Result := TMVCActiveRecord.GetOneByWhere<TClientes>(CLIENTES_POR_UUID_LOCAL,
    [AUuid], False);
end;

function TClienteRepository.ContactosDe(const AClienteId: Integer)
  : TObjectList<TClienteContactos>;
begin
  Result := TMVCActiveRecord.Where<TClienteContactos>(CONTACTOS_DE_CLIENTE,
    [AClienteId]);
end;

end.
