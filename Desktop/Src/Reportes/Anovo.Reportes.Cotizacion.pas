unit Anovo.Reportes.Cotizacion;

// Documento de la cotizacion para el cliente con FortesReport: vista previa y
// PDF. Las bandas se arman en codigo con el formato aprobado por Anovo.

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  RLReport,
  Anovo.DTOs.Documento;

type
  TReporteCotizacion = class
  private
    FForma: TForm;
    FDocumento: TCotizacionDocumentoDTO;
    FPrincipal: TRLReport;
    FCarta: TRLReport;
    FOrden: Integer;
    function NuevoReporte: TRLReport;
    function Banda(AReporte: TRLReport; ATipo: TRLBandType;
      AAlto: Integer): TRLBand;
    function Etiqueta(APadre: TRLBand; const ATexto: string;
      ALeft, ATop, AWidth: Integer; ATam: Integer = 10;
      ANegrita: Boolean = False;
      AAlin: TRLTextAlignment = taLeftJustify): TRLLabel;
    function Memo(APadre: TRLBand; const ATexto: string;
      ALeft, ATop, AWidth, AHeight: Integer; ATam: Integer = 10): TRLMemo;
    procedure Linea(APadre: TRLBand; ATop: Integer; AGrosor: Integer = 1);
    procedure Columna(APadre: TRLBand; const ACampo: string;
      ALeft, AWidth: Integer; AAlin: TRLTextAlignment);
    procedure ArmarEncabezado(AReporte: TRLReport);
    procedure ArmarTitulo;
    procedure ArmarColumnas;
    procedure ArmarDetalle;
    procedure ArmarResumen;
    procedure ArmarCarta;
    procedure ArmarPie(AReporte: TRLReport);
    procedure Armar;
  public
    constructor Create(const ADocumento: TCotizacionDocumentoDTO);
    destructor Destroy; override;
    class procedure VistaPrevia(const ADocumento: TCotizacionDocumentoDTO);
    class procedure GuardarPdf(const ADocumento: TCotizacionDocumentoDTO;
      const ARuta: string);
    class function PdfEnBytes(const ADocumento: TCotizacionDocumentoDTO)
      : TBytes;
  end;

implementation

uses
  Winapi.Windows,
  System.IOUtils,
  System.UITypes,
  Vcl.Graphics,
  Vcl.Controls,
  RLTypes,
  RLPDFFilter,
  Anovo.Datos.Memoria,
  Anovo.Formato,
  Anovo.Mapeo.Datos,
  Anovo.Textos;

const
  ANCHO = 665;
  HOLGURA = 40;
  MARGEN_LATERAL = 20;
  MARGEN_VERTICAL = 15;
  SEPARACION_BANDAS = 2000;
  FUENTE = 'Arial';
  COLOR_COLUMNAS = $00EFEFEF;

function Unir(const A, B, ASeparador: string): string;
begin
  if A.IsEmpty then
    Result := B
  else if B.IsEmpty then
    Result := A
  else
    Result := A + ASeparador + B;
end;

constructor TReporteCotizacion.Create(const ADocumento: TCotizacionDocumentoDTO);
begin
  inherited Create;
  FDocumento := ADocumento;
  FForma := TForm.CreateNew(nil);
  Armar;
end;

destructor TReporteCotizacion.Destroy;
begin
  FForma.Free;
  dmMemoria.mtDocumentoLineas.Close;
  inherited;
end;

class procedure TReporteCotizacion.VistaPrevia(const ADocumento
  : TCotizacionDocumentoDTO);
var
  lReporte: TReporteCotizacion;
begin
  lReporte := TReporteCotizacion.Create(ADocumento);
  try
    lReporte.FPrincipal.PreviewModal;
  finally
    lReporte.Free;
  end;
end;

class procedure TReporteCotizacion.GuardarPdf(const ADocumento
  : TCotizacionDocumentoDTO; const ARuta: string);
var
  lReporte: TReporteCotizacion;
begin
  lReporte := TReporteCotizacion.Create(ADocumento);
  try
    lReporte.FPrincipal.Prepare;
    lReporte.FPrincipal.SaveToFile(ARuta);
  finally
    lReporte.Free;
  end;
end;

class function TReporteCotizacion.PdfEnBytes(const ADocumento
  : TCotizacionDocumentoDTO): TBytes;
var
  lRuta: string;
begin
  lRuta := TPath.Combine(TPath.GetTempPath, TGUID.NewGuid.ToString + '.pdf');
  try
    GuardarPdf(ADocumento, lRuta);
    Result := TFile.ReadAllBytes(lRuta);
  finally
    if FileExists(lRuta) then
      System.SysUtils.DeleteFile(lRuta);
  end;
end;

function TReporteCotizacion.NuevoReporte: TRLReport;
begin
  Result := TRLReport.Create(FForma);
  Result.Parent := FForma;
  Result.DataSource := dmMemoria.dsDocumentoLineas;
  Result.PageSetup.PaperSize := fpLetter;
  Result.Margins.LeftMargin := MARGEN_LATERAL;
  Result.Margins.RightMargin := MARGEN_LATERAL;
  Result.Margins.TopMargin := MARGEN_VERTICAL;
  Result.Margins.BottomMargin := MARGEN_VERTICAL;
  Result.Font.Name := FUENTE;
end;

function TReporteCotizacion.Banda(AReporte: TRLReport; ATipo: TRLBandType;
  AAlto: Integer): TRLBand;
begin
  Inc(FOrden);
  Result := TRLBand.Create(FForma);
  Result.Top := FOrden * SEPARACION_BANDAS;
  Result.Parent := AReporte;
  Result.BandType := ATipo;
  Result.AutoSize := False;
  Result.AutoExpand := False;
  Result.Height := AAlto;
end;

function TReporteCotizacion.Etiqueta(APadre: TRLBand; const ATexto: string;
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

function TReporteCotizacion.Memo(APadre: TRLBand; const ATexto: string;
  ALeft, ATop, AWidth, AHeight: Integer; ATam: Integer): TRLMemo;
begin
  Result := TRLMemo.Create(FForma);
  Result.Parent := APadre;
  Result.AutoSize := False;
  Result.SetBounds(ALeft, ATop, AWidth, AHeight);
  Result.Font.Name := FUENTE;
  Result.Font.Height := -MulDiv(ATam, 96, 72);
  Result.WordWrap := True;
  Result.Lines.Text := ATexto;
end;

procedure TReporteCotizacion.Linea(APadre: TRLBand; ATop: Integer;
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

procedure TReporteCotizacion.Columna(APadre: TRLBand; const ACampo: string;
  ALeft, AWidth: Integer; AAlin: TRLTextAlignment);
var
  lTexto: TRLDBText;
begin
  lTexto := TRLDBText.Create(FForma);
  lTexto.Parent := APadre;
  lTexto.AutoSize := False;
  lTexto.SetBounds(ALeft, 6, AWidth, 34);
  lTexto.DataSource := dmMemoria.dsDocumentoLineas;
  lTexto.DataField := ACampo;
  lTexto.Font.Name := FUENTE;
  lTexto.Font.Height := -MulDiv(10, 96, 72);
  lTexto.Alignment := AAlin;
end;

procedure TReporteCotizacion.ArmarEncabezado(AReporte: TRLReport);
var
  lBanda: TRLBand;
begin
  lBanda := Banda(AReporte, btHeader, 96);
  Etiqueta(lBanda, FDocumento.EmpresaRazonSocial, 0, 4, 360, 12, True);
  Etiqueta(lBanda, FDocumento.EmpresaRazonSocial, 365, 4, 300, 11, True,
    taRightJustify);
  Etiqueta(lBanda, Format(SDocCedula, [FDocumento.EmpresaCedula]), 365, 26,
    300, 9, False, taRightJustify);
  Etiqueta(lBanda, Format(SDocTelefonos, [Unir(FDocumento.EmpresaTelefonoFijo,
    FDocumento.EmpresaCelular, ' / ')]), 365, 44, 300, 9, False,
    taRightJustify);
  Etiqueta(lBanda, FDocumento.EmpresaCorreo, 365, 62, 300, 9, False,
    taRightJustify);
  Linea(lBanda, 88, 2);
end;

procedure TReporteCotizacion.ArmarTitulo;
var
  lBanda: TRLBand;
  lCliente: string;
begin
  lBanda := Banda(FPrincipal, btTitle, 272);
  Memo(lBanda, FDocumento.EmpresaDireccion, 0, 6, ANCHO - HOLGURA, 34, 8);
  Etiqueta(lBanda, TFormato.FechaLarga(FDocumento.Fecha), 0, 50, 300);
  Etiqueta(lBanda, Format(SDocProforma, [FDocumento.Numero]), 365, 50, 300,
    11, True, taRightJustify);
  Etiqueta(lBanda, SDocCotizacion, 0, 80, ANCHO, 15, True, taCenter);

  lCliente := AnsiUpperCase(FDocumento.ClienteNombre);
  if not FDocumento.ClienteTelefono.IsEmpty then
    lCliente := lCliente + '     ' + Format(SDocTelefono,
      [FDocumento.ClienteTelefono]);
  Etiqueta(lBanda, SDocSenores, 0, 118, 80, 10, True);
  Etiqueta(lBanda, lCliente, 80, 118, 580);

  if FDocumento.ContactoNombre.IsEmpty then
    Etiqueta(lBanda, SDocEstimadoCliente, 0, 170, ANCHO)
  else
  begin
    Etiqueta(lBanda, SDocAtencion, 0, 140, 80, 10, True);
    Etiqueta(lBanda, FDocumento.ContactoNombre, 80, 140, 580);
    Etiqueta(lBanda, Format(SDocEstimado, [FDocumento.ContactoNombre]), 0, 170,
      ANCHO);
  end;

  Memo(lBanda, SDocIntroduccion, 0, 192, ANCHO - HOLGURA, 40);
  Etiqueta(lBanda, SDocServicio, 0, 244, 250, 10, True);
  Etiqueta(lBanda, FDocumento.DescripcionTrabajo, 250, 244, 415);
end;

procedure TReporteCotizacion.ArmarColumnas;
var
  lBanda: TRLBand;
begin
  lBanda := Banda(FPrincipal, btColumnHeader, 30);
  lBanda.Color := COLOR_COLUMNAS;
  lBanda.Transparent := False;
  Etiqueta(lBanda, SDocColDescripcion, 6, 6, 310, 10, True);
  Etiqueta(lBanda, SDocColCantidad, 316, 6, 76, 10, True, taCenter);
  Etiqueta(lBanda, SDocColPrecio, 410, 6, 124, 10, True);
  Etiqueta(lBanda, SDocColTotal, 524, 6, 135, 10, True, taRightJustify);
  Linea(lBanda, 28);
end;

procedure TReporteCotizacion.ArmarDetalle;
var
  lBanda: TRLBand;
  lTexto: TRLDBMemo;
begin
  lBanda := Banda(FPrincipal, btDetail, 46);
  lTexto := TRLDBMemo.Create(FForma);
  lTexto.Parent := lBanda;
  lTexto.AutoSize := False;
  lTexto.SetBounds(6, 6, 290, 36);
  lTexto.DataSource := dmMemoria.dsDocumentoLineas;
  lTexto.DataField := 'DESCRIPCION';
  lTexto.Font.Name := FUENTE;
  lTexto.Font.Height := -MulDiv(10, 96, 72);
  lTexto.WordWrap := True;
  Columna(lBanda, 'CANTIDAD', 320, 66, taCenter);
  Columna(lBanda, 'PRECIO_UNITARIO', 390, 130, taRightJustify);
  Columna(lBanda, 'TOTAL', 524, 135, taRightJustify);
  Linea(lBanda, 44);
end;

procedure TReporteCotizacion.ArmarResumen;
var
  lBanda: TRLBand;
  lCondiciones: string;
begin
  lBanda := Banda(FPrincipal, btSummary, 300);
  Etiqueta(lBanda, SDocSubtotal, 390, 8, 130, 10, False, taRightJustify);
  Etiqueta(lBanda, TFormato.ColonesDocumento(FDocumento.Subtotal), 524, 8,
    135, 10, False, taRightJustify);
  Etiqueta(lBanda, Format(SDocIva, [TFormato.Porcentaje(FDocumento.PorcentajeIva)]),
    390, 28, 130, 10, False, taRightJustify);
  Etiqueta(lBanda, TFormato.ColonesDocumento(FDocumento.MontoImpuesto), 524,
    28, 135, 10, False, taRightJustify);
  Etiqueta(lBanda, SDocTotal, 390, 50, 130, 11, True, taRightJustify);
  Etiqueta(lBanda, TFormato.ColonesDocumento(FDocumento.MontoTotal), 524, 50,
    135, 11, True, taRightJustify);

  lCondiciones := '';
  if not FDocumento.FormaPago.IsEmpty then
    lCondiciones := Unir(lCondiciones, Format(SDocFormaPago,
      [FDocumento.FormaPago]), sLineBreak);
  if not FDocumento.CuentaBancaria.IsEmpty then
    lCondiciones := Unir(lCondiciones, Format(SDocCuenta,
      [FDocumento.CuentaBancaria]), sLineBreak);
  if not FDocumento.PlazoEntrega.IsEmpty then
    lCondiciones := Unir(lCondiciones, Format(SDocEntrega,
      [FDocumento.PlazoEntrega]), sLineBreak);
  if not FDocumento.Garantia.IsEmpty then
    lCondiciones := Unir(lCondiciones, Format(SDocGarantia,
      [FDocumento.Garantia]), sLineBreak);
  Memo(lBanda, lCondiciones, 0, 96, ANCHO - HOLGURA, 80);

  Etiqueta(lBanda, SDocSujetoCambio, 0, 184, ANCHO, 10, True);
  Etiqueta(lBanda, SDocAtentamente, 0, 226, 300);
  Etiqueta(lBanda, FDocumento.Firmante, 0, 248, 300, 10, True);
  Etiqueta(lBanda, FDocumento.EmpresaRazonSocial, 0, 268, 300);
end;

procedure TReporteCotizacion.ArmarCarta;
var
  lBanda: TRLBand;
begin
  lBanda := Banda(FCarta, btTitle, 620);
  Memo(lBanda, FDocumento.CartaPresentacion, 0, 10, ANCHO - HOLGURA, 600);
  lBanda := Banda(FCarta, btSummary, 80);
  Etiqueta(lBanda, SDocAtentamente, 0, 6, 300);
  Etiqueta(lBanda, FDocumento.Firmante, 0, 28, 300, 10, True);
  Etiqueta(lBanda, FDocumento.EmpresaRazonSocial, 0, 48, 300);
end;

procedure TReporteCotizacion.ArmarPie(AReporte: TRLReport);
var
  lBanda: TRLBand;
  lPagina, lTotal: TRLSystemInfo;
begin
  lBanda := Banda(AReporte, btFooter, 40);
  Linea(lBanda, 2);
  Etiqueta(lBanda, Format(SDocAviso, [FDocumento.AvisoPrivacidad]), 0, 12,
    450, 8);
  Etiqueta(lBanda, SDocPagina, 520, 12, 50, 8, False, taRightJustify);

  lPagina := TRLSystemInfo.Create(FForma);
  lPagina.Parent := lBanda;
  lPagina.Info := itPageNumber;
  lPagina.AutoSize := False;
  lPagina.SetBounds(574, 12, 30, 16);
  lPagina.Alignment := taCenter;
  lPagina.Font.Name := FUENTE;
  lPagina.Font.Height := -MulDiv(8, 96, 72);

  Etiqueta(lBanda, SDocDe, 606, 12, 20, 8, False, taCenter);

  lTotal := TRLSystemInfo.Create(FForma);
  lTotal.Parent := lBanda;
  lTotal.Info := itLastPageNumber;
  lTotal.AutoSize := False;
  lTotal.SetBounds(628, 12, 30, 16);
  lTotal.Alignment := taCenter;
  lTotal.Font.Name := FUENTE;
  lTotal.Font.Height := -MulDiv(8, 96, 72);
end;

procedure TReporteCotizacion.Armar;
var
  lPdf: TRLPDFFilter;
begin
  TMapeoDatos.AListaTabla<TLineaDocumentoDTO>(FDocumento.Lineas,
    dmMemoria.mtDocumentoLineas);

  FPrincipal := NuevoReporte;
  FPrincipal.Title := Format(SDocTitulo, [FDocumento.Numero,
    FDocumento.EmpresaRazonSocial]);
  ArmarEncabezado(FPrincipal);
  ArmarTitulo;
  ArmarColumnas;
  ArmarDetalle;
  ArmarResumen;
  ArmarPie(FPrincipal);

  if not FDocumento.CartaPresentacion.Trim.IsEmpty then
  begin
    FCarta := NuevoReporte;
    FPrincipal.NextReport := FCarta;
    ArmarEncabezado(FCarta);
    ArmarCarta;
    ArmarPie(FCarta);
  end;

  lPdf := TRLPDFFilter.Create(FForma);
  lPdf.DocumentInfo.Title := FPrincipal.Title;
  lPdf.DocumentInfo.Author := FDocumento.EmpresaRazonSocial;
end;

end.
