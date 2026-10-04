unit Anovo.Forms.LineaCotizacion;

// Ventana de una linea de la cotizacion: agregar desde un catalogo,
// agregar una nota o cambiar la cantidad de una linea existente.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.TitleBarCtrls, Vcl.WinXCtrls, Vcl.Mask, Vcl.DBCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid, rDBComponents,
  VclPlano.BotonWin,
  Anovo.Forms.Edicion,
  Anovo.DTOs.Catalogos,
  Anovo.DTOs.Cotizaciones,
  Anovo.Vistas.Intf.Cotizacion,
  Anovo.Vistas.Intf.Registro,
  Anovo.Presentadores.Cotizacion;

type
  TfrmLineaCotizacion = class(TfrmEdicion, IVistaLineaCotizacion)
    pnlBusqueda: TPanel;
    sbBuscar: TSearchBox;
    cbCategoria: TrDBLookupComboBox;
    grItems: TrDBGrid;
    pnlCantidad: TPanel;
    lblPrecioRot: TLabel;
    lblPrecio: TLabel;
    lblSubtotalRot: TLabel;
    lblSubtotal: TLabel;
    lblNota: TLabel;
    edCantidad: TrDBEdit;
    pnlNota: TPanel;
    mmNota: TrDBMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure sbBuscarInvokeSearch(Sender: TObject);
    procedure cbCategoriaClick(Sender: TObject);
    procedure grItemsCellClick(Column: TColumn);
    procedure grItemsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edCantidadChange(Sender: TObject);
  private
    FPresentador: TPresentadorLineaCotizacion;
    FModo: TModoLinea;
    FPrecio: Currency;
    FGuardado: Boolean;
    procedure Preparar(const AModo: TModoLinea; const ALinea: TLineaDTO);
    procedure Buscar;
    procedure ActualizarPrecio;
    function Cantidad: Currency;
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarItems(const AItems: TObjectList<TItemLinea>);
    procedure MostrarCategorias(const ACategorias: TObjectList<TCategoriaDTO>);
    procedure Guardado(const AId: Integer);
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    class function Mostrar(AOwner: TComponent; const ACotizacionId: Integer;
      const AModo: TModoLinea; const ALinea: TLineaDTO): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.Tema,
  Anovo.UI.DBGridExtend,
  Anovo.Api.Cotizaciones,
  Anovo.Api.Catalogos,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Formato,
  Anovo.Textos;

const
  ALTO_CATALOGO = 600;
  ALTO_CANTIDAD = 300;
  ALTO_NOTA = 340;

class function TfrmLineaCotizacion.Mostrar(AOwner: TComponent;
  const ACotizacionId: Integer; const AModo: TModoLinea;
  const ALinea: TLineaDTO): Boolean;
var
  lForma: TfrmLineaCotizacion;
begin
  lForma := TfrmLineaCotizacion.Create(AOwner);
  try
    lForma.Preparar(AModo, ALinea);
    lForma.FPresentador.Iniciar(ACotizacionId, AModo, ALinea);
    lForma.ShowModal;
    Result := lForma.FGuardado;
  finally
    lForma.Free;
  end;
end;

procedure TfrmLineaCotizacion.FormCreate(Sender: TObject);
begin
  AplicarTemaGrid(grItems);
  FGuardado := False;
  FPresentador := TPresentadorLineaCotizacion.Create(Self,
    TApiCotizaciones.Create, TApiCatalogos.Create);
  dmMemoria.Preparar(dmMemoria.mtLineaNueva);
end;

procedure TfrmLineaCotizacion.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPresentador);
  dmMemoria.mtLineaNueva.Close;
  dmMemoria.mtItemsLinea.Close;
end;

function TfrmLineaCotizacion.ControlesEdicion: TArray<TControl>;
begin
  Result := [pnlBusqueda, grItems, pnlCantidad, pnlNota];
end;

procedure TfrmLineaCotizacion.Preparar(const AModo: TModoLinea;
  const ALinea: TLineaDTO);
var
  lEsNota: Boolean;
begin
  FModo := AModo;
  lEsNota := (AModo = mlNota) or ((AModo = mlEditar) and (ALinea <> nil) and
    (ALinea.Tipo = TIPO_NOTA));

  case AModo of
    mlMaterial:
      lblTitulo.Caption := SAgregarMaterial;
    mlManoObra:
      lblTitulo.Caption := SAgregarManoObra;
    mlMaquina:
      lblTitulo.Caption := SAgregarMaquina;
    mlNota:
      lblTitulo.Caption := SAgregarNota;
  else
    if lEsNota then
      lblTitulo.Caption := SEditarNota
    else
      lblTitulo.Caption := SEditarLinea;
  end;

  if AModo = mlEditar then
    btnGuardar.Caption := SBotonGuardarCambio
  else if lEsNota then
    btnGuardar.Caption := SAgregarNota
  else
    btnGuardar.Caption := SBotonAgregarLinea;

  cbCategoria.Visible := AModo = mlManoObra;
  pnlBusqueda.Visible := AModo in [mlMaterial, mlManoObra, mlMaquina];
  grItems.Visible := pnlBusqueda.Visible;

  if lEsNota then
  begin
    pnlCantidad.Visible := False;
    pnlNota.Visible := True;
    pnlNota.Align := alClient;
    ClientHeight := ALTO_NOTA;
    if ALinea <> nil then
    begin
      lblSubtitulo.Caption := ALinea.Descripcion;
      dmMemoria.mtLineaNuevaNOTA.AsString := ALinea.Descripcion;
    end;
  end
  else if AModo = mlEditar then
  begin
    pnlCantidad.Align := alClient;
    ClientHeight := ALTO_CANTIDAD;
    lblSubtitulo.Caption := ALinea.Descripcion;
    FPrecio := ALinea.PrecioUnitario.ValueOrDefault;
    dmMemoria.mtLineaNuevaCANTIDAD.AsCurrency := ALinea.Cantidad.ValueOrDefault;
    edCantidad.DBEditLabel.OwnCaption := Format('%s (%s)',
      [edCantidad.DBEditLabel.OwnCaption, ALinea.UnidadMedida.ValueOrDefault]);
    lblNota.Caption := SPrecioConservado;
  end
  else
  begin
    ClientHeight := ALTO_CATALOGO;
    lblNota.Caption := SPrecioSeCopia;
  end;
  ActualizarPrecio;
end;

function TfrmLineaCotizacion.Cantidad: Currency;
begin
  Result := StrToCurrDef(edCantidad.Text, 0);
end;

procedure TfrmLineaCotizacion.ActualizarPrecio;
begin
  if (FModo <> mlEditar) and not dmMemoria.mtItemsLinea.IsEmpty then
    FPrecio := dmMemoria.mtItemsLineaPRECIO.AsCurrency;
  lblPrecio.Caption := TFormato.Colones(FPrecio);
  lblSubtotal.Caption := TFormato.Colones(FPrecio * Cantidad);
end;

procedure TfrmLineaCotizacion.Buscar;
var
  lCategoria: Integer;
begin
  lCategoria := 0;
  if cbCategoria.Visible and not VarIsNull(cbCategoria.KeyValue) then
    lCategoria := cbCategoria.KeyValue;
  FPresentador.Buscar(sbBuscar.Text, lCategoria);
end;

procedure TfrmLineaCotizacion.sbBuscarInvokeSearch(Sender: TObject);
begin
  Buscar;
end;

procedure TfrmLineaCotizacion.cbCategoriaClick(Sender: TObject);
begin
  Buscar;
end;

procedure TfrmLineaCotizacion.grItemsCellClick(Column: TColumn);
begin
  ActualizarPrecio;
end;

procedure TfrmLineaCotizacion.grItemsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ActualizarPrecio;
end;

procedure TfrmLineaCotizacion.edCantidadChange(Sender: TObject);
begin
  ActualizarPrecio;
end;

procedure TfrmLineaCotizacion.MostrarCargando(const AActivo: Boolean);
begin
  MostrarOcupado(AActivo);
end;

procedure TfrmLineaCotizacion.MostrarItems(const AItems
  : TObjectList<TItemLinea>);
begin
  TMapeoDatos.AListaTabla<TItemLinea>(AItems, dmMemoria.mtItemsLinea);
  TDBGridExtend.De(grItems).AjustarColumnas;
  ActualizarPrecio;
end;

procedure TfrmLineaCotizacion.MostrarCategorias(const ACategorias
  : TObjectList<TCategoriaDTO>);
begin
  TMapeoDatos.AListaTabla<TCategoriaDTO>(ACategorias, dmMemoria.mtCategorias);
end;

procedure TfrmLineaCotizacion.btnGuardarClick(Sender: TObject);
begin
  dmMemoria.Confirmar(dmMemoria.mtLineaNueva);
  if pnlNota.Visible then
  begin
    if FModo = mlEditar then
      FPresentador.Cambiar(0, dmMemoria.mtLineaNuevaNOTA.AsString)
    else
      FPresentador.AgregarNota(dmMemoria.mtLineaNuevaNOTA.AsString);
  end
  else if FModo = mlEditar then
    FPresentador.Cambiar(dmMemoria.mtLineaNuevaCANTIDAD.AsCurrency, '')
  else if dmMemoria.mtItemsLinea.IsEmpty then
    FPresentador.Agregar(0, '', '', dmMemoria.mtLineaNuevaCANTIDAD.AsCurrency)
  else
    FPresentador.Agregar(dmMemoria.mtItemsLineaID.AsInteger,
      dmMemoria.mtItemsLineaNOMBRE.AsString,
      dmMemoria.mtItemsLineaUNIDAD_MEDIDA.AsString,
      dmMemoria.mtLineaNuevaCANTIDAD.AsCurrency);
end;

procedure TfrmLineaCotizacion.Guardado(const AId: Integer);
begin
  FGuardado := True;
  ModalResult := mrOk;
end;

end.
