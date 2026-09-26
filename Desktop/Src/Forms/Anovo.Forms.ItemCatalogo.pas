unit Anovo.Forms.ItemCatalogo;

// Ventana del item de catalogo: sirve a los cuatro. Modal, sin borde y con el
// tema de la aplicacion, como la de cliente nuevo.
//
// Una tarjeta por catalogo, y al abrir se activa la que toca. Antes eran los
// campos de los cuatro encimados en un panel, mostrandose y escondiendose: dos
// controles distintos ocupaban la misma posicion y cual se veia dependia de
// una linea suelta. Con TCardPanel cada catalogo tiene su propia distribucion.
//
// Los controles de las cuatro tarjetas se ligan a la misma tabla,
// mtItemCatalogo, que es la union de los cuatro. El campo que la tarjeta
// activa no usa se queda vacio y el DTO que se arma no lo lleva.
//
// El precio aparece al registrar y al editar, pero no es una tarjeta: no
// sustituye a las otras, va con ellas.
//
// Al editar, los valores se copian de la fila que ya esta en la rejilla: no
// hace falta volver a pedirle el item al servidor para mostrar lo que la
// persona tiene delante.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.TitleBarCtrls, Vcl.WinXPanels, Vcl.Mask, Vcl.DBCtrls,
  Data.DB,
  rDBComponents,
  VclPlano.BotonWin,
  Anovo.UI.Tema,
  Anovo.DTOs.Catalogos,
  Anovo.Vistas.Intf.Catalogos,
  Anovo.Vistas.Intf.Registro,
  Anovo.Presentadores.CatalogoItem;

type
  TfrmItemCatalogo = class(TForm, IVistaRegistro)
    TitleBarPanel1: TTitleBarPanel;
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    cpCatalogo: TCardPanel;
    CarMaterial: TCard;
    edCodigoMat: TrDBEdit;
    edNombreMat: TrDBEdit;
    cbUnidadMat: TrDBLookupComboBox;
    meDescripcionMat: TrDBMemo;
    CarManoObra: TCard;
    edCodigoMo: TrDBEdit;
    edNombreMo: TrDBEdit;
    lblCategoriaMo: TLabel;
    cbCategoriaMo: TComboBox;
    cbUnidadMo: TrDBLookupComboBox;
    meDescripcionMo: TrDBMemo;
    CarMaquina: TCard;
    edCodigoMaq: TrDBEdit;
    edNombreMaq: TrDBEdit;
    meDescripcionMaq: TrDBMemo;
    CarTipoTrabajo: TCard;
    edNombreTipo: TrDBEdit;
    pnlPrecio: TPanel;
    lblPrecio: TLabel;
    edCosto: TrDBEdit;
    edPrecio: TrDBEdit;
    edCostoHora: TrDBEdit;
    edVigencia: TrDBEdit;
    pnlPie: TPanel;
    btnGuardar: TPlanoBotonWin;
    btnCancelar: TPlanoBotonWin;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FPresentador: TPresentadorItemCatalogo;
    FPresentadorPrecio: TPresentadorPrecioCatalogo;
    FCatalogo: TCatalogo;
    FId: Integer;
    FGuardado: Boolean;
    FPrecioEnviado: Boolean;
    // Lo que traia el precio al abrir. Sirve para saber si cambio.
    FCostoOriginal: Currency;
    FPrecioOriginal: Currency;
    FCostoHoraOriginal: Currency;
    FVigenciaOriginal: TDateTime;
    procedure PrepararCampos;
    procedure PrepararTabla;
    procedure PrepararPrecio;
    function ValidarCampos: Boolean;
    function DtoEscrito: TObject;
    function CategoriaEscogida: Integer;
    function LlevaPrecio: Boolean;
    function PrecioCambio: Boolean;
    // IVistaRegistro
    procedure MostrarGuardando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure Guardado(const AId: Integer);
  public
    // AId en 0 es un item nuevo. ACategorias son las de mano de obra, con el
    // numero en Objects; las demas tarjetas no las usan. Devuelve True si se
    // guardo, para que quien abrio recargue.
    class function Mostrar(AOwner: TComponent; const ACatalogo: TCatalogo;
      const AId: Integer; const ACategorias: TStrings): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Api.Catalogos,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria;

const
  TITULOS: array [TCatalogo] of string = ('material', 'mano de obra',
    'm' + #225 + 'quina', 'tipo de trabajo');

  // Las letras con las que Anovo clasifica cada catalogo. Al registrar, el
  // codigo viene con las suyas y la persona escribe el resto; asi no hay que
  // acordarse de la convencion ni se cuelan codigos con otra forma.
  //
  // Los tipos de trabajo no llevan codigo: esa entrada queda vacia.
  PREFIJO: array [TCatalogo] of string = ('MAT-', 'MO-', 'MAQ-', '');

class function TfrmItemCatalogo.Mostrar(AOwner: TComponent;
  const ACatalogo: TCatalogo; const AId: Integer;
  const ACategorias: TStrings): Boolean;
var
  lForma: TfrmItemCatalogo;
begin
  lForma := TfrmItemCatalogo.Create(AOwner);
  try
    lForma.FCatalogo := ACatalogo;
    lForma.FId := AId;
    if ACategorias <> nil then
      lForma.cbCategoriaMo.Items.Assign(ACategorias);
    lForma.PrepararCampos;
    lForma.PrepararTabla;
    lForma.PrepararPrecio;
    lForma.ShowModal;
    Result := lForma.FGuardado;
  finally
    lForma.Free;
  end;
end;

procedure TfrmItemCatalogo.FormCreate(Sender: TObject);
begin
  AplicarTema(Self);
  AplicarTemaBarraTitulo(Self, TitleBarPanel1);
  FPresentador := nil;
  FPresentadorPrecio := nil;
  FGuardado := False;
  FPrecioEnviado := False;
end;

procedure TfrmItemCatalogo.FormDestroy(Sender: TObject);
begin
  FPresentador.Free;
  FPresentadorPrecio.Free;
  // Las tablas quedan cerradas: si no, la proxima ventana abre con lo de esta.
  dmMemoria.mtItemCatalogo.Close;
  dmMemoria.mtPrecioCatalogo.Close;
end;

// Preparacion

procedure TfrmItemCatalogo.PrepararCampos;
begin
  if FId = 0 then
    lblTitulo.Caption := 'Nuevo ' + TITULOS[FCatalogo]
  else
    lblTitulo.Caption := 'Editar ' + TITULOS[FCatalogo];

  case FCatalogo of
    ctManoObra:
      cpCatalogo.ActiveCard := CarManoObra;
    ctMaquinas:
      cpCatalogo.ActiveCard := CarMaquina;
    ctTiposTrabajo:
      cpCatalogo.ActiveCard := CarTipoTrabajo;
  else
    cpCatalogo.ActiveCard := CarMaterial;
  end;

  // Los tipos de trabajo no llevan precio, ni al registrar ni al editar.
  pnlPrecio.Visible := LlevaPrecio;
  edCosto.Visible := FCatalogo in [ctMateriales, ctManoObra];
  edPrecio.Visible := FCatalogo = ctMateriales;
  edCostoHora.Visible := FCatalogo = ctMaquinas;

  if FId = 0 then
    lblPrecio.Caption := 'Precio inicial (opcional, se puede cargar despu' +
      #233 + 's)'
  else
    lblPrecio.Caption := 'Precio vigente. Si lo cambia, el anterior queda ' +
      'en el historial';
end;

procedure TfrmItemCatalogo.PrepararTabla;
var
  lOrigen: TDataSet;
begin
  dmMemoria.PrepararItemCatalogo;

  if FId = 0 then
  begin
    dmMemoria.mtItemCatalogoCODIGO.AsString := PREFIJO[FCatalogo];
    if cbCategoriaMo.Items.Count > 0 then
      cbCategoriaMo.ItemIndex := 0;
    Exit;
  end;

  // La fila que la persona tiene delante en la rejilla.
  lOrigen := dmMemoria.dsCatalogo.DataSet;
  if (lOrigen = nil) or lOrigen.IsEmpty then
    Exit;

  dmMemoria.mtItemCatalogoCODIGO.AsString :=
    lOrigen.FieldByName('CODIGO').AsString;
  dmMemoria.mtItemCatalogoNOMBRE.AsString :=
    lOrigen.FieldByName('NOMBRE').AsString;
  dmMemoria.mtItemCatalogoDESCRIPCION.AsString :=
    lOrigen.FieldByName('DESCRIPCION').AsString;
  dmMemoria.mtItemCatalogoUNIDAD_MEDIDA.AsString :=
    lOrigen.FieldByName('UNIDAD_MEDIDA').AsString;
  if FCatalogo = ctManoObra then
    cbCategoriaMo.ItemIndex := cbCategoriaMo.Items.IndexOfObject
      (TObject(lOrigen.FieldByName('CATEGORIA_ID').AsInteger));
end;

procedure TfrmItemCatalogo.PrepararPrecio;
var
  lOrigen: TDataSet;
begin
  FCostoOriginal := 0;
  FPrecioOriginal := 0;
  FCostoHoraOriginal := 0;
  FVigenciaOriginal := 0;

  if not LlevaPrecio then
    Exit;

  dmMemoria.PrepararPrecioCatalogo;
  if FId = 0 then
    Exit;

  // Al editar se muestra el precio que rige hoy, que el listado ya trajo en la
  // misma consulta. Se guarda aparte para saber despues si la persona lo
  // cambio: los campos llegan llenos, asi que "tiene valor" no dice nada.
  lOrigen := dmMemoria.dsCatalogo.DataSet;
  if (lOrigen = nil) or lOrigen.IsEmpty then
    Exit;

  if FCatalogo = ctMaquinas then
  begin
    FCostoHoraOriginal := lOrigen.FieldByName('COSTO_HORA').AsCurrency;
    dmMemoria.mtPrecioCatalogoCOSTO_HORA.AsCurrency := FCostoHoraOriginal;
  end
  else
  begin
    FCostoOriginal := lOrigen.FieldByName('COSTO_UNITARIO').AsCurrency;
    dmMemoria.mtPrecioCatalogoCOSTO_UNITARIO.AsCurrency := FCostoOriginal;
    if FCatalogo = ctMateriales then
    begin
      FPrecioOriginal := lOrigen.FieldByName('PRECIO_UNITARIO').AsCurrency;
      dmMemoria.mtPrecioCatalogoPRECIO_UNITARIO.AsCurrency := FPrecioOriginal;
    end;
  end;

  FVigenciaOriginal := lOrigen.FieldByName('FECHA_VIGENCIA').AsDateTime;
  if FVigenciaOriginal > 0 then
    dmMemoria.mtPrecioCatalogoFECHA_VIGENCIA.AsDateTime := FVigenciaOriginal;
end;

// Apoyo

function TfrmItemCatalogo.LlevaPrecio: Boolean;
begin
  Result := FCatalogo <> ctTiposTrabajo;
end;

function TfrmItemCatalogo.CategoriaEscogida: Integer;
begin
  if cbCategoriaMo.ItemIndex < 0 then
    Exit(0);
  Result := Integer(cbCategoriaMo.Items.Objects[cbCategoriaMo.ItemIndex]);
end;

function TfrmItemCatalogo.PrecioCambio: Boolean;
begin
  // Contra lo que traia al abrir, no contra cero. Al editar los campos llegan
  // llenos: sin esta comparacion, corregir una tilde en el nombre registraria
  // un cambio de precio, con su fila en el historial y su asiento de
  // auditoria, y el historial se llenaria de precios que nunca cambiaron.
  //
  // Al registrar los originales son cero, asi que cualquier monto cuenta como
  // cambio y una ventana sin precio no manda nada.
  Result := LlevaPrecio and
    ((dmMemoria.mtPrecioCatalogoCOSTO_UNITARIO.AsCurrency <> FCostoOriginal) or
    (dmMemoria.mtPrecioCatalogoPRECIO_UNITARIO.AsCurrency <> FPrecioOriginal) or
    (dmMemoria.mtPrecioCatalogoCOSTO_HORA.AsCurrency <> FCostoHoraOriginal) or
    (dmMemoria.mtPrecioCatalogoFECHA_VIGENCIA.AsDateTime <>
    FVigenciaOriginal));
end;

function TfrmItemCatalogo.ValidarCampos: Boolean;
begin
  Result := False;

  if (FCatalogo <> ctTiposTrabajo) and
    (dmMemoria.mtItemCatalogoCODIGO.AsString.Trim.IsEmpty or
    SameText(dmMemoria.mtItemCatalogoCODIGO.AsString.Trim,
    PREFIJO[FCatalogo])) then
  begin
    // Vacio o solo el prefijo: el prefijo lo puso la ventana, no la persona.
    MostrarError('Complete el c' + #243 + 'digo despu' + #233 + 's de ' +
      PREFIJO[FCatalogo]);
    Exit;
  end;

  if dmMemoria.mtItemCatalogoNOMBRE.AsString.Trim.IsEmpty then
  begin
    MostrarError('El nombre es obligatorio.');
    Exit;
  end;

  if (FCatalogo in [ctMateriales, ctManoObra]) and
    dmMemoria.mtItemCatalogoUNIDAD_MEDIDA.AsString.Trim.IsEmpty then
  begin
    MostrarError('Escoja la unidad de medida.');
    Exit;
  end;

  if (FCatalogo = ctManoObra) and (CategoriaEscogida = 0) then
  begin
    MostrarError('Escoja una categor' + #237 + 'a.');
    Exit;
  end;

  // El precio de venta es el que va a la cotizacion: sin el, la linea quedaria
  // en cero y nadie lo notaria hasta ver el total.
  if PrecioCambio and (FCatalogo = ctMateriales) and
    (dmMemoria.mtPrecioCatalogoPRECIO_UNITARIO.AsCurrency <= 0) then
  begin
    MostrarError('Falta el precio de venta.');
    edPrecio.SetFocus;
    Exit;
  end;

  Result := True;
end;

function TfrmItemCatalogo.DtoEscrito: TObject;
var
  lManoObraNueva: TManoObraNuevaDTO;
  lManoObraEdicion: TManoObraEdicionDTO;
begin
  // TMapeoDatos copia por nombre de propiedad; la tabla es la union de los
  // cuatro catalogos, asi que cada DTO se lleva lo suyo y deja el resto.
  //
  // La clase depende del catalogo y de si crea o edita. El presentador la
  // comprueba con as, asi que equivocarse aqui no pasa desapercibido.
  case FCatalogo of
    ctManoObra:
      if FId = 0 then
      begin
        lManoObraNueva := TMapeoDatos.ADto<TManoObraNuevaDTO>
          (dmMemoria.mtItemCatalogo);
        // La categoria no esta en la tabla: vive en el desplegable.
        lManoObraNueva.CategoriaId := CategoriaEscogida;
        Result := lManoObraNueva;
      end
      else
      begin
        lManoObraEdicion := TMapeoDatos.ADto<TManoObraEdicionDTO>
          (dmMemoria.mtItemCatalogo);
        lManoObraEdicion.CategoriaId := CategoriaEscogida;
        Result := lManoObraEdicion;
      end;
    ctMaquinas:
      if FId = 0 then
        Result := TMapeoDatos.ADto<TMaquinaNuevaDTO>(dmMemoria.mtItemCatalogo)
      else
        Result := TMapeoDatos.ADto<TMaquinaEdicionDTO>
          (dmMemoria.mtItemCatalogo);
    ctTiposTrabajo:
      // Crear y editar usan el mismo DTO: la tabla solo tiene nombre.
      Result := TMapeoDatos.ADto<TTipoTrabajoNuevoDTO>
        (dmMemoria.mtItemCatalogo);
  else
    if FId = 0 then
      Result := TMapeoDatos.ADto<TMaterialNuevoDTO>(dmMemoria.mtItemCatalogo)
    else
      Result := TMapeoDatos.ADto<TMaterialEdicionDTO>
        (dmMemoria.mtItemCatalogo);
  end;
end;

// Guardado

procedure TfrmItemCatalogo.btnGuardarClick(Sender: TObject);
begin
  // Post primero: lo que esta en el control todavia no esta en el campo.
  if dmMemoria.mtItemCatalogo.State in dsEditModes then
    dmMemoria.mtItemCatalogo.Post;
  if pnlPrecio.Visible and (dmMemoria.mtPrecioCatalogo.State in dsEditModes)
  then
    dmMemoria.mtPrecioCatalogo.Post;

  if not ValidarCampos then
    Exit;

  if FPresentador = nil then
    FPresentador := TPresentadorItemCatalogo.Create(Self,
      TApiCatalogos.Create, FCatalogo, FId);

  FPresentador.Guardar(DtoEscrito);
end;

procedure TfrmItemCatalogo.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

// IVistaRegistro

procedure TfrmItemCatalogo.MostrarGuardando(const AActivo: Boolean);
begin
  btnGuardar.Enabled := not AActivo;
  btnCancelar.Enabled := not AActivo;
  cpCatalogo.Enabled := not AActivo;
  pnlPrecio.Enabled := not AActivo;
  if AActivo then
    Screen.Cursor := crAppStart
  else
    Screen.Cursor := crDefault;
end;

procedure TfrmItemCatalogo.MostrarError(const AMensaje: string);
begin
  MessageDlg(AMensaje, mtError, [mbOK], 0);
end;

procedure TfrmItemCatalogo.Guardado(const AId: Integer);
begin
  // El item ya entro. Si el precio cambio, va en una segunda llamada: en la
  // API son dos operaciones porque el precio deja historial. Al volver de esa,
  // esta misma rutina cierra la ventana.
  if (AId > 0) and PrecioCambio and not FPrecioEnviado then
  begin
    FPrecioEnviado := True;
    FPresentadorPrecio := TPresentadorPrecioCatalogo.Create(Self,
      TApiCatalogos.Create, FCatalogo, AId);
    FPresentadorPrecio.Guardar(TMapeoDatos.ADto<TPrecioNuevoDTO>
      (dmMemoria.mtPrecioCatalogo));
    Exit;
  end;

  FGuardado := True;
  ModalResult := mrOk;
end;

end.
