unit Anovo.Repositories.Clientes;

// Repositorios de clientes, contactos y consentimiento.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Clientes,
  Anovo.Entities.Clientes,
  Anovo.Entities.Consultas;

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
      : TObjectList<TConsentimientosDeCliente>;
  end;

implementation

uses
  System.SysUtils,
  System.Variants,
  MVCFramework.ActiveRecord,
  Anovo.SQL.Clientes;

function TClienteRepository.Buscar(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  const AConsentimiento: string): TObjectList<TClientes>;
var
  lDesde, lHasta: Integer;
begin
  lDesde := ((APagina - 1) * APorPagina) + 1;
  lHasta := APagina * APorPagina;

  Result := GetWhere(FiltroSegun(AIncluirInactivos, AConsentimiento) +
    CLIENTES_ORDEN_Y_PAGINA, ParametrosSegun(ATexto, AConsentimiento) +
    [Variant(lDesde), Variant(lHasta)]);

end;

function TClienteRepository.ContarBusqueda(const ATexto: string;
  const AIncluirInactivos: Boolean; const AConsentimiento: string): Int64;
begin
  Result := ContarPorFiltro(FiltroSegun(AIncluirInactivos, AConsentimiento),
    ParametrosSegun(ATexto, AConsentimiento));
end;

function TClienteRepository.ExitsUuidLocal(const AUuid: string): Integer;
var
  lCliente: TClientes;
begin
  lCliente := ObtenerPorUuidLocal(AUuid);
  try
    Result := 0;
    if Assigned(lCliente) then
      Result := lCliente.ID.ValueOrDefault;
  finally
    lCliente.Free;
  end;
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
  Result := GetOneByWhere(CLIENTES_POR_UUID_LOCAL, [AUuid], False);
end;

function TClienteRepository.ParametrosSegun(const ATexto, AConsentimiento
  : string): TArray<Variant>;
begin
  Result := [ATexto, ATexto, ATexto, ATexto];
  if AConsentimiento <> '' then
    Result := Result + [Variant(AConsentimiento)];
end;

function TClienteContactoRepository.ContactoDe(const AClienteId,
  AContactoId: Integer): TClienteContactos;
begin
  Result := GetOneByWhere(CONTACTO_DE_CLIENTE,
    [AContactoId, AClienteId], False);
end;

function TClienteContactoRepository.ContactosDe(const AClienteId: Integer)
  : TObjectList<TClienteContactos>;
begin
  Result := GetWhere(CONTACTOS_DE_CLIENTE, [AClienteId]);
end;

function TConsentimientoRepository.HistorialDe(const AClienteId: Integer)
  : TObjectList<TConsentimientosDeCliente>;
begin
  Result := ListarConsulta<TConsentimientosDeCliente>(CONSULTA_DE_CLIENTE,
    [AClienteId], SIN_LIMITE);
end;

end.
