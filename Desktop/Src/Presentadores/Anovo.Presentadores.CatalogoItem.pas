unit Anovo.Presentadores.CatalogoItem;

// Los presentadores de las dos ventanas de catalogos: el item y su precio.
// Son cortos y hacen lo mismo que los de registro de clientes, por eso
// comparten IVistaRegistro y viven juntos.
//
// La ventana arma el DTO con lo que se escribio y el presentador lo manda,
// fuera del hilo de la interfaz. El DTO se libera aqui.
//
// El catalogo llega por constructor: la ruta a la que va cada DTO depende de
// la pestana desde la que se abrio la ventana.

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
    // AId en 0 es un item nuevo; con numero, es una edicion.
    constructor Create(const AVista: IVistaRegistro;
      const AApi: IApiCatalogos; const ACatalogo: TCatalogo;
      const AId: Integer);
    destructor Destroy; override;
    // La ventana arma el DTO que corresponde a su catalogo y a si crea o
    // edita, y lo entrega. Aqui se comprueba con as: si mando el que no era,
    // falla en el acto y no en la serializacion. El DTO se libera aqui.
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
  Anovo.Api.Base;

const
  MENSAJE_INESPERADO = 'Ocurrio un error inesperado al guardar. Intente de ' +
    'nuevo; si persiste, avise al administrador.';

{ TPresentadorItemCatalogo }

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
      // Al crear, el numero lo asigna la base y viene en Location. Al editar
      // no hay numero nuevo y se devuelve el que ya tenia.
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
            lError := MENSAJE_INESPERADO;
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

{ TPresentadorPrecioCatalogo }

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
            lError := MENSAJE_INESPERADO;
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
