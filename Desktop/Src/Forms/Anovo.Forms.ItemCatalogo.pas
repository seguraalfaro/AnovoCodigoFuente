unit Anovo.Forms.ItemCatalogo;

// Ventana del item de catalogo: sirve a los cuatro. Modal, sin borde y con el
// tema de la aplicacion, como la de cliente nuevo.
//

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
  Anovo.Presentadores.CatalogoItem,
  Anovo.UI.Vigencia;

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
    chkProgramado: TCheckBox;
    lblNotaVigencia: TLabel;
    pnlPie: TPanel;
    btnGuardar: TPlanoBotonWin;
    btnCancelar: TPlanoBotonWin;
    edVigencia: TrDBEditDate;
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
    // El check de programado, la fecha y la nota. La comparte con la ventana
    // del boton Precio: ver Anovo.UI.Vigencia.
    FVigencia: TVigenciaPrecio;
    // Fecha del cambio que ya espera en cola, 0 si no hay ninguno.
    FProgramadoExistente: TDateTime;
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
  Anovo.Datos.Memoria,
  Anovo.Textos;

const
  // Las letras con las que Anovo clasifica cada catalogo. Al registrar, el
  // codigo viene con las suyas y la persona escribe el resto; asi no hay que
  // acordarse de la convencion ni se cuelan codigos con otra forma.
  //
  // Los tipos de trabajo no llevan codigo: esa entrada queda vacia.
  PREFIJO: array [TCatalogo] of string = ('', 'MAT-', 'MO-', 'MAQ-', '');

// El nombre del catalogo en singular, para las frases que hablan de un item.
// Funcion y no arreglo const: el texto es resourcestring y un resourcestring
// no sirve en una expresion constante.
function ItemDe(const ACatalogo: TCatalogo): string;
begin
  // ctTodos no llega aqui: el presentador lo cambia por el catalogo de la
  // fila antes de abrir la ventana. Cae en el else.
  case ACatalogo of
    ctManoObra:
      Result := SItemManoObra;
    ctMaquinas:
      Result := SItemMaquina;
    ctTiposTrabajo:
      Result := SItemTipoTrabajo;
  else
    Result := SItemMaterial;
  end;
end;

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
    lForma.FVigencia := TVigenciaPrecio.Create(lForma.chkProgramado,
      lForma.edVigencia, lForma.lblNotaVigencia, lForma.FProgramadoExistente);
    lForma.FVigencia.MostrarNota;
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
  FVigencia.Free;
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
    lblTitulo.Caption := Format(STituloNuevoItem, [ItemDe(FCatalogo)])
  else
    lblTitulo.Caption := Format(STituloEditarItem, [ItemDe(FCatalogo)]);

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
    lblPrecio.Caption := SPrecioInicial
  else
    lblPrecio.Caption := SPrecioVigente;
end;

procedure CopiarCampo(const AOrigen: TDataSet; const ACampo: string;
  const ADestino: TField);
var
  lCampo: TField;
begin
  lCampo := AOrigen.FindField(ACampo);
  if lCampo <> nil then
    ADestino.AsString := lCampo.AsString;
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

  // Por FindField y no FieldByName: la fila puede venir de cualquiera de los
  // cinco listados, y no todos tienen todas las columnas. Maquinas no tiene
  // unidad y tipos de trabajo no tiene codigo ni descripcion; con FieldByName
  // editar uno de esos reventaba al abrir.
  CopiarCampo(lOrigen, 'CODIGO', dmMemoria.mtItemCatalogoCODIGO);
  CopiarCampo(lOrigen, 'NOMBRE', dmMemoria.mtItemCatalogoNOMBRE);
  CopiarCampo(lOrigen, 'DESCRIPCION', dmMemoria.mtItemCatalogoDESCRIPCION);
  CopiarCampo(lOrigen, 'UNIDAD_MEDIDA', dmMemoria.mtItemCatalogoUNIDAD_MEDIDA);
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
  FProgramadoExistente := 0;

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

  // El campo de fecha queda vacio a proposito: es para cuando empieza a regir
  // el cambio, no para cuando empezo el precio que se esta viendo. Esa se
  // muestra en el rotulo, que es donde no se puede editar por error.
  FProgramadoExistente := ProgramadoDeLaFila(lOrigen);

  FVigenciaOriginal := lOrigen.FieldByName('FECHA_VIGENCIA').AsDateTime;
  if FVigenciaOriginal > 0 then
    lblPrecio.Caption := Format(SPrecioVigenteDesde,
      [FormatDateTime('dd/mm/yyyy', FVigenciaOriginal)]);
end;

//Apoyo

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
 
  Result := LlevaPrecio and
    ((dmMemoria.mtPrecioCatalogoCOSTO_UNITARIO.AsCurrency <> FCostoOriginal) or
    (dmMemoria.mtPrecioCatalogoPRECIO_UNITARIO.AsCurrency <> FPrecioOriginal) or
    (dmMemoria.mtPrecioCatalogoCOSTO_HORA.AsCurrency <> FCostoHoraOriginal) or
    FVigencia.Programado);
end;

function TfrmItemCatalogo.ValidarCampos: Boolean;
var
  lError: string;
begin
  Result := False;

  if (FCatalogo <> ctTiposTrabajo) and
    (dmMemoria.mtItemCatalogoCODIGO.AsString.Trim.IsEmpty or
    SameText(dmMemoria.mtItemCatalogoCODIGO.AsString.Trim,
    PREFIJO[FCatalogo])) then
  begin
    // Vacio o solo el prefijo: el prefijo lo puso la ventana, no la persona.
    MostrarError(Format(SCompleteCodigo, [PREFIJO[FCatalogo]]));
    Exit;
  end;

  if dmMemoria.mtItemCatalogoNOMBRE.AsString.Trim.IsEmpty then
  begin
    MostrarError(SNombreObligatorio);
    Exit;
  end;

  if (FCatalogo in [ctMateriales, ctManoObra]) and
    dmMemoria.mtItemCatalogoUNIDAD_MEDIDA.AsString.Trim.IsEmpty then
  begin
    MostrarError(SEscojaUnidadMedida);
    Exit;
  end;

  if (FCatalogo = ctManoObra) and (CategoriaEscogida = 0) then
  begin
    MostrarError(SEscojaCategoria);
    Exit;
  end;

  lError := FVigencia.Error;
  if not lError.IsEmpty then
  begin
    MostrarError(lError);
    edVigencia.SetFocus;
    Exit;
  end;

  // El precio de venta es el que va a la cotizacion: sin el, la linea quedaria
  // en cero y nadie lo notaria hasta ver el total.
  if PrecioCambio and (FCatalogo = ctMateriales) and
    (dmMemoria.mtPrecioCatalogoPRECIO_UNITARIO.AsCurrency <= 0) then
  begin
    MostrarError(SFaltaPrecioVenta);
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
