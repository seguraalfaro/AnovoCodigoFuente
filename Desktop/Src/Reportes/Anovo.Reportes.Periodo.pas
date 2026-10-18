unit Anovo.Reportes.Periodo;

// Reporte del periodo en PDF con FortesReport (HU-06): encabezado de la
// empresa, cifras con la comparacion y la tabla de la vista elegida.

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Vcl.Controls,
  Vcl.Forms,
  RLReport,
  Anovo.Vistas.Intf.Reportes;

type
  TReportePeriodo = class
  private
    FForma: TForm;
    FResumen: TResumenReporte;
    FVista: string;
    FDatos: TDataSet;
    FFuente: TDataSource;
    FReporte: TRLReport;
    FOrden: Integer;
    FCampos: TArray<TField>;
    FIzquierdas: TArray<Integer>;
    FAnchos: TArray<Integer>;
    function Banda(ATipo: TRLBandType; AAlto: Integer): TRLBand;
    function Etiqueta(APadre: TWinControl; const ATexto: string;
      ALeft, ATop, AWidth: Integer; ATam: Integer = 9;
      ANegrita: Boolean = False;
      AAlin: TRLTextAlignment = taLeftJustify): TRLLabel;
    procedure Linea(APadre: TRLBand; ATop: Integer; AGrosor: Integer = 1);
    function Alineacion(const ACampo: TField): TRLTextAlignment;
    function Total(const ACampo: TField): string;
    procedure ElegirCampos;
    procedure ArmarEncabezado;
    procedure ArmarCifras;
    procedure ArmarColumnas;
    procedure ArmarDetalle;
    procedure ArmarTotales;
    procedure ArmarPie;
    procedure Armar;
  public
    constructor Create(const AResumen: TResumenReporte; const AVista: string;
      const ADatos: TDataSet);
    destructor Destroy; override;
    class procedure VistaPrevia(const AResumen: TResumenReporte;
      const AVista: string; const ADatos: TDataSet);
  end;

implementation

uses
  Winapi.Windows,
  Vcl.Graphics,
  RLTypes,
  RLPDFFilter,
  Anovo.Textos;

const
  ANCHO = 665;
  ANCHO_ROTULO = 170;
  MARGEN_LATERAL = 20;
  MARGEN_VERTICAL = 15;
  SEPARACION_BANDAS = 2000;
  FUENTE = 'Arial';
  COLOR_COLUMNAS = $00EFEFEF;
  COLOR_CIFRA = $00F7F7F7;
  CAMPO_ACCIONES = 'ACCIONES';
  CAMPO_TASA = 'TASA_APROBACION';
  CAMPO_PORCENTAJE = 'PORCENTAJE_SIN_RESPUESTA';
  CIFRAS_POR_FILA = 3;
  ALTO_CIFRA = 50;

constructor TReportePeriodo.Create(const AResumen: TResumenReporte;
  const AVista: string; const ADatos: TDataSet);
begin
  inherited Create;
  FResumen := AResumen;
  FVista := AVista;
  FDatos := ADatos;
  FForma := TForm.CreateNew(nil);
  FFuente := TDataSource.Create(FForma);
  FFuente.DataSet := ADatos;
  Armar;
end;

destructor TReportePeriodo.Destroy;
begin
  FForma.Free;
  inherited;
end;

class procedure TReportePeriodo.VistaPrevia(const AResumen: TResumenReporte;
  const AVista: string; const ADatos: TDataSet);
var
  lReporte: TReportePeriodo;
begin
  lReporte := TReportePeriodo.Create(AResumen, AVista, ADatos);
  try
    lReporte.FReporte.PreviewModal;
  finally
    lReporte.Free;
  end;
end;

function TReportePeriodo.Banda(ATipo: TRLBandType; AAlto: Integer): TRLBand;
begin
  Inc(FOrden);
  Result := TRLBand.Create(FForma);
  Result.Top := FOrden * SEPARACION_BANDAS;
  Result.Parent := FReporte;
  Result.BandType := ATipo;
  Result.AutoSize := False;
  Result.AutoExpand := False;
  Result.Height := AAlto;
end;

function TReportePeriodo.Etiqueta(APadre: TWinControl; const ATexto: string;
  ALeft, ATop, AWidth: Integer; ATam: Integer; ANegrita: Boolean;
  AAlin: TRLTextAlignment): TRLLabel;
begin
  Result := TRLLabel.Create(FForma);
  Result.Parent := APadre;
  Result.AutoSize := False;
  Result.SetBounds(ALeft, ATop, AWidth, ATam * 2);
  Result.Caption := ATexto;
  Result.Font.Name := FUENTE;
  Result.Font.Height := -MulDiv(ATam, 96, 72);
  if ANegrita then
    Result.Font.Style := [fsBold];
  Result.Alignment := AAlin;
end;

procedure TReportePeriodo.Linea(APadre: TRLBand; ATop: Integer;
  AGrosor: Integer);
var
  lDibujo: TRLDraw;
begin
  lDibujo := TRLDraw.Create(FForma);
  lDibujo.Parent := APadre;
  lDibujo.DrawKind := dkLine;
  lDibujo.SetBounds(0, ATop, ANCHO, 2);
  lDibujo.Pen.Width := AGrosor;
end;

function TReportePeriodo.Alineacion(const ACampo: TField): TRLTextAlignment;
begin
  if (ACampo.FieldName = CAMPO_TASA) or (ACampo.FieldName = CAMPO_PORCENTAJE)
  then
    Result := taCenter
  else if ACampo is TNumericField then
    Result := taRightJustify
  else
    Result := taLeftJustify;
end;

function TReportePeriodo.Total(const ACampo: TField): string;
var
  lMarca: TBookmark;
  lSuma: Currency;
begin
  if ACampo.FieldName = CAMPO_TASA then
    Exit(FResumen.TasaTotal);
  if not (ACampo is TNumericField) or (ACampo.FieldName = CAMPO_PORCENTAJE) then
    Exit('');
  lSuma := 0;
  lMarca := FDatos.GetBookmark;
  FDatos.DisableControls;
  try
    FDatos.First;
    while not FDatos.Eof do
    begin
      lSuma := lSuma + ACampo.AsCurrency;
      FDatos.Next;
    end;
    FDatos.GotoBookmark(lMarca);
  finally
    FDatos.FreeBookmark(lMarca);
    FDatos.EnableControls;
  end;
  if ACampo is TCurrencyField then
    Result := FormatFloat(TCurrencyField(ACampo).DisplayFormat, lSuma)
  else
    Result := FormatFloat('#,##0', lSuma);
end;

procedure TReportePeriodo.ElegirCampos;
var
  lCampo: TField;
  lResto, lAncho, I: Integer;
begin
  FCampos := [];
  for lCampo in FDatos.Fields do
    if lCampo.Visible and (lCampo.FieldName <> CAMPO_ACCIONES) then
      FCampos := FCampos + [lCampo];
  if Length(FCampos) = 0 then
    Exit;
  SetLength(FIzquierdas, Length(FCampos));
  SetLength(FAnchos, Length(FCampos));
  FIzquierdas[0] := 4;
  FAnchos[0] := ANCHO_ROTULO;
  if Length(FCampos) > 1 then
  begin
    lResto := ANCHO - ANCHO_ROTULO - 8;
    lAncho := lResto div (Length(FCampos) - 1);
    for I := 1 to High(FCampos) do
    begin
      FIzquierdas[I] := FIzquierdas[I - 1] + FAnchos[I - 1];
      FAnchos[I] := lAncho;
    end;
  end;
end;

procedure TReportePeriodo.ArmarEncabezado;
var
  lBanda: TRLBand;
begin
  lBanda := Banda(btHeader, 70);
  Etiqueta(lBanda, FResumen.Empresa, 0, 4, 360, 14, True);
  Etiqueta(lBanda, FResumen.EmpresaDatos, 0, 32, 360, 8);
  Etiqueta(lBanda, SReportePdfTitulo, 365, 4, 300, 12, True, taRightJustify);
  Etiqueta(lBanda, Format(SReportePdfVista, [FVista, FResumen.Periodo]), 365,
    30, 300, 9, False, taRightJustify);
  Etiqueta(lBanda, FResumen.Comparado, 365, 46, 300, 8, False, taRightJustify);
  Linea(lBanda, 66, 2);
end;

procedure TReportePeriodo.ArmarCifras;
var
  lBanda: TRLBand;
  lCifra: TCifraReporte;
  lCaja: TRLPanel;
  lAncho, lFila, lColumna: Integer;
begin
  lBanda := Banda(btTitle, 2 * (ALTO_CIFRA + 8) + 18);
  lAncho := (ANCHO - (CIFRAS_POR_FILA - 1) * 8) div CIFRAS_POR_FILA;
  for lCifra := Low(TCifraReporte) to High(TCifraReporte) do
  begin
    lFila := Ord(lCifra) div CIFRAS_POR_FILA;
    lColumna := Ord(lCifra) mod CIFRAS_POR_FILA;
    lCaja := TRLPanel.Create(FForma);
    lCaja.Parent := lBanda;
    lCaja.SetBounds(lColumna * (lAncho + 8), 8 + lFila * (ALTO_CIFRA + 8),
      lAncho, ALTO_CIFRA);
    lCaja.Color := COLOR_CIFRA;
    lCaja.Transparent := False;
    Etiqueta(lCaja, FResumen.Rotulos[lCifra], 8, 4, lAncho - 16, 8);
    Etiqueta(lCaja, FResumen.Valores[lCifra], 8, 18, lAncho - 16,
      12, True);
    Etiqueta(lCaja, FResumen.Variaciones[lCifra], 8, 36,
      lAncho - 16, 7);
  end;
end;

procedure TReportePeriodo.ArmarColumnas;
var
  lBanda: TRLBand;
  I: Integer;
begin
  lBanda := Banda(btColumnHeader, 26);
  lBanda.Color := COLOR_COLUMNAS;
  lBanda.Transparent := False;
  for I := 0 to High(FCampos) do
    Etiqueta(lBanda, FCampos[I].DisplayLabel, FIzquierdas[I], 6, FAnchos[I],
      8, True, Alineacion(FCampos[I]));
  Linea(lBanda, 24);
end;

procedure TReportePeriodo.ArmarDetalle;
var
  lBanda: TRLBand;
  lTexto: TRLDBText;
  I: Integer;
begin
  lBanda := Banda(btDetail, 22);
  for I := 0 to High(FCampos) do
  begin
    lTexto := TRLDBText.Create(FForma);
    lTexto.Parent := lBanda;
    lTexto.AutoSize := False;
    lTexto.SetBounds(FIzquierdas[I], 4, FAnchos[I] - 4, 16);
    lTexto.DataSource := FFuente;
    lTexto.DataField := FCampos[I].FieldName;
    lTexto.Font.Name := FUENTE;
    lTexto.Font.Height := -MulDiv(8, 96, 72);
    lTexto.Alignment := Alineacion(FCampos[I]);
  end;
  Linea(lBanda, 20);
end;

procedure TReportePeriodo.ArmarTotales;
var
  lBanda: TRLBand;
  I: Integer;
begin
  lBanda := Banda(btSummary, 60);
  Etiqueta(lBanda, SReportePdfTotal, FIzquierdas[0], 4, FAnchos[0], 8, True);
  for I := 1 to High(FCampos) do
    Etiqueta(lBanda, Total(FCampos[I]), FIzquierdas[I], 4, FAnchos[I] - 4, 8,
      True, Alineacion(FCampos[I]));
  Linea(lBanda, 22);
  Etiqueta(lBanda, SReporteLeyenda, 0, 30, ANCHO, 7);
end;

procedure TReportePeriodo.ArmarPie;
var
  lBanda: TRLBand;
  lPagina, lTotal: TRLSystemInfo;
begin
  lBanda := Banda(btFooter, 30);
  Linea(lBanda, 2);
  Etiqueta(lBanda, FResumen.Generado, 0, 10, 450, 7);

  lPagina := TRLSystemInfo.Create(FForma);
  lPagina.Parent := lBanda;
  lPagina.Info := itPageNumber;
  lPagina.AutoSize := False;
  lPagina.SetBounds(574, 10, 30, 16);
  lPagina.Alignment := taRightJustify;
  lPagina.Font.Name := FUENTE;
  lPagina.Font.Height := -MulDiv(7, 96, 72);

  Etiqueta(lBanda, SDocDe, 606, 10, 20, 7, False, taCenter);

  lTotal := TRLSystemInfo.Create(FForma);
  lTotal.Parent := lBanda;
  lTotal.Info := itLastPageNumber;
  lTotal.AutoSize := False;
  lTotal.SetBounds(628, 10, 30, 16);
  lTotal.Alignment := taLeftJustify;
  lTotal.Font.Name := FUENTE;
  lTotal.Font.Height := -MulDiv(7, 96, 72);
end;

procedure TReportePeriodo.Armar;
var
  lPdf: TRLPDFFilter;
begin
  FReporte := TRLReport.Create(FForma);
  FReporte.Parent := FForma;
  FReporte.DataSource := FFuente;
  FReporte.PageSetup.PaperSize := fpLetter;
  FReporte.Margins.LeftMargin := MARGEN_LATERAL;
  FReporte.Margins.RightMargin := MARGEN_LATERAL;
  FReporte.Margins.TopMargin := MARGEN_VERTICAL;
  FReporte.Margins.BottomMargin := MARGEN_VERTICAL;
  FReporte.Font.Name := FUENTE;
  FReporte.Title := Format(SReportePdfVista, [SReportePdfTitulo, FVista]);

  ElegirCampos;
  ArmarEncabezado;
  ArmarCifras;
  if Length(FCampos) > 0 then
  begin
    ArmarColumnas;
    ArmarDetalle;
    ArmarTotales;
  end;
  ArmarPie;

  lPdf := TRLPDFFilter.Create(FForma);
  lPdf.DocumentInfo.Title := FReporte.Title;
  lPdf.DocumentInfo.Author := FResumen.Empresa;
end;

end.
