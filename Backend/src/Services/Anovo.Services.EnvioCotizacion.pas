unit Anovo.Services.EnvioCotizacion;

// Envia la cotizacion con visto bueno al cliente: marca enviada y registra el
// envio en una transaccion; si el correo falla, se deshace todo.

interface

uses
  System.SysUtils,
  MVCFramework,
  Anovo.DTOs.Correo,
  Anovo.Repositories.Intf.Cotizaciones,
  Anovo.Services.Intf.Correo,
  Anovo.Services.Intf.Cotizaciones,
  Anovo.Services.Intf.EnvioCotizacion;

type
  TEnvioCotizacionService = class(TInterfacedObject, IEnvioCotizacionService)
  private
    fCotizaciones: ICotizacionService;
    fEnvios: ICotizacionEnvioRepository;
    fCorreo: ICorreoService;
    function Direcciones(const ATexto: string): TArray<string>;
    function Pdf(const ABase64: string): TBytes;
  public
    [MVCInject]
    constructor Create(ACotizaciones: ICotizacionService;
      AEnvios: ICotizacionEnvioRepository; ACorreo: ICorreoService); reintroduce;
    procedure Enviar(const AId, AUsuarioId: Integer;
      const ARoles: TArray<string>; const ADto: TEnvioCorreoDTO);
  end;

implementation

uses
  System.NetEncoding,
  MVCFramework.Repository,
  Anovo.Auditoria.Contexto,
  Anovo.DTOs.Cotizaciones,
  Anovo.Entities.Cotizaciones,
  Anovo.Errors,
  Anovo.Textos;

const
  ESTADO_VISTO_BUENO = 'visto_bueno';
  FIRMA_PDF = '%PDF';
  LARGO_MENSAJE = 4000;
  SEPARADORES: array [0 .. 1] of Char = (',', ';');

constructor TEnvioCotizacionService.Create(ACotizaciones: ICotizacionService;
  AEnvios: ICotizacionEnvioRepository; ACorreo: ICorreoService);
begin
  inherited Create;
  fCotizaciones := ACotizaciones;
  fEnvios := AEnvios;
  fCorreo := ACorreo;
end;

function TEnvioCotizacionService.Direcciones(const ATexto: string)
  : TArray<string>;
var
  lParte: string;
begin
  Result := [];
  for lParte in ATexto.Split(SEPARADORES) do
    if not lParte.Trim.IsEmpty then
      Result := Result + [lParte.Trim.ToLower];
end;

function TEnvioCotizacionService.Pdf(const ABase64: string): TBytes;
begin
  if ABase64.Trim.IsEmpty then
    raise EDatoInvalido.Create(SCorreoFaltaPdf);
  try
    Result := TNetEncoding.Base64.DecodeStringToBytes(ABase64);
  except
    raise EDatoInvalido.Create(SCorreoPdfInvalido);
  end;
  if (Length(Result) < Length(FIRMA_PDF)) or
    (TEncoding.ANSI.GetString(Result, 0, Length(FIRMA_PDF)) <> FIRMA_PDF) then
    raise EDatoInvalido.Create(SCorreoPdfInvalido);
end;

procedure TEnvioCotizacionService.Enviar(const AId, AUsuarioId: Integer;
  const ARoles: TArray<string>; const ADto: TEnvioCorreoDTO);
var
  lCotizacion: TCotizacionDTO;
  lMensaje: TMensajeCorreo;
  lEnvio: TCotizacionEnvios;
begin
  if ADto.Mensaje.Length > LARGO_MENSAJE then
    raise EDatoInvalido.Create(Format(SCorreoMensajeLargo, [LARGO_MENSAJE]));

  lCotizacion := fCotizaciones.Obtener(AId, AUsuarioId, ARoles);
  lMensaje := TMensajeCorreo.Create;
  try
    if lCotizacion.Estado <> ESTADO_VISTO_BUENO then
      raise EConflictoDeEstado.Create('TRANSICION_INVALIDA',
        Format(SCotizacionNoEnviable, [lCotizacion.Estado]));

    lMensaje.Para := Direcciones(ADto.Para);
    lMensaje.Copia := Direcciones(ADto.Cc);
    lMensaje.Asunto := ADto.Asunto.Trim;
    lMensaje.Texto := ADto.Mensaje;
    lMensaje.NombreAdjunto := Format(SNombrePdfCotizacion, [lCotizacion.Numero]);
    lMensaje.Adjunto := Pdf(ADto.Pdf);

    var
    lTx := TMVCRepository.UseTransactionContext;

    fCotizaciones.Enviar(AId);

    lEnvio := TCotizacionEnvios.Create;
    try
      lEnvio.CotizacionId := AId;
      lEnvio.UsuarioId := AUsuarioId;
      lEnvio.Para := string.Join(', ', lMensaje.Para);
      if Length(lMensaje.Copia) > 0 then
        lEnvio.CC := string.Join(', ', lMensaje.Copia);
      lEnvio.Asunto := lMensaje.Asunto;
      lEnvio.Remitente := fCorreo.Remitente;
      lEnvio.Modo := fCorreo.Modo;
      FijarDetalle(Format(SDetalleEnvioCorreo, [lCotizacion.Numero,
        lEnvio.Para]));
      fEnvios.Insert(lEnvio);
    finally
      lEnvio.Free;
    end;

    fCorreo.Enviar(lMensaje);
  finally
    lMensaje.Free;
    lCotizacion.Free;
  end;
end;

end.
