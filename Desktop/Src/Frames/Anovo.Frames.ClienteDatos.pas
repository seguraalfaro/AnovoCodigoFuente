unit Anovo.Frames.ClienteDatos;

// Ficha del cliente: datos, contactos, consentimiento y
// cotizaciones.

interface

uses
  Anovo.UI.Iconos,
  Anovo.UI.Tema,
  Anovo.UI.DBGridExtend,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  VclPlano.BotonWin, Vcl.ExtCtrls, Vcl.WinXCtrls, System.Actions, Vcl.ActnList,
  VclPlano.Pestanas, Vcl.WinXPanels, VclPlano.Tarjeta, Data.DB, Vcl.Grids,
  Vcl.DBGrids, rDBGrid, VclPlano.Pastilla, Vcl.Mask, Vcl.DBCtrls,
  rDBComponents,
  System.Generics.Collections,
  Anovo.DTOs.Clientes,
  Anovo.Vistas.Intf.ClienteDatos,
  Anovo.Presentadores.ClienteDatos, rHTMLLabel;

type
  TfraClienteDatos = class(TFrame, IVistaClienteDatos)
    rpTitulo: TRelativePanel;
    PlanoBotonWin1: TPlanoBotonWin;
    ActionList1: TActionList;
    AcRegregsar: TAction;
    pstCliente: TPlanoPestanas;
    pnbottom: TRelativePanel;
    CardPanel1: TCardPanel;
    RelativePanel1: TRelativePanel;
    tjIdentificacion: TPlanoTarjeta;
    pnlBarra: TPanel;
    sbBuscar: TSearchBox;
    btnNuevo: TPlanoBotonWin;
    pnclient: TRelativePanel;
    grContactos: TrDBGrid;
    rpClient: TRelativePanel;
    tjVigente: TPlanoTarjeta;
    lblVersion: TLabel;
    valVersion: TLabel;
    lblOtorgado: TLabel;
    valOtorgado: TLabel;
    lblRecogido: TLabel;
    valRecogido: TLabel;
    pstEstado: TPlanoPastilla;
    btnRevocar: TPlanoBotonWin;
    tjHistorial: TPlanoTarjeta;
    pnlHistorial: TPanel;
    grHistorial: TrDBGrid;
    RelativePanel2: TRelativePanel;
    Panel1: TPanel;
    SearchBox1: TSearchBox;
    btnExportar: TPlanoBotonWin;
    pstFiltros: TPlanoPestanas;
    rpdatos: TRelativePanel;
    grCotizaciones: TrDBGrid;
    rDBEdit1: TrDBEdit;
    rDBEdit2: TrDBEdit;
    rDBEdit3: TrDBEdit;
    tjUbicacion: TPlanoTarjeta;
    btnEditarCliente: TPlanoBotonWin;
    btnGuardarCliente: TPlanoBotonWin;
    btnCancelarEdicion: TPlanoBotonWin;
    rDBEdit6: TrDBEdit;
    rDBEdit4: TrDBEdit;
    rDBMemo1: TrDBMemo;
    rDBCheckBox1: TrDBCheckBox;
    rDBEdit5: TrDBEdit;
    rDBLabel1: TrDBLabel;
    Label1: TLabel;
    separador: TPanel;
    procedure AcRegregsarExecute(Sender: TObject);
    procedure btnEditarClienteClick(Sender: TObject);
    procedure btnGuardarClienteClick(Sender: TObject);
    procedure btnCancelarEdicionClick(Sender: TObject);
    procedure pstClienteChange(Sender: TObject);
    procedure btnNuevoClick(Sender: TObject);
  private
    FOnRegresar: TNotifyEvent;
    FPresentador: TPresentadorClienteDatos;
    FPuedeEditar: Boolean;
    FClienteId: Integer;
    function ClienteEditado: TClienteEdicionDTO;
    procedure BotonesDeEdicion(const AEdicion: Boolean);
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure MostrarCliente(const ACliente: TClienteDTO);
    procedure MostrarContactos(const AContactos: TObjectList<TContactoDTO>);
    procedure MostrarConsentimientos(const AConsentimientos
      : TObjectList<TConsentimientoDTO>);
    procedure MostrarAcciones(const APuedeEditar, APuedeRevocar,
      APuedeVerCotizaciones: Boolean; const AContacto: TAccionesContacto;
      const ACotizacion: TAccionesCotizacionCliente);
    procedure MostrarModoEdicion(const AActivo: Boolean);
    procedure AccionContacto(Sender: TObject; const AClave: string);
    procedure AccionCotizacion(Sender: TObject; const AClave: string);
    procedure PrepararRejilla(const AGrid: TrDBGrid;
      const AManejador: TEventoAccion);
  public

    constructor Crear(AOwner: TComponent; const AClienteId: Integer);
    destructor Destroy; override;
    property OnRegresar: TNotifyEvent read FOnRegresar write FOnRegresar;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.Vista,
  Anovo.Formato,
  Anovo.Api.Clientes,
  Anovo.Forms.ContactoNuevo,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Textos;

const
  SIN_DATO = '-';

  CAMPO_ACCIONES = 'ACCIONES';

  ACCIONES_CONTACTO: array [TAccionContacto] of TAccionRejilla =
    ((Clave: 'editar'; Rotulo: SAccionEditar), (Clave: 'quitar';
    Rotulo: SAccionQuitar));

  ACCIONES_COTIZACION: array [TAccionCotizacionCliente] of TAccionRejilla =
    ((Clave: 'ver'; Rotulo: SAccionVer));

constructor TfraClienteDatos.Crear(AOwner: TComponent;
  const AClienteId: Integer);
begin
  inherited Create(AOwner);
  AplicarTemaGrid(grContactos);
  AplicarTemaGrid(grCotizaciones);
  AplicarTemaGrid(grHistorial);
  PrepararRejilla(grContactos, AccionContacto);
  PrepararRejilla(grCotizaciones, AccionCotizacion);
  FClienteId := AClienteId;
  FPresentador := TPresentadorClienteDatos.Create(Self, TApiClientes.Create,
    AClienteId);
  FPresentador.Iniciar;
end;

destructor TfraClienteDatos.Destroy;
begin
  FPresentador.Free;
  CursorOcupado(False);
  inherited;
end;

procedure TfraClienteDatos.AcRegregsarExecute(Sender: TObject);
begin
  if Assigned(FOnRegresar) then
    FOnRegresar(Self);
end;

procedure TfraClienteDatos.pstClienteChange(Sender: TObject);
begin
  if FPresentador = nil then
    Exit;
  FPresentador.AbrirPestana(TPestanaCliente(pstCliente.ItemIndex));
end;

procedure TfraClienteDatos.btnNuevoClick(Sender: TObject);
var
  lVentana: TfrmContactoNuevo;
begin
  lVentana := TfrmContactoNuevo.Crear(Self, FClienteId);
  try
    if lVentana.ShowModal = mrOk then
      FPresentador.Refrescar(pcContactos);
  finally
    lVentana.Free;
  end;
end;

procedure TfraClienteDatos.MostrarCargando(const AActivo: Boolean);
begin
  CursorOcupado(AActivo);
end;

procedure TfraClienteDatos.MostrarError(const AMensaje: string);
begin
  AvisarError(AMensaje);
end;

procedure TfraClienteDatos.PrepararRejilla(const AGrid: TrDBGrid;
  const AManejador: TEventoAccion);
var
  lRejilla: TDBGridExtend;
begin
  lRejilla := TDBGridExtend.De(AGrid);
  lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
  lRejilla.OnAccion := AManejador;
end;

procedure TfraClienteDatos.BotonesDeEdicion(const AEdicion: Boolean);
begin

  btnEditarCliente.Visible := FPuedeEditar;
  btnGuardarCliente.Visible := FPuedeEditar;
  btnCancelarEdicion.Visible := FPuedeEditar;
  btnEditarCliente.Enabled := not AEdicion;
  btnGuardarCliente.Enabled := AEdicion;
  btnCancelarEdicion.Enabled := AEdicion;
  pstCliente.Enabled := not AEdicion;
end;

procedure TfraClienteDatos.MostrarModoEdicion(const AActivo: Boolean);
begin
  BotonesDeEdicion(AActivo);

end;

procedure TfraClienteDatos.btnEditarClienteClick(Sender: TObject);
begin

  if not dmMemoria.mtClienteDetalle.Active then
    Exit;
  dmMemoria.mtClienteDetalle.Edit;
  MostrarModoEdicion(True);
end;

procedure TfraClienteDatos.btnCancelarEdicionClick(Sender: TObject);
begin
  if dmMemoria.mtClienteDetalle.State in dsEditModes then
    dmMemoria.mtClienteDetalle.Cancel;
  MostrarModoEdicion(False);
  pstCliente.SetFocus ;
end;

function TfraClienteDatos.ClienteEditado: TClienteEdicionDTO;
begin

  Result := TMapeoDatos.ADto<TClienteEdicionDTO>(dmMemoria.mtClienteDetalle);
end;

procedure TfraClienteDatos.btnGuardarClienteClick(Sender: TObject);
begin
  if not dmMemoria.mtClienteDetalle.Active then
    Exit;
  dmMemoria.Confirmar(dmMemoria.mtClienteDetalle);
  FPresentador.Guardar(ClienteEditado);
end;

procedure TfraClienteDatos.MostrarAcciones(const APuedeEditar, APuedeRevocar,
  APuedeVerCotizaciones: Boolean; const AContacto: TAccionesContacto;
  const ACotizacion: TAccionesCotizacionCliente);
begin
  FPuedeEditar := APuedeEditar;

  BotonesDeEdicion(False);
  btnNuevo.Visible := APuedeEditar;
  btnRevocar.Visible := APuedeRevocar;
  btnExportar.Visible := APuedeVerCotizaciones;

  TDBGridExtend.De(grContactos).PonerAcciones<TAccionesContacto>
    (ACCIONES_CONTACTO, AContacto);
  TDBGridExtend.De(grCotizaciones).PonerAcciones<TAccionesCotizacionCliente>
    (ACCIONES_COTIZACION, ACotizacion);
end;

procedure TfraClienteDatos.AccionContacto(Sender: TObject;
  const AClave: string);
begin
  if dmMemoria.mtContactos.IsEmpty then
    Exit;
  Informar(SOpcionPendiente);
end;

procedure TfraClienteDatos.AccionCotizacion(Sender: TObject;
  const AClave: string);
begin
  if dmMemoria.mtClienteCotizaciones.IsEmpty then
    Exit;
  Informar(SOpcionPendiente);
end;

procedure TfraClienteDatos.MostrarCliente(const ACliente: TClienteDTO);
begin

  TMapeoDatos.ATabla(ACliente, dmMemoria.mtClienteDetalle);

  pstEstado.Caption := ACliente.ConsentimientoEstado;
  valVersion.Caption := ACliente.ConsentimientoVersion.ValueOrElse(SIN_DATO);
  if ACliente.ConsentimientoFecha.HasValue then
    valOtorgado.Caption := TFormato.FechaHora(ACliente.ConsentimientoFecha.Value)
  else
    valOtorgado.Caption := SIN_DATO;
end;

procedure TfraClienteDatos.MostrarContactos(const AContactos
  : TObjectList<TContactoDTO>);
begin
  TMapeoDatos.AListaTabla<TContactoDTO>(AContactos, dmMemoria.mtContactos);
end;

procedure TfraClienteDatos.MostrarConsentimientos(const AConsentimientos
  : TObjectList<TConsentimientoDTO>);
var
  lPrimera: TConsentimientoDTO;
begin

  TMapeoDatos.AListaTabla<TConsentimientoDTO>(AConsentimientos,
    dmMemoria.mtConsentimientos);
  if AConsentimientos.Count = 0 then
    valRecogido.Caption := SIN_DATO
  else
  begin
    lPrimera := AConsentimientos.First;
    valRecogido.Caption := lPrimera.FirmanteNombre.ValueOrElse(SIN_DATO);
    if lPrimera.Origen.HasValue and (lPrimera.Origen.Value <> '') then
      valRecogido.Caption := valRecogido.Caption + ' (' +
        lPrimera.Origen.Value + ')';
  end;
end;

end.
