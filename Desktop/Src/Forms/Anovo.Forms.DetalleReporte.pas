unit Anovo.Forms.DetalleReporte;

// Cotizaciones detras de una fila del reporte (HU-06): lista de solo lectura
// con Abrir; devuelve la cotizacion elegida para mostrarla encima.

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.TitleBarCtrls, Vcl.WinXCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB,
  rDBGrid, Anovo.UI.PanelRelativo,
  VclPlano.BotonWin,
  Anovo.Forms.Edicion,
  Anovo.DTOs.Cotizaciones;

type
  TAccionDetalleReporte = (adrAbrir);
  TAccionesDetalleReporte = set of TAccionDetalleReporte;

  TfrmDetalleReporte = class(TfrmEdicion)
    grDetalle: TrDBGrid;
    lblPie: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure grDetalleDblClick(Sender: TObject);
  private
    FAbrir: Integer;
    procedure Accion(Sender: TObject; const AClave: string);
    procedure Abrir;
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    class function Mostrar(AOwner: TComponent; const ATitulo, AAyuda: string;
      const AFilas: TObjectList<TCotizacionDTO>): Integer;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.UI.CeldasRejilla,
  Anovo.Formato,
  Anovo.Textos;

const
  CAMPO_ESTADO = 'ESTADO';
  CAMPO_ACCIONES = 'ACCIONES';
  ACCIONES: array [TAccionDetalleReporte] of TAccionRejilla =
    ((Clave: 'abrir'; Rotulo: SAccionAbrir));

class function TfrmDetalleReporte.Mostrar(AOwner: TComponent;
  const ATitulo, AAyuda: string;
  const AFilas: TObjectList<TCotizacionDTO>): Integer;
var
  lForma: TfrmDetalleReporte;
begin
  lForma := TfrmDetalleReporte.Create(AOwner);
  try
    lForma.lblTitulo.Caption := ATitulo;
    lForma.lblSubtitulo.Caption := AAyuda;
    TCeldasRejilla.De(lForma.grDetalle)
      .PonerAcciones<TAccionesDetalleReporte>(ACCIONES, [adrAbrir]);
    TMapeoDatos.AListaTabla<TCotizacionDTO>(AFilas, dmMemoria.mtDetalleReporte);
    lForma.lblPie.Caption := TFormato.Cantidad(
      dmMemoria.mtDetalleReporte.RecordCount, SDetalleReportePieUno,
      SDetalleReportePie);
    TCeldasRejilla.De(lForma.grDetalle).AjustarColumnas;
    lForma.ShowModal;
    Result := lForma.FAbrir;
  finally
    lForma.Free;
  end;
end;

procedure TfrmDetalleReporte.FormCreate(Sender: TObject);
var
  lRejilla: TCeldasRejilla;
begin
  AplicarTemaGrid(grDetalle);
  lRejilla := TCeldasRejilla.De(grDetalle);
  lRejilla.TextoVacio := SVacioDetalleReporte;
  lRejilla.ColumnaEstado(CAMPO_ESTADO);
  lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
  lRejilla.OnAccion := Accion;
  btnGuardar.Caption := SBotonCerrar;
  btnCancelar.Visible := False;
end;

procedure TfrmDetalleReporte.FormDestroy(Sender: TObject);
begin
  dmMemoria.mtDetalleReporte.Close;
end;

function TfrmDetalleReporte.ControlesEdicion: TArray<TControl>;
begin
  Result := [grDetalle];
end;

procedure TfrmDetalleReporte.Accion(Sender: TObject; const AClave: string);
begin
  if SameText(AClave, ACCIONES[adrAbrir].Clave) then
    Abrir;
end;

procedure TfrmDetalleReporte.Abrir;
begin
  if dmMemoria.mtDetalleReporte.IsEmpty then
    Exit;
  FAbrir := dmMemoria.mtDetalleReporteID.AsInteger;
  ModalResult := mrOk;
end;

procedure TfrmDetalleReporte.btnGuardarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmDetalleReporte.grDetalleDblClick(Sender: TObject);
begin
  Abrir;
end;

end.
