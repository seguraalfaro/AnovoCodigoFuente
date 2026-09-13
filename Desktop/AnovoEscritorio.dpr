program AnovoEscritorio;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Anovo.UI.Tema in 'Src\Recursos\Anovo.UI.Tema.pas',
  Anovo.UI.Iconos in 'Src\Recursos\Anovo.UI.Iconos.pas' {dmIconos: TDataModule},
  Anovo.Forms.Login in 'Src\Forms\Anovo.Forms.Login.pas' {frmLogin},
  Anovo.Forms.Principal in 'Src\Forms\Anovo.Forms.Principal.pas' {frmPrincipal},
  Anovo.Frames.Cotizaciones in 'Src\Frames\Anovo.Frames.Cotizaciones.pas' {fraCotizaciones: TFrame},
  Anovo.Frames.Clientes in 'Src\Frames\Anovo.Frames.Clientes.pas' {fraClientes: TFrame},
  Anovo.Frames.Roles in 'Src\Frames\Anovo.Frames.Roles.pas' {fraRoles: TFrame},
  Anovo.Frames.Catalogos in 'Src\Frames\Anovo.Frames.Catalogos.pas' {fraCatalogos: TFrame},
  Anovo.UI.TemaGrid in 'Src\Sources\Anovo.UI.TemaGrid.pas',
  Anovo.Cliente.Sesion in 'Src\Sources\Anovo.Cliente.Sesion.pas',
  Anovo.Forms.AgregarItem in 'Src\Forms\Anovo.Forms.AgregarItem.pas' {frmAgregarItem};

{$R *.res}

begin

  TStyleManager.TrySetStyle('Windows10', False);

  Application.Initialize;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TfrmAgregarItem, frmAgregarItem);
  Application.CreateForm(TdmIconos, dmIconos);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.Run;

end.
