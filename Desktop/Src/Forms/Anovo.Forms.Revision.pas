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
    lblMotivoAjusteRot: TLabel;
    lblMotivoAjuste: TLabel;
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
    FRevisada: Boolean;
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarCotizacion(const ACotizacion: TCotizacionDTO;
      const ALineas: TObjectList<TLineaDTO>);
    procedure MostrarProcesando(const AActivo: Boolean);
    procedure Revisada;
    function Confirmar(const AMensaje: string): Boolean;
    function PedirMotivo(const ATitulo: string; out AMotivo: string): Boolean;
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
  Anovo.UI.CeldasRejilla,
  Anovo.Api.Cotizaciones,
  Anovo.Forms.Motivo,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.TotalesCotizacion,
  Anovo.Textos;

class function TfrmRevision.Mostrar(AOwner: TComponent;
  const AId: Integer): Boolean;
var
  lForma: TfrmRevision;
begin
  lForma := TfrmRevision.Create(AOwner);
  try
    lForma.FPresentador.Iniciar(AId);
    lForma.ShowModal;
    Result := lForma.FRevisada;
  finally
    lForma.Free;
  end;
end;

procedure TfrmRevision.FormCreate(Sender: TObject);
begin
  AplicarTemaGrid(grLineas);
  TCeldasRejilla.De(grLineas).TextoVacio := SVacioLineas;
  lblTitulo.Caption := '';
  lblSubtitulo.Caption := '';
  FPresentador := TPresentadorRevision.Create(Self, TApiCotizaciones.Create);
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
var
  lTotales: TTotalesCotizacion;
begin
  lblTitulo.Caption := Format(SCotizacionNumero, [ACotizacion.Numero]);
  lblSubtitulo.Caption := Format(SRevisionSubtitulo,
    [ACotizacion.ClienteNombre, ACotizacion.AsesorNombre,
    ACotizacion.ElaboradaPorNombre]);
  lblTrabajo.Caption := ACotizacion.DescripcionTrabajo;

  lTotales := TTotalesCotizacion.De(ACotizacion);
  lblMateriales.Caption := lTotales.Materiales;
  lblManoObra.Caption := lTotales.ManoObra;
  lblMaquina.Caption := lTotales.Maquina;
  lblCosto.Caption := lTotales.Costo;
  lblAjusteRot.Caption := lTotales.AjusteRotulo;
  lblAjuste.Caption := lTotales.Ajuste;
  lblMotivoAjuste.Caption := lTotales.MotivoAjuste;
  lblMotivoAjusteRot.Visible := not lTotales.MotivoAjuste.IsEmpty;
  lblMotivoAjuste.Visible := lblMotivoAjusteRot.Visible;
  lblIvaRot.Caption := lTotales.IvaRotulo;
  lblIva.Caption := lTotales.Iva;
  lblTotal.Caption := lTotales.Total;

  TMapeoDatos.AListaTabla<TLineaDTO>(ALineas, dmMemoria.mtRevisionLineas);
  Anovo.UI.CeldasRejilla.AjustarColumnas(grLineas);
end;

procedure TfrmRevision.Revisada;
begin
  FRevisada := True;
  ModalResult := mrOk;
end;

procedure TfrmRevision.btnGuardarClick(Sender: TObject);
begin
  FPresentador.DarVistoBueno;
end;

procedure TfrmRevision.btnDevolverClick(Sender: TObject);
begin
  FPresentador.Devolver;
end;

function TfrmRevision.Confirmar(const AMensaje: string): Boolean;
begin
  Result := Anovo.UI.Vista.Confirmar(AMensaje);
end;

function TfrmRevision.PedirMotivo(const ATitulo: string;
  out AMotivo: string): Boolean;
begin
  Result := TfrmMotivo.Pedir(Self, ATitulo, SDevolverAyuda, SBotonDevolver,
    AMotivo);
end;


end.
