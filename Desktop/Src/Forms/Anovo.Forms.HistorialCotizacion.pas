unit Anovo.Forms.HistorialCotizacion;

// Historial de estados de una cotizacion: cada paso con fecha, usuario y
// motivo, el mas reciente arriba (HU-07).

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
  TfrmHistorialCotizacion = class(TfrmEdicion)
    grHistorial: TrDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    class procedure Mostrar(AOwner: TComponent; const ANumero: Integer;
      const AEstados: TObjectList<TEstadoCotizacionDTO>);
  end;

implementation

{$R *.dfm}

uses
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.UI.CeldasRejilla,
  Anovo.Textos;

const
  CAMPO_ESTADO = 'ESTADO';

class procedure TfrmHistorialCotizacion.Mostrar(AOwner: TComponent;
  const ANumero: Integer; const AEstados: TObjectList<TEstadoCotizacionDTO>);
var
  lForma: TfrmHistorialCotizacion;
begin
  lForma := TfrmHistorialCotizacion.Create(AOwner);
  try
    lForma.Caption := Format(SHistorialTituloVentana, [ANumero]);
    TMapeoDatos.AListaTabla<TEstadoCotizacionDTO>(AEstados,
      dmMemoria.mtHistorialEstados);
    TCeldasRejilla.De(lForma.grHistorial).AjustarColumnas;
    lForma.ShowModal;
  finally
    lForma.Free;
  end;
end;

procedure TfrmHistorialCotizacion.FormCreate(Sender: TObject);
begin
  AplicarTemaGrid(grHistorial);
  TCeldasRejilla.De(grHistorial).ColumnaEstado(CAMPO_ESTADO);
  lblTitulo.Caption := SHistorialTitulo;
  lblSubtitulo.Caption := SHistorialAyuda;
  btnGuardar.Visible := False;
  btnCancelar.Caption := SBotonCerrar;
end;

procedure TfrmHistorialCotizacion.FormDestroy(Sender: TObject);
begin
  dmMemoria.mtHistorialEstados.Close;
end;

function TfrmHistorialCotizacion.ControlesEdicion: TArray<TControl>;
begin
  Result := [grHistorial];
end;

end.
