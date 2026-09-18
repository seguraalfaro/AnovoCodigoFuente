program AnovoEscritorio;

uses
  Vcl.Dialogs,
  System.UITypes,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Anovo.UI.Tema in 'Src\Recursos\Anovo.UI.Tema.pas',
  Anovo.UI.Iconos
    in 'Src\Recursos\Anovo.UI.Iconos.pas' {dmIconos: TDataModule} ,
  Anovo.Forms.Login in 'Src\Forms\Anovo.Forms.Login.pas' {frmLogin} ,
  Anovo.Forms.Principal
    in 'Src\Forms\Anovo.Forms.Principal.pas' {frmPrincipal} ,
  Anovo.Frames.Cotizaciones
    in 'Src\Frames\Anovo.Frames.Cotizaciones.pas' {fraCotizaciones: TFrame} ,
  Anovo.Frames.Clientes
    in 'Src\Frames\Anovo.Frames.Clientes.pas' {fraClientes: TFrame} ,
  Anovo.Frames.Roles in 'Src\Frames\Anovo.Frames.Roles.pas' {fraRoles: TFrame} ,
  Anovo.Frames.Catalogos
    in 'Src\Frames\Anovo.Frames.Catalogos.pas' {fraCatalogos: TFrame} ,
  Anovo.UI.TemaGrid in 'Src\Recursos\Anovo.UI.TemaGrid.pas',
  Anovo.Sesion in 'Src\Common\Anovo.Sesion.pas',
  Anovo.Config in 'Src\Common\Anovo.Config.pas',
  Anovo.Api.Base in 'Src\Api\Anovo.Api.Base.pas',
  Anovo.Api.Intf.Autenticacion
    in 'Src\Interfaces\Anovo.Api.Intf.Autenticacion.pas',
  Anovo.Api.Autenticacion in 'Src\Api\Anovo.Api.Autenticacion.pas',
  Anovo.Vistas.Intf.Login in 'Src\Interfaces\Anovo.Vistas.Intf.Login.pas',
  Anovo.Presentadores.Login
    in 'Src\Presentadores\Anovo.Presentadores.Login.pas',
  Anovo.Vistas.Intf.Principal
    in 'Src\Interfaces\Anovo.Vistas.Intf.Principal.pas',
  Anovo.Presentadores.Principal
    in 'Src\Presentadores\Anovo.Presentadores.Principal.pas',
  Anovo.Forms.AgregarItem
    in 'Src\Forms\Anovo.Forms.AgregarItem.pas' {frmAgregarItem} ,
  Anovo.Frames.Usuarios
    in 'Src\Frames\Anovo.Frames.Usuarios.pas' {fraUsuarios: TFrame} ,
  Anovo.Frames.Auditoria
    in 'Src\Frames\Anovo.Frames.Auditoria.pas' {fraAuditoria: TFrame} ,
  Anovo.Frames.Bandeja
    in 'Src\Frames\Anovo.Frames.Bandeja.pas' {fraBandeja: TFrame} ,
  Anovo.Frames.ClienteDatos
    in 'Src\Frames\Anovo.Frames.ClienteDatos.pas' {Frame1: TFrame} ,
  Anovo.Frames.Dashboard.Gerencia
    in 'Src\Frames\Anovo.Frames.Dashboard.Gerencia.pas' {fraDashboardGerencia: TFrame} ,
  Anovo.Frames.Dashboard
    in 'Src\Frames\Anovo.Frames.Dashboard.pas' {fraDashboard: TFrame} ,
  Anovo.Frames.GeneracionCotizacion
    in 'Src\Frames\Anovo.Frames.GeneracionCotizacion.pas' {fraGeneracionCotizacion: TFrame};

{$R *.res}

var
  lLogin: TfrmLogin;
  lDestino: TModalResult;

begin

  TStyleManager.TrySetStyle('Windows10', False);

  Application.Initialize;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TdmIconos, dmIconos);
  lLogin := TfrmLogin.Create(nil);
  try
    lDestino := lLogin.ShowModal;
  finally
    lLogin.Free;
  end;

  case lDestino of
    mrOk:
      begin
        { El primer formulario creado con CreateForm pasa a ser el principal. }
        Application.CreateForm(TfrmPrincipal, frmPrincipal);
        Application.Run;
      end;
    mrRetry:
      { Clave provisional: aqui ira el formulario de cambio de clave. }
      MessageDlg('Debe cambiar su clave antes de continuar.', mtInformation,
        [mbOK], 0);
  end;

end.
