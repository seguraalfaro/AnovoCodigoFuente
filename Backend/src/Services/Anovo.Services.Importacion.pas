unit Anovo.Services.Importacion;

// Importacion masiva de items nuevos: revisa fila por fila y, sin errores,
// los registra con su precio en una sola transaccion, con las mismas reglas
// del registro uno por uno (ICatalogoService).

interface

uses
  System.Generics.Collections,
  MVCFramework,
  Anovo.DTOs.Importacion,
  Anovo.Repositories.Intf.Catalogos,
  Anovo.Services.Intf.Catalogos,
  Anovo.Services.Intf.Importacion;

type
  TImportacionService = class(TInterfacedObject, IImportacionService)
  private
    fCatalogos: ICatalogoService;
    fMateriales: IMaterialRepository;
    fManoObra: IManoObraRepository;
    fMaquinas: IMaquinaRepository;
    fUnidades: IUnidadMedidaRepository;
    fCategorias: IManoObraCategoriaRepository;
    function CodigoExiste(const ACatalogo: TCatalogoImportacion;
      const ACodigo: string): Boolean;
    function NombreExiste(const ACatalogo: TCatalogoImportacion;
      const ANombre: string): Boolean;
    function Unidades: TDictionary<string, Integer>;
    function Categorias: TDictionary<string, Integer>;
    procedure Revisar(const ACatalogo: TCatalogoImportacion;
      const ADatos: TImportacionDTO;
      const AUnidades, ACategorias: TDictionary<string, Integer>;
      const AResultado: TImportacionResultadoDTO);
    procedure Registrar(const ACatalogo: TCatalogoImportacion;
      const ADatos: TImportacionDTO;
      const AUnidades, ACategorias: TDictionary<string, Integer>);
  public
    [MVCInject]
    constructor Create(ACatalogos: ICatalogoService;
      AMateriales: IMaterialRepository; AManoObra: IManoObraRepository;
      AMaquinas: IMaquinaRepository; AUnidades: IUnidadMedidaRepository;
      ACategorias: IManoObraCategoriaRepository); reintroduce;
    function Importar(const ACatalogo: TCatalogoImportacion;
      const ADatos: TImportacionDTO; const ASoloRevisar: Boolean)
      : TImportacionResultadoDTO;
  end;

const
  MAX_FILAS_IMPORTACION = 2000;
  LARGO_CODIGO = 30;
  LARGO_NOMBRE = 120;
  LARGO_DESCRIPCION = 500;

implementation

uses
  System.SysUtils,
  MVCFramework.Nullables,
  MVCFramework.Repository,
  Anovo.DTOs.Catalogos,
  Anovo.Entities.Catalogos,
  Anovo.Errors,
  Anovo.Textos;

function Clave(const ATexto: string): string;
begin
  Result := UpperCase(Trim(ATexto));
end;

function Texto(const AValor: NullableString): string;
begin
  Result := Trim(AValor.ValueOrDefault);
end;

function ComoNullable(const ATexto: string): NullableString;
begin
  if ATexto.IsEmpty then
    Result.Clear
  else
    Result := ATexto;
end;

constructor TImportacionService.Create(ACatalogos: ICatalogoService;
  AMateriales: IMaterialRepository; AManoObra: IManoObraRepository;
  AMaquinas: IMaquinaRepository; AUnidades: IUnidadMedidaRepository;
  ACategorias: IManoObraCategoriaRepository);
begin
  inherited Create;
  fCatalogos := ACatalogos;
  fMateriales := AMateriales;
  fManoObra := AManoObra;
  fMaquinas := AMaquinas;
  fUnidades := AUnidades;
  fCategorias := ACategorias;
end;

function TImportacionService.CodigoExiste(const ACatalogo: TCatalogoImportacion;
  const ACodigo: string): Boolean;
var
  lItem: TObject;
begin
  case ACatalogo of
    ciMateriales:
      lItem := fMateriales.ObtenerPorCodigo(ACodigo);
    ciManoObra:
      lItem := fManoObra.ObtenerPorCodigo(ACodigo);
  else
    lItem := fMaquinas.ObtenerPorCodigo(ACodigo);
  end;
  Result := lItem <> nil;
  lItem.Free;
end;

function TImportacionService.NombreExiste(const ACatalogo: TCatalogoImportacion;
  const ANombre: string): Boolean;
begin
  case ACatalogo of
    ciMateriales:
      Result := fMateriales.ExisteNombre(ANombre);
    ciManoObra:
      Result := fManoObra.ExisteNombre(ANombre);
  else
    Result := fMaquinas.ExisteNombre(ANombre);
  end;
end;

function TImportacionService.Unidades: TDictionary<string, Integer>;
var
  lFilas: TObjectList<TUnidadesMedida>;
  lUnidad: TUnidadesMedida;
begin
  Result := TDictionary<string, Integer>.Create;
  lFilas := fUnidades.Todas(False);
  try
    for lUnidad in lFilas do
    begin
      Result.AddOrSetValue(Clave(lUnidad.Nombre), lUnidad.ID.Value);
      if not Texto(lUnidad.Abreviatura).IsEmpty then
        Result.AddOrSetValue(Clave(lUnidad.Abreviatura.Value),
          lUnidad.ID.Value);
    end;
  finally
    lFilas.Free;
  end;
end;

function TImportacionService.Categorias: TDictionary<string, Integer>;
var
  lFilas: TObjectList<TManoObraCategoria>;
  lCategoria: TManoObraCategoria;
begin
  Result := TDictionary<string, Integer>.Create;
  lFilas := fCategorias.Todas;
  try
    for lCategoria in lFilas do
    begin
      Result.AddOrSetValue(Clave(lCategoria.Nombre), lCategoria.ID);
      Result.AddOrSetValue(Clave(lCategoria.Codigo), lCategoria.ID);
    end;
  finally
    lFilas.Free;
  end;
end;

procedure TImportacionService.Revisar(const ACatalogo: TCatalogoImportacion;
  const ADatos: TImportacionDTO;
  const AUnidades, ACategorias: TDictionary<string, Integer>;
  const AResultado: TImportacionResultadoDTO);
var
  lCodigos, lNombres: TDictionary<string, Integer>;
  lFila: TFilaImportacionDTO;
  lErrores: TArray<string>;
  lExiste: Boolean;
  lPrevia: Integer;
  lCodigo, lNombre, lUnidad, lCategoria: string;
  lRevision: TRevisionFilaDTO;

  procedure Agregar(const AError: string);
  begin
    lErrores := lErrores + [AError];
  end;

  procedure RevisarMonto(const AMonto: NullableCurrency;
    const AObligatorio: Boolean; const AFalta, ANegativo: string);
  begin
    if not AMonto.HasValue then
    begin
      if AObligatorio then
        Agregar(AFalta);
    end
    else if AMonto.Value < 0 then
      Agregar(ANegativo);
  end;

begin
  lCodigos := TDictionary<string, Integer>.Create;
  lNombres := TDictionary<string, Integer>.Create;
  try
    for lFila in ADatos.Filas do
    begin
      lErrores := [];
      lExiste := False;
      lCodigo := Trim(lFila.Codigo);
      lNombre := Trim(lFila.Nombre);

      if lCodigo.IsEmpty then
        Agregar(SImpFaltaCodigo)
      else if Length(lCodigo) > LARGO_CODIGO then
        Agregar(Format(SImpCodigoLargo, [LARGO_CODIGO]))
      else
      begin
        if lCodigos.TryGetValue(Clave(lCodigo), lPrevia) then
          Agregar(Format(SImpCodigoRepetido, [lPrevia]))
        else
          lCodigos.Add(Clave(lCodigo), lFila.Fila);
        if CodigoExiste(ACatalogo, lCodigo) then
        begin
          Agregar(SImpCodigoExiste);
          lExiste := True;
        end;
      end;

      if lNombre.IsEmpty then
        Agregar(SImpFaltaNombre)
      else if Length(lNombre) > LARGO_NOMBRE then
        Agregar(Format(SImpNombreLargo, [LARGO_NOMBRE]))
      else
      begin
        if lNombres.TryGetValue(Clave(lNombre), lPrevia) then
          Agregar(Format(SImpNombreRepetido, [lPrevia]))
        else
          lNombres.Add(Clave(lNombre), lFila.Fila);
        if NombreExiste(ACatalogo, lNombre) then
        begin
          Agregar(SImpNombreExiste);
          lExiste := True;
        end;
      end;

      if Length(Texto(lFila.Descripcion)) > LARGO_DESCRIPCION then
        Agregar(Format(SImpDescripcionLarga, [LARGO_DESCRIPCION]));

      if ACatalogo in [ciMateriales, ciManoObra] then
      begin
        lUnidad := Texto(lFila.Unidad);
        if lUnidad.IsEmpty then
          Agregar(SImpFaltaUnidad)
        else if not AUnidades.ContainsKey(Clave(lUnidad)) then
          Agregar(Format(SImpUnidadNoExiste, [lUnidad]));
      end;

      if ACatalogo = ciManoObra then
      begin
        lCategoria := Texto(lFila.Categoria);
        if lCategoria.IsEmpty then
          Agregar(SImpFaltaCategoria)
        else if not ACategorias.ContainsKey(Clave(lCategoria)) then
          Agregar(Format(SImpCategoriaNoExiste, [lCategoria]));
      end;

      case ACatalogo of
        ciMateriales:
          begin
            RevisarMonto(lFila.Costo, False, SImpFaltaCosto,
              SImpCostoNegativo);
            RevisarMonto(lFila.Precio, True, SImpFaltaPrecio,
              SImpPrecioNegativo);
          end;
      else
        RevisarMonto(lFila.Costo, True, SImpFaltaCosto, SImpCostoNegativo);
      end;

      if Length(lErrores) > 0 then
      begin
        lRevision := TRevisionFilaDTO.Create;
        lRevision.Fila := lFila.Fila;
        lRevision.Error := string.Join(SImpSeparador, lErrores);
        lRevision.Existe := lExiste;
        AResultado.Errores.Add(lRevision);
      end;
    end;
  finally
    lNombres.Free;
    lCodigos.Free;
  end;
end;

procedure TImportacionService.Registrar(const ACatalogo: TCatalogoImportacion;
  const ADatos: TImportacionDTO;
  const AUnidades, ACategorias: TDictionary<string, Integer>);
var
  lFila: TFilaImportacionDTO;
  lId: Integer;
  lPrecio: TPrecioNuevoDTO;
  lMaterial: TMaterialNuevoDTO;
  lManoObra: TManoObraNuevaDTO;
  lMaquina: TMaquinaNuevaDTO;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  for lFila in ADatos.Filas do
  begin
    lPrecio := TPrecioNuevoDTO.Create;
    try
      case ACatalogo of
        ciMateriales:
          begin
            lMaterial := TMaterialNuevoDTO.Create;
            try
              lMaterial.Codigo := Trim(lFila.Codigo);
              lMaterial.Nombre := Trim(lFila.Nombre);
              lMaterial.Descripcion := ComoNullable(Texto(lFila.Descripcion));
              lMaterial.UnidadMedidaId := AUnidades[Clave(Texto(lFila.Unidad))];
              lId := fCatalogos.CrearMaterial(lMaterial);
            finally
              lMaterial.Free;
            end;
            lPrecio.CostoUnitario := lFila.Costo.ValueOrDefault;
            lPrecio.PrecioUnitario := lFila.Precio;
            fCatalogos.CambiarPrecioMaterial(lId, lPrecio);
          end;
        ciManoObra:
          begin
            lManoObra := TManoObraNuevaDTO.Create;
            try
              lManoObra.Codigo := Trim(lFila.Codigo);
              lManoObra.Nombre := Trim(lFila.Nombre);
              lManoObra.Descripcion := ComoNullable(Texto(lFila.Descripcion));
              lManoObra.UnidadMedidaId := AUnidades[Clave(Texto(lFila.Unidad))];
              lManoObra.CategoriaId :=
                ACategorias[Clave(Texto(lFila.Categoria))];
              lId := fCatalogos.CrearManoObra(lManoObra);
            finally
              lManoObra.Free;
            end;
            lPrecio.CostoUnitario := lFila.Costo;
            fCatalogos.CambiarPrecioManoObra(lId, lPrecio);
          end;
        ciMaquinas:
          begin
            lMaquina := TMaquinaNuevaDTO.Create;
            try
              lMaquina.Codigo := Trim(lFila.Codigo);
              lMaquina.Nombre := Trim(lFila.Nombre);
              lMaquina.Descripcion := ComoNullable(Texto(lFila.Descripcion));
              lId := fCatalogos.CrearMaquina(lMaquina);
            finally
              lMaquina.Free;
            end;
            lPrecio.CostoHora := lFila.Costo;
            fCatalogos.CambiarCostoMaquina(lId, lPrecio);
          end;
      end;
    finally
      lPrecio.Free;
    end;
  end;
end;

function TImportacionService.Importar(const ACatalogo: TCatalogoImportacion;
  const ADatos: TImportacionDTO; const ASoloRevisar: Boolean)
  : TImportacionResultadoDTO;
var
  lUnidades, lCategorias: TDictionary<string, Integer>;
begin
  if ADatos.Filas.Count = 0 then
    raise EDatoInvalido.Create(SImportacionVacia);
  if ADatos.Filas.Count > MAX_FILAS_IMPORTACION then
    raise EDatoInvalido.Create(Format(SImportacionDemasiadas,
      [ADatos.Filas.Count, MAX_FILAS_IMPORTACION]));

  Result := TImportacionResultadoDTO.Create;
  try
    Result.Revisadas := ADatos.Filas.Count;
    lUnidades := Unidades;
    lCategorias := Categorias;
    try
      Revisar(ACatalogo, ADatos, lUnidades, lCategorias, Result);
      if ASoloRevisar or (Result.Errores.Count > 0) then
        Exit;
      Registrar(ACatalogo, ADatos, lUnidades, lCategorias);
      Result.Creados := ADatos.Filas.Count;
    finally
      lCategorias.Free;
      lUnidades.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

end.
