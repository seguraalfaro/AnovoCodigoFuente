unit Anovo.Archivo.Hoja;

// Lee una hoja de un libro .xlsx (un ZIP con XML: no hace falta Excel) o un
// .csv, y la devuelve como texto: encabezados, filas y su numero en el archivo.

interface

uses
  System.SysUtils;

type
  THojaLeida = record
    Encabezados: TArray<string>;
    Filas: TArray<TArray<string>>;
    Numeros: TArray<Integer>;
  end;

  EArchivoHoja = class(Exception);

  TArchivoHoja = class
  public
    class function Hojas(const ARuta: string): TArray<string>; static;
    class function Leer(const ARuta: string; const AHoja: Integer)
      : THojaLeida; static;
  end;

implementation

uses
  System.Classes,
  System.Zip,
  System.IOUtils,
  System.Generics.Collections,
  Xml.XMLIntf,
  Xml.XMLDoc,
  Xml.xmldom,
  Xml.omnixmldom,
  Anovo.Textos;

const
  EXT_CSV = '.csv';
  EXT_XLSX = '.xlsx';
  ENTRADA_LIBRO = 'xl/workbook.xml';
  ENTRADA_RELACIONES = 'xl/_rels/workbook.xml.rels';
  ENTRADA_TEXTOS = 'xl/sharedStrings.xml';
  CARPETA_LIBRO = 'xl/';
  TIPO_COMPARTIDO = 's';
  TIPO_EN_LINEA = 'inlineStr';
  NOMBRE_HOJA_CSV = 'CSV';
  COMILLA = '"';
  SEPARADORES_CSV: array [0 .. 1] of Char = (';', ',');

function EsCsv(const ARuta: string): Boolean;
begin
  Result := SameText(ExtractFileExt(ARuta), EXT_CSV);
end;

procedure ValidarRuta(const ARuta: string);
begin
  if not TFile.Exists(ARuta) then
    raise EArchivoHoja.Create(SArchivoNoExiste);
  if not EsCsv(ARuta) and not SameText(ExtractFileExt(ARuta), EXT_XLSX) then
    raise EArchivoHoja.Create(SArchivoFormato);
end;

function Hijo(const ANodo: IXMLNode; const ANombre: string): IXMLNode;
var
  I: Integer;
begin
  Result := nil;
  if ANodo = nil then
    Exit;
  for I := 0 to ANodo.ChildNodes.Count - 1 do
    if ANodo.ChildNodes[I].LocalName = ANombre then
      Exit(ANodo.ChildNodes[I]);
end;

function Atributo(const ANodo: IXMLNode; const ANombre: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to ANodo.AttributeNodes.Count - 1 do
    if ANodo.AttributeNodes[I].LocalName = ANombre then
      Exit(ANodo.AttributeNodes[I].Text);
end;

function TextoDe(const ANodo: IXMLNode): string;
var
  I: Integer;
begin
  Result := '';
  if ANodo = nil then
    Exit;
  if ANodo.IsTextElement then
    Exit(ANodo.Text);
  for I := 0 to ANodo.ChildNodes.Count - 1 do
    if ANodo.ChildNodes[I].NodeType = ntElement then
      Result := Result + TextoDe(ANodo.ChildNodes[I]);
end;

function AbrirXml(const AZip: TZipFile; const AEntrada: string): IXMLDocument;
var
  lBytes: TBytes;
  lFlujo: TBytesStream;
  lDocumento: TXMLDocument;
begin
  Result := nil;
  if AZip.IndexOf(AEntrada) < 0 then
    Exit;
  AZip.Read(AEntrada, lBytes);
  lFlujo := TBytesStream.Create(lBytes);
  try
    lDocumento := TXMLDocument.Create(nil);
    Result := lDocumento;
    lDocumento.DOMVendor := GetDOMVendor(sOmniXmlVendor);
    lDocumento.ParseOptions := [poPreserveWhiteSpace];
    lDocumento.LoadFromStream(lFlujo);
  finally
    lFlujo.Free;
  end;
end;

function AbrirLibro(const ARuta: string): TZipFile;
begin
  Result := TZipFile.Create;
  try
    Result.Open(ARuta, zmRead);
  except
    Result.Free;
    raise EArchivoHoja.Create(SArchivoNoSeLee);
  end;
end;

function NodosHoja(const AZip: TZipFile; out ALibro: IXMLDocument)
  : IXMLNode;
begin
  ALibro := AbrirXml(AZip, ENTRADA_LIBRO);
  if ALibro = nil then
    raise EArchivoHoja.Create(SArchivoNoSeLee);
  Result := Hijo(ALibro.DocumentElement, 'sheets');
  if Result = nil then
    raise EArchivoHoja.Create(SArchivoNoSeLee);
end;

function ColumnaDe(const AReferencia: string): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(AReferencia) do
    if CharInSet(AReferencia[I], ['A' .. 'Z']) then
      Result := Result * 26 + Ord(AReferencia[I]) - Ord('A') + 1
    else
      Break;
  Dec(Result);
end;

function TextosCompartidos(const AZip: TZipFile): TArray<string>;
var
  lDocumento: IXMLDocument;
  lRaiz: IXMLNode;
  I: Integer;
begin
  Result := [];
  lDocumento := AbrirXml(AZip, ENTRADA_TEXTOS);
  if lDocumento = nil then
    Exit;
  lRaiz := lDocumento.DocumentElement;
  SetLength(Result, lRaiz.ChildNodes.Count);
  for I := 0 to lRaiz.ChildNodes.Count - 1 do
    Result[I] := TextoDe(lRaiz.ChildNodes[I]);
end;

function EntradaDeHoja(const AZip: TZipFile; const AHoja: Integer): string;
var
  lHojas, lRelacion: IXMLNode;
  lLibro, lRelaciones: IXMLDocument;
  lId, lDestino: string;
  I: Integer;
begin
  lHojas := NodosHoja(AZip, lLibro);
  if (AHoja < 0) or (AHoja >= lHojas.ChildNodes.Count) then
    raise EArchivoHoja.Create(SArchivoNoSeLee);
  lId := Atributo(lHojas.ChildNodes[AHoja], 'id');

  lRelaciones := AbrirXml(AZip, ENTRADA_RELACIONES);
  if lRelaciones = nil then
    raise EArchivoHoja.Create(SArchivoNoSeLee);
  lDestino := '';
  for I := 0 to lRelaciones.DocumentElement.ChildNodes.Count - 1 do
  begin
    lRelacion := lRelaciones.DocumentElement.ChildNodes[I];
    if Atributo(lRelacion, 'Id') = lId then
      lDestino := Atributo(lRelacion, 'Target');
  end;
  if lDestino.IsEmpty then
    raise EArchivoHoja.Create(SArchivoNoSeLee);

  if lDestino.StartsWith('/') then
    Result := lDestino.Substring(1)
  else
    Result := CARPETA_LIBRO + lDestino;
end;

function ValorDeCelda(const ACelda: IXMLNode;
  const ATextos: TArray<string>): string;
var
  lTipo: string;
  lIndice: Integer;
begin
  lTipo := Atributo(ACelda, 't');
  if lTipo = TIPO_EN_LINEA then
    Exit(TextoDe(Hijo(ACelda, 'is')));
  Result := TextoDe(Hijo(ACelda, 'v'));
  if (lTipo = TIPO_COMPARTIDO) and TryStrToInt(Result, lIndice) and
    (lIndice >= 0) and (lIndice <= High(ATextos)) then
    Result := ATextos[lIndice];
end;

function FilaVacia(const AValores: TArray<string>): Boolean;
var
  lValor: string;
begin
  for lValor in AValores do
    if not lValor.Trim.IsEmpty then
      Exit(False);
  Result := True;
end;

procedure Acomodar(const AFilas: TList<TArray<string>>;
  const ANumeros: TList<Integer>; var AResultado: THojaLeida);
var
  I, lInicio: Integer;
begin
  lInicio := -1;
  for I := 0 to AFilas.Count - 1 do
    if not FilaVacia(AFilas[I]) then
    begin
      lInicio := I;
      Break;
    end;
  if lInicio < 0 then
    raise EArchivoHoja.Create(SArchivoSinDatos);

  AResultado.Encabezados := AFilas[lInicio];
  AResultado.Filas := [];
  AResultado.Numeros := [];
  for I := lInicio + 1 to AFilas.Count - 1 do
    if not FilaVacia(AFilas[I]) then
    begin
      AResultado.Filas := AResultado.Filas + [AFilas[I]];
      AResultado.Numeros := AResultado.Numeros + [ANumeros[I]];
    end;
end;

procedure LeerXlsx(const ARuta: string; const AHoja: Integer;
  var AResultado: THojaLeida);
var
  lZip: TZipFile;
  lTextos: TArray<string>;
  lHoja: IXMLDocument;
  lDatos, lFila, lCelda: IXMLNode;
  lFilas: TList<TArray<string>>;
  lNumeros: TList<Integer>;
  lValores: TArray<string>;
  I, J, lColumna, lNumero: Integer;
begin
  lZip := AbrirLibro(ARuta);
  lFilas := TList<TArray<string>>.Create;
  lNumeros := TList<Integer>.Create;
  try
    lTextos := TextosCompartidos(lZip);
    lHoja := AbrirXml(lZip, EntradaDeHoja(lZip, AHoja));
    if lHoja = nil then
      raise EArchivoHoja.Create(SArchivoNoSeLee);
    lDatos := Hijo(lHoja.DocumentElement, 'sheetData');
    if lDatos = nil then
      raise EArchivoHoja.Create(SArchivoSinDatos);

    for I := 0 to lDatos.ChildNodes.Count - 1 do
    begin
      lFila := lDatos.ChildNodes[I];
      if lFila.LocalName <> 'row' then
        Continue;
      if not TryStrToInt(Atributo(lFila, 'r'), lNumero) then
        lNumero := lNumeros.Count + 1;
      lValores := [];
      for J := 0 to lFila.ChildNodes.Count - 1 do
      begin
        lCelda := lFila.ChildNodes[J];
        if lCelda.LocalName <> 'c' then
          Continue;
        lColumna := ColumnaDe(Atributo(lCelda, 'r'));
        if lColumna < 0 then
          lColumna := Length(lValores);
        if lColumna >= Length(lValores) then
          SetLength(lValores, lColumna + 1);
        lValores[lColumna] := ValorDeCelda(lCelda, lTextos);
      end;
      lFilas.Add(lValores);
      lNumeros.Add(lNumero);
    end;
    Acomodar(lFilas, lNumeros, AResultado);
  finally
    lNumeros.Free;
    lFilas.Free;
    lZip.Free;
  end;
end;

function PartirCsv(const ALinea: string; const ASeparador: Char)
  : TArray<string>;
var
  I: Integer;
  lCampo: string;
  lEntreComillas: Boolean;
begin
  Result := [];
  lCampo := '';
  lEntreComillas := False;
  I := 1;
  while I <= Length(ALinea) do
  begin
    if ALinea[I] = COMILLA then
    begin
      if lEntreComillas and (I < Length(ALinea)) and
        (ALinea[I + 1] = COMILLA) then
      begin
        lCampo := lCampo + COMILLA;
        Inc(I);
      end
      else
        lEntreComillas := not lEntreComillas;
    end
    else if (ALinea[I] = ASeparador) and not lEntreComillas then
    begin
      Result := Result + [lCampo];
      lCampo := '';
    end
    else
      lCampo := lCampo + ALinea[I];
    Inc(I);
  end;
  Result := Result + [lCampo];
end;

procedure LeerCsv(const ARuta: string; var AResultado: THojaLeida);
var
  lBytes: TBytes;
  lCodificacion: TEncoding;
  lInicio, I: Integer;
  lLineas: TStringList;
  lSeparador: Char;
  lFilas: TList<TArray<string>>;
  lNumeros: TList<Integer>;
begin
  lBytes := TFile.ReadAllBytes(ARuta);
  lCodificacion := nil;
  lInicio := TEncoding.GetBufferEncoding(lBytes, lCodificacion,
    TEncoding.ANSI);
  lLineas := TStringList.Create;
  lFilas := TList<TArray<string>>.Create;
  lNumeros := TList<Integer>.Create;
  try
    lLineas.Text := lCodificacion.GetString(lBytes, lInicio,
      Length(lBytes) - lInicio);
    if lLineas.Count = 0 then
      raise EArchivoHoja.Create(SArchivoSinDatos);

    lSeparador := SEPARADORES_CSV[1];
    if lLineas[0].CountChar(SEPARADORES_CSV[0]) >
      lLineas[0].CountChar(SEPARADORES_CSV[1]) then
      lSeparador := SEPARADORES_CSV[0];

    for I := 0 to lLineas.Count - 1 do
    begin
      lFilas.Add(PartirCsv(lLineas[I], lSeparador));
      lNumeros.Add(I + 1);
    end;
    Acomodar(lFilas, lNumeros, AResultado);
  finally
    lNumeros.Free;
    lFilas.Free;
    lLineas.Free;
  end;
end;

class function TArchivoHoja.Hojas(const ARuta: string): TArray<string>;
var
  lZip: TZipFile;
  lLibro: IXMLDocument;
  lHojas: IXMLNode;
  I: Integer;
begin
  ValidarRuta(ARuta);
  if EsCsv(ARuta) then
  begin
    Result := [NOMBRE_HOJA_CSV];
    Exit;
  end;

  lZip := AbrirLibro(ARuta);
  try
    lHojas := NodosHoja(lZip, lLibro);
    Result := [];
    for I := 0 to lHojas.ChildNodes.Count - 1 do
      Result := Result + [Atributo(lHojas.ChildNodes[I], 'name')];
  finally
    lZip.Free;
  end;
  if Length(Result) = 0 then
    raise EArchivoHoja.Create(SArchivoSinDatos);
end;

class function TArchivoHoja.Leer(const ARuta: string; const AHoja: Integer)
  : THojaLeida;
begin
  ValidarRuta(ARuta);
  if EsCsv(ARuta) then
    LeerCsv(ARuta, Result)
  else
    LeerXlsx(ARuta, AHoja, Result);
end;

end.
