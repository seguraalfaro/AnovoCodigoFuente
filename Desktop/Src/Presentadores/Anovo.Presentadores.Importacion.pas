unit Anovo.Presentadores.Importacion;

// Presentador de la importacion masiva: lee el archivo, empareja columnas con
// los campos del catalogo, revisa las filas aqui y en el servidor, y al
// aprobar envia solo las listas.

interface

uses
  System.Generics.Collections,
  Anovo.Archivo.Hoja,
  Anovo.Api.Intf.Catalogos,
  Anovo.DTOs.Importacion,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.Importacion;

type
  TCampoCarga = (ccCodigo, ccNombre, ccDescripcion, ccUnidad, ccCategoria,
    ccCosto, ccPrecio);

  TPresentadorImportacion = class(TPresentadorBase)
  private
    FVista: IVistaImportacion;
    FApi: IApiCatalogos;
    FCatalogo: TCatalogoImportacion;
    FCampos: TArray<TCampoCarga>;
    FRuta: string;
    FHoja: THojaLeida;
    FColumnas: TArray<string>;
    FSeleccion: TArray<Integer>;
    FFilas: TObjectList<TFilaCarga>;
    FSaltadas: TArray<Integer>;
    FRevisando: Boolean;
    function TextoSaltadas: string;
    function Obligatorio(const ACampo: TCampoCarga): Boolean;
    function ValorDe(const AValores: TArray<string>;
      const ACampo: TCampoCarga): string;
    function FilaDe(const ANumero: Integer): TFilaCarga;
    function RevisarLocal(const AFila: TFilaCarga): string;
    function Listas: TArray<TFilaCarga>;
    function ADto(const AFilas: TArray<TFilaCarga>): TImportacionDTO;
    procedure MarcarErrores(const AResultado: TImportacionResultadoDTO);
    procedure AutoEmparejar;
    procedure Armar;
    procedure Revisar;
    procedure Publicar;
    procedure Leer(const ARuta: string; const AHoja: Integer;
      const AConHojas: Boolean);
  public
    constructor Create(const AVista: IVistaImportacion;
      const AApi: IApiCatalogos; const ACatalogo: TCatalogoImportacion);
    destructor Destroy; override;
    procedure Iniciar;
    procedure AbrirArchivo(const ARuta: string);
    procedure ElegirHoja(const AIndice: Integer);
    procedure Emparejar(const ACampo, AColumna: Integer);
    procedure CambiarFila(const AFila: TFilaCarga);
    procedure Aprobar;
  end;

function TryMonto(const ATexto: string; out AValor: Currency): Boolean;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  System.Generics.Defaults,
  MVCFramework.Nullables,
  Anovo.Api.Base,
  Anovo.Textos;

const
  CAMPOS_CATALOGO: array [TCatalogoImportacion] of TArray<TCampoCarga> = (
    [ccCodigo, ccNombre, ccDescripcion, ccUnidad, ccCosto, ccPrecio],
    [ccCodigo, ccCategoria, ccNombre, ccDescripcion, ccUnidad, ccCosto],
    [ccCodigo, ccNombre, ccDescripcion, ccCosto]);

  TITULO_CATALOGO: array [TCatalogoImportacion] of string = (
    SImportarMateriales, SImportarManoObra, SImportarMaquinas);

  ROTULO_CAMPO: array [TCampoCarga] of string = (SCampoCodigo, SCampoNombre,
    SCampoDescripcion, SCampoUnidad, SCampoCategoria, SCampoCosto,
    SCampoPrecio);

  SINONIMOS: array [TCampoCarga] of TArray<string> = (
    ['codigo', 'cod', 'code', 'sku'],
    ['nombre', 'name', 'item', 'articulo'],
    ['descripcion', 'detalle', 'description'],
    ['unidad', 'unidaddemedida', 'unidadmedida', 'um', 'medida'],
    ['categoria', 'category'],
    ['costo', 'costounitario', 'costoporhora', 'costohora', 'cost'],
    ['precio', 'preciounitario', 'precioventa', 'price']);

  CON_ACENTO = #$E1#$E9#$ED#$F3#$FA#$FC#$F1;
  SIN_ACENTO = 'aeiouun';
  SIMBOLOS_MONTO: array [0 .. 2] of string = (#$20A1, '$', ' ');

function Normalizar(const ATexto: string): string;
var
  lCaracter: Char;
  lPosicion: Integer;
begin
  Result := '';
  for lCaracter in LowerCase(Trim(ATexto)) do
  begin
    lPosicion := Pos(lCaracter, CON_ACENTO);
    if lPosicion > 0 then
      Result := Result + SIN_ACENTO[lPosicion]
    else if CharInSet(lCaracter, ['a' .. 'z', '0' .. '9']) then
      Result := Result + lCaracter;
  end;
end;

function TryMonto(const ATexto: string; out AValor: Currency): Boolean;
var
  lTexto, lSimbolo: string;
  lComa, lPunto: Integer;
  lFormato: TFormatSettings;
begin
  lTexto := Trim(ATexto);
  for lSimbolo in SIMBOLOS_MONTO do
    lTexto := StringReplace(lTexto, lSimbolo, '', [rfReplaceAll]);
  lComa := LastDelimiter(',', lTexto);
  lPunto := LastDelimiter('.', lTexto);
  if (lComa > 0) and (lPunto > 0) then
  begin
    if lComa > lPunto then
      lTexto := StringReplace(StringReplace(lTexto, '.', '', [rfReplaceAll]),
        ',', '.', [])
    else
      lTexto := StringReplace(lTexto, ',', '', [rfReplaceAll]);
  end
  else if lComa > 0 then
  begin
    if Length(lTexto) - lComa = 3 then
      lTexto := StringReplace(lTexto, ',', '', [rfReplaceAll])
    else
      lTexto := StringReplace(lTexto, ',', '.', []);
  end;
  lFormato := TFormatSettings.Invariant;
  Result := TryStrToCurr(lTexto, AValor, lFormato);
end;

constructor TPresentadorImportacion.Create(const AVista: IVistaImportacion;
  const AApi: IApiCatalogos; const ACatalogo: TCatalogoImportacion);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCatalogo := ACatalogo;
  FCampos := CAMPOS_CATALOGO[ACatalogo];
  FFilas := TObjectList<TFilaCarga>.Create(True);
end;

destructor TPresentadorImportacion.Destroy;
begin
  FFilas.Free;
  inherited;
end;

function TPresentadorImportacion.Obligatorio(const ACampo: TCampoCarga)
  : Boolean;
begin
  case ACampo of
    ccCodigo, ccNombre:
      Result := True;
    ccUnidad:
      Result := FCatalogo in [ciMateriales, ciManoObra];
    ccCategoria:
      Result := FCatalogo = ciManoObra;
    ccCosto:
      Result := FCatalogo in [ciManoObra, ciMaquinas];
    ccPrecio:
      Result := FCatalogo = ciMateriales;
  else
    Result := False;
  end;
end;

procedure TPresentadorImportacion.Iniciar;
var
  lRotulos: TArray<string>;
  lObligatorios: TArray<Boolean>;
  lCampo: TCampoCarga;
  lRotuloCosto: string;
begin
  lRotuloCosto := SCampoCosto;
  if FCatalogo = ciMaquinas then
    lRotuloCosto := SCampoCostoHora;

  lRotulos := [];
  lObligatorios := [];
  for lCampo in FCampos do
  begin
    if lCampo = ccCosto then
      lRotulos := lRotulos + [lRotuloCosto]
    else
      lRotulos := lRotulos + [ROTULO_CAMPO[lCampo]];
    lObligatorios := lObligatorios + [Obligatorio(lCampo)];
  end;

  FVista.PrepararCatalogo(TITULO_CATALOGO[FCatalogo], lRotulos, lObligatorios,
    FCatalogo in [ciMateriales, ciManoObra], FCatalogo = ciManoObra,
    FCatalogo = ciMateriales, lRotuloCosto);
  Publicar;
end;

procedure TPresentadorImportacion.Leer(const ARuta: string;
  const AHoja: Integer; const AConHojas: Boolean);
var
  lHojas: TArray<string>;
  lLeida: THojaLeida;
begin
  Ejecutar(SAccionLeerArchivo,
    procedure
    begin
      try
        if AConHojas then
          lHojas := TArchivoHoja.Hojas(ARuta);
        lLeida := TArchivoHoja.Leer(ARuta, AHoja);
      except
        on E: EArchivoHoja do
          raise EAnovoCliente.Create(E.Message);
      end;
    end,
    procedure
    begin
      FRuta := ARuta;
      FHoja := lLeida;
      FVista.MostrarArchivo(ARuta);
      if AConHojas then
        FVista.MostrarHojas(lHojas, AHoja);
      AutoEmparejar;
      Armar;
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

procedure TPresentadorImportacion.AbrirArchivo(const ARuta: string);
begin
  if Trim(ARuta).IsEmpty then
    Exit;
  Leer(ARuta, 0, True);
end;

procedure TPresentadorImportacion.ElegirHoja(const AIndice: Integer);
begin
  if FRuta.IsEmpty or (AIndice < 0) then
    Exit;
  Leer(FRuta, AIndice, False);
end;

procedure TPresentadorImportacion.AutoEmparejar;
var
  I, J: Integer;
  lUsadas: TArray<Boolean>;
  lNormal: string;
begin
  SetLength(FColumnas, Length(FHoja.Encabezados));
  SetLength(lUsadas, Length(FHoja.Encabezados));
  for J := 0 to High(FHoja.Encabezados) do
  begin
    FColumnas[J] := Trim(FHoja.Encabezados[J]);
    if FColumnas[J].IsEmpty then
      FColumnas[J] := Format(SColumnaSinNombre, [J + 1]);
  end;

  SetLength(FSeleccion, Length(FCampos));
  for I := 0 to High(FCampos) do
  begin
    FSeleccion[I] := -1;
    for J := 0 to High(FColumnas) do
    begin
      lNormal := Normalizar(FColumnas[J]);
      if not lUsadas[J] and MatchStr(lNormal, SINONIMOS[FCampos[I]]) then
      begin
        FSeleccion[I] := J;
        lUsadas[J] := True;
        Break;
      end;
    end;
  end;
  FVista.MostrarColumnas(FColumnas, FSeleccion);
end;

procedure TPresentadorImportacion.Emparejar(const ACampo, AColumna: Integer);
begin
  if (ACampo < 0) or (ACampo > High(FSeleccion)) or
    (AColumna > High(FColumnas)) then
    Exit;
  FSeleccion[ACampo] := AColumna;
  Armar;
end;

function TPresentadorImportacion.ValorDe(const AValores: TArray<string>;
  const ACampo: TCampoCarga): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to High(FCampos) do
    if (FCampos[I] = ACampo) and (FSeleccion[I] >= 0) and
      (FSeleccion[I] <= High(AValores)) then
      Exit(Trim(AValores[FSeleccion[I]]));
end;

procedure TPresentadorImportacion.Armar;
var
  I: Integer;
  lFila: TFilaCarga;
  lValores: TArray<string>;
begin
  FFilas.Clear;
  FSaltadas := [];
  for I := 0 to High(FHoja.Filas) do
  begin
    lValores := FHoja.Filas[I];
    lFila := TFilaCarga.Create;
    FFilas.Add(lFila);
    lFila.Fila := FHoja.Numeros[I];
    lFila.Codigo := ValorDe(lValores, ccCodigo);
    lFila.Nombre := ValorDe(lValores, ccNombre);
    lFila.Descripcion := ValorDe(lValores, ccDescripcion);
    lFila.Unidad := ValorDe(lValores, ccUnidad);
    lFila.Categoria := ValorDe(lValores, ccCategoria);
    lFila.Costo := ValorDe(lValores, ccCosto);
    lFila.Precio := ValorDe(lValores, ccPrecio);
  end;
  Revisar;
end;

function TPresentadorImportacion.FilaDe(const ANumero: Integer): TFilaCarga;
var
  lFila: TFilaCarga;
begin
  for lFila in FFilas do
    if lFila.Fila = ANumero then
      Exit(lFila);
  Result := nil;
end;

procedure TPresentadorImportacion.CambiarFila(const AFila: TFilaCarga);
var
  lFila: TFilaCarga;
begin
  lFila := FilaDe(AFila.Fila);
  if lFila = nil then
    Exit;
  lFila.Codigo := Trim(AFila.Codigo);
  lFila.Nombre := Trim(AFila.Nombre);
  lFila.Descripcion := Trim(AFila.Descripcion);
  lFila.Unidad := Trim(AFila.Unidad);
  lFila.Categoria := Trim(AFila.Categoria);
  lFila.Costo := Trim(AFila.Costo);
  lFila.Precio := Trim(AFila.Precio);
  Revisar;
end;

function TPresentadorImportacion.RevisarLocal(const AFila: TFilaCarga): string;
var
  lErrores: TArray<string>;
  lMonto: Currency;
begin
  lErrores := [];
  if not AFila.Costo.IsEmpty and not TryMonto(AFila.Costo, lMonto) then
    lErrores := lErrores + [SImpCostoNoNumero];
  if not AFila.Precio.IsEmpty and not TryMonto(AFila.Precio, lMonto) then
    lErrores := lErrores + [SImpPrecioNoNumero];
  Result := string.Join(SImpSeparador, lErrores);
end;

function TPresentadorImportacion.Listas: TArray<TFilaCarga>;
var
  lFila: TFilaCarga;
begin
  Result := [];
  for lFila in FFilas do
    if not lFila.ConError then
      Result := Result + [lFila];
end;

function TPresentadorImportacion.ADto(const AFilas: TArray<TFilaCarga>)
  : TImportacionDTO;
var
  lFila: TFilaCarga;
  lDto: TFilaImportacionDTO;
  lMonto: Currency;

  function Opcional(const ATexto: string): NullableString;
  begin
    if ATexto.IsEmpty then
      Result.Clear
    else
      Result := ATexto;
  end;

begin
  Result := TImportacionDTO.Create;
  for lFila in AFilas do
  begin
    lDto := TFilaImportacionDTO.Create;
    Result.Filas.Add(lDto);
    lDto.Fila := lFila.Fila;
    lDto.Codigo := lFila.Codigo;
    lDto.Nombre := lFila.Nombre;
    lDto.Descripcion := Opcional(lFila.Descripcion);
    lDto.Unidad := Opcional(lFila.Unidad);
    lDto.Categoria := Opcional(lFila.Categoria);
    if TryMonto(lFila.Costo, lMonto) then
      lDto.Costo := lMonto;
    if TryMonto(lFila.Precio, lMonto) then
      lDto.Precio := lMonto;
  end;
end;

procedure TPresentadorImportacion.MarcarErrores(const AResultado
  : TImportacionResultadoDTO);
var
  lError: TRevisionFilaDTO;
  lFila: TFilaCarga;
begin
  for lFila in FFilas do
    if not lFila.ConError then
      lFila.Revision := SFilaLista;
  for lError in AResultado.Errores do
  begin
    lFila := FilaDe(lError.Fila);
    if lFila = nil then
      Continue;
    if lError.Existe then
    begin
      FSaltadas := FSaltadas + [lFila.Fila];
      FFilas.Remove(lFila);
      Continue;
    end;
    lFila.Revision := lError.Error;
    lFila.ConError := True;
  end;
end;

procedure TPresentadorImportacion.Revisar;
var
  lFila: TFilaCarga;
  lApi: IApiCatalogos;
  lCatalogo: TCatalogoImportacion;
  lDto: TImportacionDTO;
  lListas: TArray<TFilaCarga>;
begin
  for lFila in FFilas do
  begin
    lFila.Revision := RevisarLocal(lFila);
    lFila.ConError := not lFila.Revision.IsEmpty;
    if not lFila.ConError then
      lFila.Revision := SFilaRevisando;
  end;

  lListas := Listas;
  FRevisando := Length(lListas) > 0;
  Publicar;
  if not FRevisando then
    Exit;

  lApi := FApi;
  lCatalogo := FCatalogo;
  lDto := ADto(lListas);

  EjecutarUltima<TImportacionResultadoDTO>(SAccionRevisarCarga,
    function: TImportacionResultadoDTO
    begin
      try
        Result := lApi.Importar(lCatalogo, lDto, True);
      finally
        lDto.Free;
      end;
    end,
    procedure(AResultado: TImportacionResultadoDTO)
    begin
      FRevisando := False;
      MarcarErrores(AResultado);
      Publicar;
    end,
    procedure(AMensaje: string)
    begin
      FRevisando := False;
      FVista.MostrarError(AMensaje);
      Publicar;
    end,
    nil);
end;

function TPresentadorImportacion.TextoSaltadas: string;
var
  lNumeros: TArray<string>;
  lNumero: Integer;
begin
  Result := '';
  if Length(FSaltadas) = 0 then
    Exit;
  TArray.Sort<Integer>(FSaltadas);
  lNumeros := [];
  for lNumero in FSaltadas do
    lNumeros := lNumeros + [lNumero.ToString];
  if Length(FSaltadas) = 1 then
    Result := Format(SFilaSaltada, [lNumeros[0]])
  else
    Result := Format(SFilasSaltadas, [Length(FSaltadas),
      string.Join(SSeparadorFilas, lNumeros)]);
end;

procedure TPresentadorImportacion.Publicar;
var
  lListas: Integer;
begin
  lListas := 0;
  if not FRevisando then
    lListas := Length(Listas);
  FVista.MostrarFilas(FFilas);
  FVista.MostrarResumen(FFilas.Count, lListas, FFilas.Count - Length(Listas),
    FRevisando);
  FVista.MostrarSaltadas(TextoSaltadas);
end;

procedure TPresentadorImportacion.Aprobar;
var
  lListas: TArray<TFilaCarga>;
  lApi: IApiCatalogos;
  lCatalogo: TCatalogoImportacion;
  lDto: TImportacionDTO;
begin
  if FRevisando then
    Exit;
  lListas := Listas;
  if Length(lListas) = 0 then
    Exit;
  if not FVista.Confirmar(Format(SConfirmarCarga, [Length(lListas)])) then
    Exit;

  lApi := FApi;
  lCatalogo := FCatalogo;
  lDto := ADto(lListas);

  Ejecutar<TImportacionResultadoDTO>(SAccionAprobarCarga,
    function: TImportacionResultadoDTO
    begin
      try
        Result := lApi.Importar(lCatalogo, lDto, False);
      finally
        lDto.Free;
      end;
    end,
    procedure(AResultado: TImportacionResultadoDTO)
    begin
      if AResultado.Creados > 0 then
      begin
        FVista.Terminar(Format(SCargaCreada, [AResultado.Creados]));
        Exit;
      end;
      MarcarErrores(AResultado);
      Publicar;
      FVista.MostrarError(SCargaConErrores);
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
