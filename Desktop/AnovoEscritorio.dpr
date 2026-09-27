program AnovoEscritorio;

// Cliente de escritorio de Anovo: login, cambio de clave
// provisional y ventana principal.

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
  Anovo.Frames.Usuarios in 'Src\Frames\Anovo.Frames.Usuarios.pas' {fraUsuarios: TFrame},
  Anovo.Frames.Listado in 'Src\Frames\Anovo.Frames.Listado.pas' {fraListado: TFrame},
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
  Anovo.Frames.Dashboard.Asesor in 'Src\Frames\Anovo.Frames.Dashboard.Asesor.pas' {fraDashboardAsesor: TFrame},
  Anovo.Frames.GeneracionCotizacion in 'Src\Frames\Anovo.Frames.GeneracionCotizacion.pas' {fraGeneracionCotizacion: TFrame},
  Anovo.DTOs.Clientes in '..\Backend\src\DTOs\Anovo.DTOs.Clientes.pas',
  Anovo.DTOs.Auditoria in '..\Backend\src\DTOs\Anovo.DTOs.Auditoria.pas',
  Anovo.Textos in '..\Backend\src\Common\Anovo.Textos.pas',
  Anovo.DTOs.Dashboard in '..\Backend\src\DTOs\Anovo.DTOs.Dashboard.pas',
  Anovo.Api.Intf.Dashboard in 'Src\Interfaces\Anovo.Api.Intf.Dashboard.pas',
  Anovo.Api.Dashboard in 'Src\Api\Anovo.Api.Dashboard.pas',
  Anovo.Vistas.Intf.DashboardAsesor in 'Src\Interfaces\Anovo.Vistas.Intf.DashboardAsesor.pas',
  Anovo.Presentadores.DashboardAsesor in 'Src\Presentadores\Anovo.Presentadores.DashboardAsesor.pas',
  Anovo.Api.Intf.Solicitudes in 'Src\Interfaces\Anovo.Api.Intf.Solicitudes.pas',
  Anovo.Api.Solicitudes in 'Src\Api\Anovo.Api.Solicitudes.pas',
  Anovo.Vistas.Intf.Solicitudes in 'Src\Interfaces\Anovo.Vistas.Intf.Solicitudes.pas',
  Anovo.Presentadores.Solicitudes in 'Src\Presentadores\Anovo.Presentadores.Solicitudes.pas',
  Anovo.Frames.Solicitudes in 'Src\Frames\Anovo.Frames.Solicitudes.pas' {fraSolicitudes: TFrame},
  Anovo.UI.Vigencia in 'Src\Recursos\Anovo.UI.Vigencia.pas',
  Anovo.UI.Vista in 'Src\Recursos\Anovo.UI.Vista.pas',
  Anovo.DTOs.Catalogos in '..\Backend\src\DTOs\Anovo.DTOs.Catalogos.pas',
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
  Anovo.Mapeo.Datos in 'Src\Common\Anovo.Mapeo.Datos.pas',
  Anovo.Presentadores.Catalogos in 'Src\Presentadores\Anovo.Presentadores.Catalogos.pas',
  Anovo.Vistas.Intf.Catalogos in 'Src\Interfaces\Anovo.Vistas.Intf.Catalogos.pas',
  Anovo.Api.Catalogos in 'Src\Api\Anovo.Api.Catalogos.pas',
  Anovo.Api.Intf.Catalogos in 'Src\Interfaces\Anovo.Api.Intf.Catalogos.pas',
  Anovo.Forms.ItemCatalogo in 'Src\Forms\Anovo.Forms.ItemCatalogo.pas' {frmItemCatalogo},
  Anovo.Forms.PrecioCatalogo in 'Src\Forms\Anovo.Forms.PrecioCatalogo.pas' {frmPrecioCatalogo},
  Anovo.Presentadores.CatalogoItem in 'Src\Presentadores\Anovo.Presentadores.CatalogoItem.pas',
  Anovo.DTOs.Sesion in '..\Backend\src\DTOs\Anovo.DTOs.Sesion.pas',
  Anovo.Api.Intf.Configuracion in 'Src\Interfaces\Anovo.Api.Intf.Configuracion.pas',
  Anovo.Api.Configuracion in 'Src\Api\Anovo.Api.Configuracion.pas',
  Anovo.Vistas.Intf.Configuracion in 'Src\Interfaces\Anovo.Vistas.Intf.Configuracion.pas',
  Anovo.Presentadores.Configuracion in 'Src\Presentadores\Anovo.Presentadores.Configuracion.pas',
  Anovo.Frames.Configuracion in 'Src\Frames\Anovo.Frames.Configuracion.pas' {fraConfiguracion: TFrame},
  Anovo.Forms.Edicion in 'Src\Forms\Anovo.Forms.Edicion.pas' {frmEdicion},
  Anovo.Forms.CambioClave in 'Src\Forms\Anovo.Forms.CambioClave.pas' {frmCambioClave},
  Anovo.Forms.Conexion in 'Src\Forms\Anovo.Forms.Conexion.pas' {frmConexion};

{$R *.res}

var
  lLogin: TfrmLogin;
  lDestino: TModalResult;

begin

  TStyleManager.TrySetStyle('Windows10', False);

  Application.Initialize;
  Application.MainFormOnTaskbar := true;
  EngancharRequeridos;
  Application.CreateForm(TdmIconos, dmIconos);
  Application.CreateForm(TdmMemoria, dmMemoria);
  repeat
    lLogin := TfrmLogin.Create(nil);
    try
      lDestino := lLogin.ShowModal;
    finally
      lLogin.Free;
    end;

    if lDestino = mrRetry then
    begin
      if TfrmCambioClave.Mostrar(nil, True) then
        MessageDlg(SClaveCambiadaReingreso, mtInformation, [mbOK], 0)
      else
        lDestino := mrCancel;
      TSesion.Cerrar;
    end;
  until lDestino <> mrRetry;

  if lDestino = mrOk then
  begin
    Application.CreateForm(TfrmPrincipal, frmPrincipal);
    Application.Run;
  end;

end.
