unit Anovo.UI.ColumnasRejilla;

// Columnas de una rejilla a gusto de cada usuario: orden, visibilidad,
// alineacion y ancho, guardadas con PropSave de RosiComp en AppData.

interface

uses
  System.Classes, System.Types, Vcl.Controls, Vcl.Menus, Vcl.DBGrids, rDBGrid;

type
  TColumnaElegida = record
    Campo: string;
    Titulo: string;
    Visible: Boolean;
    Alineacion: TAlignment;
  end;

  TColumnasElegidas = TArray<TColumnaElegida>;

  TColumnasRejilla = class(TComponent)
  private
    FGrid: TrDBGrid;
    FClave: string;
    FMenu: TPopupMenu;
    FUpAnterior: TMouseEvent;
    FDownAnterior: TMouseEvent;
    FOriginal: TColumnasElegidas;
    FAnchosAlPresionar: string;
    function Seccion: string;
    function Columna(const ACampo: string): TColumn;
    function CampoAcciones: string;
    function AnchosActuales: string;
    function Leer: TColumnasElegidas;
    procedure Poner(const AColumnas: TColumnasElegidas);
    procedure AnchoAutomatico;
    procedure GuardarConAnchos(const AAnchosPropios: Boolean);
    procedure Presionar(Sender: TObject; AButton: TMouseButton;
      AShift: TShiftState; AX, AY: Integer);
    procedure Soltar(Sender: TObject; AButton: TMouseButton;
      AShift: TShiftState; AX, AY: Integer);
    procedure ElegirColumnas(Sender: TObject);
    procedure ElegirRestablecer(Sender: TObject);
  public
    constructor Crear(AGrid: TrDBGrid; const AClave: string);

    class function Activar(AGrid: TrDBGrid;
      const AClave: string): TColumnasRejilla; overload;
    class function Activar(AGrid: TrDBGrid): TColumnasRejilla; overload;
    class procedure AplicarEn(AGrid: TrDBGrid);
    class procedure Quitar(AGrid: TrDBGrid);
    class function De(AGrid: TrDBGrid): TColumnasRejilla;

    procedure Aplicar;
    procedure Guardar;
    procedure Configurar;
    procedure Restablecer;
  end;

implementation

uses
  System.SysUtils, System.IOUtils, System.UITypes, Vcl.Grids, Vcl.Forms,
  PropSaveMain, PropSaveGrids, RosiCompGlobalCfg,
  Anovo.Sesion,
  Anovo.Textos,
  Anovo.UI.DBGridExtend,
  Anovo.Forms.Columnas;

const
  CARPETA = 'Anovo';
  NOMBRE_ARCHIVO = 'pantallas.ini';
  CLAVE_ALINEACION = 'Alineacion';
  CLAVE_ANCHOS_PROPIOS = 'AnchosPropios';
  PREFIJO_FRAME = 'Tfra';
  PREFIJO_FORMA = 'Tfrm';
  REJILLA_LISTADO = 'grDatos';

type
  TGuardaColumnas = class(TDBGridsPropSave);

var
  GArchivo: TPropSaveFile;

function Archivo: TPropSaveFile;
var
  lCarpeta: string;
begin
  if GArchivo = nil then
  begin
    lCarpeta := TPath.Combine(TPath.GetHomePath, CARPETA);
    ForceDirectories(lCarpeta);
    RosiCompConfig.PropSaveCfg.Grids_UseGlobalSetting := True;
    GArchivo := TPropSaveFile.Create(nil);
    GArchivo.LoadFile(TPath.Combine(lCarpeta, NOMBRE_ARCHIVO));
  end;
  Result := GArchivo;
end;

function NuevoGuarda: TGuardaColumnas;
begin
  Result := TGuardaColumnas.Create(nil);
  Result.StoreColumns := True;
  Result.StoreColumnsProp := False;
end;

constructor TColumnasRejilla.Crear(AGrid: TrDBGrid; const AClave: string);
var
  lOpcion: TMenuItem;
begin
  inherited Create(AGrid);
  FGrid := AGrid;
  FClave := AClave;

  FMenu := TPopupMenu.Create(Self);
  lOpcion := TMenuItem.Create(FMenu);
  lOpcion.Caption := SMenuColumnas;
  lOpcion.OnClick := ElegirColumnas;
  FMenu.Items.Add(lOpcion);
  lOpcion := TMenuItem.Create(FMenu);
  lOpcion.Caption := SMenuRestablecerColumnas;
  lOpcion.OnClick := ElegirRestablecer;
  FMenu.Items.Add(lOpcion);

  FUpAnterior := FGrid.OnMouseUp;
  FDownAnterior := FGrid.OnMouseDown;
  FGrid.OnMouseUp := Soltar;
  FGrid.OnMouseDown := Presionar;
end;

class function TColumnasRejilla.Activar(AGrid: TrDBGrid;
  const AClave: string): TColumnasRejilla;
begin
  Result := De(AGrid);
  if Result = nil then
    Result := TColumnasRejilla.Crear(AGrid, AClave);
end;

class function TColumnasRejilla.Activar(AGrid: TrDBGrid): TColumnasRejilla;
var
  lClave: string;
begin
  Result := nil;
  if (AGrid = nil) or (AGrid.Owner = nil) then
    Exit;
  lClave := AGrid.Owner.ClassName;
  if lClave.StartsWith(PREFIJO_FRAME) or lClave.StartsWith(PREFIJO_FORMA) then
    lClave := Copy(lClave, Length(PREFIJO_FRAME) + 1, MaxInt)
  else
    lClave := Copy(lClave, 2, MaxInt);
  if not SameText(AGrid.Name, REJILLA_LISTADO) then
    lClave := lClave + '.' + AGrid.Name;
  Result := Activar(AGrid, lClave);
end;

class procedure TColumnasRejilla.AplicarEn(AGrid: TrDBGrid);
begin
  if De(AGrid) <> nil then
    De(AGrid).Aplicar;
end;

class procedure TColumnasRejilla.Quitar(AGrid: TrDBGrid);
var
  lColumnas: TColumnasRejilla;
begin
  lColumnas := De(AGrid);
  if lColumnas = nil then
    Exit;
  AGrid.OnMouseUp := lColumnas.FUpAnterior;
  AGrid.OnMouseDown := lColumnas.FDownAnterior;
  lColumnas.Free;
end;

class function TColumnasRejilla.De(AGrid: TrDBGrid): TColumnasRejilla;
var
  I: Integer;
begin
  Result := nil;
  if AGrid = nil then
    Exit;
  for I := 0 to AGrid.ComponentCount - 1 do
    if AGrid.Components[I] is TColumnasRejilla then
      Exit(TColumnasRejilla(AGrid.Components[I]));
end;

function TColumnasRejilla.Seccion: string;
begin
  Result := Format('U%d.%s', [TSesion.UsuarioId, FClave]);
end;

function TColumnasRejilla.Columna(const ACampo: string): TColumn;
var
  I: Integer;
begin
  for I := 0 to FGrid.Columns.Count - 1 do
    if SameText(FGrid.Columns[I].FieldName, ACampo) then
      Exit(FGrid.Columns[I]);
  Result := nil;
end;

function TColumnasRejilla.CampoAcciones: string;
begin
  Result := TDBGridExtend.De(FGrid).CampoAcciones;
end;

function TColumnasRejilla.AnchosActuales: string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to FGrid.Columns.Count - 1 do
    if FGrid.Columns[I].Visible then
      Result := Result + FGrid.Columns[I].FieldName + '=' +
        IntToStr(FGrid.Columns[I].Width) + ';';
end;

function TColumnasRejilla.Leer: TColumnasElegidas;
var
  I: Integer;
  lElegida: TColumnaElegida;
begin
  Result := [];
  for I := 0 to FGrid.Columns.Count - 1 do
  begin
    if SameText(FGrid.Columns[I].FieldName, CampoAcciones) then
      Continue;
    lElegida.Campo := FGrid.Columns[I].FieldName;
    lElegida.Titulo := FGrid.Columns[I].Title.Caption;
    if lElegida.Titulo = '' then
      lElegida.Titulo := lElegida.Campo;
    lElegida.Visible := FGrid.Columns[I].Visible;
    lElegida.Alineacion := FGrid.Columns[I].Alignment;
    Result := Result + [lElegida];
  end;
end;

procedure TColumnasRejilla.Poner(const AColumnas: TColumnasElegidas);
var
  I: Integer;
  lColumna: TColumn;
begin
  FGrid.Columns.BeginUpdate;
  try
    for I := 0 to High(AColumnas) do
    begin
      lColumna := Columna(AColumnas[I].Campo);
      if lColumna = nil then
        Continue;
      lColumna.Index := I;
      lColumna.Visible := AColumnas[I].Visible;
      lColumna.Alignment := AColumnas[I].Alineacion;
    end;
  finally
    FGrid.Columns.EndUpdate;
  end;
  TDBGridExtend.De(FGrid).AjustarAcciones;
end;

procedure TColumnasRejilla.AnchoAutomatico;
begin
  AjustarAnchos(FGrid);
end;

procedure TColumnasRejilla.Aplicar;
var
  lGuarda: TGuardaColumnas;
  lColumna: TColumn;
  lValor, I: Integer;
begin
  if FGrid.Columns.Count = 0 then
    Exit;
  if Length(FOriginal) = 0 then
    FOriginal := Leer;
  if not Archivo.SectionExists(Seccion) then
    Exit;

  FGrid.ColumnWidth := cwNone;
  lGuarda := NuevoGuarda;
  try
    lGuarda.ReadSaveProps(psaRead, Archivo, Seccion, FGrid);
    for I := 0 to lGuarda.SavedDBColumnFieldList.Count - 1 do
    begin
      lColumna := Columna(lGuarda.SavedDBColumnFieldList[I]);
      lValor := Archivo.ReadInteger(lGuarda.GetColumnKey(Seccion, I),
        CLAVE_ALINEACION, -1);
      if (lColumna <> nil) and (lValor >= Ord(Low(TAlignment))) and
        (lValor <= Ord(High(TAlignment))) then
        lColumna.Alignment := TAlignment(lValor);
    end;
  finally
    lGuarda.Free;
  end;
  TDBGridExtend.De(FGrid).AjustarAcciones;
  if Archivo.ReadBool(Seccion, CLAVE_ANCHOS_PROPIOS, False) then
    TDBGridExtend.De(FGrid).AjusteAutomatico := False
  else
    AnchoAutomatico;
end;

procedure TColumnasRejilla.GuardarConAnchos(const AAnchosPropios: Boolean);
var
  lGuarda: TGuardaColumnas;
  I: Integer;
begin
  lGuarda := NuevoGuarda;
  try
    lGuarda.ReadSaveProps(psaSave, Archivo, Seccion, FGrid);
    for I := 0 to FGrid.Columns.Count - 1 do
      Archivo.WriteInteger(lGuarda.GetColumnKey(Seccion, I), CLAVE_ALINEACION,
        Ord(FGrid.Columns[I].Alignment));
  finally
    lGuarda.Free;
  end;
  Archivo.WriteBool(Seccion, CLAVE_ANCHOS_PROPIOS, AAnchosPropios);
  Archivo.SaveFileSilent('');
end;

procedure TColumnasRejilla.Guardar;
begin
  GuardarConAnchos(Archivo.ReadBool(Seccion, CLAVE_ANCHOS_PROPIOS, False));
end;

procedure TColumnasRejilla.Configurar;
var
  lColumnas: TColumnasElegidas;
begin
  lColumnas := Leer;
  case TfrmColumnas.Elegir(GetParentForm(FGrid), lColumnas) of
    mrOk:
      begin
        Poner(lColumnas);
        if not Archivo.ReadBool(Seccion, CLAVE_ANCHOS_PROPIOS, False) then
          AnchoAutomatico;
        Guardar;
      end;
    mrRetry:
      Restablecer;
  end;
end;

procedure TColumnasRejilla.Restablecer;
var
  lGuarda: TGuardaColumnas;
begin
  lGuarda := NuevoGuarda;
  try
    lGuarda.ReadSaveProps(psaDelete, Archivo, Seccion, FGrid);
  finally
    lGuarda.Free;
  end;
  Archivo.EraseSection(Seccion);
  Archivo.SaveFileSilent('');
  if Length(FOriginal) > 0 then
    Poner(FOriginal);
  TDBGridExtend.De(FGrid).AjustarColumnas;
end;

procedure TColumnasRejilla.Presionar(Sender: TObject; AButton: TMouseButton;
  AShift: TShiftState; AX, AY: Integer);
begin
  if Assigned(FDownAnterior) then
    FDownAnterior(Sender, AButton, AShift, AX, AY);
  FAnchosAlPresionar := AnchosActuales;
end;

procedure TColumnasRejilla.Soltar(Sender: TObject; AButton: TMouseButton;
  AShift: TShiftState; AX, AY: Integer);
var
  lPunto: TPoint;
begin
  if Assigned(FUpAnterior) then
    FUpAnterior(Sender, AButton, AShift, AX, AY);

  if (AButton = mbRight) and (FGrid.MouseCoord(AX, AY).Y = 0) then
  begin
    lPunto := FGrid.ClientToScreen(Point(AX, AY));
    FMenu.Popup(lPunto.X, lPunto.Y);
  end
  else if (AButton = mbLeft) and (FAnchosAlPresionar <> '') and
    (AnchosActuales <> FAnchosAlPresionar) then
  begin
    FGrid.ColumnWidth := cwNone;
    TDBGridExtend.De(FGrid).AjusteAutomatico := False;
    GuardarConAnchos(True);
  end;
end;

procedure TColumnasRejilla.ElegirColumnas(Sender: TObject);
begin
  Configurar;
end;

procedure TColumnasRejilla.ElegirRestablecer(Sender: TObject);
begin
  Restablecer;
end;

initialization

finalization
  FreeAndNil(GArchivo);

end.
