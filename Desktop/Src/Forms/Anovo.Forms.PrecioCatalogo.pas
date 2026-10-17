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
  Anovo.UI.CeldasRejilla,
  Anovo.Forms.Edicion,
  Anovo.DTOs.Catalogos,
  Anovo.Vistas.Intf.Catalogos,
  Anovo.Vistas.Intf.Registro,
  Anovo.Presentadores.CatalogoItem, Vcl.Mask, Vcl.DBCtrls,
  Anovo.UI.Vigencia;

type
  TModoPrecio = (mpCambiar, mpHistorial);

  TfrmPrecioCatalogo = class(TfrmEdicion, IVistaRegistro)
    pnlCampos: TPanel;
    edCosto: TrDBEdit;
    edPrecio: TrDBEdit;
    edCostoHora: TrDBEdit;
    pnlHistorial: TPanel;
    lblHistorial: TLabel;
    grHistorial: TrDBGrid;
    edVigencia: TrDBEditDate;
    chkProgramado: TCheckBox;
    lblNotaVigencia: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
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
    procedure Guardado(const AId: Integer);
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    class function Mostrar(AOwner: TComponent; const ACatalogo: TCatalogo;
      const AId: Integer; const ANombre: string;
      const AModo: TModoPrecio): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.Vista,
  Anovo.UI.ColumnasRejilla,
  Anovo.Api.Catalogos,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Textos;

const
  ALTO_HISTORIAL = 533;
  ALTO_CAMBIO = 244;

function Positivo(AControl: TWinControl; ACampo: TField;
  const AMensaje: string): Boolean;
begin
  Result := not AControl.Visible or (ACampo.AsCurrency > 0);
  if not Result then
  begin
    AvisarError(AMensaje);
    AControl.SetFocus;
  end;
end;

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
    lForma.FPresentador.Iniciar(ACatalogo, AId);
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
  AplicarTemaGrid(grHistorial);
  TColumnasRejilla.AplicarEn(grHistorial);
  FPresentador := TPresentadorPrecioCatalogo.Create(Self, TApiCatalogos.Create);
  FVigencia := nil;
  FGuardado := False;
end;

procedure TfrmPrecioCatalogo.FormDestroy(Sender: TObject);
begin
  FVigencia.Free;
  FreeAndNil(FPresentador);
  dmMemoria.mtPrecioCatalogo.Close;
end;

procedure TfrmPrecioCatalogo.PrepararCampos;
begin
  edCosto.Visible := FCatalogo in [ctMateriales, ctManoObra];
  edPrecio.Visible := FCatalogo = ctMateriales;
  edCostoHora.Visible := FCatalogo = ctMaquinas;

  if FModo = mpHistorial then
  begin
    Height := ScaleValue(ALTO_HISTORIAL);
    lblTitulo.Caption := STituloHistorialPrecios;
    pnlCampos.Visible := False;
    btnGuardar.Visible := False;
    btnCancelar.Caption := SCerrar;
    Exit;
  end;

  lblTitulo.Caption := STituloCambiarPrecio;
  pnlHistorial.Visible := False;
  Height := ScaleValue(ALTO_CAMBIO);
  dmMemoria.PrepararPrecioCatalogo;

  FVigencia := TVigenciaPrecio.Create(chkProgramado, edVigencia,
    lblNotaVigencia, ProgramadoDeLaFila(dmMemoria.FilaCatalogo));
  FVigencia.MostrarNota;
end;

function TfrmPrecioCatalogo.ValidarCampos: Boolean;
var
  lError: string;
begin
  Result := Positivo(edPrecio, dmMemoria.mtPrecioCatalogoPRECIO_UNITARIO,
    SPrecioUnitarioMayorCero) and Positivo(edCosto,
    dmMemoria.mtPrecioCatalogoCOSTO_UNITARIO, SCostoUnitarioMayorCero) and
    Positivo(edCostoHora, dmMemoria.mtPrecioCatalogoCOSTO_HORA,
    SCostoHoraMayorCero);
  if not Result then
    Exit;

  lError := FVigencia.Error;
  Result := lError.IsEmpty;
  if not Result then
  begin
    MostrarError(lError);
    edVigencia.SetFocus;
  end;
end;

function TfrmPrecioCatalogo.DtoEscrito: TPrecioNuevoDTO;
begin
  Result := TMapeoDatos.ADto<TPrecioNuevoDTO>(dmMemoria.mtPrecioCatalogo);
end;

procedure TfrmPrecioCatalogo.btnGuardarClick(Sender: TObject);
begin
  dmMemoria.Confirmar(dmMemoria.mtPrecioCatalogo);

  if not ValidarCampos then
    Exit;

  FPresentador.Guardar(DtoEscrito);
end;

function TfrmPrecioCatalogo.ControlesEdicion: TArray<TControl>;
begin
  Result := [pnlCampos];
end;

procedure TfrmPrecioCatalogo.Guardado(const AId: Integer);
begin
  FGuardado := True;
  ModalResult := mrOk;
end;

end.
