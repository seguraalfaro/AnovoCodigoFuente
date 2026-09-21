unit Anovo.Frames.ClienteDatos;

// Ficha del cliente: datos, contactos, consentimiento y cotizaciones, una
// pestana cada uno. La abre el listado de clientes encima de si mismo.
//
// No decide nada: pide al presentador lo de cada pestana y muestra lo que
// vuelve. Los datos se copian a las tablas de dmMemoria, que es de donde leen
// los controles enlazados.
//
// Regresar no se cierra solo: avisa con OnRegresar y el listado decide. Un
// frame no puede liberarse dentro de su propio evento.

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
    // Con clientes.editar: sin el permiso, no se ve ninguno de los tres.
    FPuedeEditar: Boolean;
    // El cliente que esta abierto: la ventana de contacto nuevo lo necesita.
    FClienteId: Integer;
    function ClienteEditado: TClienteEdicionDTO;
    procedure BotonesDeEdicion(const AEdicion: Boolean);
    // IVistaClienteDatos
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure MostrarCliente(const ACliente: TClienteDTO);
    procedure MostrarContactos(const AContactos: TObjectList<TContactoDTO>);
    procedure MostrarConsentimientos(const AConsentimientos
      : TObjectList<TConsentimientoDTO>);
    procedure MostrarAcciones(const APuedeEditar, APuedeRevocar,
      APuedeVerCotizaciones: Boolean);
    procedure MostrarModoEdicion(const AActivo: Boolean);
    // Los botones de cada rejilla, y la columna donde se dibujan.
    procedure AccionContacto(Sender: TObject; const AClave: string);
    procedure AccionCotizacion(Sender: TObject; const AClave: string);
    procedure PrepararAcciones(const AGrid: TrDBGrid;
      const AAcciones: array of TAccionRejilla; const AActiva: Boolean;
      const AManejador: TEventoAccion);
  public

    constructor Crear(AOwner: TComponent; const AClienteId: Integer);
    destructor Destroy; override;
    property OnRegresar: TNotifyEvent read FOnRegresar write FOnRegresar;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Api.Clientes,
  Anovo.Forms.ContactoNuevo,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria;

const
  // Lo que se ve cuando el cliente no tiene ese dato.
  SIN_DATO = '-';

  // La columna donde se dibujan los botones en las dos rejillas.
  CAMPO_ACCIONES = 'ACCIONES';

  ACCIONES_CONTACTO: array [0 .. 1] of TAccionRejilla = ((Clave: 'editar';
    Rotulo: 'Editar'), (Clave: 'quitar'; Rotulo: 'Quitar'));

  // Ver la cotizacion: quien no tenga el permiso no ve ni el boton ni la
  // columna. El servidor filtra ademas cuales puede abrir el asesor.
  ACCIONES_COTIZACION: array [0 .. 0] of TAccionRejilla = ((Clave: 'ver';
    Rotulo: 'Ver'));

  MENSAJE_PENDIENTE = 'Esta opcion todavia no esta disponible.';

constructor TfraClienteDatos.Crear(AOwner: TComponent;
  const AClienteId: Integer);
begin
  inherited Create(AOwner);
  AplicarTemaGrid(grContactos);
  AplicarTemaGrid(grCotizaciones);
  AplicarTemaGrid(grHistorial);
  FClienteId := AClienteId;
  FPresentador := TPresentadorClienteDatos.Create(Self, TApiClientes.Create,
    AClienteId);
  FPresentador.Iniciar;
end;

destructor TfraClienteDatos.Destroy;
begin

  FPresentador.Free;

  Screen.Cursor := crDefault;
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
      // La pestana ya estaba cargada, asi que hay que pedirla de nuevo para
      // que aparezca el contacto.
      FPresentador.Refrescar(pcContactos);
  finally
    lVentana.Free;
  end;
end;

procedure TfraClienteDatos.MostrarCargando(const AActivo: Boolean);
begin
  if AActivo then
    Screen.Cursor := crAppStart
  else
    Screen.Cursor := crDefault;
end;

procedure TfraClienteDatos.MostrarError(const AMensaje: string);
begin
  MessageDlg(AMensaje, mtWarning, [mbOK], 0);
end;

procedure TfraClienteDatos.PrepararAcciones(const AGrid: TrDBGrid;
  const AAcciones: array of TAccionRejilla; const AActiva: Boolean;
  const AManejador: TEventoAccion);
var
  lRejilla: TDBGridExtend;
  lAccion: TAccionRejilla;
  I: Integer;
begin
  // El dibujo es del TDBGridExtend que AplicarTemaGrid le dejo a la rejilla:
  // aqui solo se le dice que columna es suya y que botones lleva.
  lRejilla := TDBGridExtend.De(AGrid);
  lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
  if AActiva then
    for lAccion in AAcciones do
      lRejilla.Agregar(lAccion.Clave, lAccion.Rotulo);
  lRejilla.OnAccion := AManejador;

  // Sin permiso la columna no se muestra: una columna vacia se lee como si
  // faltara algo.
  for I := 0 to AGrid.Columns.Count - 1 do
    if SameText(AGrid.Columns[I].FieldName, CAMPO_ACCIONES) then
    begin
      AGrid.Columns[I].Visible := AActiva;
      AGrid.Columns[I].Width := lRejilla.AnchoAcciones;
    end;
end;

procedure TfraClienteDatos.BotonesDeEdicion(const AEdicion: Boolean);
begin

  btnEditarCliente.Visible := FPuedeEditar;
  btnGuardarCliente.Visible := FPuedeEditar;
  btnCancelarEdicion.Visible := FPuedeEditar;
  btnEditarCliente.Enabled := not AEdicion;
  btnGuardarCliente.Enabled := AEdicion;
  btnCancelarEdicion.Enabled := AEdicion;
  // Cambiar de pestana a media edicion dejaria cambios sin guardar.
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
  // Post baja a la tabla lo que quedo en los controles.
  if dmMemoria.mtClienteDetalle.State in dsEditModes then
    dmMemoria.mtClienteDetalle.Post;
  FPresentador.Guardar(ClienteEditado);
end;

procedure TfraClienteDatos.MostrarAcciones(const APuedeEditar, APuedeRevocar,
  APuedeVerCotizaciones: Boolean);
begin
  FPuedeEditar := APuedeEditar;

  BotonesDeEdicion(False);
  btnNuevo.Visible := APuedeEditar;
  btnRevocar.Visible := APuedeRevocar;
  btnExportar.Visible := APuedeVerCotizaciones;

  PrepararAcciones(grContactos, ACCIONES_CONTACTO, APuedeEditar,
    AccionContacto);
  PrepararAcciones(grCotizaciones, ACCIONES_COTIZACION, APuedeVerCotizaciones,
    AccionCotizacion);
end;

procedure TfraClienteDatos.AccionContacto(Sender: TObject;
  const AClave: string);
begin
  // La rejilla ya movio el cursor a la fila pulsada: el contacto es el de esa
  // fila.
  if dmMemoria.mtContactos.IsEmpty then
    Exit;
  // Editar y quitar se construyen en los pasos siguientes: el backend ya
  // tiene PUT e inactivacion de contactos.
  MessageDlg(MENSAJE_PENDIENTE, mtInformation, [mbOK], 0);
end;

procedure TfraClienteDatos.AccionCotizacion(Sender: TObject;
  const AClave: string);
begin
  if dmMemoria.mtClienteCotizaciones.IsEmpty then
    Exit;
  // Abrir la cotizacion queda para cuando exista ese modulo.
  MessageDlg(MENSAJE_PENDIENTE, mtInformation, [mbOK], 0);
end;

procedure TfraClienteDatos.MostrarCliente(const ACliente: TClienteDTO);
begin

  TMapeoDatos.ATabla(ACliente, dmMemoria.mtClienteDetalle);

  // La tarjeta del consentimiento vigente, en la pestana de al lado.
  pstEstado.Caption := ACliente.ConsentimientoEstado;
  valVersion.Caption := ACliente.ConsentimientoVersion.ValueOrElse(SIN_DATO);
  if ACliente.ConsentimientoFecha.HasValue then
    valOtorgado.Caption := FormatDateTime('dd/mm/yyyy hh:nn',
      ACliente.ConsentimientoFecha.Value)
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
