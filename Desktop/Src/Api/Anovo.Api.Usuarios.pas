unit Anovo.Api.Usuarios;

// Cliente de la API de usuarios: listado, cuenta, clave temporal y
// permisos adicionales de cada persona.

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  MVCFramework.RESTClient.Intf,
  Anovo.Api.Base,
  Anovo.Api.Intf.Usuarios,
  Anovo.DTOs.Usuarios;

type
  TApiUsuarios = class(TApiBase, IApiUsuarios)
  private
    procedure Accion(const AId: Integer; const AAccion: string);
  public
    function Buscar(const ATexto, AEstado: string;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TUsuarioDTO>;
    function Obtener(const AId: Integer): TUsuarioDTO;
    function Crear(const ADto: TUsuarioEdicionDTO): TUsuarioDTO;
    procedure Editar(const AId: Integer; const ADto: TUsuarioEdicionDTO);
    procedure Inactivar(const AId: Integer);
    procedure Activar(const AId: Integer);
    procedure RestablecerClave(const AId: Integer; const AClave: string);
    procedure PedirCambioClave(const AId: Integer);
    function Excepciones(const AId: Integer): TObjectList<TExcepcionDTO>;
    procedure CambiarExcepciones(const AId: Integer;
      const ADto: TCambiosExcepcionesDTO);
  end;

implementation

uses
  JsonDataObjects;

const
  RUTA_USUARIOS = '/api/usuarios';
  SUB_ID = '%s/%d';
  SUB_ACCION = '%s/%d/%s';
  ACCION_INACTIVACION = 'inactivacion';
  ACCION_ACTIVACION = 'activacion';
  ACCION_CLAVE = 'clave';
  ACCION_CAMBIO_CLAVE = 'cambio-clave';
  ACCION_PERMISOS = 'permisos';

function TApiUsuarios.Buscar(const ATexto, AEstado: string;
  const APagina, APorPagina: Integer; out ATotal: Int64)
  : TObjectList<TUsuarioDTO>;
var
  lRespuesta: IMVCRESTResponse;
  lJson: TJsonObject;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    var
      lCliente: IMVCRESTClient;
    begin
      lCliente := NuevoCliente
        .AddQueryStringParam('q', ATexto)
        .AddQueryStringParam('pagina', APagina)
        .AddQueryStringParam('por_pagina', APorPagina);
      if AEstado <> '' then
        lCliente.AddQueryStringParam('estado', AEstado);
      Result := lCliente.Get(RUTA_USUARIOS);
    end);

  Result := TObjectList<TUsuarioDTO>.Create(True);
  try
    lRespuesta.BodyForListOf(Result, TUsuarioDTO, 'data');

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

function TApiUsuarios.Obtener(const AId: Integer): TUsuarioDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(Format(SUB_ID, [RUTA_USUARIOS, AId]));
    end);

  Result := TUsuarioDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiUsuarios.Crear(const ADto: TUsuarioEdicionDTO): TUsuarioDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False).Post(RUTA_USUARIOS);
    end);

  Result := TUsuarioDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

procedure TApiUsuarios.Editar(const AId: Integer;
  const ADto: TUsuarioEdicionDTO);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False)
        .Put(Format(SUB_ID, [RUTA_USUARIOS, AId]));
    end);
end;

procedure TApiUsuarios.Accion(const AId: Integer; const AAccion: string);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Post(Format(SUB_ACCION,
        [RUTA_USUARIOS, AId, AAccion]));
    end);
end;

procedure TApiUsuarios.Inactivar(const AId: Integer);
begin
  Accion(AId, ACCION_INACTIVACION);
end;

procedure TApiUsuarios.Activar(const AId: Integer);
begin
  Accion(AId, ACCION_ACTIVACION);
end;

procedure TApiUsuarios.RestablecerClave(const AId: Integer;
  const AClave: string);
var
  lDto: TClaveTemporalDTO;
begin
  lDto := TClaveTemporalDTO.Create;
  try
    lDto.ClaveTemporal := AClave;
    Ejecutar(
      function: IMVCRESTResponse
      begin
        Result := NuevoCliente.AddBody(lDto, False)
          .Put(Format(SUB_ACCION, [RUTA_USUARIOS, AId, ACCION_CLAVE]));
      end);
  finally
    lDto.Free;
  end;
end;

procedure TApiUsuarios.PedirCambioClave(const AId: Integer);
begin
  Accion(AId, ACCION_CAMBIO_CLAVE);
end;

function TApiUsuarios.Excepciones(const AId: Integer)
  : TObjectList<TExcepcionDTO>;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(Format(SUB_ACCION,
        [RUTA_USUARIOS, AId, ACCION_PERMISOS]));
    end);

  Result := TObjectList<TExcepcionDTO>.Create(True);
  try
    lRespuesta.BodyForListOf(Result, TExcepcionDTO, 'data');
  except
    Result.Free;
    raise;
  end;
end;

procedure TApiUsuarios.CambiarExcepciones(const AId: Integer;
  const ADto: TCambiosExcepcionesDTO);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False)
        .Put(Format(SUB_ACCION, [RUTA_USUARIOS, AId, ACCION_PERMISOS]));
    end);
end;

end.
