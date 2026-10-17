unit Anovo.Forms.ExportarRejilla;

// Dialogo para exportar las filas cargadas de una rejilla: formato,
// separador, columnas y opciones del archivo.

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
    Separador: string;
    SoloVisibles: Boolean;
    Titulos: Boolean;
    Totales: Boolean;
    Filtro: Boolean;
    Abrir: Boolean;
  end;

  TfrmExportarRejilla = class(TfrmEdicion)
    pnlCampos: TPanel;
    lblFormato: TLabel;
    rbExcel: TRadioButton;
    rbCsv: TRadioButton;
    lblSeparador: TLabel;
    cbSeparador: TComboBox;
    lblColumnas: TLabel;
    rbVisibles: TRadioButton;
    rbTodas: TRadioButton;
    lblOpciones: TLabel;
    chkTitulos: TCheckBox;
    chkTotales: TCheckBox;
    chkFiltro: TCheckBox;
    chkAbrir: TCheckBox;
    lblNota: TLabel;
    procedure btnGuardarClick(Sender: TObject);
    procedure CambioFormato(Sender: TObject);
  private
    function Opciones: TOpcionesExportacion;
  public
    class function Elegir(AOwner: TComponent; const AFilas: Integer;
      const AHayExcel: Boolean; out AOpciones: TOpcionesExportacion): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Textos;

const
  SEPARADORES: array [0 .. 2] of string = (';', ',', #9);

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
    lForma.cbSeparador.Items.Add(SSeparadorPuntoComa);
    lForma.cbSeparador.Items.Add(SSeparadorComa);
    lForma.cbSeparador.Items.Add(SSeparadorTabulador);
    lForma.cbSeparador.ItemIndex := 0;
    lForma.rbExcel.Enabled := AHayExcel;
    lForma.rbExcel.Checked := AHayExcel;
    lForma.rbCsv.Checked := not AHayExcel;
    if AHayExcel then
      lForma.lblNota.Caption := ''
    else
      lForma.lblNota.Caption := SSinExcel;
    lForma.CambioFormato(nil);
    Result := lForma.ShowModal = mrOk;
    AOpciones := lForma.Opciones;
  finally
    lForma.Free;
  end;
end;

function TfrmExportarRejilla.Opciones: TOpcionesExportacion;
begin
  if rbExcel.Checked then
    Result.Formato := feExcel
  else
    Result.Formato := feCsv;
  Result.Separador := SEPARADORES[cbSeparador.ItemIndex];
  Result.SoloVisibles := rbVisibles.Checked;
  Result.Titulos := chkTitulos.Checked;
  Result.Totales := chkTotales.Checked;
  Result.Filtro := chkFiltro.Checked;
  Result.Abrir := chkAbrir.Checked;
end;

procedure TfrmExportarRejilla.CambioFormato(Sender: TObject);
begin
  lblSeparador.Enabled := rbCsv.Checked;
  cbSeparador.Enabled := rbCsv.Checked;
  chkTotales.Enabled := rbExcel.Checked;
  chkFiltro.Enabled := rbExcel.Checked;
end;

procedure TfrmExportarRejilla.btnGuardarClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
