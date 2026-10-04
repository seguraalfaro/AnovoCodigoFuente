unit Anovo.UI.Requeridos;

// Aviso de campos obligatorios vacios en los controles de RosiComp.

interface

procedure EngancharRequeridos;

implementation

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Vcl.Controls,
  RosiCompGlobalCfg,
  Anovo.UI.Vista,
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
  AvisarError(Format(SCampoObligatorio, [AField.DisplayLabel]));
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
