unit Anovo.Api.Catalogos;

// Cliente de la API de catalogos, precios y la lista Todos.

interface

uses
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.Api.Intf.Catalogos,
  Anovo.DTOs.Catalogos,
  Anovo.DTOs.Importacion;

type
  TApiCatalogos = class(TApiBase, IApiCatalogos)
  private
    function PaginaDe<T: class, constructor>(const ARuta, ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      const ACategoriaId: Integer; out ATotal: Int64): TObjectList<T>;
    function ListaDe<T: class, constructor>(const ARuta: string;
      const AIncluirInactivos: Boolean = False;
      const ATexto: string = ''): TObjectList<T>;
    procedure CambiarPrecio(const ARuta: string; const AId: Integer;
      const ADto: TPrecioNuevoDTO);
    procedure Inactivar(const ARuta: string; const AId: Integer);
  public
    function BuscarMateriales(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      out ATotal: Int64): TObjectList<TMaterialDTO>;
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
    function CrearManoObra(const ADto: TManoObraNuevaDTO): Integer;
    procedure ActualizarManoObra(const AId: Integer;
      const ADto: TManoObraEdicionDTO);
    procedure InactivarManoObra(const AId: Integer);
    procedure CambiarPrecioManoObra(const AId: Integer;
      const ADto: TPrecioNuevoDTO);
    function HistorialPrecioManoObra(const AId: Integer)
      : TObjectList<TPrecioDTO>;
    function Categorias: TObjectList<TCategoriaDTO>;
    function Importar(const ACatalogo: TCatalogoImportacion;
      const ADatos: TImportacionDTO; const ASoloRevisar: Boolean)
      : TImportacionResultadoDTO;

    function BuscarTodos(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      out ATotal: Int64): TObjectList<TCatalogoItemDTO>;
    function BuscarMaquinas(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      out ATotal: Int64): TObjectList<TMaquinaDTO>;
    function CrearMaquina(const ADto: TMaquinaNuevaDTO): Integer;
    procedure ActualizarMaquina(const AId: Integer;
      const ADto: TMaquinaEdicionDTO);
    procedure InactivarMaquina(const AId: Integer);
    procedure CambiarCostoMaquina(const AId: Integer;
      const ADto: TPrecioNuevoDTO);
    function HistorialCostoMaquina(const AId: Integer)
      : TObjectList<TPrecioDTO>;

    function TiposTrabajo(const AIncluirInactivos: Boolean;
      const ATexto: string = ''): TObjectList<TTipoTrabajoDTO>;
    function CrearTipoTrabajo(const ADto: TTipoTrabajoNuevoDTO): Integer;
    procedure ActualizarTipoTrabajo(const AId: Integer;
      const ADto: TTipoTrabajoNuevoDTO);
    procedure InactivarTipoTrabajo(const AId: Integer);

    function Simples(const ACatalogo: TCatalogoSimple;
      const AIncluirInactivos: Boolean; const ATexto: string = '')
      : TObjectList<TCatalogoSimpleDTO>;
    function CrearSimple(const ACatalogo: TCatalogoSimple;
      const ADto: TCatalogoSimpleNuevoDTO): Integer;
    procedure ActualizarSimple(const ACatalogo: TCatalogoSimple;
      const AId: Integer; const ADto: TCatalogoSimpleNuevoDTO);
    procedure InactivarSimple(const ACatalogo: TCatalogoSimple;
      const AId: Integer);

    function UnidadesMedida(const AIncluirInactivas: Boolean;
      const ATexto: string = ''): TObjectList<TUnidadMedidaDTO>;
    function CrearUnidadMedida(const ADto: TUnidadMedidaNuevaDTO): Integer;
    procedure ActualizarUnidadMedida(const AId: Integer;
      const ADto: TUnidadMedidaNuevaDTO);
    procedure InactivarUnidadMedida(const AId: Integer);
  end;

implementation

uses
  System.SysUtils,
  System.TypInfo,
  JsonDataObjects,
  MVCFramework.RESTClient.Intf;

const
  RUTA_TODOS = '/api/catalogos';
  RUTA_MATERIALES = '/api/catalogos/materiales';
  RUTA_MANO_OBRA = '/api/catalogos/mano-obra';
  RUTA_MAQUINAS = '/api/catalogos/maquinas';
  RUTA_TIPOS_TRABAJO = '/api/catalogos/tipos-trabajo';
  RUTA_UNIDADES_MEDIDA = '/api/catalogos/unidades-medida';
  RUTA_SIMPLE: array [TCatalogoSimple] of string = (
    '/api/catalogos/tipos-material', '/api/catalogos/acabados',
    '/api/catalogos/formas-pago');
  RUTA_CATEGORIAS = '/api/catalogos/mano-obra/categorias';
  RUTA_IMPORTACION = '%s/importacion';
  RUTA_CATALOGO_IMPORTACION: array [TCatalogoImportacion] of string = (
    RUTA_MATERIALES, RUTA_MANO_OBRA, RUTA_MAQUINAS);
  VALOR_REVISAR: array [Boolean] of string = ('false', 'true');

  SUB_PRECIOS = '%s/%d/precios';
  SUB_INACTIVACION = '%s/%d/inactivacion';
  SUB_ID = '%s/%d';

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
      lCliente := NuevoCliente
        .AddQueryStringParam('q', ATexto)
        .AddQueryStringParam('pagina', APagina)
        .AddQueryStringParam('por_pagina', APorPagina);
      if AIncluirInactivos then
        lCliente.AddQueryStringParam('incluir_inactivos', 'true');
      if ACategoriaId > 0 then
        lCliente.AddQueryStringParam('categoria_id', ACategoriaId);
      Result := lCliente.Get(ARuta);
    end);

  Result := TObjectList<T>.Create(True);
  try
    lRespuesta.BodyForListOf(Result,
      GetTypeData(TypeInfo(T))^.ClassType, 'data');

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

function TApiCatalogos.ListaDe<T>(const ARuta: string;
  const AIncluirInactivos: Boolean; const ATexto: string): TObjectList<T>;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    var
      lCliente: IMVCRESTClient;
    begin
      lCliente := NuevoCliente;
      if AIncluirInactivos then
        lCliente.AddQueryStringParam('incluir_inactivos', 'true');
      if ATexto <> '' then
        lCliente.AddQueryStringParam('q', ATexto);
      Result := lCliente.Get(ARuta);
    end);

  Result := TObjectList<T>.Create(True);
  try
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

function TApiCatalogos.BuscarMateriales(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  out ATotal: Int64): TObjectList<TMaterialDTO>;
begin
  Result := PaginaDe<TMaterialDTO>(RUTA_MATERIALES, ATexto, APagina,
    APorPagina, AIncluirInactivos, 0, ATotal);
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

function TApiCatalogos.BuscarManoObra(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  const ACategoriaId: Integer; out ATotal: Int64): TObjectList<TManoObraDTO>;
begin
  Result := PaginaDe<TManoObraDTO>(RUTA_MANO_OBRA, ATexto, APagina,
    APorPagina, AIncluirInactivos, ACategoriaId, ATotal);
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

function TApiCatalogos.Importar(const ACatalogo: TCatalogoImportacion;
  const ADatos: TImportacionDTO; const ASoloRevisar: Boolean)
  : TImportacionResultadoDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADatos, False)
        .AddQueryStringParam('revisar', VALOR_REVISAR[ASoloRevisar])
        .Post(Format(RUTA_IMPORTACION,
        [RUTA_CATALOGO_IMPORTACION[ACatalogo]]));
    end);

  Result := TImportacionResultadoDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiCatalogos.BuscarTodos(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  out ATotal: Int64): TObjectList<TCatalogoItemDTO>;
begin
  Result := PaginaDe<TCatalogoItemDTO>(RUTA_TODOS, ATexto, APagina,
    APorPagina, AIncluirInactivos, 0, ATotal);
end;

function TApiCatalogos.BuscarMaquinas(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  out ATotal: Int64): TObjectList<TMaquinaDTO>;
begin
  Result := PaginaDe<TMaquinaDTO>(RUTA_MAQUINAS, ATexto, APagina, APorPagina,
    AIncluirInactivos, 0, ATotal);
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

function TApiCatalogos.TiposTrabajo(const AIncluirInactivos: Boolean;
  const ATexto: string): TObjectList<TTipoTrabajoDTO>;
begin
  Result := ListaDe<TTipoTrabajoDTO>(RUTA_TIPOS_TRABAJO, AIncluirInactivos,
    ATexto);
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

function TApiCatalogos.Simples(const ACatalogo: TCatalogoSimple;
  const AIncluirInactivos: Boolean; const ATexto: string)
  : TObjectList<TCatalogoSimpleDTO>;
begin
  Result := ListaDe<TCatalogoSimpleDTO>(RUTA_SIMPLE[ACatalogo],
    AIncluirInactivos, ATexto);
end;

function TApiCatalogos.CrearSimple(const ACatalogo: TCatalogoSimple;
  const ADto: TCatalogoSimpleNuevoDTO): Integer;
begin
  Result := IdDeLocation(Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False).Post(RUTA_SIMPLE[ACatalogo]);
    end));
end;

procedure TApiCatalogos.ActualizarSimple(const ACatalogo: TCatalogoSimple;
  const AId: Integer; const ADto: TCatalogoSimpleNuevoDTO);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False)
        .Put(Format(SUB_ID, [RUTA_SIMPLE[ACatalogo], AId]));
    end);
end;

procedure TApiCatalogos.InactivarSimple(const ACatalogo: TCatalogoSimple;
  const AId: Integer);
begin
  Inactivar(RUTA_SIMPLE[ACatalogo], AId);
end;

function TApiCatalogos.UnidadesMedida(const AIncluirInactivas: Boolean;
  const ATexto: string): TObjectList<TUnidadMedidaDTO>;
begin
  Result := ListaDe<TUnidadMedidaDTO>(RUTA_UNIDADES_MEDIDA,
    AIncluirInactivas, ATexto);
end;

function TApiCatalogos.CrearUnidadMedida(const ADto: TUnidadMedidaNuevaDTO)
  : Integer;
begin
  Result := IdDeLocation(Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False).Post(RUTA_UNIDADES_MEDIDA);
    end));
end;

procedure TApiCatalogos.ActualizarUnidadMedida(const AId: Integer;
  const ADto: TUnidadMedidaNuevaDTO);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False)
        .Put(Format(SUB_ID, [RUTA_UNIDADES_MEDIDA, AId]));
    end);
end;

procedure TApiCatalogos.InactivarUnidadMedida(const AId: Integer);
begin
  Inactivar(RUTA_UNIDADES_MEDIDA, AId);
end;

end.
