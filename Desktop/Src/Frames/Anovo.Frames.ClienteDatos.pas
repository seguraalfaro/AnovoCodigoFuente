unit Anovo.Frames.ClienteDatos;

// Ficha del cliente: datos, contactos, consentimiento y
// cotizaciones.

interface

uses
  Anovo.UI.Iconos,
  Anovo.UI.Tema,
  Anovo.UI.CeldasRejilla,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  VclPlano.BotonWin, Vcl.ExtCtrls, Vcl.WinXCtrls, Anovo.UI.PanelRelativo, System.Actions, Vcl.ActnList,
  VclPlano.Pestanas, Vcl.WinXPanels, VclPlano.Tarjeta, Data.DB, Vcl.Grids,
  Vcl.DBGrids, rDBGrid, VclPlano.Pastilla, Vcl.Mask, Vcl.DBCtrls,
  rDBComponents,
  System.Generics.Collections,
  Anovo.DTOs.Clientes,
  Anovo.DTOs.Cotizaciones,
  Anovo.Vistas.Intf.ClienteDatos,
  Anovo.PeriodoBusqueda,
  Anovo.Forms.Periodo,
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
    cbFiltro: TComboBox;
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
    btnAnonimizar: TPlanoBotonWin;
    lblUbicacionRot: TLabel;
    lblUbicacion: TLabel;
    lblVerMapa: TLabel;
    btnPeriodo: TPlanoBotonWin;
    procedure AcRegregsarExecute(Sender: TObject);
    procedure lblVerMapaClick(Sender: TObject);
    procedure cbFiltroChange(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
    procedure btnEditarClienteClick(Sender: TObject);
    procedure btnGuardarClienteClick(Sender: TObject);
    procedure btnCancelarEdicionClick(Sender: TObject);
    procedure pstClienteChange(Sender: TObject);
    procedure btnNuevoClick(Sender: TObject);
    procedure btnAnonimizarClick(Sender: TObject);
    procedure btnRevocarClick(Sender: TObject);
  private
    FOnRegresar: TNotifyEvent;
    FPresentador: TPresentadorClienteDatos;
    FPuedeEditar: Boolean;
    FPuedeAnonimizar: Boolean;
    FClienteId: Integer;
    FUrlMapa: string;
    FSelector: TSelectorPeriodo;
    procedure PeriodoCambio(const APeriodo: TPeriodoBusqueda);
    procedure MostrarPeriodoCotizaciones(const APeriodo: TPeriodoBusqueda);
    function ClienteEditado: TClienteEdicionDTO;
    procedure BotonesDeEdicion(const AEdicion: Boolean);
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure MostrarCliente(const ACliente: TClienteDTO);
    procedure MostrarUbicacion(const ATexto, AUrlMapa: string);
    procedure MostrarContactos(const AContactos: TObjectList<TContactoDTO>);
    procedure MostrarCotizaciones(const ACotizaciones
      : TObjectList<TCotizacionDTO>);
    procedure MostrarConsentimientos(const AConsentimientos
      : TObjectList<TConsentimientoDTO>; const ARecogido: string);
    procedure MostrarAcciones(const APuedeEditar, APuedeRevocar,
      APuedeVerCotizaciones: Boolean; const AContacto: TAccionesContacto;
      const ACotizacion: TAccionesCotizacionCliente);
    procedure MostrarModoEdicion(const AActivo: Boolean);
    procedure MostrarAnonimizacion(const AVisible, AHabilitado: Boolean);
    function PedirMotivoAnonimizacion(out AMotivo: string): Boolean;
    function PedirMotivoContacto(const ANombre: string;
      out AMotivo: string): Boolean;
    function ConfirmarQuitarContacto(const ANombre: string): Boolean;
    procedure MostrarRevocacion(const AHabilitado: Boolean);
    function PedirRevocante(const ACliente: string;
      var ANombre, AIdentificacion: string): Boolean;
    procedure EditarContacto;
    procedure grContactosDblClick(Sender: TObject);
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
  Winapi.ShellAPI,
  Anovo.UI.ColumnasRejilla,
  Anovo.UI.Mascara,
  Anovo.UI.Vista,
  Anovo.Formato,
  Anovo.Api.Clientes,
  Anovo.Api.Cotizaciones,
  Anovo.Forms.ContactoNuevo,
  Anovo.Forms.Motivo,
  Anovo.Forms.Revocacion,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Textos;

const
  CONSENTIMIENTO_REVOCADO = 'revocado';
  ACCION_ABRIR_MAPA = 'open';

  CAMPO_ACCIONES = 'ACCIONES';

  ACCIONES_CONTACTO: array [TAccionContacto] of TAccionRejilla =
    ((Clave: 'editar'; Rotulo: SAccionEditar), (Clave: 'anonimizar';
    Rotulo: SAccionAnonimizarFila), (Clave: 'quitar'; Rotulo: SAccionQuitar;
    Alterno: ''; Campo: 'QUITABLE'));

  ACCIONES_COTIZACION: array [TAccionCotizacionCliente] of TAccionRejilla =
    ((Clave: 'ver'; Rotulo: SAccionVer));

constructor TfraClienteDatos.Crear(AOwner: TComponent;
  const AClienteId: Integer);
begin
  inherited Create(AOwner);
  AplicarTemaGrid(grContactos);
  AplicarTemaGrid(grCotizaciones);
  AplicarTemaGrid(grHistorial);
  CursorAlInicioEnMascaras(Self);
  TCeldasRejilla.De(grContactos).TextoVacio := SVacioContactos;
  TCeldasRejilla.De(grCotizaciones).TextoVacio := SVacioCotizacionesCliente;
  TCeldasRejilla.De(grHistorial).TextoVacio := SVacioConsentimientos;
  PrepararRejilla(grContactos, AccionContacto);
  grContactos.OnDblClick := grContactosDblClick;
  PrepararRejilla(grCotizaciones, AccionCotizacion);
  FClienteId := AClienteId;
  FSelector := TSelectorPeriodo.Crear(btnPeriodo, False, PeriodoCambio);
  TBusquedaAlEscribir.Crear(SearchBox1,
    procedure(ATexto: string)
    begin
      FPresentador.BuscarCotizaciones(ATexto);
    end);
  FPresentador := TPresentadorClienteDatos.Create(Self, TApiClientes.Create,
    TApiCotizaciones.Create,
    AClienteId);
  FPresentador.Iniciar;
end;

destructor TfraClienteDatos.Destroy;
begin
  FreeAndNil(FPresentador);
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

procedure TfraClienteDatos.EditarContacto;
var
  lVentana: TfrmContactoNuevo;
begin
  if dmMemoria.mtContactos.IsEmpty or
    not(acoEditar in TPresentadorClienteDatos.AccionesContacto) then
    Exit;
  lVentana := TfrmContactoNuevo.Editar(Self, FClienteId,
    dmMemoria.mtContactosID.AsInteger);
  try
    if lVentana.ShowModal = mrOk then
      FPresentador.Refrescar(pcContactos);
  finally
    lVentana.Free;
  end;
end;

procedure TfraClienteDatos.grContactosDblClick(Sender: TObject);
begin
  if not TCeldasRejilla.De(grContactos).Ocupada then
    EditarContacto;
end;

function TfraClienteDatos.ConfirmarQuitarContacto(const ANombre
  : string): Boolean;
begin
  Result := Confirmar(Format(SQuitarContactoPregunta, [ANombre]));
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
  TCeldasRejilla.De(grContactos).Ocupada := AActivo;
  TCeldasRejilla.De(grCotizaciones).Ocupada := AActivo;
  if AActivo then
  begin
    btnGuardarCliente.Enabled := False;
    btnAnonimizar.Enabled := False;
  end
  else
    BotonesDeEdicion(dmMemoria.mtClienteDetalle.State in dsEditModes);
end;

procedure TfraClienteDatos.MostrarError(const AMensaje: string);
begin
  AvisarError(AMensaje);
end;

procedure TfraClienteDatos.PrepararRejilla(const AGrid: TrDBGrid;
  const AManejador: TEventoAccion);
var
  lRejilla: TCeldasRejilla;
begin
  lRejilla := TCeldasRejilla.De(AGrid);
  lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
  lRejilla.OnAccion := AManejador;
end;

procedure TfraClienteDatos.BotonesDeEdicion(const AEdicion: Boolean);
begin

  btnEditarCliente.Visible := FPuedeEditar;
  btnGuardarCliente.Visible := FPuedeEditar;
  btnCancelarEdicion.Visible := FPuedeEditar;
  btnEditarCliente.Enabled := not AEdicion;
  btnAnonimizar.Enabled := FPuedeAnonimizar and not AEdicion;
  btnGuardarCliente.Enabled := AEdicion;
  btnCancelarEdicion.Enabled := AEdicion;
  pstCliente.Enabled := not AEdicion;
end;

procedure TfraClienteDatos.MostrarModoEdicion(const AActivo: Boolean);
begin
  BotonesDeEdicion(AActivo);

end;

procedure TfraClienteDatos.MostrarAnonimizacion(const AVisible,
  AHabilitado: Boolean);
begin
  FPuedeAnonimizar := AHabilitado;
  btnAnonimizar.Visible := AVisible;
  btnAnonimizar.Enabled := AHabilitado;
end;

function TfraClienteDatos.PedirMotivoAnonimizacion(out AMotivo: string)
  : Boolean;
begin
  Result := TfrmMotivo.Pedir(Self, SAnonimizarTitulo, SAnonimizarAyuda,
    SAnonimizarBoton, AMotivo);
end;

function TfraClienteDatos.PedirMotivoContacto(const ANombre: string;
  out AMotivo: string): Boolean;
begin
  Result := TfrmMotivo.Pedir(Self, SAnonimizarContactoTitulo,
    Format(SAnonimizarContactoAyuda, [ANombre]), SAnonimizarBoton, AMotivo);
end;

procedure TfraClienteDatos.btnAnonimizarClick(Sender: TObject);
begin
  FPresentador.Anonimizar;
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

procedure TfraClienteDatos.btnRevocarClick(Sender: TObject);
begin
  FPresentador.Revocar;
end;

procedure TfraClienteDatos.MostrarRevocacion(const AHabilitado: Boolean);
begin
  btnRevocar.Enabled := AHabilitado;
end;

function TfraClienteDatos.PedirRevocante(const ACliente: string;
  var ANombre, AIdentificacion: string): Boolean;
begin
  Result := TfrmRevocacion.Pedir(Self, ACliente, ANombre, AIdentificacion);
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

  TCeldasRejilla.De(grContactos).PonerAcciones<TAccionesContacto>
    (ACCIONES_CONTACTO, AContacto);
  TCeldasRejilla.De(grCotizaciones).PonerAcciones<TAccionesCotizacionCliente>
    (ACCIONES_COTIZACION, ACotizacion);
end;

procedure TfraClienteDatos.AccionContacto(Sender: TObject;
  const AClave: string);
begin
  if dmMemoria.mtContactos.IsEmpty then
    Exit;
  if SameText(AClave, ACCIONES_CONTACTO[acoEditar].Clave) then
    EditarContacto
  else if SameText(AClave, ACCIONES_CONTACTO[acoQuitar].Clave) then
    FPresentador.QuitarContacto(dmMemoria.mtContactosID.AsInteger,
      dmMemoria.mtContactosNOMBRE.AsString)
  else if SameText(AClave, ACCIONES_CONTACTO[acoAnonimizar].Clave) then
    FPresentador.AnonimizarContacto(dmMemoria.mtContactosID.AsInteger,
      dmMemoria.mtContactosNOMBRE.AsString);
end;

procedure TfraClienteDatos.AccionCotizacion(Sender: TObject;
  const AClave: string);
begin
  if dmMemoria.mtClienteCotizaciones.IsEmpty then
    Exit;
  FPresentador.VerCotizacion(dmMemoria.mtClienteCotizacionesID.AsInteger);
end;

procedure TfraClienteDatos.MostrarPeriodoCotizaciones(const APeriodo
  : TPeriodoBusqueda);
begin
  FSelector.Mostrar(APeriodo);
end;

procedure TfraClienteDatos.PeriodoCambio(const APeriodo: TPeriodoBusqueda);
begin
  FPresentador.FiltrarPeriodoCotizaciones(APeriodo);
end;

procedure TfraClienteDatos.MostrarCotizaciones(const ACotizaciones
  : TObjectList<TCotizacionDTO>);
begin
  TMapeoDatos.AListaTabla<TCotizacionDTO>(ACotizaciones,
    dmMemoria.mtClienteCotizaciones);
  TCeldasRejilla.De(grCotizaciones).AjustarColumnas;
end;


procedure TfraClienteDatos.cbFiltroChange(Sender: TObject);
begin
  if (FPresentador = nil) or (cbFiltro.ItemIndex < 0) then
    Exit;
  FPresentador.FiltrarCotizaciones(cbFiltro.ItemIndex);
end;

procedure TfraClienteDatos.btnExportarClick(Sender: TObject);
begin
  TColumnasRejilla.ExportarRejilla(grCotizaciones);
end;

procedure TfraClienteDatos.MostrarUbicacion(const ATexto, AUrlMapa: string);
begin
  FUrlMapa := AUrlMapa;
  lblUbicacion.Caption := ATexto;
  lblVerMapa.Visible := not AUrlMapa.IsEmpty;
end;

procedure TfraClienteDatos.lblVerMapaClick(Sender: TObject);
begin
  if not FUrlMapa.IsEmpty then
    ShellExecute(Handle, ACCION_ABRIR_MAPA, PChar(FUrlMapa), nil, nil,
      SW_SHOWNORMAL);
end;

procedure TfraClienteDatos.MostrarCliente(const ACliente: TClienteDTO);
begin

  TMapeoDatos.ATabla(ACliente, dmMemoria.mtClienteDetalle);

  pstEstado.Caption := ACliente.ConsentimientoEstado;
  pstEstado.Status := EstadoPlano(ACliente.ConsentimientoEstado);
  if ACliente.ConsentimientoEstado = CONSENTIMIENTO_REVOCADO then
    lblOtorgado.Caption := SRevocadoEl
  else
    lblOtorgado.Caption := SOtorgadoEl;
  valVersion.Caption := ACliente.ConsentimientoVersion.ValueOrElse(SSinDato);
  if ACliente.ConsentimientoFecha.HasValue then
    valOtorgado.Caption := TFormato.FechaHora(ACliente.ConsentimientoFecha.Value)
  else
    valOtorgado.Caption := SSinDato;
end;

procedure TfraClienteDatos.MostrarContactos(const AContactos
  : TObjectList<TContactoDTO>);
begin
  TMapeoDatos.AListaTabla<TContactoDTO>(AContactos, dmMemoria.mtContactos);
  dmMemoria.MarcarContactosQuitables;
end;

procedure TfraClienteDatos.MostrarConsentimientos(const AConsentimientos
  : TObjectList<TConsentimientoDTO>; const ARecogido: string);
begin
  TMapeoDatos.AListaTabla<TConsentimientoDTO>(AConsentimientos,
    dmMemoria.mtConsentimientos);
  TColumnasRejilla.AplicarEn(grHistorial);
  valRecogido.Caption := ARecogido;
end;

end.
