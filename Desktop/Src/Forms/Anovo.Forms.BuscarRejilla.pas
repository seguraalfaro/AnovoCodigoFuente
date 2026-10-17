unit Anovo.Forms.BuscarRejilla;

// Dialogo para buscar un texto en las filas cargadas de una rejilla,
// en una columna o en todas, y saltar a la siguiente coincidencia.

interface

uses
  System.SysUtils, System.Classes, System.UITypes, Data.DB,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.TitleBarCtrls, Vcl.WinXCtrls, Anovo.UI.PanelRelativo,
  VclPlano.BotonWin,
  Anovo.Forms.Edicion;

type
  TfrmBuscarRejilla = class(TfrmEdicion)
    pnlCampos: TPanel;
    lblColumna: TLabel;
    cbColumna: TComboBox;
    lblTexto: TLabel;
    edTexto: TEdit;
    lblResultado: TLabel;
    procedure btnGuardarClick(Sender: TObject);
    procedure edTextoChange(Sender: TObject);
  private
    FDatos: TDataSet;
    FCampos: TArray<string>;
    function CamposElegidos: TArray<string>;
  public
    class procedure Buscar(AOwner: TComponent; ADatos: TDataSet;
      const ACampos, ATitulos: TArray<string>; const ACampoInicial: string);
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.ColumnasRejilla,
  Anovo.Textos;

class procedure TfrmBuscarRejilla.Buscar(AOwner: TComponent; ADatos: TDataSet;
  const ACampos, ATitulos: TArray<string>; const ACampoInicial: string);
var
  lForma: TfrmBuscarRejilla;
  I: Integer;
begin
  lForma := TfrmBuscarRejilla.Create(AOwner);
  try
    lForma.lblTitulo.Caption := STituloBuscarRejilla;
    lForma.lblSubtitulo.Caption := SAyudaBuscarRejilla;
    lForma.btnGuardar.Caption := SBuscarSiguiente;
    lForma.btnCancelar.Caption := SCerrar;
    lForma.FDatos := ADatos;
    lForma.FCampos := Copy(ACampos);
    lForma.cbColumna.Items.Add(STodasLasColumnas);
    for I := 0 to High(ATitulos) do
      lForma.cbColumna.Items.Add(ATitulos[I]);
    lForma.cbColumna.ItemIndex := 0;
    for I := 0 to High(ACampos) do
      if SameText(ACampos[I], ACampoInicial) then
        lForma.cbColumna.ItemIndex := I + 1;
    lForma.lblResultado.Caption := '';
    lForma.ShowModal;
  finally
    lForma.Free;
  end;
end;

function TfrmBuscarRejilla.CamposElegidos: TArray<string>;
begin
  if cbColumna.ItemIndex > 0 then
    Result := [FCampos[cbColumna.ItemIndex - 1]]
  else
    Result := Copy(FCampos);
end;

procedure TfrmBuscarRejilla.btnGuardarClick(Sender: TObject);
var
  lTexto: string;
begin
  lTexto := LowerCase(Trim(edTexto.Text));
  if lTexto = '' then
  begin
    MostrarError(SBuscarFaltaTexto);
    edTexto.SetFocus;
    Exit;
  end;
  if BuscarFila(FDatos, CamposElegidos, lTexto) then
    lblResultado.Caption := Format(SBuscarEncontrado, [FDatos.RecNo])
  else
    lblResultado.Caption := SBuscarSinCoincidencias;
end;

procedure TfrmBuscarRejilla.edTextoChange(Sender: TObject);
begin
  lblResultado.Caption := '';
end;

end.
