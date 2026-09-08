program AnovoEscritorio;

uses
  Vcl.Forms,
  Main in 'Src\Sources\Main.pas' {Form16},
  Anovo.Forms.Login in 'Src\Forms\Anovo.Forms.Login.pas' {frmLogin},
  Anovo.UI.Iconos in 'Src\Recursos\Anovo.UI.Iconos.pas' {dmIconos: TDataModule},
  Anovo.UI.Tema in 'Src\Recursos\Anovo.UI.Tema.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
    TStyleManager.TrySetStyle('Windows10', False);
  Application.CreateForm(TdmIconos, dmIconos);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TForm16, Form16);
  Application.Run;
end.
