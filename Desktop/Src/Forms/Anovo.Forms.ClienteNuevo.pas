unit Anovo.Forms.ClienteNuevo;






// Ventana de cliente nuevo. Modal, sin borde y con el tema de la aplicacion,
// como la de agregar item.
//
// No decide nada: arma el DTO con lo que se escribio y se lo pasa al
// presentador. Lo que el servidor no acepta desde afuera -el consentimiento-
// arranca en pendiente, que es lo que corresponde a un cliente que todavia no
// ha firmado.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, Vcl.WinXPanels,
  VclPlano.BotonWin,
  Anovo.UI.Tema,
  Anovo.Validacion,
  Anovo.DTOs.Clientes,
  Anovo.Vistas.Intf.Registro,
  Anovo.Presentadores.Registro, Vcl.TitleBarCtrls, Vcl.DBCtrls, rDBComponents,
  Vcl.Mask;

type
  TfrmClienteNuevo = class(TForm, IVistaRegistro)
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pnlCampos: TPanel;
    pnlPie: TPanel;
    btnGuardar: TPlanoBotonWin;
    btnCancelar: TPlanoBotonWin;
    TitleBarPanel1: TTitleBarPanel;
    cbTipoIdentificacion: TrDBLookupComboBox;
    rDBEdit1: TrDBEdit;
    rDBEdit2: TrDBEdit;
    rDBEdit3: TrDBEdit;
    rDBMemo1: TrDBMemo;
    leCodigoExoneracion: TrDBEdit;
    rDBEdit4: TrDBEdit;
    chkExonerado: TrDBCheckBox;
    rDBEdit5: TrDBEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure chkExoneradoClick(Sender: TObject);

  private
    FPresentador: TPresentadorClienteNuevo;
    FClienteId: Integer;
    function ClienteEscrito: TClienteNuevoDTO;

    function ValidarCampos: Boolean;

    procedure MostrarGuardando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure Guardado(const AId: Integer);

  public

    property ClienteId: Integer read FClienteId;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Datos.Memoria,
  Anovo.Mapeo.Datos,
  Anovo.Api.Clientes;

const
  // Un cliente nuevo no ha firmado nada todavia.
  CONSENTIMIENTO_PENDIENTE = 'pendiente';

procedure TfrmClienteNuevo.FormCreate(Sender: TObject);
begin
  AplicarTema(Self);
  AplicarTemaBarraTitulo(Self, TitleBarPanel1);
  // La fila en blanco con el uuid y lo que la ventana no pregunta: los
  // controles enlazados escriben sobre ella.
  dmMemoria.PrepararClienteNuevo;
  FPresentador := TPresentadorClienteNuevo.Create(Self, TApiClientes.Create);
  chkExoneradoClick(nil);
end;

procedure TfrmClienteNuevo.FormDestroy(Sender: TObject);
begin
  FPresentador.Free;
end;

procedure TfrmClienteNuevo.chkExoneradoClick(Sender: TObject);
begin

  leCodigoExoneracion.Enabled := chkExonerado.Checked;
  if not chkExonerado.Checked then
    leCodigoExoneracion.Clear;
end;

function TfrmClienteNuevo.ClienteEscrito: TClienteNuevoDTO;
begin

  Result := TMapeoDatos.ADto<TClienteNuevoDTO>(dmMemoria.mtClienteNuevo);
end;

function TfrmClienteNuevo.ValidarCampos: Boolean;
var
  lReparos: TStringList;
  lMensaje: string;
  I: Integer;
begin
  lReparos := TStringList.Create;
  try
    with dmMemoria do
    begin
      if not TValidacion.Texto(mtClienteNuevoNOMBRE.AsString) then
        lReparos.Add
          ('El nombre o razon social debe tener al menos tres letras.');
      if not TValidacion.Texto(mtClienteNuevoCONTACTO.AsString) then
        lReparos.Add
          ('El nombre o razon social debe tener al menos tres letras.');

      if (mtClienteNuevoIDENTIFICACION.AsString <> '') and
        not TValidacion.Identificacion
        (TTipoIdentificacion(mtClienteNuevoTIPO_IDENTIFICACION.AsInteger),
        mtClienteNuevoIDENTIFICACION.AsString) then
        lReparos.Add('La identificacion no tiene el largo que corresponde al ' +
          'tipo seleccionado.');

      if (mtClienteNuevoTELEFONO.AsString <> '') and
        not TValidacion.Telefono(mtClienteNuevoTELEFONO.AsString) then
        lReparos.Add('El telefono debe tener ocho digitos.');

      if (mtClienteNuevoCORREO.AsString <> '') and
        not TValidacion.Correo(mtClienteNuevoCORREO.AsString) then
        lReparos.Add('El correo no tiene una forma valida, por ejemplo ' +
          'nombre@dominio.cr');

      if mtClienteNuevoEXONERADO.AsBoolean and
        (Trim(mtClienteNuevoCODIGO_EXONERACION.AsString) = '') then
        lReparos.Add('Un cliente exonerado necesita su codigo de exoneracion.');
    end;

    Result := lReparos.Count = 0;
    if Result then
      Exit;

    if lReparos.Count = 1 then
      lMensaje := lReparos[0]
    else
    begin
      lMensaje := 'No se puede guardar el cliente. Corrija lo siguiente:' +
        sLineBreak;
      for I := 0 to lReparos.Count - 1 do
        lMensaje := lMensaje + sLineBreak + '   ' + #$2022 + '  ' + lReparos[I];
    end;
    MostrarError(lMensaje);
  finally
    lReparos.Free;
  end;
end;

procedure TfrmClienteNuevo.btnGuardarClick(Sender: TObject);
begin
  if dmMemoria.mtClienteNuevo.State in dsEditModes then
    dmMemoria.mtClienteNuevo.Post;

  if not ValidarCampos then
    Exit;
  FPresentador.Guardar(ClienteEscrito);
end;

procedure TfrmClienteNuevo.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmClienteNuevo.MostrarGuardando(const AActivo: Boolean);
begin
  pnlCampos.Enabled := not AActivo;
  btnGuardar.Enabled := not AActivo;
  btnCancelar.Enabled := not AActivo;
  if AActivo then
    Screen.Cursor := crAppStart
  else
    Screen.Cursor := crDefault;
end;

procedure TfrmClienteNuevo.MostrarError(const AMensaje: string);
begin
  MessageDlg(AMensaje, mtWarning, [mbOK], 0);
end;

procedure TfrmClienteNuevo.Guardado(const AId: Integer);
begin
  FClienteId := AId;
  ModalResult := mrOk;
end;

end.
