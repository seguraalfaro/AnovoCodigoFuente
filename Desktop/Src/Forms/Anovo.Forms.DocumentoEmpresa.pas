unit Anovo.Forms.DocumentoEmpresa;

// Datos del documento de la cotizacion en EMPRESA: firmante, condiciones por
// defecto y carta de presentacion. Edita la fila de mtEmpresa.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, Data.DB,
  rDBComponents,
  VclPlano.BotonWin,
  Anovo.Forms.Edicion, Vcl.TitleBarCtrls, Vcl.WinXCtrls,
  Anovo.UI.PanelRelativo;

type
  TfrmDocumentoEmpresa = class(TfrmEdicion)
    pnlCampos: TPanel;
    edFirmante: TrDBEdit;
    edFormaPago: TrDBEdit;
    edEntrega: TrDBEdit;
    edGarantia: TrDBEdit;
    meCarta: TrDBMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnGuardarClick(Sender: TObject);
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    class function Editar(AOwner: TComponent): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Datos.Memoria;

class function TfrmDocumentoEmpresa.Editar(AOwner: TComponent): Boolean;
var
  lForma: TfrmDocumentoEmpresa;
begin
  lForma := TfrmDocumentoEmpresa.Create(AOwner);
  try
    Result := lForma.ShowModal = mrOk;
  finally
    lForma.Free;
  end;
end;

procedure TfrmDocumentoEmpresa.FormCreate(Sender: TObject);
begin
  if not (dmMemoria.mtEmpresa.State in dsEditModes) then
    dmMemoria.mtEmpresa.Edit;
end;

procedure TfrmDocumentoEmpresa.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ModalResult <> mrOk then
    dmMemoria.mtEmpresa.Cancel;
end;

function TfrmDocumentoEmpresa.ControlesEdicion: TArray<TControl>;
begin
  Result := [pnlCampos];
end;

procedure TfrmDocumentoEmpresa.btnGuardarClick(Sender: TObject);
begin
  dmMemoria.Confirmar(dmMemoria.mtEmpresa);
  ModalResult := mrOk;
end;

end.
