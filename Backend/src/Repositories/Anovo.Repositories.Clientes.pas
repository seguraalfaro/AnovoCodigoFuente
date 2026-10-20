unit Anovo.Repositories.Clientes;

// Repositorios de clientes, contactos y consentimiento.

interface

uses
  System.Generics.Collections,
  MVCFramework.Nullables,
  MVCFramework.Repository,
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Clientes,
  Anovo.Entities.Clientes,
  Anovo.Entities.Vistas.Lectura,
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
    function NombreRepetido(const ANombre: string;
      const AExcluirId: Integer): Boolean;
    function ConIdentificacion(const ATipo: Integer;
      const ANumero: string; const AExcluirId: Integer): TClientes;
  end;

  TClienteContactoRepository = class(TAnovoRepository<TClienteContactos>,
    IClienteContactoRepository)
  public
    function ContactosDe(const AClienteId: Integer)
      : TObjectList<TClienteContactos>;
    function ContactoDe(const AClienteId, AContactoId: Integer)
      : TClienteContactos;
    function TodosDe(const AClienteId: Integer): TObjectList<TClienteContactos>;
    function PorUuidLocal(const AUuid: string): TClienteContactos;
    function ParaElMovil(const ADesde: NullableTDateTime)
      : TObjectList<TVContactosBajada>;
  end;

  TConsentimientoRepository = class
    (TAnovoRepository<TClienteConsentimientoHistorial>,
    IConsentimientoRepository)
  public
    function HistorialDe(const AClienteId: Integer)
      : TObjectList<TConsentimientosDeCliente>;
    function FirmaRepetida(const AClienteId: Integer; const AFecha: TDateTime;
      const AFirmante: string): Integer;
  end;

  TConsentimientoTextoRepository = class
    (TAnovoRepository<TConsentimientoTextos>, IConsentimientoTextoRepository)
  public
    function Todas: TObjectList<TConsentimientoTextos>;
    function Vigente: TConsentimientoTextos;
    function PorVersion(const AVersion: string): TConsentimientoTextos;
  end;

implementation

uses
  System.SysUtils,
  System.Variants,
  MVCFramework.ActiveRecord,
  Anovo.SQL.Clientes,
  Anovo.SQL.Sincronizacion;

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

function TClienteRepository.NombreRepetido(const ANombre: string;
  const AExcluirId: Integer): Boolean;
begin
  Result := NombreDuplicado(ANombre, AExcluirId);
end;

function TClienteRepository.ConIdentificacion(const ATipo: Integer;
  const ANumero: string; const AExcluirId: Integer): TClientes;
begin
  Result := GetOneByWhere(CLIENTES_CON_IDENTIFICACION,
    [ATipo, ANumero, AExcluirId], False);
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

function TClienteContactoRepository.PorUuidLocal(const AUuid: string)
  : TClienteContactos;
begin
  Result := GetOneByWhere(CONTACTO_POR_UUID_LOCAL, [AUuid], False);
end;

function TClienteContactoRepository.ParaElMovil(const ADesde: NullableTDateTime)
  : TObjectList<TVContactosBajada>;
begin
  if ADesde.HasValue then
    Result := ListarDonde<TVContactosBajada>(BAJADA_CONTACTOS_DESDE,
      [ADesde.Value])
  else
    Result := ListarDonde<TVContactosBajada>(BAJADA_CONTACTOS_COMPLETA, []);
end;

function TClienteContactoRepository.TodosDe(const AClienteId: Integer)
  : TObjectList<TClienteContactos>;
begin
  Result := GetWhere(CONTACTOS_DE_CLIENTE_TODOS, [AClienteId]);
end;

function TClienteContactoRepository.ContactosDe(const AClienteId: Integer)
  : TObjectList<TClienteContactos>;
begin
  Result := GetWhere(CONTACTOS_DE_CLIENTE, [AClienteId]);
end;

function TConsentimientoTextoRepository.Todas
  : TObjectList<TConsentimientoTextos>;
begin
  Result := GetWhere(TEXTOS_CONSENTIMIENTO_TODOS, []);
end;

function TConsentimientoTextoRepository.Vigente: TConsentimientoTextos;
begin
  Result := GetOneByWhere(TEXTO_CONSENTIMIENTO_VIGENTE, [], False);
end;

function TConsentimientoTextoRepository.PorVersion(const AVersion: string)
  : TConsentimientoTextos;
begin
  Result := GetOneByWhere(TEXTO_CONSENTIMIENTO_POR_VERSION, [AVersion], False);
end;

function TConsentimientoRepository.FirmaRepetida(const AClienteId: Integer;
  const AFecha: TDateTime; const AFirmante: string): Integer;
var
  lFirma: TClienteConsentimientoHistorial;
begin
  lFirma := GetOneByWhere(FIRMA_REPETIDA, [AClienteId, AFecha, AFirmante],
    False);
  try
    if lFirma = nil then
      Exit(0);
    Result := lFirma.ID.Value;
  finally
    lFirma.Free;
  end;
end;

function TConsentimientoRepository.HistorialDe(const AClienteId: Integer)
  : TObjectList<TConsentimientosDeCliente>;
begin
  Result := ListarConsulta<TConsentimientosDeCliente>(CONSULTA_DE_CLIENTE,
    [AClienteId], SIN_LIMITE);
end;

end.
