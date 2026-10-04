unit Anovo.Forms.ContactoNuevo;

// Ventana de registro de un contacto nuevo del cliente.

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
    function ContactoEscrito: TContactoNuevoDTO;
    function ValidarCampos: Boolean;
    procedure Guardado(const AId: Integer);
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    constructor Crear(AOwner: TComponent; const AClienteId: Integer);
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

procedure TfrmContactoNuevo.FormDestroy(Sender: TObject);
begin
  FPresentador.Free;
end;

function TfrmContactoNuevo.ControlesEdicion: TArray<TControl>;
begin
  Result := [pnlCampos];
end;

function TfrmContactoNuevo.ContactoEscrito: TContactoNuevoDTO;
begin
  Result := TMapeoDatos.ADto<TContactoNuevoDTO>(dmMemoria.mtContactoNuevo);
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

  FPresentador.Guardar(ContactoEscrito);
end;

procedure TfrmContactoNuevo.Guardado(const AId: Integer);
begin
  FContactoId := AId;
  ModalResult := mrOk;
end;

end.
