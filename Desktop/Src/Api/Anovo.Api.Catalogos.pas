unit Anovo.Api.Catalogos;

// Los cuatro catalogos contra el servidor.
//
// Las cuatro busquedas son la misma consulta con otra subruta y otro tipo de
// DTO, asi que la lectura de la pagina esta una sola vez en PaginaDe<T>. Lo
// que cambia -que parametros lleva cada una- se arma antes y se le pasa.

interface

uses
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.Api.Intf.Catalogos,
  Anovo.DTOs.Catalogos;

type
  TApiCatalogos = class(TApiBase, IApiCatalogos)
  private
    function PaginaDe<T: class, constructor>(const ARuta, ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      const ACategoriaId: Integer; out ATotal: Int64): TObjectList<T>;
    function ListaDe<T: class, constructor>(const ARuta: string;
      const AIncluirInactivos: Boolean = False): TObjectList<T>;
    procedure CambiarPrecio(const ARuta: string; const AId: Integer;
      const ADto: TPrecioNuevoDTO);
    procedure Inactivar(const ARuta: string; const AId: Integer);
  public
    function BuscarMateriales(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      out ATotal: Int64): TObjectList<TMaterialDTO>;
    function ObtenerMaterial(const AId: Integer): TMaterialDTO;
    function CrearMaterial(const ADto: TMaterialNuevoDTO): Integer;
    procedure ActualizarMaterial(const AId: Integer;
      const ADto: TMaterialEdicionDTO);
    procedure InactivarMaterial(const AId: Integer);
    procedure CambiarPrecioMaterial(const AId: Integer;
      const ADto: TPrecioNuevoDTO);
    function HistorialPrecioMaterial(const AId: Integer)
      : TObjectList<TPrecioDTO>;

    function BuscarManoObra(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      const ACategoriaId: Integer; out ATotal: Int64)
      : TObjectList<TManoObraDTO>;
    function ObtenerManoObra(const AId: Integer): TManoObraDTO;
    function CrearManoObra(const ADto: TManoObraNuevaDTO): Integer;
    procedure ActualizarManoObra(const AId: Integer;
      const ADto: TManoObraEdicionDTO);
    procedure InactivarManoObra(const AId: Integer);
    procedure CambiarPrecioManoObra(const AId: Integer;
      const ADto: TPrecioNuevoDTO);
    function HistorialPrecioManoObra(const AId: Integer)
      : TObjectList<TPrecioDTO>;
    function Categorias: TObjectList<TCategoriaDTO>;

    function BuscarMaquinas(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      out ATotal: Int64): TObjectList<TMaquinaDTO>;
    function ObtenerMaquina(const AId: Integer): TMaquinaDTO;
    function CrearMaquina(const ADto: TMaquinaNuevaDTO): Integer;
    procedure ActualizarMaquina(const AId: Integer;
      const ADto: TMaquinaEdicionDTO);
    procedure InactivarMaquina(const AId: Integer);
    procedure CambiarCostoMaquina(const AId: Integer;
      const ADto: TPrecioNuevoDTO);
    function HistorialCostoMaquina(const AId: Integer)
      : TObjectList<TPrecioDTO>;

    function TiposTrabajo(const AIncluirInactivos: Boolean)
      : TObjectList<TTipoTrabajoDTO>;
    function CrearTipoTrabajo(const ADto: TTipoTrabajoNuevoDTO): Integer;
    procedure ActualizarTipoTrabajo(const AId: Integer;
      const ADto: TTipoTrabajoNuevoDTO);
    procedure InactivarTipoTrabajo(const AId: Integer);
  end;

implementation

uses
  System.SysUtils,
  System.TypInfo,
  JsonDataObjects,
  MVCFramework.RESTClient.Intf;

const
  RUTA_MATERIALES = '/api/catalogos/materiales';
  RUTA_MANO_OBRA = '/api/catalogos/mano-obra';
  RUTA_MAQUINAS = '/api/catalogos/maquinas';
  RUTA_TIPOS_TRABAJO = '/api/catalogos/tipos-trabajo';
  RUTA_CATEGORIAS = '/api/catalogos/mano-obra/categorias';

  // La subruta del precio es la misma en los tres catalogos que lo llevan.
  SUB_PRECIOS = '%s/%d/precios';
  SUB_INACTIVACION = '%s/%d/inactivacion';
  SUB_ID = '%s/%d';

{ Apoyo }

function TApiCatalogos.PaginaDe<T>(const ARuta, ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  const ACategoriaId: Integer; out ATotal: Int64): TObjectList<T>;
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
        .AddQueryStringParam('q', ATexto)
        .AddQueryStringParam('pagina', APagina)
        .AddQueryStringParam('por_pagina', APorPagina);
      if AIncluirInactivos then
        lCliente.AddQueryStringParam('incluir_inactivos', 'true');
      // Solo mano de obra lo usa; en los demas llega en 0 y no se manda.
      if ACategoriaId > 0 then
        lCliente.AddQueryStringParam('categoria_id', ACategoriaId);
      Result := lCliente.Get(ARuta);
    end);

  Result := TObjectList<T>.Create(True);
  try
    // Coleccion del contrato: la lista en data, la paginacion en la raiz.
    //
    // BodyForListOf pide un TClass y T es un tipo, no un valor: el parametro
    // generico no se puede pasar tal cual. De ahi el rodeo por TypeInfo.
    lRespuesta.BodyForListOf(Result,
      GetTypeData(TypeInfo(T))^.ClassType, 'data');

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

function TApiCatalogos.ListaDe<T>(const ARuta: string;
  const AIncluirInactivos: Boolean): TObjectList<T>;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    var
      lCliente: IMVCRESTClient;
    begin
      lCliente := NuevoCliente;
      // Por parametro, como arriba: concatenarlo a la ruta no llega.
      if AIncluirInactivos then
        lCliente.AddQueryStringParam('incluir_inactivos', 'true');
      Result := lCliente.Get(ARuta);
    end);

  Result := TObjectList<T>.Create(True);
  try
    // Sin paginar: historiales de precio, categorias y tipos de trabajo son
    // listas cortas por definicion.
    lRespuesta.BodyForListOf(Result,
      GetTypeData(TypeInfo(T))^.ClassType, 'data');
  except
    Result.Free;
    raise;
  end;
end;

procedure TApiCatalogos.CambiarPrecio(const ARuta: string;
  const AId: Integer; const ADto: TPrecioNuevoDTO);
begin
  // 204 sin cuerpo: no hay nada que leer, y Ejecutar ya convirtio cualquier
  // error del servidor en excepcion.
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False)
        .Post(Format(SUB_PRECIOS, [ARuta, AId]));
    end);
end;

procedure TApiCatalogos.Inactivar(const ARuta: string; const AId: Integer);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Post(Format(SUB_INACTIVACION, [ARuta, AId]));
    end);
end;

{ Materiales }

function TApiCatalogos.BuscarMateriales(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  out ATotal: Int64): TObjectList<TMaterialDTO>;
begin
  Result := PaginaDe<TMaterialDTO>(RUTA_MATERIALES, ATexto, APagina,
    APorPagina, AIncluirInactivos, 0, ATotal);
end;

function TApiCatalogos.ObtenerMaterial(const AId: Integer): TMaterialDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(Format(SUB_ID, [RUTA_MATERIALES, AId]));
    end);

  Result := TMaterialDTO.Create;
  try
    // El objeto viene dentro de data, como en el resto del contrato.
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiCatalogos.CrearMaterial(const ADto: TMaterialNuevoDTO): Integer;
begin
  Result := IdDeLocation(Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False).Post(RUTA_MATERIALES);
    end));
end;

procedure TApiCatalogos.ActualizarMaterial(const AId: Integer;
  const ADto: TMaterialEdicionDTO);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False)
        .Put(Format(SUB_ID, [RUTA_MATERIALES, AId]));
    end);
end;

procedure TApiCatalogos.InactivarMaterial(const AId: Integer);
begin
  Inactivar(RUTA_MATERIALES, AId);
end;

procedure TApiCatalogos.CambiarPrecioMaterial(const AId: Integer;
  const ADto: TPrecioNuevoDTO);
begin
  CambiarPrecio(RUTA_MATERIALES, AId, ADto);
end;

function TApiCatalogos.HistorialPrecioMaterial(const AId: Integer)
  : TObjectList<TPrecioDTO>;
begin
  Result := ListaDe<TPrecioDTO>(Format(SUB_PRECIOS, [RUTA_MATERIALES, AId]));
end;

{ Mano de obra }

function TApiCatalogos.BuscarManoObra(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  const ACategoriaId: Integer; out ATotal: Int64): TObjectList<TManoObraDTO>;
begin
  Result := PaginaDe<TManoObraDTO>(RUTA_MANO_OBRA, ATexto, APagina,
    APorPagina, AIncluirInactivos, ACategoriaId, ATotal);
end;

function TApiCatalogos.ObtenerManoObra(const AId: Integer): TManoObraDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(Format(SUB_ID, [RUTA_MANO_OBRA, AId]));
    end);

  Result := TManoObraDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiCatalogos.CrearManoObra(const ADto: TManoObraNuevaDTO): Integer;
begin
  Result := IdDeLocation(Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False).Post(RUTA_MANO_OBRA);
    end));
end;

procedure TApiCatalogos.ActualizarManoObra(const AId: Integer;
  const ADto: TManoObraEdicionDTO);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False)
        .Put(Format(SUB_ID, [RUTA_MANO_OBRA, AId]));
    end);
end;

procedure TApiCatalogos.InactivarManoObra(const AId: Integer);
begin
  Inactivar(RUTA_MANO_OBRA, AId);
end;

procedure TApiCatalogos.CambiarPrecioManoObra(const AId: Integer;
  const ADto: TPrecioNuevoDTO);
begin
  CambiarPrecio(RUTA_MANO_OBRA, AId, ADto);
end;

function TApiCatalogos.HistorialPrecioManoObra(const AId: Integer)
  : TObjectList<TPrecioDTO>;
begin
  Result := ListaDe<TPrecioDTO>(Format(SUB_PRECIOS, [RUTA_MANO_OBRA, AId]));
end;

function TApiCatalogos.Categorias: TObjectList<TCategoriaDTO>;
begin
  Result := ListaDe<TCategoriaDTO>(RUTA_CATEGORIAS);
end;

{ Maquinas }

function TApiCatalogos.BuscarMaquinas(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  out ATotal: Int64): TObjectList<TMaquinaDTO>;
begin
  Result := PaginaDe<TMaquinaDTO>(RUTA_MAQUINAS, ATexto, APagina, APorPagina,
    AIncluirInactivos, 0, ATotal);
end;

function TApiCatalogos.ObtenerMaquina(const AId: Integer): TMaquinaDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(Format(SUB_ID, [RUTA_MAQUINAS, AId]));
    end);

  Result := TMaquinaDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiCatalogos.CrearMaquina(const ADto: TMaquinaNuevaDTO): Integer;
begin
  Result := IdDeLocation(Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False).Post(RUTA_MAQUINAS);
    end));
end;

procedure TApiCatalogos.ActualizarMaquina(const AId: Integer;
  const ADto: TMaquinaEdicionDTO);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False)
        .Put(Format(SUB_ID, [RUTA_MAQUINAS, AId]));
    end);
end;

procedure TApiCatalogos.InactivarMaquina(const AId: Integer);
begin
  Inactivar(RUTA_MAQUINAS, AId);
end;

procedure TApiCatalogos.CambiarCostoMaquina(const AId: Integer;
  const ADto: TPrecioNuevoDTO);
begin
  CambiarPrecio(RUTA_MAQUINAS, AId, ADto);
end;

function TApiCatalogos.HistorialCostoMaquina(const AId: Integer)
  : TObjectList<TPrecioDTO>;
begin
  Result := ListaDe<TPrecioDTO>(Format(SUB_PRECIOS, [RUTA_MAQUINAS, AId]));
end;

{ Tipos de trabajo }

function TApiCatalogos.TiposTrabajo(const AIncluirInactivos: Boolean)
  : TObjectList<TTipoTrabajoDTO>;
begin
  Result := ListaDe<TTipoTrabajoDTO>(RUTA_TIPOS_TRABAJO, AIncluirInactivos);
end;

function TApiCatalogos.CrearTipoTrabajo(const ADto: TTipoTrabajoNuevoDTO)
  : Integer;
begin
  Result := IdDeLocation(Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False).Post(RUTA_TIPOS_TRABAJO);
    end));
end;

procedure TApiCatalogos.ActualizarTipoTrabajo(const AId: Integer;
  const ADto: TTipoTrabajoNuevoDTO);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False)
        .Put(Format(SUB_ID, [RUTA_TIPOS_TRABAJO, AId]));
    end);
end;

procedure TApiCatalogos.InactivarTipoTrabajo(const AId: Integer);
begin
  Inactivar(RUTA_TIPOS_TRABAJO, AId);
end;

end.
