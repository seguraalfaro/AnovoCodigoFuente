unit Anovo.UI.Requeridos;

// Aviso de campos obligatorios vacios en los controles de RosiComp.

interface

procedure EngancharRequeridos;

implementation

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Vcl.Dialogs,
  Vcl.Controls,
  System.UITypes,
  RosiCompGlobalCfg,
  Anovo.Textos;

type
  TManejadorRequeridos = class
    procedure AlSalir(Sender: TObject; AField: TField;
      var ACanExit: Boolean);
  end;

var
  Manejador: TManejadorRequeridos;

procedure TManejadorRequeridos.AlSalir(Sender: TObject; AField: TField;
  var ACanExit: Boolean);
begin
  MessageDlg(Format(SCampoObligatorio, [AField.DisplayLabel]),
    mtWarning, [mbOK], 0);
  ACanExit := False;
end;

procedure EngancharRequeridos;
begin
  RosiCompConfig.rDBComponentsCfg.ExitControlEvent := Manejador.AlSalir;
end;

initialization

Manejador := TManejadorRequeridos.Create;

finalization

Manejador.Free;

end.
