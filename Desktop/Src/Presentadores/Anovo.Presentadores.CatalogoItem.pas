unit Anovo.Presentadores.CatalogoItem;

// Presentadores de las ventanas del item de catalogo
// y de su precio.

interface

uses
  System.Generics.Collections,
  Anovo.Api.Intf.Catalogos,
  Anovo.Presentadores.Base,
  Anovo.DTOs.Catalogos,
  Anovo.Vistas.Intf.Catalogos,
  Anovo.Vistas.Intf.Registro;

type
  TPresentadorItemCatalogo = class(TPresentadorBase)
  private
    FVista: IVistaRegistro;
    FApi: IApiCatalogos;
    FCatalogo: TCatalogo;
    FId: Integer;
    FPrecioOriginal: TPrecioNuevoDTO;
    function PrecioCambio(const APrecio: TPrecioNuevoDTO;
      const AProgramado: Boolean): Boolean;
  public
    constructor Create(const AVista: IVistaRegistro;
      const AApi: IApiCatalogos);
    destructor Destroy; override;
    procedure Iniciar(const ACatalogo: TCatalogo; const AId: Integer);
    procedure RecordarPrecio(const APrecio: TPrecioNuevoDTO);
    function LlevaPrecio: Boolean;
    procedure Guardar(const AItem: TObject; const APrecio: TPrecioNuevoDTO;
      const AProgramado: Boolean);
  end;

  TPresentadorPrecioCatalogo = class(TPresentadorBase)
  private
    FVista: IVistaRegistro;
    FApi: IApiCatalogos;
    FCatalogo: TCatalogo;
    FId: Integer;
  public
    constructor Create(const AVista: IVistaRegistro;
      const AApi: IApiCatalogos; const ACatalogo: TCatalogo;
      const AId: Integer);
    procedure Guardar(const ADto: TPrecioNuevoDTO);
  end;

implementation

uses
  System.SysUtils,
  Anovo.Textos;

function EnviarItem(const AApi: IApiCatalogos; const ACatalogo: TCatalogo;
  const AId: Integer; const ADto: TObject): Integer;
begin
  Result := AId;
  case ACatalogo of
    ctManoObra:
      if AId = 0 then
        Result := AApi.CrearManoObra(ADto as TManoObraNuevaDTO)
      else
        AApi.ActualizarManoObra(AId, ADto as TManoObraEdicionDTO);
    ctMaquinas:
      if AId = 0 then
        Result := AApi.CrearMaquina(ADto as TMaquinaNuevaDTO)
      else
        AApi.ActualizarMaquina(AId, ADto as TMaquinaEdicionDTO);
    ctTiposTrabajo:
      if AId = 0 then
        Result := AApi.CrearTipoTrabajo(ADto as TTipoTrabajoNuevoDTO)
      else
        AApi.ActualizarTipoTrabajo(AId, ADto as TTipoTrabajoNuevoDTO);
    ctUnidadesMedida:
      if AId = 0 then
        Result := AApi.CrearUnidadMedida(ADto as TUnidadMedidaNuevaDTO)
      else
        AApi.ActualizarUnidadMedida(AId, ADto as TUnidadMedidaNuevaDTO);
  else
    if AId = 0 then
      Result := AApi.CrearMaterial(ADto as TMaterialNuevoDTO)
    else
      AApi.ActualizarMaterial(AId, ADto as TMaterialEdicionDTO);
  end;
end;

procedure EnviarPrecio(const AApi: IApiCatalogos; const ACatalogo: TCatalogo;
  const AId: Integer; const ADto: TPrecioNuevoDTO);
begin
  case ACatalogo of
    ctManoObra:
      AApi.CambiarPrecioManoObra(AId, ADto);
    ctMaquinas:
      AApi.CambiarCostoMaquina(AId, ADto);
  else
    AApi.CambiarPrecioMaterial(AId, ADto);
  end;
end;

constructor TPresentadorItemCatalogo.Create(const AVista: IVistaRegistro;
  const AApi: IApiCatalogos);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FPrecioOriginal := TPrecioNuevoDTO.Create;
end;

destructor TPresentadorItemCatalogo.Destroy;
begin
  FPrecioOriginal.Free;
  inherited;
end;

procedure TPresentadorItemCatalogo.Iniciar(const ACatalogo: TCatalogo;
  const AId: Integer);
begin
  FCatalogo := ACatalogo;
  FId := AId;
end;

procedure TPresentadorItemCatalogo.RecordarPrecio(const APrecio
  : TPrecioNuevoDTO);
begin
  FPrecioOriginal.Free;
  FPrecioOriginal := APrecio;
end;

function TPresentadorItemCatalogo.LlevaPrecio: Boolean;
begin
  Result := not (FCatalogo in [ctTiposTrabajo, ctUnidadesMedida]);
end;

function TPresentadorItemCatalogo.PrecioCambio(const APrecio: TPrecioNuevoDTO;
  const AProgramado: Boolean): Boolean;
begin
  Result := LlevaPrecio and (APrecio <> nil) and (AProgramado or
    (APrecio.CostoUnitario.ValueOrDefault <>
    FPrecioOriginal.CostoUnitario.ValueOrDefault) or
    (APrecio.PrecioUnitario.ValueOrDefault <>
    FPrecioOriginal.PrecioUnitario.ValueOrDefault) or
    (APrecio.CostoHora.ValueOrDefault <>
    FPrecioOriginal.CostoHora.ValueOrDefault));
end;

procedure TPresentadorItemCatalogo.Guardar(const AItem: TObject;
  const APrecio: TPrecioNuevoDTO; const AProgramado: Boolean);
var
  lApi: IApiCatalogos;
  lCatalogo: TCatalogo;
  lId, lNuevo: Integer;
  lConPrecio: Boolean;
begin
  lConPrecio := PrecioCambio(APrecio, AProgramado);
  if lConPrecio and (FCatalogo = ctMateriales) and
    (APrecio.PrecioUnitario.ValueOrDefault <= 0) then
  begin
    AItem.Free;
    APrecio.Free;
    FVista.MostrarError(SFaltaPrecioVenta);
    Exit;
  end;

  lApi := FApi;
  lCatalogo := FCatalogo;
  lId := FId;
  lNuevo := lId;

  Ejecutar(SAccionGuardar,
    procedure
    begin
      lNuevo := EnviarItem(lApi, lCatalogo, lId, AItem);
      if lConPrecio then
        EnviarPrecio(lApi, lCatalogo, lNuevo, APrecio);
    end,
    procedure
    begin
      FId := lNuevo;
      FVista.Guardado(lNuevo);
    end,
    procedure(AMensaje: string)
    begin
      FId := lNuevo;
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarGuardando(AActivo);
    end,
    procedure
    begin
      AItem.Free;
      APrecio.Free;
    end);
end;

constructor TPresentadorPrecioCatalogo.Create(const AVista: IVistaRegistro;
  const AApi: IApiCatalogos; const ACatalogo: TCatalogo; const AId: Integer);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCatalogo := ACatalogo;
  FId := AId;
end;

procedure TPresentadorPrecioCatalogo.Guardar(const ADto: TPrecioNuevoDTO);
var
  lApi: IApiCatalogos;
  lCatalogo: TCatalogo;
  lId: Integer;
begin
  lApi := FApi;
  lCatalogo := FCatalogo;
  lId := FId;

  Ejecutar(SAccionGuardar,
    procedure
    begin
      EnviarPrecio(lApi, lCatalogo, lId, ADto);
    end,
    procedure
    begin
      FVista.Guardado(lId);
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarGuardando(AActivo);
    end,
    procedure
    begin
      ADto.Free;
    end);
end;

end.
