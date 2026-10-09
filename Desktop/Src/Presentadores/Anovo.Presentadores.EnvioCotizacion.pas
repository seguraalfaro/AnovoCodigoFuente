unit Anovo.Presentadores.EnvioCotizacion;

// Presentador de Enviar al cliente: arma el correo con los datos del
// documento y envia desde el servidor o marca enviada tras el envio manual.

interface

uses
  Anovo.Api.Intf.Cotizaciones,
  Anovo.DTOs.Correo,
  Anovo.DTOs.Documento,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.EnvioCotizacion;

type
  TPresentadorEnvioCotizacion = class(TPresentadorBase)
  private
    FVista: IVistaEnvioCotizacion;
    FApi: IApiCotizaciones;
    FDocumento: TCotizacionDocumentoDTO;
    FCotizacionId: Integer;
    function DatosIniciales: TEnvioCorreoDTO;
    procedure CargarServidor;
  public
    constructor Create(const AVista: IVistaEnvioCotizacion;
      const AApi: IApiCotizaciones; const ADocumento: TCotizacionDocumentoDTO;
      const ACotizacionId: Integer);
    procedure Iniciar;
    procedure EnviarDesdeServidor(const ADatos: TEnvioCorreoDTO);
    procedure ConfirmarEnvioManual(const ARutaPdf: string);
  end;

implementation

uses
  System.SysUtils,
  Anovo.Textos;

constructor TPresentadorEnvioCotizacion.Create(const AVista
  : IVistaEnvioCotizacion; const AApi: IApiCotizaciones;
  const ADocumento: TCotizacionDocumentoDTO; const ACotizacionId: Integer);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FDocumento := ADocumento;
  FCotizacionId := ACotizacionId;
end;

function TPresentadorEnvioCotizacion.DatosIniciales: TEnvioCorreoDTO;
var
  lSaludo: string;
begin
  if FDocumento.ContactoNombre.IsEmpty then
    lSaludo := SEnvioClienteGenerico
  else
    lSaludo := FDocumento.ContactoNombre;
  Result := TEnvioCorreoDTO.Create;
  Result.Para := FDocumento.ContactoCorreo;
  Result.Asunto := Format(SEnvioAsunto, [FDocumento.Numero,
    FDocumento.EmpresaRazonSocial]);
  Result.Mensaje := Format(SEnvioMensaje, [lSaludo, FDocumento.Numero,
    FDocumento.DescripcionTrabajo, FDocumento.Firmante,
    FDocumento.EmpresaRazonSocial]);
end;

procedure TPresentadorEnvioCotizacion.Iniciar;
var
  lDatos: TEnvioCorreoDTO;
begin
  lDatos := DatosIniciales;
  try
    FVista.MostrarDatos(lDatos);
  finally
    lDatos.Free;
  end;
  CargarServidor;
end;

procedure TPresentadorEnvioCotizacion.CargarServidor;
var
  lApi: IApiCotizaciones;
begin
  lApi := FApi;
  FVista.MostrarServidor(False, SEnvioServidorNoDisponible);

  Ejecutar<TEstadoCorreoDTO>(SAccionEstadoCorreo,
    function: TEstadoCorreoDTO
    begin
      Result := lApi.EstadoCorreo;
    end,
    procedure(AEstado: TEstadoCorreoDTO)
    begin
      if AEstado.Configurado then
        FVista.MostrarServidor(True, Format(SEnvioDesdeServidor,
          [AEstado.Remitente]))
      else
        FVista.MostrarServidor(False, SEnvioServidorNoDisponible);
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarServidor(False, SEnvioServidorNoDisponible);
    end);
end;

procedure TPresentadorEnvioCotizacion.EnviarDesdeServidor(const ADatos
  : TEnvioCorreoDTO);
var
  lApi: IApiCotizaciones;
  lId, lNumero: Integer;
  lPara: string;
begin
  if not FVista.Confirmar(Format(SConfirmarEnvioServidor,
    [FDocumento.Numero, ADatos.Para])) then
  begin
    ADatos.Free;
    Exit;
  end;
  lApi := FApi;
  lId := FCotizacionId;
  lNumero := FDocumento.Numero;
  lPara := ADatos.Para;

  Ejecutar(SAccionEnviarCorreo,
    procedure
    begin
      lApi.EnviarPorCorreo(lId, ADatos);
    end,
    procedure
    begin
      FVista.Enviado(Format(SCotizacionEnviadaCorreo, [lNumero, lPara]));
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarCargando(AActivo);
    end,
    procedure
    begin
      ADatos.Free;
    end);
end;

procedure TPresentadorEnvioCotizacion.ConfirmarEnvioManual(const ARutaPdf
  : string);
var
  lApi: IApiCotizaciones;
  lId: Integer;
begin
  if not FVista.Confirmar(Format(SConfirmarEnvioManual,
    [ARutaPdf, FDocumento.Numero])) then
    Exit;
  lApi := FApi;
  lId := FCotizacionId;

  Ejecutar(SAccionEnviarCotizacion,
    procedure
    begin
      lApi.Enviar(lId);
    end,
    procedure
    begin
      FVista.Enviado('');
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarCargando(AActivo);
    end);
end;

end.
