unit Anovo.Forms.Periodo;

// Dialogo del periodo de busqueda (atajos y fechas) y el selector que lo abre
// desde el boton de la barra de un listado.

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.TitleBarCtrls, Vcl.WinXCtrls, Anovo.UI.PanelRelativo,
  VclPlano.BotonWin,
  Anovo.PeriodoBusqueda,
  Anovo.Forms.Edicion;

type
  TfrmPeriodo = class(TfrmEdicion)
    pnlCampos: TPanel;
    lblAtajos: TLabel;
    rbHoy: TRadioButton;
    rbEstaSemana: TRadioButton;
    rbEsteMes: TRadioButton;
    rbMesAnterior: TRadioButton;
    rbTresMeses: TRadioButton;
    rbEsteAnio: TRadioButton;
    rbPersonalizado: TRadioButton;
    rbTodas: TRadioButton;
    lblFechas: TLabel;
    lblDesde: TLabel;
    dtpDesde: TDateTimePicker;
    lblHasta: TLabel;
    dtpHasta: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure AtajoClick(Sender: TObject);
    procedure FechasChange(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
  private
    FAtajos: array [TAtajoPeriodo] of TRadioButton;
    FObligatorio: Boolean;
    FPoniendo: Boolean;
    FPeriodo: TPeriodoBusqueda;
    procedure Poner(const APeriodo: TPeriodoBusqueda);
    procedure PonerFecha(const AControl: TDateTimePicker;
      const AFecha: TDateTime);
    function FechaDe(const AControl: TDateTimePicker): TDateTime;
    function AtajoMarcado: TAtajoPeriodo;
    function PeriodoElegido: TPeriodoBusqueda;
  public
    class function Elegir(AOwner: TComponent; var APeriodo: TPeriodoBusqueda;
      const AObligatorio: Boolean): Boolean;
  end;

  TCambioPeriodo = procedure(const APeriodo: TPeriodoBusqueda) of object;

  TSelectorPeriodo = class(TComponent)
  private
    FBoton: TPlanoBotonWin;
    FPeriodo: TPeriodoBusqueda;
    FObligatorio: Boolean;
    FOnCambio: TCambioPeriodo;
    procedure BotonClick(Sender: TObject);
  public
    constructor Crear(const ABoton: TPlanoBotonWin;
      const AObligatorio: Boolean; const AOnCambio: TCambioPeriodo);
    procedure Mostrar(const APeriodo: TPeriodoBusqueda);
    property Periodo: TPeriodoBusqueda read FPeriodo;
  end;

implementation

{$R *.dfm}

uses
  System.DateUtils,
  Anovo.UI.Iconos,
  Anovo.Textos;

const
  ICONO_CALENDARIO = 'Azul\27-calendario-azul';

class function TfrmPeriodo.Elegir(AOwner: TComponent;
  var APeriodo: TPeriodoBusqueda; const AObligatorio: Boolean): Boolean;
var
  lForma: TfrmPeriodo;
begin
  lForma := TfrmPeriodo.Create(AOwner);
  try
    lForma.FObligatorio := AObligatorio;
    lForma.rbTodas.Visible := not AObligatorio;
    lForma.dtpDesde.ShowCheckbox := not AObligatorio;
    lForma.dtpHasta.ShowCheckbox := not AObligatorio;
    if AObligatorio then
      lForma.lblSubtitulo.Caption := SPeriodoAyudaObligatorio;
    lForma.Poner(APeriodo);
    Result := lForma.ShowModal = mrOk;
    if Result then
      APeriodo := lForma.FPeriodo;
  finally
    lForma.Free;
  end;
end;

procedure TfrmPeriodo.FormCreate(Sender: TObject);
var
  lAtajo: TAtajoPeriodo;
begin
  FAtajos[apTodas] := rbTodas;
  FAtajos[apHoy] := rbHoy;
  FAtajos[apEstaSemana] := rbEstaSemana;
  FAtajos[apEsteMes] := rbEsteMes;
  FAtajos[apMesAnterior] := rbMesAnterior;
  FAtajos[apTresMeses] := rbTresMeses;
  FAtajos[apEsteAnio] := rbEsteAnio;
  FAtajos[apPersonalizado] := rbPersonalizado;
  for lAtajo := Low(TAtajoPeriodo) to High(TAtajoPeriodo) do
    FAtajos[lAtajo].Caption := TPeriodoBusqueda.Nombre(lAtajo);
  lblTitulo.Caption := SPeriodoTitulo;
  lblSubtitulo.Caption := SPeriodoAyuda;
  btnGuardar.Caption := SBotonAplicar;
end;

procedure TfrmPeriodo.Poner(const APeriodo: TPeriodoBusqueda);
begin
  FPoniendo := True;
  try
    FAtajos[APeriodo.Atajo].Checked := True;
    PonerFecha(dtpDesde, APeriodo.Desde);
    PonerFecha(dtpHasta, APeriodo.Hasta);
  finally
    FPoniendo := False;
  end;
end;

procedure TfrmPeriodo.PonerFecha(const AControl: TDateTimePicker;
  const AFecha: TDateTime);
begin
  if AFecha > 0 then
    AControl.Date := AFecha
  else
    AControl.Date := Date;
  if AControl.ShowCheckbox then
    AControl.Checked := AFecha > 0;
end;

function TfrmPeriodo.FechaDe(const AControl: TDateTimePicker): TDateTime;
begin
  Result := 0;
  if FObligatorio or AControl.Checked then
    Result := DateOf(AControl.Date);
end;

function TfrmPeriodo.AtajoMarcado: TAtajoPeriodo;
var
  lAtajo: TAtajoPeriodo;
begin
  Result := apPersonalizado;
  for lAtajo := Low(TAtajoPeriodo) to High(TAtajoPeriodo) do
    if FAtajos[lAtajo].Checked then
      Exit(lAtajo);
end;

function TfrmPeriodo.PeriodoElegido: TPeriodoBusqueda;
var
  lAtajo: TAtajoPeriodo;
begin
  lAtajo := AtajoMarcado;
  if lAtajo = apPersonalizado then
    Result := TPeriodoBusqueda.Personalizado(FechaDe(dtpDesde),
      FechaDe(dtpHasta))
  else
    Result := TPeriodoBusqueda.De(lAtajo);
end;

procedure TfrmPeriodo.AtajoClick(Sender: TObject);
var
  lAtajo: TAtajoPeriodo;
begin
  if FPoniendo then
    Exit;
  lAtajo := AtajoMarcado;
  if lAtajo <> apPersonalizado then
    Poner(TPeriodoBusqueda.De(lAtajo));
end;

procedure TfrmPeriodo.FechasChange(Sender: TObject);
begin
  if FPoniendo then
    Exit;
  FPoniendo := True;
  try
    rbPersonalizado.Checked := True;
  finally
    FPoniendo := False;
  end;
end;

procedure TfrmPeriodo.btnGuardarClick(Sender: TObject);
var
  lPeriodo: TPeriodoBusqueda;
  lMensaje: string;
begin
  lPeriodo := PeriodoElegido;
  if not lPeriodo.Validar(lMensaje) then
  begin
    MostrarError(lMensaje);
    dtpDesde.SetFocus;
    Exit;
  end;
  FPeriodo := lPeriodo;
  ModalResult := mrOk;
end;

constructor TSelectorPeriodo.Crear(const ABoton: TPlanoBotonWin;
  const AObligatorio: Boolean; const AOnCambio: TCambioPeriodo);
begin
  inherited Create(ABoton);
  FBoton := ABoton;
  FObligatorio := AObligatorio;
  FOnCambio := AOnCambio;
  FBoton.Images := dmIconos.ViAnovo;
  FBoton.ImageIndex := dmIconos.ViAnovo.GetIndexByName(ICONO_CALENDARIO);
  FBoton.OnClick := BotonClick;
  Mostrar(TPeriodoBusqueda.De(apTodas));
end;

procedure TSelectorPeriodo.Mostrar(const APeriodo: TPeriodoBusqueda);
begin
  FPeriodo := APeriodo;
  FBoton.Caption := FPeriodo.Texto;
end;

procedure TSelectorPeriodo.BotonClick(Sender: TObject);
var
  lPeriodo: TPeriodoBusqueda;
begin
  lPeriodo := FPeriodo;
  if not TfrmPeriodo.Elegir(FBoton, lPeriodo, FObligatorio) then
    Exit;
  Mostrar(lPeriodo);
  if Assigned(FOnCambio) then
    FOnCambio(lPeriodo);
end;

end.
