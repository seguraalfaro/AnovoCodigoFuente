unit Anovo.Api.Cotizaciones;

// Cliente de la API de cotizaciones.

interface

uses
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.Api.Intf.Cotizaciones,
  Anovo.DTOs.Cotizaciones;

type
  TApiCotizaciones = class(TApiBase, IApiCotizaciones)
  public
    function Bandeja(const ATexto: string; const APagina, APorPagina: Integer)
      : TBandejaPaginaDTO;
    function Obtener(const AId: Integer): TCotizacionDTO;
    function Detalle(const AId: Integer): TObjectList<TLineaDTO>;
    procedure Aprobar(const AId: Integer);
    procedure Devolver(const AId: Integer; const AMotivo: string);
    procedure Rechazar(const AId: Integer; const AMotivo: string);
    procedure Tomar(const ASolicitudId: Integer);
  private
    procedure Decidir(const AId: Integer; const ARuta, AMotivo: string);
  end;

implementation

uses
  System.SysUtils,
  MVCFramework.RESTClient.Intf;

const
  RUTA_COTIZACIONES = '/api/cotizaciones';
  RUTA_BANDEJA = '/api/cotizaciones/bandeja';
  RUTA_COTIZACION = '/api/cotizaciones/%d';
  RUTA_DETALLE = '/api/cotizaciones/%d/detalle';
  RUTA_APROBACION = '/api/cotizaciones/%d/aprobacion';
  RUTA_DEVOLUCION = '/api/cotizaciones/%d/devolucion';
  RUTA_RECHAZO = '/api/cotizaciones/%d/rechazo';

function TApiCotizaciones.Bandeja(const ATexto: string;
  const APagina, APorPagina: Integer): TBandejaPaginaDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente
        .AddQueryStringParam('q', ATexto)
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

procedure TApiCotizaciones.Aprobar(const AId: Integer);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Post(Format(RUTA_APROBACION, [AId]));
    end);
end;

procedure TApiCotizaciones.Devolver(const AId: Integer; const AMotivo: string);
begin
  Decidir(AId, RUTA_DEVOLUCION, AMotivo);
end;

procedure TApiCotizaciones.Rechazar(const AId: Integer; const AMotivo: string);
begin
  Decidir(AId, RUTA_RECHAZO, AMotivo);
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
