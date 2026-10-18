unit Anovo.Api.Cotizaciones;

// Cliente de la API de cotizaciones.

interface

uses
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.Api.Intf.Cotizaciones,
  Anovo.DTOs.Correo,
  Anovo.DTOs.Cotizaciones,
  Anovo.DTOs.Documento;

type
  TApiCotizaciones = class(TApiBase, IApiCotizaciones)
  public
    function Bandeja(const ATexto: string;
      const AFiltroDesde, AFiltroHasta: TDateTime;
      const APagina, APorPagina: Integer): TBandejaPaginaDTO;
    function Obtener(const AId: Integer): TCotizacionDTO;
    function Documento(const AId: Integer): TCotizacionDocumentoDTO;
    function EstadoCorreo: TEstadoCorreoDTO;
    procedure EnviarPorCorreo(const AId: Integer; const ADto: TEnvioCorreoDTO);
    function Detalle(const AId: Integer): TObjectList<TLineaDTO>;
    function SinRespuesta: TObjectList<TCotizacionDTO>;
    function Estados(const AId: Integer): TObjectList<TEstadoCotizacionDTO>;
    procedure DarVistoBueno(const AId: Integer);
    procedure Devolver(const AId: Integer; const AMotivo: string);
    procedure RegistrarRespuesta(const AId: Integer; const AAceptada: Boolean;
      const AOrdenCompra: string);
    procedure Tomar(const ASolicitudId: Integer);
    function Listar(const ATexto, AEstado: string; const AClienteId: Integer;
      const ADesde, AHasta: TDateTime; const APagina, APorPagina: Integer;
      out ATotal: Int64)
      : TObjectList<TCotizacionDTO>;
    procedure Actualizar(const AId: Integer; const ADto: TCotizacionEdicionDTO);
    function AgregarLinea(const AId: Integer;
      const ADto: TLineaNuevaDTO): Integer;
    procedure ActualizarLinea(const AId, ALineaId: Integer;
      const ADto: TLineaNuevaDTO);
    procedure QuitarLinea(const AId, ALineaId: Integer);
    procedure AplicarAjuste(const AId: Integer; const ADto: TAjusteDTO);
    procedure Presentar(const AId: Integer);
    procedure Enviar(const AId: Integer);
    procedure Descartar(const AId: Integer);
  private
    procedure Accion(const AId: Integer; const ARuta: string);
    procedure Decidir(const AId: Integer; const ARuta, AMotivo: string);
  end;

implementation

uses
  System.SysUtils,
  JsonDataObjects,
  MVCFramework.RESTClient.Intf;

const
  RUTA_COTIZACIONES = '/api/cotizaciones';
  RUTA_BANDEJA = '/api/cotizaciones/bandeja';
  RUTA_SIN_RESPUESTA = '/api/cotizaciones/sin-respuesta';
  RUTA_COTIZACION = '/api/cotizaciones/%d';
  RUTA_DOCUMENTO = '/api/cotizaciones/%d/documento';
  RUTA_ENVIO_CORREO = '/api/cotizaciones/%d/envio-correo';
  RUTA_ESTADO_CORREO = '/api/correo/estado';
  RUTA_DETALLE = '/api/cotizaciones/%d/detalle';
  RUTA_ESTADOS = '/api/cotizaciones/%d/estados';
  RUTA_VISTO_BUENO = '/api/cotizaciones/%d/visto-bueno';
  RUTA_DEVOLUCION = '/api/cotizaciones/%d/devolucion';
  RUTA_RESPUESTA = '/api/cotizaciones/%d/respuesta';
  RUTA_LINEA = '/api/cotizaciones/%d/detalle/%d';
  RUTA_AJUSTE = '/api/cotizaciones/%d/ajuste';
  RUTA_PRESENTACION = '/api/cotizaciones/%d/presentacion';
  RUTA_ENVIO = '/api/cotizaciones/%d/envio';
  RUTA_DESCARTE = '/api/cotizaciones/%d/descarte';

function TApiCotizaciones.Bandeja(const ATexto: string;
  const AFiltroDesde, AFiltroHasta: TDateTime;
  const APagina, APorPagina: Integer): TBandejaPaginaDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente
        .AddQueryStringParam('q', ATexto)
        .AddQueryStringParam('desde', FechaParaApi(AFiltroDesde))
        .AddQueryStringParam('hasta', FechaParaApi(AFiltroHasta))
        .AddQueryStringParam('pagina', APagina)
        .AddQueryStringParam('por_pagina', APorPagina)
        .Get(RUTA_BANDEJA);
    end);

  Result := TBandejaPaginaDTO.Create;
  try
    lRespuesta.BodyFor(Result);
  except
    Result.Free;
    raise;
  end;
end;

function TApiCotizaciones.Obtener(const AId: Integer): TCotizacionDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(Format(RUTA_COTIZACION, [AId]));
    end);

  Result := TCotizacionDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiCotizaciones.Documento(const AId: Integer)
  : TCotizacionDocumentoDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente(True, '', True).Get(Format(RUTA_DOCUMENTO, [AId]));
    end);

  Result := TCotizacionDocumentoDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiCotizaciones.EstadoCorreo: TEstadoCorreoDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(RUTA_ESTADO_CORREO);
    end);

  Result := TEstadoCorreoDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

procedure TApiCotizaciones.EnviarPorCorreo(const AId: Integer;
  const ADto: TEnvioCorreoDTO);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False)
        .Post(Format(RUTA_ENVIO_CORREO, [AId]));
    end);
end;

function TApiCotizaciones.Detalle(const AId: Integer): TObjectList<TLineaDTO>;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(Format(RUTA_DETALLE, [AId]));
    end);

  Result := TObjectList<TLineaDTO>.Create(True);
  try
    lRespuesta.BodyForListOf(Result, TLineaDTO, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiCotizaciones.Estados(const AId: Integer)
  : TObjectList<TEstadoCotizacionDTO>;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(Format(RUTA_ESTADOS, [AId]));
    end);

  Result := TObjectList<TEstadoCotizacionDTO>.Create(True);
  try
    lRespuesta.BodyForListOf(Result, TEstadoCotizacionDTO, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiCotizaciones.SinRespuesta: TObjectList<TCotizacionDTO>;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(RUTA_SIN_RESPUESTA);
    end);

  Result := TObjectList<TCotizacionDTO>.Create(True);
  try
    lRespuesta.BodyForListOf(Result, TCotizacionDTO, 'data');
  except
    Result.Free;
    raise;
  end;
end;

procedure TApiCotizaciones.Accion(const AId: Integer; const ARuta: string);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Post(Format(ARuta, [AId]));
    end);
end;

procedure TApiCotizaciones.DarVistoBueno(const AId: Integer);
begin
  Accion(AId, RUTA_VISTO_BUENO);
end;

procedure TApiCotizaciones.Presentar(const AId: Integer);
begin
  Accion(AId, RUTA_PRESENTACION);
end;

procedure TApiCotizaciones.Enviar(const AId: Integer);
begin
  Accion(AId, RUTA_ENVIO);
end;

procedure TApiCotizaciones.Descartar(const AId: Integer);
begin
  Accion(AId, RUTA_DESCARTE);
end;

function TApiCotizaciones.Listar(const ATexto, AEstado: string;
  const AClienteId: Integer; const ADesde, AHasta: TDateTime;
  const APagina, APorPagina: Integer;
  out ATotal: Int64)
  : TObjectList<TCotizacionDTO>;
var
  lRespuesta: IMVCRESTResponse;
  lJson: TJsonObject;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente
        .AddQueryStringParam('q', ATexto)
        .AddQueryStringParam('estado', AEstado)
        .AddQueryStringParam('cliente_id', AClienteId)
        .AddQueryStringParam('desde', FechaParaApi(ADesde))
        .AddQueryStringParam('hasta', FechaParaApi(AHasta))
        .AddQueryStringParam('pagina', APagina)
        .AddQueryStringParam('por_pagina', APorPagina)
        .Get(RUTA_COTIZACIONES);
    end);

  Result := TObjectList<TCotizacionDTO>.Create(True);
  try
    lRespuesta.BodyForListOf(Result, TCotizacionDTO, 'data');
    lJson := TJsonObject.Parse(lRespuesta.Content) as TJsonObject;
    try
      ATotal := lJson.L['total'];
    finally
      lJson.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

procedure TApiCotizaciones.Actualizar(const AId: Integer;
  const ADto: TCotizacionEdicionDTO);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False)
        .Put(Format(RUTA_COTIZACION, [AId]));
    end);
end;

function TApiCotizaciones.AgregarLinea(const AId: Integer;
  const ADto: TLineaNuevaDTO): Integer;
begin
  Result := IdDeLocation(Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False)
        .Post(Format(RUTA_DETALLE, [AId]));
    end));
end;

procedure TApiCotizaciones.ActualizarLinea(const AId, ALineaId: Integer;
  const ADto: TLineaNuevaDTO);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False)
        .Put(Format(RUTA_LINEA, [AId, ALineaId]));
    end);
end;

procedure TApiCotizaciones.QuitarLinea(const AId, ALineaId: Integer);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Delete(Format(RUTA_LINEA, [AId, ALineaId]));
    end);
end;

procedure TApiCotizaciones.AplicarAjuste(const AId: Integer;
  const ADto: TAjusteDTO);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False)
        .Post(Format(RUTA_AJUSTE, [AId]));
    end);
end;

procedure TApiCotizaciones.Devolver(const AId: Integer; const AMotivo: string);
begin
  Decidir(AId, RUTA_DEVOLUCION, AMotivo);
end;

procedure TApiCotizaciones.RegistrarRespuesta(const AId: Integer;
  const AAceptada: Boolean; const AOrdenCompra: string);
var
  lDto: TRespuestaClienteDTO;
begin
  lDto := TRespuestaClienteDTO.Create;
  try
    lDto.Aceptada := AAceptada;
    if AOrdenCompra <> '' then
      lDto.OrdenCompra := AOrdenCompra;
    Ejecutar(
      function: IMVCRESTResponse
      begin
        Result := NuevoCliente.AddBody(lDto, False)
          .Post(Format(RUTA_RESPUESTA, [AId]));
      end);
  finally
    lDto.Free;
  end;
end;

procedure TApiCotizaciones.Decidir(const AId: Integer;
  const ARuta, AMotivo: string);
var
  lDto: TMotivoDTO;
begin
  lDto := TMotivoDTO.Create;
  try
    lDto.Motivo := AMotivo;
    Ejecutar(
      function: IMVCRESTResponse
      begin
        Result := NuevoCliente.AddBody(lDto, False)
          .Post(Format(ARuta, [AId]));
      end);
  finally
    lDto.Free;
  end;
end;

procedure TApiCotizaciones.Tomar(const ASolicitudId: Integer);
var
  lDto: TCotizacionNuevaDTO;
begin
  lDto := TCotizacionNuevaDTO.Create;
  try
    lDto.SolicitudId := ASolicitudId;
    Ejecutar(
      function: IMVCRESTResponse
      begin
        Result := NuevoCliente.AddBody(lDto, False).Post(RUTA_COTIZACIONES);
      end);
  finally
    lDto.Free;
  end;
end;

end.
