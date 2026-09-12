program AnovoEscritorio;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Anovo.UI.Tema in 'Src\Recursos\Anovo.UI.Tema.pas',
  Anovo.UI.Iconos in 'Src\Recursos\Anovo.UI.Iconos.pas' {dmIconos: TDataModule},
  Anovo.Forms.Login in 'Src\Forms\Anovo.Forms.Login.pas' {frmLogin},
  Anovo.Forms.Principal in 'Src\Forms\Anovo.Forms.Principal.pas' {frmPrincipal};

{$R *.res}

begin

   TStyleManager.TrySetStyle('Windows10', False);

  Application.Initialize;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TdmIconos, dmIconos);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.Run;
end.
