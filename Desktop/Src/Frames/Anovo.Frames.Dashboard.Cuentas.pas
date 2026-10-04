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
  Anovo.Vistas.Intf.Dashboard,
  Anovo.Presentadores.Dashboard;

type
  TfraDashboardCuentas = class(TfraDashboard, IVistaDashboard<TDashboardCuentasDTO>)
  private
    FPresentador: TPresentadorDashboard<TDashboardCuentasDTO>;
    procedure MostrarDashboard(const ADatos: TDashboardCuentasDTO);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Api.Intf.Dashboard,
  Anovo.Api.Dashboard,
  Anovo.Formato,
  Anovo.Datos.Memoria;

constructor TfraDashboardCuentas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPresentador := TPresentadorDashboard<TDashboardCuentasDTO>.Create(Self,
    TApiDashboard.Create,
    function(AApi: IApiDashboard): TDashboardCuentasDTO
    begin
      Result := AApi.Cuentas;
    end);
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
