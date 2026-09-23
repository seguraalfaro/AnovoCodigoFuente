program AnovoEscritorio;

uses
  Vcl.Dialogs,
  System.UITypes,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  Anovo.UI.Requeridos in 'Src\Recursos\Anovo.UI.Requeridos.pas',
  Anovo.UI.Tema in 'Src\Recursos\Anovo.UI.Tema.pas',
  Anovo.UI.Iconos in 'Src\Recursos\Anovo.UI.Iconos.pas' {dmIconos: TDataModule},
  Anovo.Forms.Login in 'Src\Forms\Anovo.Forms.Login.pas' {frmLogin},
  Anovo.Forms.Principal in 'Src\Forms\Anovo.Forms.Principal.pas' {frmPrincipal},
  Anovo.Frames.Cotizaciones in 'Src\Frames\Anovo.Frames.Cotizaciones.pas' {fraCotizaciones: TFrame},
  Anovo.Frames.Clientes in 'Src\Frames\Anovo.Frames.Clientes.pas' {fraClientes: TFrame},
  Anovo.Frames.Roles in 'Src\Frames\Anovo.Frames.Roles.pas' {fraRoles: TFrame},
  Anovo.Frames.Catalogos in 'Src\Frames\Anovo.Frames.Catalogos.pas' {fraCatalogos: TFrame},
  Anovo.UI.DBGridExtend in 'Src\Recursos\Anovo.UI.DBGridExtend.pas',
  Anovo.Sesion in 'Src\Common\Anovo.Sesion.pas',
  Anovo.Config in 'Src\Common\Anovo.Config.pas',
  Anovo.Api.Base in 'Src\Api\Anovo.Api.Base.pas',
  Anovo.Api.Intf.Autenticacion in 'Src\Interfaces\Anovo.Api.Intf.Autenticacion.pas',
  Anovo.Api.Autenticacion in 'Src\Api\Anovo.Api.Autenticacion.pas',
  Anovo.Vistas.Intf.Login in 'Src\Interfaces\Anovo.Vistas.Intf.Login.pas',
  Anovo.Presentadores.Login in 'Src\Presentadores\Anovo.Presentadores.Login.pas',
  Anovo.Vistas.Intf.Principal in 'Src\Interfaces\Anovo.Vistas.Intf.Principal.pas',
  Anovo.Presentadores.Principal in 'Src\Presentadores\Anovo.Presentadores.Principal.pas',
  Anovo.Forms.AgregarItem in 'Src\Forms\Anovo.Forms.AgregarItem.pas' {frmAgregarItem},
  Anovo.Frames.Usuarios in 'Src\Frames\Anovo.Frames.Usuarios.pas' {fraUsuarios: TFrame},
  Anovo.Frames.Auditoria in 'Src\Frames\Anovo.Frames.Auditoria.pas' {fraAuditoria: TFrame},
  Anovo.Frames.Bandeja in 'Src\Frames\Anovo.Frames.Bandeja.pas' {fraBandeja: TFrame},
  Anovo.Cancelacion in 'Src\Common\Anovo.Cancelacion.pas',
  Anovo.Vistas.Intf.ClienteDatos in 'Src\Interfaces\Anovo.Vistas.Intf.ClienteDatos.pas',
  Anovo.Presentadores.ClienteDatos in 'Src\Presentadores\Anovo.Presentadores.ClienteDatos.pas',
  Anovo.Vistas.Intf.Registro in 'Src\Interfaces\Anovo.Vistas.Intf.Registro.pas',
  Anovo.Presentadores.Registro in 'Src\Presentadores\Anovo.Presentadores.Registro.pas',
  Anovo.Forms.ClienteNuevo in 'Src\Forms\Anovo.Forms.ClienteNuevo.pas' {frmClienteNuevo},
  Anovo.Forms.ContactoNuevo in 'Src\Forms\Anovo.Forms.ContactoNuevo.pas' {frmContactoNuevo},
  Anovo.Frames.ClienteDatos in 'Src\Frames\Anovo.Frames.ClienteDatos.pas' {TfraClienteDatos: TFrame},
  Anovo.Frames.Dashboard.Gerencia in 'Src\Frames\Anovo.Frames.Dashboard.Gerencia.pas' {fraDashboardGerencia: TFrame},
  Anovo.Frames.Dashboard in 'Src\Frames\Anovo.Frames.Dashboard.pas' {fraDashboard: TFrame},
  Anovo.Frames.GeneracionCotizacion in 'Src\Frames\Anovo.Frames.GeneracionCotizacion.pas' {fraGeneracionCotizacion: TFrame},
  Anovo.DTOs.Clientes in '..\Backend\src\DTOs\Anovo.DTOs.Clientes.pas',
  Anovo.DTOs.Auditoria in '..\Backend\src\DTOs\Anovo.DTOs.Auditoria.pas',
  Anovo.Api.Intf.Auditoria in 'Src\Interfaces\Anovo.Api.Intf.Auditoria.pas',
  Anovo.Api.Auditoria in 'Src\Api\Anovo.Api.Auditoria.pas',
  Anovo.Vistas.Intf.Auditoria in 'Src\Interfaces\Anovo.Vistas.Intf.Auditoria.pas',
  Anovo.Presentadores.Auditoria in 'Src\Presentadores\Anovo.Presentadores.Auditoria.pas',
  Anovo.Api.Intf.Clientes in 'Src\Interfaces\Anovo.Api.Intf.Clientes.pas',
  Anovo.Api.Clientes in 'Src\Api\Anovo.Api.Clientes.pas',
  Anovo.Vistas.Intf.Clientes in 'Src\Interfaces\Anovo.Vistas.Intf.Clientes.pas',
  Anovo.Presentadores.Clientes in 'Src\Presentadores\Anovo.Presentadores.Clientes.pas',
  Anovo.Datos.Memoria in 'Src\Datos\Anovo.Datos.Memoria.pas' {dmMemoria: TDataModule},
  Anovo.Formato in 'Src\Common\Anovo.Formato.pas',
  Anovo.Validacion in 'Src\Common\Anovo.Validacion.pas',
  Anovo.Mapeo.Datos in 'Src\Common\Anovo.Mapeo.Datos.pas';

{$R *.res}

var
  lLogin: TfrmLogin;
  lDestino: TModalResult;

begin

  TStyleManager.TrySetStyle('Windows10', False);

  Application.Initialize;
  Application.MainFormOnTaskbar := true;
  // Los campos con Required avisan solos al salir del control.
  EngancharRequeridos;
  Application.CreateForm(TdmIconos, dmIconos);
  Application.CreateForm(TdmMemoria, dmMemoria);
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
