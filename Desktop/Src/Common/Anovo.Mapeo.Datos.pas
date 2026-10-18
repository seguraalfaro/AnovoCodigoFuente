unit Anovo.Mapeo.Datos;

// Copia entre DTO y filas de una tabla en memoria, por nombre.

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
    class procedure DeLaFila(const ATabla: TDataSet;
      const ADestino: TObject); static;
  public
    class procedure ATabla(const AOrigen: TObject;
      const ATabla: TFDMemTable); static;

    class procedure AListaTabla<T: class>(const AOrigen: TObjectList<T>;
      const ATabla: TFDMemTable); static;

    class function ADto<TD: class, constructor>(const ATabla: TDataSet)
      : TD; static;
  end;

implementation

uses
  System.SysUtils,
  System.Rtti,
  System.TypInfo,
  System.MaskUtils,
  MVCFramework.Nullables,
  MVCFramework.Serializer.Commons;

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

function NombreEnElContrato(const APropiedad: TRttiProperty): string;
var
  lAtributo: TCustomAttribute;
begin
  for lAtributo in APropiedad.GetAttributes do
    if lAtributo is MVCNameAsAttribute then
      Exit(UpperCase(MVCNameAsAttribute(lAtributo).Name));
  Result := ASnake(APropiedad.Name);
end;

function CampoDe(const ATabla: TDataSet;
  const APropiedad: TRttiProperty): TField;
begin
  Result := ATabla.FindField(NombreEnElContrato(APropiedad));
  if Assigned(Result) and (Result.FieldKind <> fkData) then
    Result := nil;
end;

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
  lTipo.GetField('fHasValue').SetValue(lRegistro.GetReferenceToRawData, '_');
  ADestino.SetValue(AObjeto, lRegistro);
end;

function EsFecha(const ATipo: PTypeInfo): Boolean;
begin
  Result := (ATipo = TypeInfo(TDateTime)) or (ATipo = TypeInfo(TDate)) or
    (ATipo = TypeInfo(TTime));
end;

function ConMascara(const ACampo: TField; const ATexto: string): string;
const
  POSICIONES = ['0', '9', '#', 'L', 'l', 'A', 'a', 'C', 'c'];
var
  lMascara: string;
  lPosiciones: Integer;
  lCaracter: Char;
begin
  Result := ATexto;
  if (ACampo.EditMask = '') or (ATexto = '') then
    Exit;
  lMascara := string(ACampo.EditMask);
  if Pos(';', lMascara) > 0 then
    lMascara := Copy(lMascara, 1, Pos(';', lMascara) - 1);
  lPosiciones := 0;
  for lCaracter in lMascara do
    if CharInSet(lCaracter, POSICIONES) then
      Inc(lPosiciones);
  if Length(ATexto) = lPosiciones then
    Result := FormatMaskText(lMascara + ';0;_', ATexto);
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
      ACampo.AsString := ConMascara(ACampo, AValor.AsString);
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
    else if lPropiedad.PropertyType.TypeKind <> tkRecord then
      AlCampo(lCampo, lValor, lPropiedad.PropertyType.Handle);
  end;
end;

class procedure TMapeoDatos.ATabla(const AOrigen: TObject;
  const ATabla: TFDMemTable);
begin
  ATabla.Close;
  ATabla.CreateDataSet;
  ATabla.Append;
  try
    ALaFila(AOrigen, ATabla);
    ATabla.Post;
  except
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
