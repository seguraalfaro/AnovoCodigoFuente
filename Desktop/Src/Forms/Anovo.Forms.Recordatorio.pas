unit Anovo.Forms.Recordatorio;

// Recordatorio al iniciar sesion: cotizaciones enviadas que llevan mas
// de los dias configurados sin respuesta del cliente (HU-07).

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
  TfrmRecordatorio = class(TfrmEdicion)
    grSinRespuesta: TrDBGrid;
    lblPie: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure grSinRespuestaDblClick(Sender: TObject);
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    class function Mostrar(AOwner: TComponent;
      const ACotizaciones: TObjectList<TCotizacionDTO>): Integer;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.UI.CeldasRejilla,
  Anovo.Textos;

class function TfrmRecordatorio.Mostrar(AOwner: TComponent;
  const ACotizaciones: TObjectList<TCotizacionDTO>): Integer;
var
  lForma: TfrmRecordatorio;
begin
  Result := 0;
  lForma := TfrmRecordatorio.Create(AOwner);
  try
    TMapeoDatos.AListaTabla<TCotizacionDTO>(ACotizaciones,
      dmMemoria.mtSinRespuesta);
    lForma.lblPie.Caption := Format(SRecordatorioPie, [ACotizaciones.Count]);
    TCeldasRejilla.De(lForma.grSinRespuesta).AjustarColumnas;
    if (lForma.ShowModal = mrOk) and not dmMemoria.mtSinRespuesta.IsEmpty then
      Result := dmMemoria.mtSinRespuestaID.AsInteger;
  finally
    lForma.Free;
  end;
end;

procedure TfrmRecordatorio.FormCreate(Sender: TObject);
begin
  AplicarTemaGrid(grSinRespuesta);
  lblTitulo.Caption := SRecordatorioTitulo;
  lblSubtitulo.Caption := SRecordatorioAyuda;
  btnGuardar.Caption := SBotonAbrirCotizacion;
  btnCancelar.Caption := SBotonCerrar;
end;

procedure TfrmRecordatorio.FormDestroy(Sender: TObject);
begin
  dmMemoria.mtSinRespuesta.Close;
end;

function TfrmRecordatorio.ControlesEdicion: TArray<TControl>;
begin
  Result := [grSinRespuesta];
end;

procedure TfrmRecordatorio.btnGuardarClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmRecordatorio.grSinRespuestaDblClick(Sender: TObject);
begin
  btnGuardarClick(Sender);
end;

end.
