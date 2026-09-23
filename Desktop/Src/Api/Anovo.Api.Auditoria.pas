unit Anovo.Api.Auditoria;

// La bitacora de auditoria contra el servidor.
//
// Dos rutas de listado y no una con filtro, porque asi las separa el servidor:
// /api/auditoria pide auditoria.ver_toda y /api/auditoria/cuentas pide
// auditoria.ver_cuentas. Aqui solo se escoge cual, con lo que diga el
// presentador.

interface

uses
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.Api.Intf.Auditoria,
  Anovo.DTOs.Auditoria;

type
  TApiAuditoria = class(TApiBase, IApiAuditoria)
  public
    function Buscar(const ASoloCuentas: Boolean;
      const ADesde, AHasta: TDateTime;
      const AEntidad, AAccion, ATexto: string;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TAuditoriaDTO>;
    function DeLaEntidad(const AEntidad: string; const AEntidadId: Integer)
      : TObjectList<TAuditoriaDTO>;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  JsonDataObjects,
  MVCFramework.RESTClient.Intf;

const
  RUTA_AUDITORIA = '/api/auditoria';
  RUTA_CUENTAS = '/api/auditoria/cuentas';

  // El formato que espera el controller. Fijo y no el de la maquina: la fecha
  // viaja en la URL y no debe depender de la configuracion regional.
  FORMATO_FECHA = 'yyyy-mm-dd';

function ComoTexto(const AFecha: TDateTime): string;
begin
  Result := FormatDateTime(FORMATO_FECHA, AFecha);
end;

function TApiAuditoria.Buscar(const ASoloCuentas: Boolean;
  const ADesde, AHasta: TDateTime; const AEntidad, AAccion, ATexto: string;
  const APagina, APorPagina: Integer; out ATotal: Int64)
  : TObjectList<TAuditoriaDTO>;
var
  lRespuesta: IMVCRESTResponse;
  lJson: TJsonObject;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    var
      lCliente: IMVCRESTClient;
    begin
      // Por parametro y no pegado a la ruta: el cliente REST codifica los
      // espacios y las tildes de lo que se escribio en el buscador.
      lCliente := NuevoCliente
        .AddQueryStringParam('desde', ComoTexto(ADesde))
        .AddQueryStringParam('hasta', ComoTexto(AHasta))
        .AddQueryStringParam('pagina', APagina)
        .AddQueryStringParam('por_pagina', APorPagina);
      if AEntidad <> '' then
        lCliente.AddQueryStringParam('entidad', AEntidad);
      if AAccion <> '' then
        lCliente.AddQueryStringParam('accion', AAccion);
      if ATexto <> '' then
        lCliente.AddQueryStringParam('q', ATexto);

      if ASoloCuentas then
        Result := lCliente.Get(RUTA_CUENTAS)
      else
        Result := lCliente.Get(RUTA_AUDITORIA);
    end);

  Result := TObjectList<TAuditoriaDTO>.Create(True);
  try
    // Coleccion del contrato: la lista en data, la paginacion en la raiz.
    lRespuesta.BodyForListOf(Result, TAuditoriaDTO, 'data');

    lJson := TJsonObject.Parse(lRespuesta.Content) as TJsonObject;
    try
      ATotal := lJson.L['total'];
    finally
      lJson.Free;
    end;
  except
    // Si falla a mitad de la lectura, la lista no la recibe nadie que la
    // pueda liberar.
    Result.Free;
    raise;
  end;
end;

function TApiAuditoria.DeLaEntidad(const AEntidad: string;
  const AEntidadId: Integer): TObjectList<TAuditoriaDTO>;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(Format('%s/%s/%d',
        [RUTA_AUDITORIA, AEntidad, AEntidadId]));
    end);

  Result := TObjectList<TAuditoriaDTO>.Create(True);
  try
    lRespuesta.BodyForListOf(Result, TAuditoriaDTO, 'data');
  except
    Result.Free;
    raise;
  end;
end;

end.
