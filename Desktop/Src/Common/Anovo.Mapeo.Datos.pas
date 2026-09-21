unit Anovo.Mapeo.Datos;

// Pasa DTO a filas de una tabla en memoria, y filas a DTO, copiando por
// nombre. Es el hermano del TMapeo del backend: alla entre entidad y DTO,
// aqui entre DTO y dataset.
//
// El nombre del campo es el del contrato del DTO, en mayusculas: el mismo
// que la columna de la base. Sale de [MVCNameAs] cuando la propiedad lo
// lleva -objversion-, y si no de [MVCNameCase(ncSnakeCase)]: UuidLocal busca
// UUID_LOCAL. Una sola regla, sin excepciones. Lo que no exista en la tabla
// se salta: una tabla de listado lleva menos columnas que el DTO.
//
// Tipos, como en el backend: un Nullable sin valor deja el campo nulo, y un
// campo nulo deja el Nullable sin valor. Lo demas se copia segun el tipo del
// campo.
//
// Lo que no hace: objetos anidados ni listas. Esos necesitan su propio mapeo,
// porque una fila no puede guardar otra tabla adentro.

interface

uses
  System.Classes,
  System.Generics.Collections,
  Data.DB,
  FireDAC.Comp.Client;

type
  TMapeoDatos = class
  private
    class procedure ALaFila(const AOrigen: TObject;
      const ATabla: TFDMemTable); static;
    // Un metodo generico no puede llamar a una rutina suelta de la
    // implementacion, asi que la vuelta tambien vive en la clase.
    class procedure DeLaFila(const ATabla: TDataSet;
      const ADestino: TObject); static;
  public
    // La ficha: una fila con ese DTO y nada mas.
    class procedure ATabla(const AOrigen: TObject;
      const ATabla: TFDMemTable); static;

    // El listado: la tabla queda con lo que trae la lista. La lista sigue
    // siendo de quien la paso, aqui solo se lee.
    class procedure AListaTabla<T: class>(const AOrigen: TObjectList<T>;
      const ATabla: TFDMemTable); static;

    // La vuelta: el registro actual en un DTO nuevo, que libera quien lo
    // recibe.
    class function ADto<TD: class, constructor>(const ATabla: TDataSet)
      : TD; static;
  end;

implementation

uses
  System.SysUtils,
  System.Rtti,
  System.TypInfo,
  MVCFramework.Nullables,
  MVCFramework.Serializer.Commons;

// CAMPOS

// NombreCliente pasa a NOMBRE_CLIENTE, que es como se llama en la base y en
// el JSON del contrato.
function ASnake(const ANombre: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(ANombre) do
  begin
    if (I > 1) and CharInSet(ANombre[I], ['A' .. 'Z']) and
      not CharInSet(ANombre[I - 1], ['A' .. 'Z']) then
      Result := Result + '_';
    Result := Result + ANombre[I];
  end;
  Result := UpperCase(Result);
end;

// El nombre que el DTO declara para esa propiedad. [MVCNameAs] manda sobre
// la conversion, que es lo que resuelve objversion sin tratarla aparte.
function NombreEnElContrato(const APropiedad: TRttiProperty): string;
var
  lAtributo: TCustomAttribute;
begin
  for lAtributo in APropiedad.GetAttributes do
    if lAtributo is MVCNameAsAttribute then
      Exit(UpperCase(MVCNameAsAttribute(lAtributo).Name));
  Result := ASnake(APropiedad.Name);
end;

// Nil si la tabla no tiene esa columna, que es un caso normal.
//
// Los campos de busqueda y los calculados tampoco cuentan: no son columnas,
// son el rotulo que la pantalla muestra en lugar del numero. Quien los guarda
// es la columna de la que cuelgan.
function CampoDe(const ATabla: TDataSet;
  const APropiedad: TRttiProperty): TField;
begin
  Result := ATabla.FindField(NombreEnElContrato(APropiedad));
  if Assigned(Result) and (Result.FieldKind <> fkData) then
    Result := nil;
end;

// NULLABLES
//
// Son registros con dos campos privados: fValue y fHasValue, este ultimo un
// string que vale '' cuando no hay valor. Se leen y escriben los campos
// porque HasValue y Value son metodos del registro, y llamarlos por RTTI
// sobre un registro es mas enredado que tocar dos campos.

function EsNulable(const ATipo: PTypeInfo): Boolean;
begin
  Result := GetNullableType(ATipo) <> ntInvalidNullableType;
end;

function LeerNullable(const AContexto: TRttiContext; const AValor: TValue;
  out AInterno: TValue): Boolean;
var
  lTipo: TRttiType;
begin
  lTipo := AContexto.GetType(AValor.TypeInfo);
  Result := lTipo.GetField('fHasValue').GetValue(AValor.GetReferenceToRawData)
    .AsString <> '';
  if Result then
    AInterno := lTipo.GetField('fValue').GetValue(AValor.GetReferenceToRawData);
end;

procedure EscribirNullable(const AContexto: TRttiContext;
  const ADestino: TRttiProperty; const AObjeto: TObject;
  const AInterno: TValue);
var
  lRegistro: TValue;
  lTipo: TRttiType;
  lCampo: TRttiField;
begin
  lRegistro := ADestino.GetValue(AObjeto);
  lTipo := AContexto.GetType(lRegistro.TypeInfo);
  lCampo := lTipo.GetField('fValue');
  lCampo.SetValue(lRegistro.GetReferenceToRawData,
    AInterno.Cast(lCampo.FieldType.Handle));
  // '_' es lo que escribe el SetValue del propio Nullable.
  lTipo.GetField('fHasValue').SetValue(lRegistro.GetReferenceToRawData, '_');
  ADestino.SetValue(AObjeto, lRegistro);
end;

// VALOR DE IDA Y VUELTA

// TDateTime, TDate y TTime son Double por dentro: sin esto, una fecha entraria
// al campo como numero.
function EsFecha(const ATipo: PTypeInfo): Boolean;
begin
  Result := (ATipo = TypeInfo(TDateTime)) or (ATipo = TypeInfo(TDate)) or
    (ATipo = TypeInfo(TTime));
end;

procedure AlCampo(const ACampo: TField; const AValor: TValue;
  const ATipo: PTypeInfo);
begin
  case ATipo.Kind of
    tkInteger, tkInt64:
      ACampo.AsLargeInt := AValor.AsInt64;
    tkFloat:
      if EsFecha(ATipo) then
        ACampo.AsDateTime := AValor.AsType<TDateTime>
      else
        ACampo.AsFloat := AValor.AsExtended;
    tkEnumeration:
      if ATipo = TypeInfo(Boolean) then
        ACampo.AsBoolean := AValor.AsBoolean
      else
        ACampo.AsInteger := AValor.AsOrdinal;
    tkString, tkLString, tkWString, tkUString:
      ACampo.AsString := AValor.AsString;
  end;
end;

function DelCampo(const ACampo: TField; const ATipo: PTypeInfo): TValue;
begin
  case ATipo.Kind of
    tkInteger:
      Result := TValue.From<Integer>(ACampo.AsInteger);
    tkInt64:
      Result := TValue.From<Int64>(ACampo.AsLargeInt);
    tkFloat:
      if EsFecha(ATipo) then
        Result := TValue.From<TDateTime>(ACampo.AsDateTime)
      else
        Result := TValue.From<Double>(ACampo.AsFloat);
    tkEnumeration:
      if ATipo = TypeInfo(Boolean) then
        Result := TValue.From<Boolean>(ACampo.AsBoolean)
      else
        Result := TValue.FromOrdinal(ATipo, ACampo.AsInteger);
    tkString, tkLString, tkWString, tkUString:
      Result := TValue.From<string>(ACampo.AsString);
  else
    Result := TValue.Empty;
  end;
end;

// Se salta lo que no tiene sentido en una fila: objetos, listas y punteros.
function EsCopiable(const ATipo: TRttiType): Boolean;
begin
  Result := Assigned(ATipo) and
    (ATipo.TypeKind in [tkInteger, tkInt64, tkFloat, tkEnumeration, tkString,
    tkLString, tkWString, tkUString, tkRecord]);
end;

class procedure TMapeoDatos.DeLaFila(const ATabla: TDataSet;
  const ADestino: TObject);
var
  lContexto: TRttiContext;
  lPropiedad: TRttiProperty;
  lCampo: TField;
  lValor: TValue;
  lTipo: PTypeInfo;
begin
  lContexto := TRttiContext.Create;
  for lPropiedad in lContexto.GetType(ADestino.ClassType).GetProperties do
  begin
    if not lPropiedad.IsWritable or (lPropiedad.Visibility < mvPublic) then
      Continue;
    if not EsCopiable(lPropiedad.PropertyType) then
      Continue;

    lCampo := CampoDe(ATabla, lPropiedad);
    if lCampo = nil then
      Continue;

    if EsNulable(lPropiedad.PropertyType.Handle) then
    begin
      // Un campo nulo deja el Nullable como estaba, sin valor.
      if lCampo.IsNull then
        Continue;
      lTipo := lContexto.GetType(lPropiedad.PropertyType.Handle)
        .GetField('fValue').FieldType.Handle;
      EscribirNullable(lContexto, lPropiedad, ADestino,
        DelCampo(lCampo, lTipo));
    end
    else if lPropiedad.PropertyType.TypeKind <> tkRecord then
    begin
      lValor := DelCampo(lCampo, lPropiedad.PropertyType.Handle);
      if not lValor.IsEmpty then
        lPropiedad.SetValue(ADestino, lValor);
    end;
  end;
end;

// TMapeoDatos

class procedure TMapeoDatos.ALaFila(const AOrigen: TObject;
  const ATabla: TFDMemTable);
var
  lContexto: TRttiContext;
  lPropiedad: TRttiProperty;
  lCampo: TField;
  lValor, lInterno: TValue;
begin
  lContexto := TRttiContext.Create;
  for lPropiedad in lContexto.GetType(AOrigen.ClassType).GetProperties do
  begin
    if not lPropiedad.IsReadable or (lPropiedad.Visibility < mvPublic) then
      Continue;
    if not EsCopiable(lPropiedad.PropertyType) then
      Continue;

    lCampo := CampoDe(ATabla, lPropiedad);
    // La tabla del listado lleva menos columnas que el DTO: no es un error.
    if (lCampo = nil) or lCampo.ReadOnly then
      Continue;

    lValor := lPropiedad.GetValue(AOrigen);
    if EsNulable(lPropiedad.PropertyType.Handle) then
    begin
      if LeerNullable(lContexto, lValor, lInterno) then
        AlCampo(lCampo, lInterno, lInterno.TypeInfo)
      else
        lCampo.Clear;
    end
    // Un registro que no es Nullable no se sabe como guardar.
    else if lPropiedad.PropertyType.TypeKind <> tkRecord then
      AlCampo(lCampo, lValor, lPropiedad.PropertyType.Handle);
  end;
end;

class procedure TMapeoDatos.ATabla(const AOrigen: TObject;
  const ATabla: TFDMemTable);
begin
  // CreateDataSet sobre una tabla ya creada la deja vacia y lista.
  ATabla.Close;
  ATabla.CreateDataSet;
  ATabla.Append;
  try
    ALaFila(AOrigen, ATabla);
    ATabla.Post;
  except
    // Sin esto la tabla se queda en insercion y el proximo Append falla.
    ATabla.Cancel;
    raise;
  end;
end;

class procedure TMapeoDatos.AListaTabla<T>(const AOrigen: TObjectList<T>;
  const ATabla: TFDMemTable);
var
  lElemento: T;
begin
  ATabla.Close;
  ATabla.CreateDataSet;
  ATabla.DisableControls;
  try
    for lElemento in AOrigen do
    begin
      ATabla.Append;
      try
        ALaFila(lElemento, ATabla);
        ATabla.Post;
      except
        ATabla.Cancel;
        raise;
      end;
    end;
    ATabla.First;
  finally
    ATabla.EnableControls;
  end;
end;

class function TMapeoDatos.ADto<TD>(const ATabla: TDataSet): TD;
begin
  Result := TD.Create;
  try
    DeLaFila(ATabla, Result);
  except
    Result.Free;
    raise;
  end;
end;

end.
