unit Anovo.Forms.Revision;

// Ventana de revision de una cotizacion: desglose y totales, y la
// decision del supervisor (aprobar, devolver o rechazar).

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.UITypes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.TitleBarCtrls, Vcl.WinXCtrls, Anovo.UI.PanelRelativo, Data.DB, Vcl.Grids,
  Vcl.DBGrids, rDBGrid,
  VclPlano.BotonWin,
  Anovo.Forms.Edicion,
  Anovo.DTOs.Cotizaciones,
  Anovo.Vistas.Intf.Revision,
  Anovo.Presentadores.Revision;

type
  TfrmRevision = class(TfrmEdicion, IVistaRevision)
    btnDevolver: TPlanoBotonWin;
    pnlTrabajo: TPanel;
    lblTrabajoRot: TLabel;
    lblTrabajo: TLabel;
    pnlTotales: TPanel;
    lblMaterialesRot: TLabel;
    lblMateriales: TLabel;
    lblManoObraRot: TLabel;
    lblManoObra: TLabel;
    lblMaquinaRot: TLabel;
    lblMaquina: TLabel;
    lblCostoRot: TLabel;
    lblCosto: TLabel;
    lblAjusteRot: TLabel;
    lblAjuste: TLabel;
    lblIvaRot: TLabel;
    lblIva: TLabel;
    lblTotalRot: TLabel;
    lblTotal: TLabel;
    grLineas: TrDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure btnDevolverClick(Sender: TObject);
  private
    FPresentador: TPresentadorRevision;
    FId: Integer;
    FNumero: Integer;
    FRevisada: Boolean;
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarCotizacion(const ACotizacion: TCotizacionDTO;
      const ALineas: TObjectList<TLineaDTO>);
    procedure MostrarProcesando(const AActivo: Boolean);
    procedure Revisada;
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    class function Mostrar(AOwner: TComponent; const AId: Integer): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.Vista,
  Anovo.UI.Tema,
  Anovo.UI.DBGridExtend,
  Anovo.Api.Cotizaciones,
  Anovo.Forms.Motivo,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Formato,
  Anovo.Textos;

class function TfrmRevision.Mostrar(AOwner: TComponent;
  const AId: Integer): Boolean;
var
  lForma: TfrmRevision;
begin
  lForma := TfrmRevision.Create(AOwner);
  try
    lForma.FId := AId;
    lForma.FPresentador := TPresentadorRevision.Create(lForma,
      TApiCotizaciones.Create, AId);
    lForma.FPresentador.Iniciar;
    lForma.ShowModal;
    Result := lForma.FRevisada;
  finally
    lForma.Free;
  end;
end;

procedure TfrmRevision.FormCreate(Sender: TObject);
begin
  AplicarTemaGrid(grLineas);
  lblTitulo.Caption := '';
  lblSubtitulo.Caption := '';
end;

procedure TfrmRevision.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPresentador);
end;

function TfrmRevision.ControlesEdicion: TArray<TControl>;
begin
  Result := [btnDevolver];
end;

procedure TfrmRevision.MostrarCargando(const AActivo: Boolean);
begin
  MostrarOcupado(AActivo);
end;

procedure TfrmRevision.MostrarProcesando(const AActivo: Boolean);
begin
  MostrarOcupado(AActivo);
end;

procedure TfrmRevision.MostrarCotizacion(const ACotizacion: TCotizacionDTO;
  const ALineas: TObjectList<TLineaDTO>);
begin
  FNumero := ACotizacion.Numero;
  lblTitulo.Caption := Format(SCotizacionNumero, [ACotizacion.Numero]);
  lblSubtitulo.Caption := Format(SRevisionSubtitulo,
    [ACotizacion.ClienteNombre, ACotizacion.AsesorNombre,
    ACotizacion.ElaboradaPorNombre]);
  lblTrabajo.Caption := ACotizacion.DescripcionTrabajo;

  lblMateriales.Caption :=
    TFormato.Colones(ACotizacion.SubtotalMateriales.ValueOrDefault);
  lblManoObra.Caption :=
    TFormato.Colones(ACotizacion.SubtotalManoObra.ValueOrDefault);
  lblMaquina.Caption :=
    TFormato.Colones(ACotizacion.SubtotalMaquina.ValueOrDefault);
  lblCosto.Caption := TFormato.Colones(ACotizacion.CostoTotal.ValueOrDefault);
  lblAjusteRot.Caption := Format(SAjustePorcentaje,
    [TFormato.Porcentaje(ACotizacion.PorcentajeAjuste)]);
  lblAjuste.Caption := ACotizacion.MotivoAjuste.ValueOrDefault;
  lblIvaRot.Caption := Format(SIvaPorcentaje,
    [TFormato.Porcentaje(ACotizacion.PorcentajeIva)]);
  lblIva.Caption := TFormato.Colones(ACotizacion.MontoImpuesto.ValueOrDefault);
  lblTotal.Caption := TFormato.Colones(ACotizacion.MontoTotal.ValueOrDefault);

  TMapeoDatos.AListaTabla<TLineaDTO>(ALineas, dmMemoria.mtRevisionLineas);
  Anovo.UI.DBGridExtend.AjustarColumnas(grLineas);
end;

procedure TfrmRevision.Revisada;
begin
  FRevisada := True;
  ModalResult := mrOk;
end;

procedure TfrmRevision.btnGuardarClick(Sender: TObject);
begin
  if Confirmar(Format(SConfirmarAprobar, [FNumero])) then
    FPresentador.DarVistoBueno;
end;

procedure TfrmRevision.btnDevolverClick(Sender: TObject);
var
  lMotivo: string;
begin
  if TfrmMotivo.Pedir(Self, Format(SDevolverTitulo, [FNumero]),
    SDevolverAyuda, SBotonDevolver, lMotivo) then
    FPresentador.Devolver(lMotivo);
end;


end.
