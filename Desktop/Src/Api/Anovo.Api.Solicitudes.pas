unit Anovo.Api.Solicitudes;

// Cliente de la API de solicitudes.

interface

uses
  System.Generics.Collections,
  MVCFramework.RESTClient.Intf,
  Anovo.Api.Base,
  Anovo.Api.Intf.Solicitudes,
  Anovo.DTOs.Dashboard,
  Anovo.DTOs.Solicitudes;

type
  TApiSolicitudes = class(TApiBase, IApiSolicitudes)
  public
    function Seguimiento(const ATexto: string; const AHistorial: Boolean;
      const AFiltroDesde, AFiltroHasta: TDateTime;
      const APagina, APorPagina: Integer; out ATotal: Int64;
      out ADesde: TDateTime): TObjectList<TSolicitudAsesorDTO>;
    function Cola(const ATexto: string;
      const AFiltroDesde, AFiltroHasta: TDateTime;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TSolicitudPorCotizarDTO>;
    function EnTrabajo(const ATexto: string;
      const AFiltroDesde, AFiltroHasta: TDateTime;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TSolicitudEnTrabajoDTO>;
    function Obtener(const AId: Integer): TSolicitudDTO;
    function Piezas(const AId: Integer): TObjectList<TPiezaDTO>;
    function Medidas(const AId: Integer): TObjectList<TMedidaDTO>;
    function Adjuntos(const AId: Integer): TObjectList<TAdjuntoDTO>;
    function Adjunto(const AId, AAdjuntoId: Integer): TAdjuntoContenidoDTO;
    function RegistrarEnOficina(const ADto: TSolicitudCompletaDTO): Integer;
  private
    function Leer(const ARuta: string;
      const ALarga: Boolean = False): IMVCRESTResponse;
    function Pagina(const ARuta, ATexto: string;
      const AFiltroDesde, AFiltroHasta: TDateTime;
      const APagina, APorPagina: Integer; out ATotal: Int64;
      const ALista: TObject; const AClase: TClass): IMVCRESTResponse;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  JsonDataObjects;

const
  RUTA_SEGUIMIENTO = '/api/solicitudes/seguimiento';
  RUTA_COLA = '/api/solicitudes/cola';
  RUTA_EN_TRABAJO = '/api/solicitudes/en-trabajo';
  RUTA_SOLICITUD = '/api/solicitudes/%d';
  RUTA_PIEZAS = '/api/solicitudes/%d/piezas';
  RUTA_MEDIDAS = '/api/solicitudes/%d/medidas';
  RUTA_ADJUNTOS = '/api/solicitudes/%d/adjuntos';
  RUTA_ADJUNTO = '/api/solicitudes/%d/adjuntos/%d';
  RUTA_OFICINA = '/api/solicitudes/oficina';
  CAMPO_DATOS = 'data';
  PERIODO_MES = 'mes';
  PERIODO_TODO = 'todo';

function TApiSolicitudes.Seguimiento(const ATexto: string;
  const AHistorial: Boolean; const AFiltroDesde, AFiltroHasta: TDateTime;
  const APagina, APorPagina: Integer;
  out ATotal: Int64; out ADesde: TDateTime): TObjectList<TSolicitudAsesorDTO>;
var
  lRespuesta: IMVCRESTResponse;
  lJson: TJsonObject;
  lPeriodo: string;
begin
  if AHistorial then
    lPeriodo := PERIODO_TODO
  else
    lPeriodo := PERIODO_MES;

  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente
        .AddQueryStringParam('q', ATexto)
        .AddQueryStringParam('periodo', lPeriodo)
        .AddQueryStringParam('desde', FechaParaApi(AFiltroDesde))
        .AddQueryStringParam('hasta', FechaParaApi(AFiltroHasta))
        .AddQueryStringParam('pagina', APagina)
        .AddQueryStringParam('por_pagina', APorPagina)
        .Get(RUTA_SEGUIMIENTO);
    end);

  Result := TObjectList<TSolicitudAsesorDTO>.Create(True);
  try
    lRespuesta.BodyForListOf(Result, TSolicitudAsesorDTO, 'data');

    lJson := TJsonObject.Parse(lRespuesta.Content) as TJsonObject;
    try
      ATotal := lJson.L['total'];
      ADesde := 0;
      if not lJson.IsNull('desde') then
        ADesde := ISO8601ToDate(lJson.S['desde'], False);
    finally
      lJson.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TApiSolicitudes.Pagina(const ARuta, ATexto: string;
  const AFiltroDesde, AFiltroHasta: TDateTime;
  const APagina, APorPagina: Integer; out ATotal: Int64;
  const ALista: TObject; const AClase: TClass): IMVCRESTResponse;
var
  lJson: TJsonObject;
begin
  Result := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente
        .AddQueryStringParam('q', ATexto)
        .AddQueryStringParam('desde', FechaParaApi(AFiltroDesde))
        .AddQueryStringParam('hasta', FechaParaApi(AFiltroHasta))
        .AddQueryStringParam('pagina', APagina)
        .AddQueryStringParam('por_pagina', APorPagina)
        .Get(ARuta);
    end);

  Result.BodyForListOf(ALista, AClase, 'data');
  lJson := TJsonObject.Parse(Result.Content) as TJsonObject;
  try
    ATotal := lJson.L['total'];
  finally
    lJson.Free;
  end;
end;

function TApiSolicitudes.Leer(const ARuta: string;
  const ALarga: Boolean): IMVCRESTResponse;
begin
  Result := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente(True, '', ALarga).Get(ARuta);
    end);
end;

function TApiSolicitudes.RegistrarEnOficina(const ADto
  : TSolicitudCompletaDTO): Integer;
begin
  Result := IdDeLocation(Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False).Post(RUTA_OFICINA);
    end));
end;

function TApiSolicitudes.Obtener(const AId: Integer): TSolicitudDTO;
begin
  Result := TSolicitudDTO.Create;
  try
    Leer(Format(RUTA_SOLICITUD, [AId])).BodyFor(Result, CAMPO_DATOS);
  except
    Result.Free;
    raise;
  end;
end;

function TApiSolicitudes.Piezas(const AId: Integer): TObjectList<TPiezaDTO>;
begin
  Result := TObjectList<TPiezaDTO>.Create(True);
  try
    Leer(Format(RUTA_PIEZAS, [AId])).BodyForListOf(Result, TPiezaDTO,
      CAMPO_DATOS);
  except
    Result.Free;
    raise;
  end;
end;

function TApiSolicitudes.Medidas(const AId: Integer): TObjectList<TMedidaDTO>;
begin
  Result := TObjectList<TMedidaDTO>.Create(True);
  try
    Leer(Format(RUTA_MEDIDAS, [AId])).BodyForListOf(Result, TMedidaDTO,
      CAMPO_DATOS);
  except
    Result.Free;
    raise;
  end;
end;

function TApiSolicitudes.Adjuntos(const AId: Integer)
  : TObjectList<TAdjuntoDTO>;
begin
  Result := TObjectList<TAdjuntoDTO>.Create(True);
  try
    Leer(Format(RUTA_ADJUNTOS, [AId])).BodyForListOf(Result, TAdjuntoDTO,
      CAMPO_DATOS);
  except
    Result.Free;
    raise;
  end;
end;

function TApiSolicitudes.Adjunto(const AId, AAdjuntoId: Integer)
  : TAdjuntoContenidoDTO;
begin
  Result := TAdjuntoContenidoDTO.Create;
  try
    Leer(Format(RUTA_ADJUNTO, [AId, AAdjuntoId]), True).BodyFor(Result, CAMPO_DATOS);
  except
    Result.Free;
    raise;
  end;
end;

function TApiSolicitudes.Cola(const ATexto: string;
  const AFiltroDesde, AFiltroHasta: TDateTime;
  const APagina, APorPagina: Integer; out ATotal: Int64)
  : TObjectList<TSolicitudPorCotizarDTO>;
begin
  Result := TObjectList<TSolicitudPorCotizarDTO>.Create(True);
  try
    Pagina(RUTA_COLA, ATexto, AFiltroDesde, AFiltroHasta, APagina, APorPagina, ATotal, Result,
      TSolicitudPorCotizarDTO);
  except
    Result.Free;
    raise;
  end;
end;

function TApiSolicitudes.EnTrabajo(const ATexto: string;
  const AFiltroDesde, AFiltroHasta: TDateTime;
  const APagina, APorPagina: Integer; out ATotal: Int64)
  : TObjectList<TSolicitudEnTrabajoDTO>;
begin
  Result := TObjectList<TSolicitudEnTrabajoDTO>.Create(True);
  try
    Pagina(RUTA_EN_TRABAJO, ATexto, AFiltroDesde, AFiltroHasta,
      APagina, APorPagina, ATotal, Result,
      TSolicitudEnTrabajoDTO);
  except
    Result.Free;
    raise;
  end;
end;

end.
