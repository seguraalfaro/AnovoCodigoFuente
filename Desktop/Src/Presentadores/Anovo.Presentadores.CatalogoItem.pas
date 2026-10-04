unit Anovo.Presentadores.CatalogoItem;

// Presentadores de las ventanas del item de catalogo
// y de su precio.

interface

uses
  System.Generics.Collections,
  Anovo.Api.Intf.Catalogos,
  Anovo.Cancelacion,
  Anovo.DTOs.Catalogos,
  Anovo.Vistas.Intf.Catalogos,
  Anovo.Vistas.Intf.Registro;

type
  TPresentadorItemCatalogo = class
  private
    FVista: IVistaRegistro;
    FApi: IApiCatalogos;
    FCancelacion: ICancelacion;
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

  TPresentadorPrecioCatalogo = class
  private
    FVista: IVistaRegistro;
    FApi: IApiCatalogos;
    FCancelacion: ICancelacion;
    FCatalogo: TCatalogo;
    FId: Integer;
  public
    constructor Create(const AVista: IVistaRegistro;
      const AApi: IApiCatalogos; const ACatalogo: TCatalogo;
      const AId: Integer);
    destructor Destroy; override;
    procedure Guardar(const ADto: TPrecioNuevoDTO);
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.Threading,
  Anovo.Api.Base,
  Anovo.Textos;

function MensajeInesperado: string;
begin
  Result := Format(SErrorInesperado, [SAccionGuardar]);
end;

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
  FCancelacion := TCancelacion.Create;
  FPrecioOriginal := TPrecioNuevoDTO.Create;
end;

destructor TPresentadorItemCatalogo.Destroy;
begin
  FCancelacion.Cancelar;
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
  lCancelacion: ICancelacion;
  lApi: IApiCatalogos;
  lCatalogo: TCatalogo;
  lId: Integer;
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

  lCancelacion := FCancelacion;
  lApi := FApi;
  lCatalogo := FCatalogo;
  lId := FId;
  FVista.MostrarGuardando(True);

  TTask.Run(
    procedure
    var
      lError: string;
      lNuevo: Integer;
    begin
      lError := '';
      lNuevo := lId;
      try
        try
          lNuevo := EnviarItem(lApi, lCatalogo, lId, AItem);
          if lConPrecio then
            EnviarPrecio(lApi, lCatalogo, lNuevo, APrecio);
        except
          on E: EAnovoCliente do
            lError := E.Message;
          on E: Exception do
            lError := MensajeInesperado;
        end;
      finally
        AItem.Free;
        APrecio.Free;
      end;

      TThread.Queue(nil,
        procedure
        begin
          if lCancelacion.Cancelada then
            Exit;
          FId := lNuevo;
          FVista.MostrarGuardando(False);
          if lError.IsEmpty then
            FVista.Guardado(lNuevo)
          else
            FVista.MostrarError(lError);
        end);
    end);
end;

constructor TPresentadorPrecioCatalogo.Create(const AVista: IVistaRegistro;
  const AApi: IApiCatalogos; const ACatalogo: TCatalogo; const AId: Integer);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCancelacion := TCancelacion.Create;
  FCatalogo := ACatalogo;
  FId := AId;
end;

destructor TPresentadorPrecioCatalogo.Destroy;
begin
  FCancelacion.Cancelar;
  inherited;
end;

procedure TPresentadorPrecioCatalogo.Guardar(const ADto: TPrecioNuevoDTO);
var
  lCancelacion: ICancelacion;
  lApi: IApiCatalogos;
  lCatalogo: TCatalogo;
  lId: Integer;
begin
  lCancelacion := FCancelacion;
  lApi := FApi;
  lCatalogo := FCatalogo;
  lId := FId;
  FVista.MostrarGuardando(True);

  TTask.Run(
    procedure
    var
      lError: string;
    begin
      lError := '';
      try
        try
          EnviarPrecio(lApi, lCatalogo, lId, ADto);
        except
          on E: EAnovoCliente do
            lError := E.Message;
          on E: Exception do
            lError := MensajeInesperado;
        end;
      finally
        ADto.Free;
      end;

      TThread.Queue(nil,
        procedure
        begin
          if lCancelacion.Cancelada then
            Exit;
          FVista.MostrarGuardando(False);
          if lError.IsEmpty then
            FVista.Guardado(lId)
          else
            FVista.MostrarError(lError);
        end);
    end);
end;

end.
