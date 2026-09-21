unit Anovo.UI.Requeridos;

// Los campos obligatorios, con lo que ya trae RosiComp.
//
// Al salir de un control data-aware de Rosi, si el TField tiene Required y
// quedo vacio, el componente llama a este manejador y, si se le dice que no
// puede salir, devuelve el foco al campo solo (RosiCompGlobalCfg.pas,
// TrDBComponentsCfg.DoExitControl).
//
// Con eso, marcar un campo como obligatorio es una propiedad de la tabla y no
// codigo en cada ventana. La etiqueta tambien lo muestra sola: TDBBoundLabel
// trae ShowRequiredMark encendido de fabrica.
//
// Lo que Rosi revisa es solo que no este vacio. El largo de la identificacion,
// la forma del correo y los ocho digitos del telefono los sigue viendo
// Anovo.Validacion al guardar.

interface

// Se engancha una vez al arrancar, antes de crear los formularios.
procedure EngancharRequeridos;

implementation

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Vcl.Dialogs,
  Vcl.Controls,
  System.UITypes,
  RosiCompGlobalCfg;

type
  // El evento de Rosi es un metodo de objeto, asi que hace falta alguien que
  // lo sea. Vive lo que dura la aplicacion.
  TManejadorRequeridos = class
    procedure AlSalir(Sender: TObject; AField: TField;
      var ACanExit: Boolean);
  end;

var
  Manejador: TManejadorRequeridos;

procedure TManejadorRequeridos.AlSalir(Sender: TObject; AField: TField;
  var ACanExit: Boolean);
begin
  // DisplayLabel es el rotulo que ve la persona, no el nombre de la columna.
  MessageDlg(Format('%s es obligatorio.', [AField.DisplayLabel]),
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
