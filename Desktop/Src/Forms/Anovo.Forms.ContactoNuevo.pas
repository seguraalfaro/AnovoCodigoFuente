unit Anovo.Forms.ContactoNuevo;

// Ventana de contacto nuevo, la que abre la pestana Contactos de la ficha.
// Mismo molde que la de cliente nuevo.
//
// De que cliente es lo dice quien la abre, no la ventana: el numero entra por
// el constructor y viaja en la ruta.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, Data.DB,
  rDBComponents,
  VclPlano.BotonWin,
  Anovo.UI.Tema,
  Anovo.Validacion,
  Anovo.DTOs.Clientes,
  Anovo.Vistas.Intf.Registro,
  Anovo.Presentadores.Registro, Vcl.TitleBarCtrls;

type
  TfrmContactoNuevo = class(TForm, IVistaRegistro)
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pnlCampos: TPanel;
    edNombre: TrDBEdit;
    edArea: TrDBEdit;
    edTelefono: TrDBEdit;
    edCelular: TrDBEdit;
    edCorreo: TrDBEdit;
    chkPrincipal: TrDBCheckBox;
    pnlPie: TPanel;
    btnGuardar: TPlanoBotonWin;
    btnCancelar: TPlanoBotonWin;
    TitleBarPanel1: TTitleBarPanel;
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FPresentador: TPresentadorContactoNuevo;
    FContactoId: Integer;
    function ContactoEscrito: TContactoNuevoDTO;
    // Revisa lo que se escribio y, si hay reparos, los muestra todos juntos.
    function ValidarCampos: Boolean;
    // IVistaRegistro
    procedure MostrarGuardando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure Guardado(const AId: Integer);
  public
  
    constructor Crear(AOwner: TComponent; const AClienteId: Integer);
    // El numero del contacto que se creo, o 0 si se cancelo.
    property ContactoId: Integer read FContactoId;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Api.Clientes,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria;

constructor TfrmContactoNuevo.Crear(AOwner: TComponent;
  const AClienteId: Integer);
begin
  inherited Create(AOwner);
  AplicarTema(Self);

  dmMemoria.PrepararContactoNuevo(AClienteId);
  FPresentador := TPresentadorContactoNuevo.Create(Self,
    TApiClientes.Create, AClienteId);
end;

procedure TfrmContactoNuevo.FormDestroy(Sender: TObject);
begin
  FPresentador.Free;
end;

function TfrmContactoNuevo.ContactoEscrito: TContactoNuevoDTO;
begin

  Result := TMapeoDatos.ADto<TContactoNuevoDTO>(dmMemoria.mtContactoNuevo);
end;

function TfrmContactoNuevo.ValidarCampos: Boolean;
var
  lReparos: TStringList;
  lMensaje: string;
  I: Integer;
begin

  lReparos := TStringList.Create;
  try
    with dmMemoria do
    begin
      if not TValidacion.Texto(mtContactoNuevoNOMBRE.AsString) then
        lReparos.Add('El nombre del contacto debe tener al menos tres letras.');

      if not TValidacion.Correo(mtContactoNuevoCORREO.AsString) then
        lReparos.Add('El correo no tiene una forma valida, por ejemplo ' +
          'nombre@dominio.cr');

      // El de la oficina admite extension, el celular no.
      if (mtContactoNuevoTELEFONO.AsString <> '') and
        not TValidacion.TelefonoExt(mtContactoNuevoTELEFONO.AsString) then
        lReparos.Add('El telefono debe tener ocho digitos, con extension o ' +
          'sin ella.');

      if (mtContactoNuevoCELULAR.AsString <> '') and
        not TValidacion.Telefono(mtContactoNuevoCELULAR.AsString) then
        lReparos.Add('El celular debe tener ocho digitos.');
    end;

    Result := lReparos.Count = 0;
    if Result then
      Exit;

    if lReparos.Count = 1 then
      lMensaje := lReparos[0]
    else
    begin
      lMensaje := 'No se puede guardar el contacto. Corrija lo siguiente:' +
        sLineBreak;
      for I := 0 to lReparos.Count - 1 do
        lMensaje := lMensaje + sLineBreak + '   ' + #$2022 + '  ' + lReparos[I];
    end;
    MostrarError(lMensaje);
  finally
    lReparos.Free;
  end;
end;

procedure TfrmContactoNuevo.btnGuardarClick(Sender: TObject);
begin

  if dmMemoria.mtContactoNuevo.State in dsEditModes then
    dmMemoria.mtContactoNuevo.Post;

  if not ValidarCampos then
    Exit;

  FPresentador.Guardar(ContactoEscrito);
end;

procedure TfrmContactoNuevo.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmContactoNuevo.MostrarGuardando(const AActivo: Boolean);
begin
  pnlCampos.Enabled := not AActivo;
  btnGuardar.Enabled := not AActivo;
  btnCancelar.Enabled := not AActivo;
  if AActivo then
    Screen.Cursor := crAppStart
  else
    Screen.Cursor := crDefault;
end;

procedure TfrmContactoNuevo.MostrarError(const AMensaje: string);
begin
  MessageDlg(AMensaje, mtWarning, [mbOK], 0);
end;

procedure TfrmContactoNuevo.Guardado(const AId: Integer);
begin
  FContactoId := AId;
  ModalResult := mrOk;
end;

end.
