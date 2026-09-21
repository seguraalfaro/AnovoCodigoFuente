                                                                    unit Anovo.Mapeo;

// Pasa entidades a DTO, y DTO a entidades, copiando las propiedades que se
// llaman igual.
//
// El destino manda: se recorre lo que el destino puede recibir y se busca en
// el origen una propiedad con el mismo nombre. Si el origen no la tiene, se
// deja como estaba; asi un DTO puede llevar campos que se llenan aparte, y
// una entidad conserva lo que el DTO de entrada no trae.
//
// Tipos, en las cuatro combinaciones:
//   iguales           se copia tal cual.
//   Nullable a simple con valor se copia; sin valor el destino queda como
//                     estaba, igual que ValueOrDefault.
//   simple a Nullable se copia y el destino queda con valor.
//   Nullable a otro   se pasa el valor de adentro: NullableInt32 del DTO a
//   Nullable          NullableInt32 de la entidad son tipos distintos.
// Cualquier otra combinacion es un error de diseno del DTO y se avisa con
// EMapeo en vez de dejar el campo vacio.
//
// Lo que se pierde frente al mapeo a mano: renombrar una propiedad en un lado
// ya no rompe la compilacion, el campo solo deja de llegar.

interface

uses
  System.SysUtils,
  System.Generics.Collections;

type
  EMapeo = class(Exception);

  TMapeo = class
  public
    // Copia sobre un objeto que ya existe: la entidad que se cargo de la base
    // y se va a actualizar. Solo toca las propiedades que el origen tiene.
    class procedure Copiar(const AOrigen, ADestino: TObject); static;
    class function ADto<TD: class, constructor>(const AOrigen: TObject)
      : TD; static;
    // La lista de origen no se toca ni se libera: es de quien llama. La que
    // devuelve es nueva, duena de sus objetos, y la libera quien la recibe.
    class function AListaDto<TE: class; TD: class, constructor>
      (const AOrigen: TObjectList<TE>): TObjectList<TD>; static;
  end;

implementation

uses
  System.Rtti,
  System.TypInfo,
  MVCFramework.Nullables;

// Los Nullable de DMVC son registros con dos campos privados: fValue y
// fHasValue, este ultimo un string que vale '' cuando no hay valor. Se leen
// los campos porque HasValue y Value son metodos del registro, y llamarlos
// por RTTI sobre un registro es mas enredado que leer dos campos.
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

// El valor entra en el registro por sus campos, y fHasValue queda en '_',
// que es lo que escribe el SetValue del propio Nullable.
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
    // Listas y objetos anidados necesitan su propio mapeo.
    if lDestino.PropertyType.TypeKind = tkClass then
      Continue;
    lOrigen := lTipoOrigen.GetProperty(lDestino.Name);
    if (lOrigen = nil) or not lOrigen.IsReadable or
      (lOrigen.Visibility < mvPublic) then
      Continue;

    lValor := lOrigen.GetValue(AOrigen);
    lOrigenNulable := GetNullableType(lOrigen.PropertyType.Handle) <>
      ntInvalidNullableType;
    lDestinoNulable := GetNullableType(lDestino.PropertyType.Handle) <>
      ntInvalidNullableType;

    // El valor que se copia: el del origen, o el de adentro si el origen es
    // Nullable. Un Nullable sin valor no se copia: el destino queda como
    // estaba, que es lo que hacia ValueOrDefault.
    lInterno := lValor;
    if lOrigenNulable and not LeerNullable(lContexto, lValor, lInterno) then
      Continue;

    if lOrigen.PropertyType.Handle = lDestino.PropertyType.Handle then
      lDestino.SetValue(ADestino, lValor)
    else if lDestinoNulable then
      EscribirNullable(lContexto, lDestino, ADestino, lInterno)
    else if lOrigenNulable then
      lDestino.SetValue(ADestino, lInterno.Cast(lDestino.PropertyType.Handle))
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
    // Si falla a mitad, la lista a medio armar no la recibe nadie que la
    // pueda liberar.
    Result.Free;
    raise;
  end;
end;

end.
