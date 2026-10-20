unit Anovo.Forms.ContactoNuevo;

// Ventana de registro y de edicion de un contacto del cliente.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, Data.DB,
  rDBComponents,
  VclPlano.BotonWin,
  Anovo.Forms.Edicion,
  Anovo.Validacion,
  Anovo.DTOs.Clientes,
  Anovo.Vistas.Intf.Registro,
  Anovo.Presentadores.Registro, Vcl.TitleBarCtrls;

type
  TfrmContactoNuevo = class(TfrmEdicion, IVistaRegistro)
    pnlCampos: TPanel;
    edNombre: TrDBEdit;
    edArea: TrDBEdit;
    edTelefono: TrDBEdit;
    edCelular: TrDBEdit;
    edCorreo: TrDBEdit;
    chkPrincipal: TrDBCheckBox;
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
  private
    FPresentador: TPresentadorContactoNuevo;
    FContactoId: Integer;
    FObjVersion: Integer;
    function ContactoEscrito: TContactoNuevoDTO;
    function ContactoEditado: TContactoEdicionDTO;
    function ValidarCampos: Boolean;
    procedure Guardado(const AId: Integer);
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    constructor Crear(AOwner: TComponent; const AClienteId: Integer);
    constructor Editar(AOwner: TComponent; const AClienteId: Integer);
    property ContactoId: Integer read FContactoId;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Api.Clientes,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Textos;

constructor TfrmContactoNuevo.Crear(AOwner: TComponent;
  const AClienteId: Integer);
begin
  inherited Create(AOwner);
  dmMemoria.PrepararContactoNuevo(AClienteId);
  FPresentador := TPresentadorContactoNuevo.Create(Self,
    TApiClientes.Create, AClienteId);
end;

constructor TfrmContactoNuevo.Editar(AOwner: TComponent;
  const AClienteId: Integer);
begin
  inherited Create(AOwner);
  FContactoId := dmMemoria.mtContactosID.AsInteger;
  FObjVersion := dmMemoria.mtContactosOBJVERSION.AsInteger;
  dmMemoria.PrepararContactoEdicion(AClienteId);
  FPresentador := TPresentadorContactoNuevo.Create(Self,
    TApiClientes.Create, AClienteId);
  Caption := STituloEditarContacto;
  lblTitulo.Caption := STituloEditarContacto;
  if dmMemoria.ContactoFirmado then
  begin
    edNombre.ReadOnly := True;
    edNombre.TabStop := False;
    lblSubtitulo.Caption := SSubtituloContactoFirmado;
  end;
end;

procedure TfrmContactoNuevo.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPresentador);
end;

function TfrmContactoNuevo.ControlesEdicion: TArray<TControl>;
begin
  Result := [pnlCampos];
end;

function TfrmContactoNuevo.ContactoEscrito: TContactoNuevoDTO;
begin
  Result := TMapeoDatos.ADto<TContactoNuevoDTO>(dmMemoria.mtContactoNuevo);
end;

function TfrmContactoNuevo.ContactoEditado: TContactoEdicionDTO;
begin
  Result := TMapeoDatos.ADto<TContactoEdicionDTO>(dmMemoria.mtContactoNuevo);
  Result.ObjVersion := FObjVersion;
end;

function TfrmContactoNuevo.ValidarCampos: Boolean;
var
  lReparos: TStringList;
begin
  lReparos := TStringList.Create;
  try
    with dmMemoria do
    begin
      if not TValidacion.Texto(mtContactoNuevoNOMBRE.AsString) then
        lReparos.Add(SValNombreContacto);

      if not TValidacion.Correo(mtContactoNuevoCORREO.AsString) then
        lReparos.Add(SValCorreo);

      if (mtContactoNuevoTELEFONO.AsString <> '') and
        not TValidacion.TelefonoExt(mtContactoNuevoTELEFONO.AsString) then
        lReparos.Add(SValTelefonoExt);

      if (mtContactoNuevoCELULAR.AsString <> '') and
        not TValidacion.Telefono(mtContactoNuevoCELULAR.AsString) then
        lReparos.Add(SValCelular);
    end;

    Result := MostrarReparos(lReparos, SReparosContacto);
  finally
    lReparos.Free;
  end;
end;

procedure TfrmContactoNuevo.btnGuardarClick(Sender: TObject);
begin
  dmMemoria.Confirmar(dmMemoria.mtContactoNuevo);

  if not ValidarCampos then
    Exit;

  if FContactoId > 0 then
    FPresentador.Actualizar(FContactoId, ContactoEditado)
  else
    FPresentador.Guardar(ContactoEscrito);
end;

procedure TfrmContactoNuevo.Guardado(const AId: Integer);
begin
  FContactoId := AId;
  ModalResult := mrOk;
end;

end.
