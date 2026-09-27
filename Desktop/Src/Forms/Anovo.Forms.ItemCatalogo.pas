unit Anovo.Forms.ItemCatalogo;

// Ventana del item de catalogo, para los cuatro catalogos.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.TitleBarCtrls, Vcl.WinXPanels, Vcl.Mask, Vcl.DBCtrls,
  Data.DB,
  rDBComponents,
  VclPlano.BotonWin,
  Anovo.Forms.Edicion,
  Anovo.DTOs.Catalogos,
  Anovo.Vistas.Intf.Catalogos,
  Anovo.Vistas.Intf.Registro,
  Anovo.Presentadores.CatalogoItem,
  Anovo.UI.Vigencia;

type
  TfrmItemCatalogo = class(TfrmEdicion, IVistaRegistro)
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
    edVigencia: TrDBEditDate;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
  private
    FPresentador: TPresentadorItemCatalogo;
    FPresentadorPrecio: TPresentadorPrecioCatalogo;
    FCatalogo: TCatalogo;
    FId: Integer;
    FGuardado: Boolean;
    FPrecioEnviado: Boolean;
    FCostoOriginal: Currency;
    FPrecioOriginal: Currency;
    FCostoHoraOriginal: Currency;
    FVigenciaOriginal: TDateTime;
    FVigencia: TVigenciaPrecio;
    FProgramadoExistente: TDateTime;
    procedure PrepararCampos;
    procedure PrepararTabla;
    procedure PrepararPrecio;
    function ValidarCampos: Boolean;
    function DtoEscrito: TObject;
    function CategoriaEscogida: Integer;
    function LlevaPrecio: Boolean;
    function PrecioCambio: Boolean;
    procedure Guardado(const AId: Integer);
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
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
  PREFIJO: array [TCatalogo] of string = ('', 'MAT-', 'MO-', 'MAQ-', '');

function ItemDe(const ACatalogo: TCatalogo): string;
begin
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
  dmMemoria.mtItemCatalogo.Close;
  dmMemoria.mtPrecioCatalogo.Close;
end;

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

  pnlPrecio.Visible := LlevaPrecio;
  edCosto.Visible := FCatalogo in [ctMateriales, ctManoObra];
  edPrecio.Visible := FCatalogo = ctMateriales;
  edCostoHora.Visible := FCatalogo = ctMaquinas;

  if FId = 0 then
    lblPrecio.Caption := SPrecioInicial
  else
    lblPrecio.Caption := SPrecioVigente;
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

  lOrigen := dmMemoria.FilaCatalogo;
  if lOrigen = nil then
    Exit;

  dmMemoria.mtItemCatalogo.CopyRecord(lOrigen);
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

  lOrigen := dmMemoria.FilaCatalogo;
  if lOrigen = nil then
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

  FProgramadoExistente := ProgramadoDeLaFila(lOrigen);

  FVigenciaOriginal := lOrigen.FieldByName('FECHA_VIGENCIA').AsDateTime;
  if FVigenciaOriginal > 0 then
    lblPrecio.Caption := Format(SPrecioVigenteDesde,
      [FormatDateTime('dd/mm/yyyy', FVigenciaOriginal)]);
end;

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
  case FCatalogo of
    ctManoObra:
      if FId = 0 then
      begin
        lManoObraNueva := TMapeoDatos.ADto<TManoObraNuevaDTO>
          (dmMemoria.mtItemCatalogo);
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

procedure TfrmItemCatalogo.btnGuardarClick(Sender: TObject);
begin
  dmMemoria.Confirmar(dmMemoria.mtItemCatalogo);
  dmMemoria.Confirmar(dmMemoria.mtPrecioCatalogo);

  if not ValidarCampos then
    Exit;

  if FPresentador = nil then
    FPresentador := TPresentadorItemCatalogo.Create(Self,
      TApiCatalogos.Create, FCatalogo, FId);

  FPresentador.Guardar(DtoEscrito);
end;

function TfrmItemCatalogo.ControlesEdicion: TArray<TControl>;
begin
  Result := [cpCatalogo, pnlPrecio];
end;

procedure TfrmItemCatalogo.Guardado(const AId: Integer);
begin
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
