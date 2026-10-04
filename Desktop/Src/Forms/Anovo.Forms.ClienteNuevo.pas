unit Anovo.Forms.ClienteNuevo;

// Ventana de registro de un cliente nuevo.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, Vcl.WinXPanels,
  VclPlano.BotonWin,
  Anovo.Forms.Edicion,
  Anovo.Validacion,
  Anovo.DTOs.Clientes,
  Anovo.Vistas.Intf.Registro,
  Anovo.Presentadores.Registro, Vcl.TitleBarCtrls, Vcl.DBCtrls, rDBComponents,
  Vcl.Mask;

type
  TfrmClienteNuevo = class(TfrmEdicion, IVistaRegistro)
    pnlCampos: TPanel;
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
    procedure chkExoneradoClick(Sender: TObject);
  private
    FPresentador: TPresentadorClienteNuevo;
    FClienteId: Integer;
    function ClienteEscrito: TClienteNuevoDTO;
    function ValidarCampos: Boolean;
    procedure Guardado(const AId: Integer);
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    property ClienteId: Integer read FClienteId;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Datos.Memoria,
  Anovo.Mapeo.Datos,
  Anovo.Api.Clientes,
  Anovo.Textos;

procedure TfrmClienteNuevo.FormCreate(Sender: TObject);
begin
  dmMemoria.PrepararClienteNuevo;
  FPresentador := TPresentadorClienteNuevo.Create(Self, TApiClientes.Create);
  chkExoneradoClick(nil);
end;

procedure TfrmClienteNuevo.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPresentador);
end;

function TfrmClienteNuevo.ControlesEdicion: TArray<TControl>;
begin
  Result := [pnlCampos];
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
begin
  lReparos := TStringList.Create;
  try
    with dmMemoria do
    begin
      if not TValidacion.Texto(mtClienteNuevoNOMBRE.AsString) then
        lReparos.Add(SValNombreCliente);
      if not TValidacion.Texto(mtClienteNuevoCONTACTO.AsString) then
        lReparos.Add(SValNombreContacto);

      if (mtClienteNuevoIDENTIFICACION.AsString <> '') and
        not TValidacion.Identificacion
        (TTipoIdentificacion(mtClienteNuevoTIPO_IDENTIFICACION.AsInteger),
        mtClienteNuevoIDENTIFICACION.AsString) then
        lReparos.Add(SValIdentificacion);

      if (mtClienteNuevoTELEFONO.AsString <> '') and
        not TValidacion.Telefono(mtClienteNuevoTELEFONO.AsString) then
        lReparos.Add(SValTelefono);

      if (mtClienteNuevoCORREO.AsString <> '') and
        not TValidacion.Correo(mtClienteNuevoCORREO.AsString) then
        lReparos.Add(SValCorreo);

      if mtClienteNuevoEXONERADO.AsBoolean and
        (Trim(mtClienteNuevoCODIGO_EXONERACION.AsString) = '') then
        lReparos.Add(SValCodigoExoneracion);
    end;

    Result := MostrarReparos(lReparos, SReparosCliente);
  finally
    lReparos.Free;
  end;
end;

procedure TfrmClienteNuevo.btnGuardarClick(Sender: TObject);
begin
  dmMemoria.Confirmar(dmMemoria.mtClienteNuevo);

  if not ValidarCampos then
    Exit;
  FPresentador.Guardar(ClienteEscrito);
end;

procedure TfrmClienteNuevo.Guardado(const AId: Integer);
begin
  FClienteId := AId;
  ModalResult := mrOk;
end;

end.
