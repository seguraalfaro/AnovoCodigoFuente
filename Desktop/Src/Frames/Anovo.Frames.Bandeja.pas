unit Anovo.Frames.Bandeja;

// Seccion Bandeja de aprobacion del supervisor: cotizaciones
// pendientes de revision.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.WinXCtrls, Anovo.UI.PanelRelativo, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.BotonWin, VclPlano.Tarjeta,
  Anovo.PeriodoBusqueda,
  Anovo.Forms.Periodo,
  Anovo.Frames.Listado,
  Anovo.DTOs.Cotizaciones,
  Anovo.Vistas.Intf.Bandeja,
  Anovo.Presentadores.Bandeja;

type
  TfraBandeja = class(TfraListado, IVistaBandeja)
    pnlKpi: TPanel;
    tjPendientes: TPlanoTarjeta;
    lblPendientes: TLabel;
    tjAntigua: TPlanoTarjeta;
    lblAntigua: TLabel;
    tjEspera: TPlanoTarjeta;
    lblEspera: TLabel;
    btnPeriodo: TPlanoBotonWin;
    procedure grDatosDblClick(Sender: TObject);
  private
    FPresentador: TPresentadorBandeja;
    FSelector: TSelectorPeriodo;
    procedure PeriodoCambio(const APeriodo: TPeriodoBusqueda);
    procedure MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure MostrarAcciones(const AAcciones: TAccionesBandeja);
    procedure Accion(Sender: TObject; const AClave: string);
    procedure Revisar;
    procedure MostrarBandeja(const ADatos: TBandejaPaginaDTO);
    function MostrarRevision(const AId: Integer): Boolean;
  protected
    procedure Buscar(const ATexto: string); override;
    procedure Limpiar; override;
    procedure PaginaAnterior; override;
    procedure PaginaSiguiente; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.CeldasRejilla,
  Anovo.Api.Cotizaciones,
  Anovo.Forms.Revision,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Formato,
  Anovo.Textos;

const
  CAMPO_ACCIONES = 'ACCIONES';
  ACCIONES: array [TAccionBandeja] of TAccionRejilla = ((Clave: 'revisar';
    Rotulo: SAccionRevisar));

constructor TfraBandeja.Create(AOwner: TComponent);
var
  lRejilla: TCeldasRejilla;
begin
  inherited Create(AOwner);
  FTextoCargando := SCargandoBandeja;
  FTextoSinRegistros := SSinBandeja;
  FTextoPaginacion := SPaginacionBandeja;

  lRejilla := TCeldasRejilla.De(grDatos);
  lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
  lRejilla.OnAccion := Accion;

  FSelector := TSelectorPeriodo.Crear(btnPeriodo, False, PeriodoCambio);

  FPresentador := TPresentadorBandeja.Create(Self, TApiCotizaciones.Create);
  FPresentador.Iniciar;
end;

destructor TfraBandeja.Destroy;
begin
  FreeAndNil(FPresentador);
  inherited;
end;

procedure TfraBandeja.Buscar(const ATexto: string);
begin
  FPresentador.Buscar(ATexto);
end;

procedure TfraBandeja.Limpiar;
begin
  FPresentador.Limpiar;
end;

procedure TfraBandeja.MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
begin
  FSelector.Mostrar(APeriodo);
end;

procedure TfraBandeja.PeriodoCambio(const APeriodo: TPeriodoBusqueda);
begin
  FPresentador.FiltrarPeriodo(APeriodo);
end;

procedure TfraBandeja.PaginaAnterior;
begin
  FPresentador.PaginaAnterior;
end;

procedure TfraBandeja.PaginaSiguiente;
begin
  FPresentador.PaginaSiguiente;
end;

procedure TfraBandeja.MostrarBandeja(const ADatos: TBandejaPaginaDTO);
begin
  lblPendientes.Caption := ADatos.PorAprobar.ToString;
  lblAntigua.Caption := TFormato.Dias(ADatos.DiasMasAntigua);
  lblEspera.Caption := TFormato.Colones(ADatos.MontoPorAprobar);
  TMapeoDatos.AListaTabla<TCotizacionBandejaDTO>(ADatos.Data,
    dmMemoria.mtBandeja);
end;

procedure TfraBandeja.Accion(Sender: TObject; const AClave: string);
begin
  if SameText(AClave, ACCIONES[abRevisar].Clave) then
    Revisar;
end;

procedure TfraBandeja.MostrarAcciones(const AAcciones: TAccionesBandeja);
begin
  TCeldasRejilla.De(grDatos).PonerAcciones<TAccionesBandeja>(ACCIONES,
    AAcciones);
end;

procedure TfraBandeja.grDatosDblClick(Sender: TObject);
begin
  Revisar;
end;

procedure TfraBandeja.Revisar;
begin
  if not dmMemoria.mtBandeja.IsEmpty then
    FPresentador.Revisar(dmMemoria.mtBandejaID.AsInteger);
end;

function TfraBandeja.MostrarRevision(const AId: Integer): Boolean;
begin
  Result := TfrmRevision.Mostrar(Self, AId);
end;

end.
