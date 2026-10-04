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
    cbCategoriaMo: TrDBLookupComboBox;
    cbUnidadMo: TrDBLookupComboBox;
    meDescripcionMo: TrDBMemo;
    CarMaquina: TCard;
    edCodigoMaq: TrDBEdit;
    edNombreMaq: TrDBEdit;
    meDescripcionMaq: TrDBMemo;
    CarTipoTrabajo: TCard;
    edNombreTipo: TrDBEdit;
    CarUnidadMedida: TCard;
    edNombreUni: TrDBEdit;
    edAbreviaturaUni: TrDBEdit;
    cbMagnitudUni: TrDBLookupComboBox;
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
    FCatalogo: TCatalogo;
    FId: Integer;
    FGuardado: Boolean;
    FVigencia: TVigenciaPrecio;
    FProgramadoExistente: TDateTime;
    procedure PrepararCampos;
    procedure PrepararTabla;
    procedure PrepararPrecio;
    function ValidarCampos: Boolean;
    function DtoEscrito: TObject;
    function PrecioEscrito: TPrecioNuevoDTO;
    procedure Guardado(const AId: Integer);
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    class function Mostrar(AOwner: TComponent; const ACatalogo: TCatalogo;
      const AId: Integer): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Api.Catalogos,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Textos;

const
  PREFIJO: array [TCatalogo] of string = ('', 'MAT-', 'MO-', 'MAQ-', '', '');

function ItemDe(const ACatalogo: TCatalogo): string;
begin
  case ACatalogo of
    ctManoObra:
      Result := SItemManoObra;
    ctMaquinas:
      Result := SItemMaquina;
    ctTiposTrabajo:
      Result := SItemTipoTrabajo;
    ctUnidadesMedida:
      Result := SItemUnidadMedida;
  else
    Result := SItemMaterial;
  end;
end;

class function TfrmItemCatalogo.Mostrar(AOwner: TComponent;
  const ACatalogo: TCatalogo; const AId: Integer): Boolean;
var
  lForma: TfrmItemCatalogo;
begin
  lForma := TfrmItemCatalogo.Create(AOwner);
  try
    lForma.FCatalogo := ACatalogo;
    lForma.FId := AId;
    lForma.FPresentador.Iniciar(ACatalogo, AId);
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
  FGuardado := False;
  FProgramadoExistente := 0;
  FPresentador := TPresentadorItemCatalogo.Create(Self, TApiCatalogos.Create);
  dmMemoria.SinTodasLasCategorias(True);
end;

procedure TfrmItemCatalogo.FormDestroy(Sender: TObject);
begin
  FVigencia.Free;
  FPresentador.Free;
  dmMemoria.SinTodasLasCategorias(False);
  dmMemoria.mtItemCatalogo.Close;
  dmMemoria.mtPrecioCatalogo.Close;
end;

procedure TfrmItemCatalogo.PrepararCampos;
begin
  if (FId = 0) and (FCatalogo = ctUnidadesMedida) then
    lblTitulo.Caption := STituloNuevaUnidadMedida
  else if FId = 0 then
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
    ctUnidadesMedida:
      cpCatalogo.ActiveCard := CarUnidadMedida;
  else
    cpCatalogo.ActiveCard := CarMaterial;
  end;

  pnlPrecio.Visible := FPresentador.LlevaPrecio;
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
    Exit;
  end;

  lOrigen := dmMemoria.FilaCatalogo;
  if lOrigen <> nil then
    dmMemoria.mtItemCatalogo.CopyRecord(lOrigen);
end;

procedure TfrmItemCatalogo.PrepararPrecio;
var
  lOrigen: TDataSet;
  lVigencia: TDateTime;
begin
  if not FPresentador.LlevaPrecio then
    Exit;

  dmMemoria.PrepararPrecioCatalogo;
  if FId = 0 then
    Exit;

  lOrigen := dmMemoria.FilaCatalogo;
  if lOrigen = nil then
    Exit;

  dmMemoria.mtPrecioCatalogo.CopyRecord(lOrigen);
  FProgramadoExistente := ProgramadoDeLaFila(lOrigen);

  lVigencia := dmMemoria.mtPrecioCatalogoFECHA_VIGENCIA.AsDateTime;
  if lVigencia > 0 then
    lblPrecio.Caption := Format(SPrecioVigenteDesde,
      [FormatDateTime('dd/mm/yyyy', lVigencia)]);

  FPresentador.RecordarPrecio(TMapeoDatos.ADto<TPrecioNuevoDTO>
    (dmMemoria.mtPrecioCatalogo));
  dmMemoria.mtPrecioCatalogoFECHA_VIGENCIA.AsDateTime := Date;
end;

function TfrmItemCatalogo.ValidarCampos: Boolean;
var
  lError: string;
begin
  Result := False;

  if not (FCatalogo in [ctTiposTrabajo, ctUnidadesMedida]) and
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
    (dmMemoria.mtItemCatalogoUNIDAD_MEDIDA_ID.AsInteger = 0) then
  begin
    MostrarError(SEscojaUnidadMedida);
    Exit;
  end;

  if (FCatalogo = ctUnidadesMedida) and
    dmMemoria.mtItemCatalogoMAGNITUD.AsString.IsEmpty then
  begin
    MostrarError(SEscojaMagnitud);
    Exit;
  end;

  if (FCatalogo = ctManoObra) and
    (dmMemoria.mtItemCatalogoCATEGORIA_ID.AsInteger = 0) then
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

  Result := True;
end;

function TfrmItemCatalogo.DtoEscrito: TObject;
begin
  case FCatalogo of
    ctManoObra:
      if FId = 0 then
        Result := TMapeoDatos.ADto<TManoObraNuevaDTO>(dmMemoria.mtItemCatalogo)
      else
        Result := TMapeoDatos.ADto<TManoObraEdicionDTO>
          (dmMemoria.mtItemCatalogo);
    ctMaquinas:
      if FId = 0 then
        Result := TMapeoDatos.ADto<TMaquinaNuevaDTO>(dmMemoria.mtItemCatalogo)
      else
        Result := TMapeoDatos.ADto<TMaquinaEdicionDTO>
          (dmMemoria.mtItemCatalogo);
    ctTiposTrabajo:
      Result := TMapeoDatos.ADto<TTipoTrabajoNuevoDTO>
        (dmMemoria.mtItemCatalogo);
    ctUnidadesMedida:
      Result := TMapeoDatos.ADto<TUnidadMedidaNuevaDTO>
        (dmMemoria.mtItemCatalogo);
  else
    if FId = 0 then
      Result := TMapeoDatos.ADto<TMaterialNuevoDTO>(dmMemoria.mtItemCatalogo)
    else
      Result := TMapeoDatos.ADto<TMaterialEdicionDTO>
        (dmMemoria.mtItemCatalogo);
  end;
end;

function TfrmItemCatalogo.PrecioEscrito: TPrecioNuevoDTO;
begin
  if not FPresentador.LlevaPrecio then
    Exit(nil);
  Result := TMapeoDatos.ADto<TPrecioNuevoDTO>(dmMemoria.mtPrecioCatalogo);
end;

procedure TfrmItemCatalogo.btnGuardarClick(Sender: TObject);
begin
  dmMemoria.Confirmar(dmMemoria.mtItemCatalogo);
  dmMemoria.Confirmar(dmMemoria.mtPrecioCatalogo);

  if not ValidarCampos then
    Exit;

  FPresentador.Guardar(DtoEscrito, PrecioEscrito, FVigencia.Programado);
end;

function TfrmItemCatalogo.ControlesEdicion: TArray<TControl>;
begin
  Result := [cpCatalogo, pnlPrecio];
end;

procedure TfrmItemCatalogo.Guardado(const AId: Integer);
begin
  FGuardado := True;
  ModalResult := mrOk;
end;

end.
