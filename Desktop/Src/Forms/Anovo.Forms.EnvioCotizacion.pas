unit Anovo.Forms.EnvioCotizacion;

// Ventana Enviar al cliente: el correo con el PDF adjunto sale desde el
// servidor, o se guarda el PDF y se abre el programa de correo del usuario.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, Data.DB,
  rDBComponents,
  VclPlano.BotonWin,
  Anovo.Forms.Edicion, Vcl.TitleBarCtrls, Vcl.WinXCtrls,
  Anovo.UI.PanelRelativo,
  Anovo.DTOs.Correo,
  Anovo.DTOs.Documento,
  Anovo.Vistas.Intf.EnvioCotizacion,
  Anovo.Presentadores.EnvioCotizacion;

type
  TfrmEnvioCotizacion = class(TfrmEdicion, IVistaEnvioCotizacion)
    pnlCampos: TPanel;
    edPara: TrDBEdit;
    edCopia: TrDBEdit;
    edAsunto: TrDBEdit;
    meMensaje: TrDBMemo;
    lblAdjunto: TLabel;
    lblVia: TLabel;
    btnVistaPrevia: TPlanoBotonWin;
    btnManual: TPlanoBotonWin;
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure btnManualClick(Sender: TObject);
    procedure btnVistaPreviaClick(Sender: TObject);
  private
    FPresentador: TPresentadorEnvioCotizacion;
    FDocumento: TCotizacionDocumentoDTO;
    FServidorDisponible: Boolean;
    function Direcciones(const ATexto: string): TArray<string>;
    function ValidarCampos(const AExigirPara: Boolean): Boolean;
    procedure AbrirCorreo;
    procedure MostrarCargando(const AActivo: Boolean);
    function Confirmar(const AMensaje: string): Boolean;
    procedure MostrarDatos(const ADatos: TEnvioCorreoDTO);
    procedure MostrarServidor(const ADisponible: Boolean;
      const AAviso: string);
    procedure Enviado(const AMensaje: string);
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    constructor Crear(AOwner: TComponent;
      const ADocumento: TCotizacionDocumentoDTO; const ACotizacionId: Integer);
    class function Enviar(AOwner: TComponent;
      const ADocumento: TCotizacionDocumentoDTO;
      const ACotizacionId: Integer): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Winapi.ShellAPI,
  System.NetEncoding,
  Anovo.UI.Vista,
  Anovo.Api.Cotizaciones,
  Anovo.Datos.Memoria,
  Anovo.Mapeo.Datos,
  Anovo.Reportes.Cotizacion,
  Anovo.Validacion,
  Anovo.Textos;

const
  EXTENSION_PDF = 'pdf';
  SEPARADORES: array [0 .. 1] of Char = (',', ';');
  ESQUEMA_MAILTO = 'mailto:';

function Codificar(const ATexto: string): string;
begin
  Result := TNetEncoding.URL.Encode(ATexto).Replace('+', '%20',
    [rfReplaceAll]);
end;

constructor TfrmEnvioCotizacion.Crear(AOwner: TComponent;
  const ADocumento: TCotizacionDocumentoDTO; const ACotizacionId: Integer);
begin
  inherited Create(AOwner);
  FDocumento := ADocumento;
  lblAdjunto.Caption := Format(SEnvioAdjunto,
    [Format(SNombrePdfCotizacion, [ADocumento.Numero])]);
  FPresentador := TPresentadorEnvioCotizacion.Create(Self,
    TApiCotizaciones.Create, ADocumento, ACotizacionId);
  FPresentador.Iniciar;
end;

class function TfrmEnvioCotizacion.Enviar(AOwner: TComponent;
  const ADocumento: TCotizacionDocumentoDTO;
  const ACotizacionId: Integer): Boolean;
var
  lForma: TfrmEnvioCotizacion;
begin
  lForma := TfrmEnvioCotizacion.Crear(AOwner, ADocumento, ACotizacionId);
  try
    Result := lForma.ShowModal = mrOk;
  finally
    lForma.Free;
  end;
end;

procedure TfrmEnvioCotizacion.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPresentador);
  dmMemoria.mtEnvioCorreo.Close;
end;

function TfrmEnvioCotizacion.ControlesEdicion: TArray<TControl>;
begin
  Result := [pnlCampos];
end;

function TfrmEnvioCotizacion.Direcciones(const ATexto: string): TArray<string>;
var
  lParte: string;
begin
  Result := [];
  for lParte in ATexto.Split(SEPARADORES) do
    if not lParte.Trim.IsEmpty then
      Result := Result + [lParte.Trim];
end;

function TfrmEnvioCotizacion.ValidarCampos(const AExigirPara: Boolean): Boolean;
var
  lReparos: TStringList;
  lCorreo: string;
  lPara: TArray<string>;
begin
  lReparos := TStringList.Create;
  try
    with dmMemoria do
    begin
      lPara := Direcciones(mtEnvioCorreoPARA.AsString);
      if AExigirPara and (Length(lPara) = 0) then
        lReparos.Add(SValPara);
      for lCorreo in lPara do
        if not TValidacion.Correo(lCorreo) then
        begin
          lReparos.Add(SValPara);
          Break;
        end;
      for lCorreo in Direcciones(mtEnvioCorreoCC.AsString) do
        if not TValidacion.Correo(lCorreo) then
        begin
          lReparos.Add(SValCopia);
          Break;
        end;
      if not TValidacion.Texto(mtEnvioCorreoASUNTO.AsString) then
        lReparos.Add(SValAsunto);
    end;
    Result := MostrarReparos(lReparos, SReparosEnvio);
  finally
    lReparos.Free;
  end;
end;

procedure TfrmEnvioCotizacion.btnGuardarClick(Sender: TObject);
var
  lDatos: TEnvioCorreoDTO;
  lCodificador: TBase64Encoding;
begin
  dmMemoria.Confirmar(dmMemoria.mtEnvioCorreo);
  if not ValidarCampos(True) then
    Exit;

  lDatos := TMapeoDatos.ADto<TEnvioCorreoDTO>(dmMemoria.mtEnvioCorreo);
  lCodificador := TBase64Encoding.Create(0);
  try
    try
      lDatos.Pdf := lCodificador.EncodeBytesToString(
        TReporteCotizacion.PdfEnBytes(FDocumento));
    except
      lDatos.Free;
      raise;
    end;
  finally
    lCodificador.Free;
  end;
  FPresentador.EnviarDesdeServidor(lDatos);
end;

procedure TfrmEnvioCotizacion.AbrirCorreo;
var
  lUrl: string;
begin
  with dmMemoria do
  begin
    lUrl := ESQUEMA_MAILTO + Codificar(mtEnvioCorreoPARA.AsString.Trim) +
      '?subject=' + Codificar(mtEnvioCorreoASUNTO.AsString.Trim) +
      '&body=' + Codificar(mtEnvioCorreoMENSAJE.AsString);
    if not mtEnvioCorreoCC.AsString.Trim.IsEmpty then
      lUrl := lUrl + '&cc=' + Codificar(mtEnvioCorreoCC.AsString.Trim);
  end;
  ShellExecute(Handle, 'open', PChar(lUrl), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmEnvioCotizacion.btnManualClick(Sender: TObject);
var
  lDialogo: TSaveDialog;
begin
  dmMemoria.Confirmar(dmMemoria.mtEnvioCorreo);
  if not ValidarCampos(False) then
    Exit;

  lDialogo := TSaveDialog.Create(nil);
  try
    lDialogo.Filter := SFiltroPdf;
    lDialogo.DefaultExt := EXTENSION_PDF;
    lDialogo.FileName := Format(SNombrePdfCotizacion, [FDocumento.Numero]);
    lDialogo.Options := lDialogo.Options + [ofOverwritePrompt];
    if not lDialogo.Execute then
      Exit;
    TReporteCotizacion.GuardarPdf(FDocumento, lDialogo.FileName);
    AbrirCorreo;
    FPresentador.ConfirmarEnvioManual(lDialogo.FileName);
  finally
    lDialogo.Free;
  end;
end;

procedure TfrmEnvioCotizacion.btnVistaPreviaClick(Sender: TObject);
begin
  TReporteCotizacion.VistaPrevia(FDocumento);
end;

procedure TfrmEnvioCotizacion.MostrarCargando(const AActivo: Boolean);
begin
  MostrarOcupado(AActivo);
  if not AActivo then
    btnGuardar.Enabled := FServidorDisponible;
end;

function TfrmEnvioCotizacion.Confirmar(const AMensaje: string): Boolean;
begin
  Result := Anovo.UI.Vista.Confirmar(AMensaje);
end;

procedure TfrmEnvioCotizacion.MostrarDatos(const ADatos: TEnvioCorreoDTO);
begin
  TMapeoDatos.ATabla(ADatos, dmMemoria.mtEnvioCorreo);
  dmMemoria.mtEnvioCorreo.Edit;
end;

procedure TfrmEnvioCotizacion.MostrarServidor(const ADisponible: Boolean;
  const AAviso: string);
begin
  FServidorDisponible := ADisponible;
  btnGuardar.Enabled := ADisponible;
  lblVia.Caption := AAviso;
end;

procedure TfrmEnvioCotizacion.Enviado(const AMensaje: string);
begin
  if not AMensaje.IsEmpty then
    Informar(AMensaje);
  ModalResult := mrOk;
end;

end.
