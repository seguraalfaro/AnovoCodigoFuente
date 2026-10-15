unit Anovo.Services.Sincronizacion;

// Bajada al movil: clientes, contactos y catalogos modificados desde una fecha,
// con unos minutos de solape para no perder lo que se confirmo durante la lectura.

interface

uses
  System.Generics.Collections,
  MVCFramework,
  MVCFramework.Nullables,
  Anovo.DTOs.Sincronizacion,
  Anovo.Entities.Clientes,
  Anovo.Repositories.Intf.Clientes,
  Anovo.Repositories.Intf.Catalogos,
  Anovo.Repositories.Intf.Solicitudes,
  Anovo.Services.Intf.Sincronizacion;

type
  TSincronizacionService = class(TInterfacedObject, ISincronizacionService)
  private
    fClientes: IClienteRepository;
    fContactos: IClienteContactoRepository;
    fTiposTrabajo: ITipoTrabajoRepository;
    fTiposMaterial: ITipoMaterialRepository;
    fAcabados: IAcabadoRepository;
    fSolicitudes: ISolicitudRepository;
    function UuidsDe(const AClientes: TObjectList<TClientes>)
      : TDictionary<Integer, string>;
    function UuidDelCliente(const AUuids: TDictionary<Integer, string>;
      const AClienteId: Integer; const ACompleta: Boolean): string;
    procedure LlenarClientes(const ABajada: TBajadaDTO;
      const ADesde: NullableTDateTime);
    procedure LlenarCatalogos(const ABajada: TBajadaDTO;
      const ADesde: NullableTDateTime);
    procedure LlenarSolicitudes(const ABajada: TBajadaDTO;
      const AAsesorId: Integer; const ADesde: NullableTDateTime);
  public
    [MVCInject]
    constructor Create(AClientes: IClienteRepository;
      AContactos: IClienteContactoRepository;
      ATiposTrabajo: ITipoTrabajoRepository;
      ATiposMaterial: ITipoMaterialRepository;
      AAcabados: IAcabadoRepository;
      ASolicitudes: ISolicitudRepository); reintroduce;
    function Bajar(const AAsesorId: Integer;
      const ADesde: NullableTDateTime): TBajadaDTO;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  Anovo.Mapeo,
  Anovo.Entities.Catalogos,
  Anovo.Entities.Consultas;

const
  MINUTOS_SOLAPE = 5;

constructor TSincronizacionService.Create(AClientes: IClienteRepository;
  AContactos: IClienteContactoRepository; ATiposTrabajo: ITipoTrabajoRepository;
  ATiposMaterial: ITipoMaterialRepository; AAcabados: IAcabadoRepository;
  ASolicitudes: ISolicitudRepository);
begin
  inherited Create;
  fClientes := AClientes;
  fContactos := AContactos;
  fTiposTrabajo := ATiposTrabajo;
  fTiposMaterial := ATiposMaterial;
  fAcabados := AAcabados;
  fSolicitudes := ASolicitudes;
end;

function TSincronizacionService.Bajar(const AAsesorId: Integer;
  const ADesde: NullableTDateTime): TBajadaDTO;
var
  lDesde: NullableTDateTime;
begin
  Result := TBajadaDTO.Create;
  try
    Result.ServidorAhora := Now;
    Result.Completa := not ADesde.HasValue;
    if ADesde.HasValue then
      lDesde := IncMinute(ADesde.Value, -MINUTOS_SOLAPE);
    LlenarClientes(Result, lDesde);
    LlenarCatalogos(Result, lDesde);
    LlenarSolicitudes(Result, AAsesorId, lDesde);
  except
    Result.Free;
    raise;
  end;
end;

procedure TSincronizacionService.LlenarClientes(const ABajada: TBajadaDTO;
  const ADesde: NullableTDateTime);
var
  lClientes: TObjectList<TClientes>;
  lContactos: TObjectList<TClienteContactos>;
  lUuids: TDictionary<Integer, string>;
  lContacto: TClienteContactos;
  lDto: TContactoBajadaDTO;
  lUuid: string;
begin
  lClientes := fClientes.ParaBajar(ADesde, True);
  try
    ABajada.Clientes.Free;
    ABajada.Clientes := TMapeo.AListaDto<TClientes, TClienteBajadaDTO>
      (lClientes);
    lUuids := UuidsDe(lClientes);
  finally
    lClientes.Free;
  end;

  try
    lContactos := fContactos.ParaBajar(ADesde, True);
    try
      for lContacto in lContactos do
      begin
        lUuid := UuidDelCliente(lUuids, lContacto.ClienteId,
          ABajada.Completa);
        if lUuid = '' then
          Continue;
        lDto := TMapeo.ADto<TContactoBajadaDTO>(lContacto);
        lDto.ClienteUuid := lUuid;
        ABajada.Contactos.Add(lDto);
      end;
    finally
      lContactos.Free;
    end;
  finally
    lUuids.Free;
  end;
end;

function TSincronizacionService.UuidsDe(const AClientes: TObjectList<TClientes>)
  : TDictionary<Integer, string>;
var
  lCliente: TClientes;
begin
  Result := TDictionary<Integer, string>.Create;
  for lCliente in AClientes do
    Result.AddOrSetValue(lCliente.ID.Value, lCliente.UuidLocal.Value);
end;

function TSincronizacionService.UuidDelCliente(const AUuids
  : TDictionary<Integer, string>; const AClienteId: Integer;
  const ACompleta: Boolean): string;
var
  lCliente: TClientes;
begin
  if AUuids.TryGetValue(AClienteId, Result) then
    Exit;
  Result := '';
  if not ACompleta then
  begin
    lCliente := fClientes.GetByPK(AClienteId, False);
    try
      if Assigned(lCliente) then
        Result := lCliente.UuidLocal.ValueOrDefault;
    finally
      lCliente.Free;
    end;
  end;
  AUuids.Add(AClienteId, Result);
end;

procedure TSincronizacionService.LlenarSolicitudes(const ABajada: TBajadaDTO;
  const AAsesorId: Integer; const ADesde: NullableTDateTime);
var
  lFilas: TObjectList<TSeguimientoAsesor>;
begin
  lFilas := fSolicitudes.SeguimientoParaBajar(AAsesorId, ADesde);
  try
    ABajada.Solicitudes.Free;
    ABajada.Solicitudes := TMapeo.AListaDto<TSeguimientoAsesor,
      TSolicitudBajadaDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

procedure TSincronizacionService.LlenarCatalogos(const ABajada: TBajadaDTO;
  const ADesde: NullableTDateTime);
var
  lTrabajos: TObjectList<TTiposTrabajo>;
  lMateriales: TObjectList<TTiposMaterial>;
  lAcabados: TObjectList<TAcabados>;
begin
  lTrabajos := fTiposTrabajo.ParaBajar(ADesde);
  try
    ABajada.TiposTrabajo.Free;
    ABajada.TiposTrabajo := TMapeo.AListaDto<TTiposTrabajo, TCatalogoBajadaDTO>
      (lTrabajos);
  finally
    lTrabajos.Free;
  end;

  lMateriales := fTiposMaterial.ParaBajar(ADesde);
  try
    ABajada.TiposMaterial.Free;
    ABajada.TiposMaterial := TMapeo.AListaDto<TTiposMaterial,
      TCatalogoBajadaDTO>(lMateriales);
  finally
    lMateriales.Free;
  end;

  lAcabados := fAcabados.ParaBajar(ADesde);
  try
    ABajada.Acabados.Free;
    ABajada.Acabados := TMapeo.AListaDto<TAcabados, TCatalogoBajadaDTO>
      (lAcabados);
  finally
    lAcabados.Free;
  end;
end;

end.
