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
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Clientes,
  Anovo.Entities.Clientes;

type
  TClienteRepository = class(TAnovoRepository<TClientes>, IClienteRepository)
  private
    function FiltroSegun(const AIncluirInactivos: Boolean;
      const AConsentimiento: string): string;
    function ParametrosSegun(const ATexto, AConsentimiento: string)
      : TArray<Variant>;
  public
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False;
      const AConsentimiento: string = ''): TObjectList<TClientes>;
    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False;
      const AConsentimiento: string = ''): Int64;
    function ObtenerPorUuidLocal(const AUuid: string): TClientes;
    function ExitsUuidLocal(const AUuid: string): Integer;
  end;

  TClienteContactoRepository = class(TAnovoRepository<TClienteContactos>,
    IClienteContactoRepository)
  public
    function ContactosDe(const AClienteId: Integer)
      : TObjectList<TClienteContactos>;
    function ContactoDe(const AClienteId, AContactoId: Integer)
      : TClienteContactos;
  end;

  TConsentimientoRepository = class
    (TAnovoRepository<TClienteConsentimientoHistorial>,
    IConsentimientoRepository)
  public
    function HistorialDe(const AClienteId: Integer)
      : TObjectList<TClienteConsentimientoHistorial>;
  end;

implementation

uses
  System.SysUtils,
  System.Variants,
  MVCFramework.ActiveRecord,
  Anovo.SQL.Clientes;

{ TClienteRepository }

function TClienteRepository.Buscar(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  const AConsentimiento: string): TObjectList<TClientes>;
var
  lDesde, lHasta: Integer;
begin
  lDesde := ((APagina - 1) * APorPagina) + 1;
  lHasta := APagina * APorPagina;

  // Variant(...) explicito: sin el, [lDesde, lHasta] es un arreglo de enteros
  // y no se concatena con uno de Variant.
  Result := GetWhere(FiltroSegun(AIncluirInactivos, AConsentimiento) +
    CLIENTES_ORDEN_Y_PAGINA, ParametrosSegun(ATexto, AConsentimiento) +
    [Variant(lDesde), Variant(lHasta)]);

end;

function TClienteRepository.ContarBusqueda(const ATexto: string;
  const AIncluirInactivos: Boolean; const AConsentimiento: string): Int64;
begin
  // Count del repositorio solo acepta RQL: el total va por la conexion.
  Result := GetConnection.ExecSQLScalar(CLIENTES_CONTAR +
    FiltroSegun(AIncluirInactivos, AConsentimiento),
    ParametrosSegun(ATexto, AConsentimiento));
end;

function TClienteRepository.ExitsUuidLocal(const AUuid: string): Integer;
var
  lId: Variant;
begin
  lId := GetConnection.ExecSQLScalar(CLIENTES_ID_POR_UUID_LOCAL, [AUuid]);
  if VarIsNull(lId) then
    Result := 0
  else
    Result := lId;
end;

function TClienteRepository.FiltroSegun(const AIncluirInactivos: Boolean;
  const AConsentimiento: string): string;
begin
  Result := CLIENTES_FILTRO_BUSQUEDA;
  if not AIncluirInactivos then
    Result := Result + CLIENTES_SOLO_ACTIVOS;
  if AConsentimiento <> '' then
    Result := Result + CLIENTES_POR_CONSENTIMIENTO;
end;

function TClienteRepository.ObtenerPorUuidLocal(const AUuid: string): TClientes;
begin
  // El False del final es RaiseExceptionIfNotFound: aqui no encontrarlo es el
  // caso normal -significa que el registro todavia no habia subido-, no un
  // error.
  Result := GetOneByWhere(CLIENTES_POR_UUID_LOCAL, [AUuid], False);
end;

function TClienteRepository.ParametrosSegun(const ATexto, AConsentimiento
  : string): TArray<Variant>;
begin
  // En el mismo orden en que FiltroSegun pone los ?.
  Result := [ATexto, ATexto, ATexto, ATexto];
  if AConsentimiento <> '' then
    Result := Result + [Variant(AConsentimiento)];
end;

{ TClienteContactoRepository }

function TClienteContactoRepository.ContactoDe(const AClienteId,
  AContactoId: Integer): TClienteContactos;
begin
  // El False del final es RaiseExceptionIfNotFound: el servicio lanza la
  // excepcion propia, que sale con el codigo y el mensaje del contrato.
  Result := GetOneByWhere(CONTACTO_DE_CLIENTE,
    [AContactoId, AClienteId], False);
end;

function TClienteContactoRepository.ContactosDe(const AClienteId: Integer)
  : TObjectList<TClienteContactos>;
begin
  Result := GetWhere(CONTACTOS_DE_CLIENTE, [AClienteId]);
end;

{ TConsentimientoRepository }

function TConsentimientoRepository.HistorialDe(const AClienteId: Integer)
  : TObjectList<TClienteConsentimientoHistorial>;
begin
  // La consulta deja fuera FIRMA_IMAGEN; sin loIgnoreNotExistentFields la
  // carga fallaria por esa columna. En la entidad queda el stream vacio: una
  // entidad cargada asi no se guarda.
  Result := SelectConOpciones(CONSENTIMIENTOS_DE_CLIENTE, [AClienteId],
    [loIgnoreNotExistentFields]);;
end;

end.
