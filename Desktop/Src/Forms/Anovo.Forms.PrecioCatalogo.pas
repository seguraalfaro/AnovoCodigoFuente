unit Anovo.Forms.PrecioCatalogo;

// Ventana del precio de un item: cambiar precio o ver
// el historial.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.TitleBarCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids,
  rDBGrid, rDBComponents,
  VclPlano.BotonWin,
  Anovo.UI.Tema,
  Anovo.UI.DBGridExtend,
  Anovo.DTOs.Catalogos,
  Anovo.Vistas.Intf.Catalogos,
  Anovo.Vistas.Intf.Registro,
  Anovo.Presentadores.CatalogoItem, Vcl.Mask, Vcl.DBCtrls,
  Anovo.UI.Vigencia;

type
  TModoPrecio = (mpCambiar, mpHistorial);

  TfrmPrecioCatalogo = class(TForm, IVistaRegistro)
    TitleBarPanel1: TTitleBarPanel;
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pnlCampos: TPanel;
    edCosto: TrDBEdit;
    edPrecio: TrDBEdit;
    edCostoHora: TrDBEdit;
    pnlHistorial: TPanel;
    lblHistorial: TLabel;
    grHistorial: TrDBGrid;
    pnlPie: TPanel;
    btnGuardar: TPlanoBotonWin;
    btnCancelar: TPlanoBotonWin;
    edVigencia: TrDBEditDate;
    chkProgramado: TCheckBox;
    lblNotaVigencia: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FPresentador: TPresentadorPrecioCatalogo;
    FCatalogo: TCatalogo;
    FModo: TModoPrecio;
    FId: Integer;
    FGuardado: Boolean;
    FVigencia: TVigenciaPrecio;
    procedure PrepararCampos;
    function ValidarCampos: Boolean;
    function DtoEscrito: TPrecioNuevoDTO;
    procedure MostrarGuardando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure Guardado(const AId: Integer);
  public
    class function Mostrar(AOwner: TComponent; const ACatalogo: TCatalogo;
      const AId: Integer; const ANombre: string;
      const AModo: TModoPrecio): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Api.Catalogos,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Textos;

class function TfrmPrecioCatalogo.Mostrar(AOwner: TComponent;
  const ACatalogo: TCatalogo; const AId: Integer; const ANombre: string;
  const AModo: TModoPrecio): Boolean;
var
  lForma: TfrmPrecioCatalogo;
begin
  lForma := TfrmPrecioCatalogo.Create(AOwner);
  try
    lForma.FCatalogo := ACatalogo;
    lForma.FId := AId;
    lForma.FModo := AModo;
    lForma.lblSubtitulo.Caption := ANombre;
    lForma.PrepararCampos;
    lForma.ShowModal;
    Result := lForma.FGuardado;
  finally
    lForma.Free;
  end;
end;

procedure TfrmPrecioCatalogo.FormCreate(Sender: TObject);
begin
  AplicarTema(Self);
  AplicarTemaBarraTitulo(Self, TitleBarPanel1);
  AplicarTemaGrid(grHistorial);
  FPresentador := nil;
  FVigencia := nil;
  FGuardado := False;
end;

procedure TfrmPrecioCatalogo.FormDestroy(Sender: TObject);
begin
  FVigencia.Free;
  FPresentador.Free;
  dmMemoria.mtPrecioCatalogo.Close;
end;

procedure TfrmPrecioCatalogo.PrepararCampos;
begin
  edCosto.Visible := FCatalogo in [ctMateriales, ctManoObra];
  edPrecio.Visible := FCatalogo = ctMateriales;
  edCostoHora.Visible := FCatalogo = ctMaquinas;

  if FModo = mpHistorial then
  begin
   self.Height:=533;
    lblTitulo.Caption := STituloHistorialPrecios;
    pnlCampos.Visible := False;
    btnGuardar.Visible := False;
    btnCancelar.Caption := SCerrar;
    Exit;
  end;

  lblTitulo.Caption := STituloCambiarPrecio;
  pnlHistorial.Visible := False;
  self.Height:=244;
  dmMemoria.PrepararPrecioCatalogo;

  FVigencia := TVigenciaPrecio.Create(chkProgramado, edVigencia,
    lblNotaVigencia, ProgramadoDeLaFila(dmMemoria.dsCatalogo.DataSet));
  FVigencia.MostrarNota;
end;

function TfrmPrecioCatalogo.ValidarCampos: Boolean;
var
  lError: string;
begin
  Result := False;

  if edPrecio.Visible and (dmMemoria.mtPrecioCatalogoPRECIO_UNITARIO
    .AsCurrency <= 0) then
  begin
    MostrarError(SPrecioUnitarioMayorCero);
    edPrecio.SetFocus;
    Exit;
  end;

  if edCosto.Visible and (dmMemoria.mtPrecioCatalogoCOSTO_UNITARIO
    .AsCurrency <= 0) then
  begin
    MostrarError(SCostoUnitarioMayorCero);
    edCosto.SetFocus;
    Exit;
  end;

  if edCostoHora.Visible and (dmMemoria.mtPrecioCatalogoCOSTO_HORA
    .AsCurrency <= 0) then
  begin
    MostrarError(SCostoHoraMayorCero);
    edCostoHora.SetFocus;
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

function TfrmPrecioCatalogo.DtoEscrito: TPrecioNuevoDTO;
begin
  Result := TMapeoDatos.ADto<TPrecioNuevoDTO>(dmMemoria.mtPrecioCatalogo);
end;

procedure TfrmPrecioCatalogo.btnGuardarClick(Sender: TObject);
begin
  if dmMemoria.mtPrecioCatalogo.State in dsEditModes then
    dmMemoria.mtPrecioCatalogo.Post;

  if not ValidarCampos then
    Exit;

  if FPresentador = nil then
    FPresentador := TPresentadorPrecioCatalogo.Create(Self,
      TApiCatalogos.Create, FCatalogo, FId);

  FPresentador.Guardar(DtoEscrito);
end;

procedure TfrmPrecioCatalogo.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmPrecioCatalogo.MostrarGuardando(const AActivo: Boolean);
begin
  btnGuardar.Enabled := not AActivo;
  btnCancelar.Enabled := not AActivo;
  pnlCampos.Enabled := not AActivo;
  if AActivo then
    Screen.Cursor := crAppStart
  else
    Screen.Cursor := crDefault;
end;

procedure TfrmPrecioCatalogo.MostrarError(const AMensaje: string);
begin
  MessageDlg(AMensaje, mtError, [mbOK], 0);
end;

procedure TfrmPrecioCatalogo.Guardado(const AId: Integer);
begin
  FGuardado := True;
  ModalResult := mrOk;
end;

end.
