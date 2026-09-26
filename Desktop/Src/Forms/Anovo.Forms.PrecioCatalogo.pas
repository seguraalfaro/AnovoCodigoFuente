unit Anovo.Forms.PrecioCatalogo;

// Ventana del precio de un item de catalogo. Dos modos, porque son las dos
// acciones que tiene la fila:
//
//   mpCambiar     registra el precio nuevo. El anterior queda en el historial.
//   mpHistorial   solo muestra lo que ya paso, sin campos ni boton de guardar.
//
// Que campo se pide depende del catalogo: materiales llevan costo y precio de
// venta, mano de obra solo costo, y maquinas costo por hora.

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
  Anovo.Presentadores.CatalogoItem, Vcl.Mask, Vcl.DBCtrls;

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
    edVigencia: TrDBEdit;
    pnlHistorial: TPanel;
    lblHistorial: TLabel;
    grHistorial: TrDBGrid;
    pnlPie: TPanel;
    btnGuardar: TPlanoBotonWin;
    btnCancelar: TPlanoBotonWin;
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
    procedure PrepararCampos;
    function ValidarCampos: Boolean;
    function DtoEscrito: TPrecioNuevoDTO;
    // IVistaRegistro
    procedure MostrarGuardando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure Guardado(const AId: Integer);
  public
    // En modo historial, quien abre ya dejo las filas en
    // dmMemoria.mtHistorialPrecio. Devuelve True solo si se guardo un precio.
    class function Mostrar(AOwner: TComponent; const ACatalogo: TCatalogo;
      const AId: Integer; const ANombre: string;
      const AModo: TModoPrecio): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Api.Catalogos,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria;

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
  FGuardado := False;
end;

procedure TfrmPrecioCatalogo.FormDestroy(Sender: TObject);
begin
  FPresentador.Free;
  dmMemoria.mtPrecioCatalogo.Close;
end;

procedure TfrmPrecioCatalogo.PrepararCampos;
begin
  // El costo por hora es de maquinas; el costo unitario y el precio de venta,
  // de los otros dos. Mano de obra no tiene precio de venta.
  edCosto.Visible := FCatalogo in [ctMateriales, ctManoObra];
  edPrecio.Visible := FCatalogo = ctMateriales;
  edCostoHora.Visible := FCatalogo = ctMaquinas;

  if FModo = mpHistorial then
  begin
    lblTitulo.Caption := 'Historial de precios';
    pnlCampos.Visible := False;
    btnGuardar.Visible := False;
    btnCancelar.Caption := 'Cerrar';
    Exit;
  end;

  lblTitulo.Caption := 'Cambiar precio';
  // El historial se consulta con su propia accion: aqui solo se registra.
  pnlHistorial.Visible := False;
  dmMemoria.PrepararPrecioCatalogo;
end;

function TfrmPrecioCatalogo.ValidarCampos: Boolean;
begin
  Result := False;

  if edPrecio.Visible and (dmMemoria.mtPrecioCatalogoPRECIO_UNITARIO
    .AsCurrency <= 0) then
  begin
    MostrarError('El precio unitario debe ser mayor que cero.');
    edPrecio.SetFocus;
    Exit;
  end;

  if edCosto.Visible and (dmMemoria.mtPrecioCatalogoCOSTO_UNITARIO
    .AsCurrency <= 0) then
  begin
    MostrarError('El costo unitario debe ser mayor que cero.');
    edCosto.SetFocus;
    Exit;
  end;

  if edCostoHora.Visible and (dmMemoria.mtPrecioCatalogoCOSTO_HORA
    .AsCurrency <= 0) then
  begin
    MostrarError('El costo por hora debe ser mayor que cero.');
    edCostoHora.SetFocus;
    Exit;
  end;

  Result := True;
end;

function TfrmPrecioCatalogo.DtoEscrito: TPrecioNuevoDTO;
begin
  // Los campos que la pestana no muestra quedan en cero y no viajan: el
  // servidor solo mira el que le corresponde a su catalogo.
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

// IVistaRegistro

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
