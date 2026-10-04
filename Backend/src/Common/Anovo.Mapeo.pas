unit Anovo.Mapeo;

// Copia entre DTO y entidad por nombre de propiedad.

interface

uses
  System.SysUtils,
  System.Generics.Collections;

type
  EMapeo = class(Exception);

  TMapeo = class
  public
    class procedure Copiar(const AOrigen, ADestino: TObject); static;
    class function ADto<TD: class, constructor>(const AOrigen: TObject)
      : TD; static;
    class function AListaDto<TE: class; TD: class, constructor>
      (const AOrigen: TObjectList<TE>): TObjectList<TD>; static;
  end;

implementation

uses
  System.Rtti,
  System.TypInfo,
  MVCFramework.Nullables;

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

class procedure TMapeo.Copiar(const AOrigen, ADestino: TObject);
var
  lContexto: TRttiContext;
  lTipoOrigen: TRttiType;
  lDestino, lOrigen: TRttiProperty;
  lValor, lInterno: TValue;
  lOrigenNulable, lDestinoNulable: Boolean;
begin
  lContexto := TRttiContext.Create;
  lTipoOrigen := lContexto.GetType(AOrigen.ClassType);
  for lDestino in lContexto.GetType(ADestino.ClassType).GetProperties do
  begin
    if not lDestino.IsWritable or (lDestino.Visibility < mvPublic) then
      Continue;
    if lDestino.PropertyType.TypeKind = tkClass then
      Continue;
    lOrigen := lTipoOrigen.GetProperty(lDestino.Name);
    if (lOrigen = nil) or not lOrigen.IsReadable or
      (lOrigen.Visibility < mvPublic) or
      (lOrigen.PropertyType.TypeKind = tkClass) then
      Continue;

    lValor := lOrigen.GetValue(AOrigen);
    lOrigenNulable := GetNullableType(lOrigen.PropertyType.Handle) <>
      ntInvalidNullableType;
    lDestinoNulable := GetNullableType(lDestino.PropertyType.Handle) <>
      ntInvalidNullableType;

    lInterno := lValor;
    if lOrigenNulable and not LeerNullable(lContexto, lValor, lInterno) then
      Continue;

    if lOrigen.PropertyType.Handle = lDestino.PropertyType.Handle then
      lDestino.SetValue(ADestino, lValor)
    else if lDestinoNulable then
      EscribirNullable(lContexto, lDestino, ADestino, lInterno)
    else if lOrigenNulable then
      lDestino.SetValue(ADestino, lInterno.Cast(lDestino.PropertyType.Handle))
    else if (lOrigen.PropertyType.TypeKind = lDestino.PropertyType.TypeKind) and
      (lDestino.PropertyType.TypeKind in [tkInteger, tkInt64, tkFloat]) then
      lDestino.SetValue(ADestino, lValor.Cast(lDestino.PropertyType.Handle))
    else
      raise EMapeo.CreateFmt('%s.%s es %s y %s.%s es %s: no se mapea solo',
        [AOrigen.ClassName, lOrigen.Name, lOrigen.PropertyType.Name,
        ADestino.ClassName, lDestino.Name, lDestino.PropertyType.Name]);
  end;
end;

class function TMapeo.ADto<TD>(const AOrigen: TObject): TD;
begin
  Result := TD.Create;
  try
    Copiar(AOrigen, Result);
  except
    Result.Free;
    raise;
  end;
end;

class function TMapeo.AListaDto<TE, TD>(const AOrigen: TObjectList<TE>)
  : TObjectList<TD>;
var
  lElemento: TE;
begin
  Result := TObjectList<TD>.Create(True);
  try
    for lElemento in AOrigen do
      Result.Add(ADto<TD>(lElemento));
  except
    Result.Free;
    raise;
  end;
end;

end.
