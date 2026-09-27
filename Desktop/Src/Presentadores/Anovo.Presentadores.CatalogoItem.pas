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
  public
    constructor Create(const AVista: IVistaRegistro;
      const AApi: IApiCatalogos; const ACatalogo: TCatalogo;
      const AId: Integer);
    destructor Destroy; override;
    procedure Guardar(const ADto: TObject);
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

constructor TPresentadorItemCatalogo.Create(const AVista: IVistaRegistro;
  const AApi: IApiCatalogos; const ACatalogo: TCatalogo; const AId: Integer);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCancelacion := TCancelacion.Create;
  FCatalogo := ACatalogo;
  FId := AId;
end;

destructor TPresentadorItemCatalogo.Destroy;
begin
  FCancelacion.Cancelar;
  inherited;
end;

procedure TPresentadorItemCatalogo.Guardar(const ADto: TObject);
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
      lNuevo: Integer;
    begin
      lError := '';
      lNuevo := lId;
      try
        try
          case lCatalogo of
            ctManoObra:
              if lId = 0 then
                lNuevo := lApi.CrearManoObra(ADto as TManoObraNuevaDTO)
              else
                lApi.ActualizarManoObra(lId, ADto as TManoObraEdicionDTO);
            ctMaquinas:
              if lId = 0 then
                lNuevo := lApi.CrearMaquina(ADto as TMaquinaNuevaDTO)
              else
                lApi.ActualizarMaquina(lId, ADto as TMaquinaEdicionDTO);
            ctTiposTrabajo:
              if lId = 0 then
                lNuevo := lApi.CrearTipoTrabajo(ADto as TTipoTrabajoNuevoDTO)
              else
                lApi.ActualizarTipoTrabajo(lId, ADto as TTipoTrabajoNuevoDTO);
            ctUnidadesMedida:
              if lId = 0 then
                lNuevo := lApi.CrearUnidadMedida(ADto as TUnidadMedidaNuevaDTO)
              else
                lApi.ActualizarUnidadMedida(lId, ADto as TUnidadMedidaNuevaDTO);
          else
            if lId = 0 then
              lNuevo := lApi.CrearMaterial(ADto as TMaterialNuevoDTO)
            else
              lApi.ActualizarMaterial(lId, ADto as TMaterialEdicionDTO);
          end;
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
          case lCatalogo of
            ctManoObra:
              lApi.CambiarPrecioManoObra(lId, ADto);
            ctMaquinas:
              lApi.CambiarCostoMaquina(lId, ADto);
          else
            lApi.CambiarPrecioMaterial(lId, ADto);
          end;
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
