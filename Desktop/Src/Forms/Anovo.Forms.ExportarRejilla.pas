unit Anovo.Forms.ExportarRejilla;

// Dialogo para elegir el formato de exportacion de las filas cargadas de
// una rejilla y si se abre el archivo al terminar.

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.TitleBarCtrls, Vcl.WinXCtrls, Anovo.UI.PanelRelativo,
  VclPlano.BotonWin,
  Anovo.Forms.Edicion;

type
  TFormatoExportacion = (feExcel, feCsv);

  TOpcionesExportacion = record
    Formato: TFormatoExportacion;
    Abrir: Boolean;
  end;

  TfrmExportarRejilla = class(TfrmEdicion)
    pnlCampos: TPanel;
    lblFormato: TLabel;
    rbExcel: TRadioButton;
    rbCsv: TRadioButton;
    chkAbrir: TCheckBox;
    lblNota: TLabel;
    procedure btnGuardarClick(Sender: TObject);
  public
    class function Elegir(AOwner: TComponent; const AFilas: Integer;
      const AHayExcel: Boolean; out AOpciones: TOpcionesExportacion): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Textos;

class function TfrmExportarRejilla.Elegir(AOwner: TComponent;
  const AFilas: Integer; const AHayExcel: Boolean;
  out AOpciones: TOpcionesExportacion): Boolean;
var
  lForma: TfrmExportarRejilla;
begin
  lForma := TfrmExportarRejilla.Create(AOwner);
  try
    lForma.lblTitulo.Caption := STituloExportarRejilla;
    lForma.lblSubtitulo.Caption := Format(SAyudaExportarRejilla, [AFilas]);
    lForma.btnGuardar.Caption := SExportar;
    lForma.rbExcel.Enabled := AHayExcel;
    lForma.rbExcel.Checked := AHayExcel;
    lForma.rbCsv.Checked := not AHayExcel;
    if AHayExcel then
      lForma.lblNota.Caption := ''
    else
      lForma.lblNota.Caption := SSinExcel;
    Result := lForma.ShowModal = mrOk;
    if lForma.rbExcel.Checked then
      AOpciones.Formato := feExcel
    else
      AOpciones.Formato := feCsv;
    AOpciones.Abrir := lForma.chkAbrir.Checked;
  finally
    lForma.Free;
  end;
end;

procedure TfrmExportarRejilla.btnGuardarClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
