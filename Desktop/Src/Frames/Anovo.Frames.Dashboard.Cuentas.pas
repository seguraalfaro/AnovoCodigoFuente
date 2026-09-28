unit Anovo.Frames.Dashboard.Cuentas;

// Dashboard del administrador: cuentas de usuario
// y cambios recientes.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.Tarjeta,
  Anovo.Frames.Dashboard,
  Anovo.DTOs.Dashboard,
  Anovo.Vistas.Intf.DashboardCuentas,
  Anovo.Presentadores.DashboardCuentas;

type
  TfraDashboardCuentas = class(TfraDashboard, IVistaDashboardCuentas)
  private
    FPresentador: TPresentadorDashboardCuentas;
    procedure MostrarDashboard(const ADatos: TDashboardCuentasDTO);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Api.Dashboard,
  Anovo.Formato,
  Anovo.Datos.Memoria;

constructor TfraDashboardCuentas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPresentador := TPresentadorDashboardCuentas.Create(Self,
    TApiDashboard.Create);
  FPresentador.Iniciar;
end;

destructor TfraDashboardCuentas.Destroy;
begin
  FPresentador.Free;
  inherited;
end;

procedure TfraDashboardCuentas.MostrarDashboard(const ADatos
  : TDashboardCuentasDTO);
begin
  lblPeriodo.Caption := TFormato.MesAnio(ADatos.Desde);
  lblCifra1.Caption := ADatos.UsuariosActivos.ToString;
  lblCifra2.Caption := ADatos.UsuariosInactivos.ToString;
  lblCifra3.Caption := ADatos.ClavePendiente.ToString;
  lblCifra4.Caption := ADatos.CambiosMes.ToString;
  MostrarLista<TCambioCuentaDTO>(ADatos.Cambios,
    dmMemoria.mtDashboardCuentas);
end;

end.
