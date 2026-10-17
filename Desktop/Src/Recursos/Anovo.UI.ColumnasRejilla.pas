unit Anovo.UI.ColumnasRejilla;

// Columnas y vista de una rejilla a gusto de cada usuario, guardadas con
// PropSave en AppData, y el menu del titulo con funciones de RosiComp.

interface

uses
  System.Classes, System.Types, Vcl.Controls, Vcl.Menus, Vcl.DBGrids, Vcl.Graphics,
  Winapi.Windows, rDBGrid,
  rDBGridSorter_FireDac, Anovo.Forms.ExportarRejilla;

type
  TColumnaElegida = record
    Campo: string;
    Titulo: string;
    Visible: Boolean;
    Alineacion: TAlignment;
  end;

  TColumnasElegidas = TArray<TColumnaElegida>;

  TVistaRejilla = record
    FilasAlternas: Boolean;
    DegradadoFila: Boolean;
    OrdenarTitulo: Boolean;
    EmbudoFiltro: Boolean;
    FilaTotales: Boolean;
    AltoFila: Integer;
  end;

  TColumnasRejilla = class(TComponent)
  private
    FGrid: TrDBGrid;
    FClave: string;
    FMenu: TPopupMenu;
    FOrdenador: TrDBGridSorter_FireDac;
    FUpAnterior: TMouseEvent;
    FDownAnterior: TMouseEvent;
    FOriginal: TColumnasElegidas;
    FVistaOriginal: TVistaRejilla;
    FAnchosAlPresionar: string;
    FCampoMenu: string;
    FTotalesPropios: Boolean;
    FOpcionPagina: TMenuItem;
    FOpcionQuitarOrden: TMenuItem;
    FOpcionFiltrar: TMenuItem;
    FOpcionQuitarFiltro: TMenuItem;
    function Seccion: string;
    function Columna(const ACampo: string): TColumn;
    function CampoAcciones: string;
    procedure AjustarAcciones;
    function AnchosActuales: string;
    function Leer: TColumnasElegidas;
    procedure Poner(const AColumnas: TColumnasElegidas);
    function VistaActual: TVistaRejilla;
    function LeerVista: TVistaRejilla;
    procedure PonerVista(const AVista: TVistaRejilla);
    procedure GuardarVista(const AVista: TVistaRejilla);
    procedure PonerTotales(const AActivos, AElegidos: Boolean);
    function HayDatos: Boolean;
    procedure AnchoAutomatico;
    procedure GuardarConAnchos(const AAnchosPropios: Boolean);
    function Opcion(const ACaption: string; AEvento: TNotifyEvent;
      const AGlifo: Char = #0): TMenuItem;
    procedure MedirOpcion(Sender: TObject; ACanvas: TCanvas;
      var AWidth, AHeight: Integer);
    procedure DibujarOpcion(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
      AState: TOwnerDrawState);
    procedure Separador;
    procedure Presionar(Sender: TObject; AButton: TMouseButton;
      AShift: TShiftState; AX, AY: Integer);
    procedure Soltar(Sender: TObject; AButton: TMouseButton;
      AShift: TShiftState; AX, AY: Integer);
    procedure AbrirMenu(Sender: TObject);
    procedure ElegirColumnas(Sender: TObject);
    procedure ElegirRestablecer(Sender: TObject);
    procedure ElegirOrdenAsc(Sender: TObject);
    procedure ElegirOrdenDesc(Sender: TObject);
    procedure ElegirQuitarOrden(Sender: TObject);
    procedure ElegirBuscar(Sender: TObject);
    procedure ElegirFiltrar(Sender: TObject);
    procedure ElegirQuitarFiltro(Sender: TObject);
    procedure ElegirAnchoAutomatico(Sender: TObject);
    procedure ElegirAnchoDatos(Sender: TObject);
    procedure ElegirExportar(Sender: TObject);
    procedure ElegirVista(Sender: TObject);
    function HayExcel: Boolean;
    function PedirArchivo(const AFormato: TFormatoExportacion;
      out ARuta: string): Boolean;
    procedure Exportar(const AOpciones: TOpcionesExportacion;
      const ARuta: string);
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
    procedure Configurar(const APestana: Integer = 0);
    procedure Restablecer;
  end;

implementation

uses
  System.SysUtils, System.IOUtils, System.UITypes, Data.DB, Vcl.Grids, Vcl.Forms,
  PropSaveMain, PropSaveGrids, RosiCompGlobalCfg,
  Vcl.Dialogs, Winapi.ShellAPI, rDBFilter, rXLSExport, TXTExport,
  Anovo.UI.Vista,
  Anovo.UI.Tema,
  Anovo.Forms.BuscarRejilla,
  Anovo.Sesion,
  Anovo.Textos,
  Anovo.UI.CeldasRejilla,
  Anovo.Forms.Columnas;

const
  CARPETA = 'Anovo';
  NOMBRE_ARCHIVO = 'pantallas.ini';
  CLAVE_ALINEACION = 'Alineacion';
  CLAVE_ANCHOS_PROPIOS = 'AnchosPropios';
  CLAVE_VISTA = 'VistaGuardada';
  CLAVE_FILAS_ALTERNAS = 'FilasAlternas';
  CLAVE_DEGRADADO = 'DegradadoFila';
  CLAVE_ORDENAR = 'OrdenarTitulo';
  CLAVE_EMBUDO = 'EmbudoFiltro';
  CLAVE_TOTALES = 'FilaTotales';
  CLAVE_ALTO = 'AltoFila';
  TOTAL_SUMA = '%SUM';
  PREFIJO_FRAME = 'Tfra';
  PREFIJO_FORMA = 'Tfrm';
  REJILLA_LISTADO = 'grDatos';
  PESTANA_VISTA = 1;
  TAG_ROTULO = -1;
  ALTO_OPCION = 28;
  ALTO_ROTULO = 22;
  ALTO_SEPARADOR = 9;
  MARGEN_TEXTO = 36;
  MARGEN_DERECHO = 24;
  MARGEN_LINEA = 8;
  FUENTE_GLIFOS = 'Segoe MDL2 Assets';
  GLIFO_COLUMNAS = #$E8FD;
  GLIFO_RESTABLECER = #$E777;
  GLIFO_ORDENAR = #$E8CB;
  GLIFO_QUITAR = #$E711;
  GLIFO_BUSCAR = #$E721;
  GLIFO_FILTRAR = #$E71C;
  GLIFO_QUITAR_FILTRO = #$E894;
  GLIFO_ANCHO = #$E9A6;
  GLIFO_ANCHO_DATOS = #$E8B3;
  GLIFO_EXPORTAR = #$E896;
  GLIFO_VISTA = #$E9E9;
  EXTENSION_EXCEL = 'xlsx';
  EXTENSION_CSV = 'csv';
  SEPARADOR_CSV = ';';
  SUFIJO_FECHA = '_yyyy-mm-dd';

type
  TGuardaColumnas = class(TDBGridsPropSave);
  TRejillaAbierta = class(TrDBGrid);

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

function EsNumero(ACampo: TField): Boolean;
begin
  Result := (ACampo is TFloatField) or (ACampo is TBCDField) or
    (ACampo is TFMTBCDField);
end;

constructor TColumnasRejilla.Crear(AGrid: TrDBGrid; const AClave: string);
begin
  inherited Create(AGrid);
  FGrid := AGrid;
  FClave := AClave;
  FVistaOriginal := VistaActual;

  FOrdenador := TrDBGridSorter_FireDac.Create(Self);
  if FGrid.Sorter = nil then
    FGrid.Sorter := FOrdenador;

  FMenu := TPopupMenu.Create(Self);
  FMenu.OwnerDraw := True;
  FMenu.OnPopup := AbrirMenu;
  Opcion(SMenuColumnas, ElegirColumnas, GLIFO_COLUMNAS);
  Opcion(SMenuRestablecerColumnas, ElegirRestablecer, GLIFO_RESTABLECER);
  Separador;
  FOpcionPagina := Opcion('', nil);
  FOpcionPagina.Enabled := False;
  FOpcionPagina.Tag := TAG_ROTULO;
  Opcion(SMenuOrdenarAsc, ElegirOrdenAsc, GLIFO_ORDENAR);
  Opcion(SMenuOrdenarDesc, ElegirOrdenDesc, GLIFO_ORDENAR);
  FOpcionQuitarOrden := Opcion(SMenuQuitarOrden, ElegirQuitarOrden, GLIFO_QUITAR);
  Opcion(SMenuBuscar, ElegirBuscar, GLIFO_BUSCAR);
  FOpcionFiltrar := Opcion(SMenuFiltrarValor, ElegirFiltrar, GLIFO_FILTRAR);
  FOpcionQuitarFiltro := Opcion(SMenuQuitarFiltro, ElegirQuitarFiltro,
    GLIFO_QUITAR_FILTRO);
  Separador;
  Opcion(SMenuAnchoAutomatico, ElegirAnchoAutomatico, GLIFO_ANCHO);
  Opcion(SMenuAnchoDatos, ElegirAnchoDatos, GLIFO_ANCHO_DATOS);
  Opcion(SMenuExportar, ElegirExportar, GLIFO_EXPORTAR);
  Separador;
  Opcion(SMenuVistaRejilla, ElegirVista, GLIFO_VISTA);

  FUpAnterior := FGrid.OnMouseUp;
  FDownAnterior := FGrid.OnMouseDown;
  FGrid.OnMouseUp := Soltar;
  FGrid.OnMouseDown := Presionar;
end;

function TColumnasRejilla.Opcion(const ACaption: string;
  AEvento: TNotifyEvent; const AGlifo: Char): TMenuItem;
begin
  Result := TMenuItem.Create(FMenu);
  Result.Caption := ACaption;
  Result.OnClick := AEvento;
  Result.Tag := Ord(AGlifo);
  Result.OnMeasureItem := MedirOpcion;
  Result.OnAdvancedDrawItem := DibujarOpcion;
  FMenu.Items.Add(Result);
end;

procedure TColumnasRejilla.MedirOpcion(Sender: TObject; ACanvas: TCanvas;
  var AWidth, AHeight: Integer);
var
  lOpcion: TMenuItem;
begin
  lOpcion := TMenuItem(Sender);
  if lOpcion.IsLine then
  begin
    AHeight := ALTO_SEPARADOR;
    Exit;
  end;
  ACanvas.Font.Name := FUENTE;
  ACanvas.Font.Height := -12;
  AWidth := ACanvas.TextWidth(StripHotkey(lOpcion.Caption)) + MARGEN_TEXTO + MARGEN_DERECHO;
  if lOpcion.Tag = TAG_ROTULO then
    AHeight := ALTO_ROTULO
  else
    AHeight := ALTO_OPCION;
end;

procedure TColumnasRejilla.DibujarOpcion(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
var
  lOpcion: TMenuItem;
  lRotulo: Boolean;
  R: TRect;
  lTinta: TColor;
  lTexto: string;
begin
  lOpcion := TMenuItem(Sender);
  lRotulo := lOpcion.Tag = TAG_ROTULO;
  ACanvas.Brush.Style := bsSolid;
  ACanvas.Brush.Color := clAnovoTarjeta;
  if (odSelected in AState) and lOpcion.Enabled and not lRotulo then
    ACanvas.Brush.Color := clAnovoAcentoSuave;
  ACanvas.FillRect(ARect);

  if lOpcion.IsLine then
  begin
    ACanvas.Pen.Color := clAnovoBorde;
    ACanvas.MoveTo(ARect.Left + MARGEN_LINEA, (ARect.Top + ARect.Bottom) div 2);
    ACanvas.LineTo(ARect.Right - MARGEN_LINEA, (ARect.Top + ARect.Bottom) div 2);
    Exit;
  end;

  if lRotulo then
    lTinta := clAnovoTextoSuave
  else if lOpcion.Enabled then
    lTinta := clAnovoTexto
  else
    lTinta := clAnovoDeshabilitado;
  ACanvas.Brush.Style := bsClear;

  if (lOpcion.Tag > 0) and not lRotulo then
  begin
    R := ARect;
    R.Left := ARect.Left + MARGEN_LINEA;
    R.Right := ARect.Left + MARGEN_TEXTO - MARGEN_LINEA;
    ACanvas.Font.Name := FUENTE_GLIFOS;
    ACanvas.Font.Height := -13;
    ACanvas.Font.Color := lTinta;
    lTexto := Char(lOpcion.Tag);
    ACanvas.TextRect(R, lTexto, [tfCenter, tfVerticalCenter, tfSingleLine]);
  end;

  R := ARect;
  R.Left := ARect.Left + MARGEN_TEXTO;
  if lRotulo then
    R.Left := ARect.Left + MARGEN_LINEA + 4;
  ACanvas.Font.Name := FUENTE;
  if lRotulo then
    ACanvas.Font.Height := -11
  else
    ACanvas.Font.Height := -12;
  ACanvas.Font.Color := lTinta;
  lTexto := StripHotkey(lOpcion.Caption);
  ACanvas.TextRect(R, lTexto, [tfLeft, tfVerticalCenter, tfSingleLine]);
  ACanvas.Brush.Style := bsSolid;
end;

procedure TColumnasRejilla.Separador;
begin
  Opcion('-', nil);
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
  if AGrid.Sorter = lColumnas.FOrdenador then
    AGrid.Sorter := nil;
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
  Result := '';
  if TCeldasRejilla.Buscar(FGrid) <> nil then
    Result := TCeldasRejilla.Buscar(FGrid).CampoAcciones;
end;

procedure TColumnasRejilla.AjustarAcciones;
begin
  if TCeldasRejilla.Buscar(FGrid) <> nil then
    TCeldasRejilla.Buscar(FGrid).AjustarAcciones;
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
  AjustarAcciones;
  TemarTitulos(FGrid);
end;

function TColumnasRejilla.VistaActual: TVistaRejilla;
begin
  Result.FilasAlternas := FGrid.OptionsEx2.Appearance.DrawColoredRow;
  Result.DegradadoFila := FGrid.OptionsEx2.Appearance.ActiveRowGradient;
  Result.OrdenarTitulo := FGrid.OptionsEx2.FixedCell.TitleBtn;
  Result.EmbudoFiltro := FGrid.OptionsEx2.Filters.FunnelBtn;
  Result.FilaTotales := FGrid.FooterRow.FooterVisible;
  Result.AltoFila := FGrid.RowFixHeight;
end;

function TColumnasRejilla.LeerVista: TVistaRejilla;
begin
  Result := FVistaOriginal;
  if not Archivo.ReadBool(Seccion, CLAVE_VISTA, False) then
    Exit;
  Result.FilasAlternas := Archivo.ReadBool(Seccion, CLAVE_FILAS_ALTERNAS,
    Result.FilasAlternas);
  Result.DegradadoFila := Archivo.ReadBool(Seccion, CLAVE_DEGRADADO,
    Result.DegradadoFila);
  Result.OrdenarTitulo := Archivo.ReadBool(Seccion, CLAVE_ORDENAR,
    Result.OrdenarTitulo);
  Result.EmbudoFiltro := Archivo.ReadBool(Seccion, CLAVE_EMBUDO,
    Result.EmbudoFiltro);
  Result.FilaTotales := Archivo.ReadBool(Seccion, CLAVE_TOTALES,
    Result.FilaTotales);
  Result.AltoFila := Archivo.ReadInteger(Seccion, CLAVE_ALTO, Result.AltoFila);
end;

procedure TColumnasRejilla.GuardarVista(const AVista: TVistaRejilla);
begin
  Archivo.WriteBool(Seccion, CLAVE_VISTA, True);
  Archivo.WriteBool(Seccion, CLAVE_FILAS_ALTERNAS, AVista.FilasAlternas);
  Archivo.WriteBool(Seccion, CLAVE_DEGRADADO, AVista.DegradadoFila);
  Archivo.WriteBool(Seccion, CLAVE_ORDENAR, AVista.OrdenarTitulo);
  Archivo.WriteBool(Seccion, CLAVE_EMBUDO, AVista.EmbudoFiltro);
  Archivo.WriteBool(Seccion, CLAVE_TOTALES, AVista.FilaTotales);
  Archivo.WriteInteger(Seccion, CLAVE_ALTO, AVista.AltoFila);
  Archivo.SaveFileSilent('');
end;

procedure TColumnasRejilla.PonerVista(const AVista: TVistaRejilla);
begin
  FGrid.OptionsEx2.Appearance.DrawColoredRow := AVista.FilasAlternas;
  FGrid.OptionsEx2.Appearance.ActiveRowGradient := AVista.DegradadoFila;
  FGrid.OptionsEx2.FixedCell.TitleBtn := AVista.OrdenarTitulo;
  FGrid.OptionsEx2.Filters.FunnelBtn := AVista.EmbudoFiltro;
  if AVista.AltoFila > 0 then
    FGrid.RowFixHeight := AVista.AltoFila;
  PonerTotales(AVista.FilaTotales, Archivo.ReadBool(Seccion, CLAVE_VISTA, False));
  FGrid.Invalidate;
end;

procedure TColumnasRejilla.PonerTotales(const AActivos, AElegidos: Boolean);
var
  I: Integer;
  lRotulo: Boolean;
  lColumna: TColumn;
begin
  if not AActivos then
  begin
    if AElegidos or FTotalesPropios then
      FGrid.FooterRow.FooterVisible := False;
    Exit;
  end;
  if FTotalesPropios or (FGrid.FooterRow.FieldFooterDefs.Count = 0) then
  begin
    FTotalesPropios := True;
    FGrid.FooterRow.FieldFooterDefs.Clear;
    lRotulo := False;
    for I := 0 to FGrid.Columns.Count - 1 do
    begin
      lColumna := FGrid.Columns[I];
      if not lColumna.Visible or (lColumna.Field = nil) then
        Continue;
      if EsNumero(lColumna.Field) then
        FGrid.FooterRow.FieldFooterDefs.Add(lColumna.FieldName + '=' + TOTAL_SUMA)
      else if not lRotulo then
      begin
        FGrid.FooterRow.FieldFooterDefs.Add(lColumna.FieldName + '=' + STotalPie);
        lRotulo := True;
      end;
    end;
  end;
  FGrid.FooterRow.RecalculateAfterOpen := True;
  FGrid.FooterRow.RecalculateAfterFilter := True;
  FGrid.FooterRow.FooterVisible := True;
  if HayDatos then
    FGrid.RecalculateSummaryResults;
end;

function TColumnasRejilla.HayDatos: Boolean;
begin
  Result := (FGrid.DataSource <> nil) and (FGrid.DataSource.DataSet <> nil) and
    FGrid.DataSource.DataSet.Active;
end;

procedure TColumnasRejilla.AnchoAutomatico;
begin
  AnchosAutomaticos(FGrid);
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
  PonerVista(LeerVista);
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
  AjustarAcciones;
  if not Archivo.ReadBool(Seccion, CLAVE_ANCHOS_PROPIOS, False) then
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

procedure TColumnasRejilla.Configurar(const APestana: Integer);
var
  lColumnas: TColumnasElegidas;
  lVista: TVistaRejilla;
begin
  lColumnas := Leer;
  lVista := VistaActual;
  case TfrmColumnas.Elegir(GetParentForm(FGrid), lColumnas, lVista, APestana) of
    mrOk:
      begin
        Poner(lColumnas);
        PonerVista(lVista);
        GuardarVista(lVista);
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
  PonerVista(FVistaOriginal);
  AjustarAcciones;
  AjustarColumnas(FGrid);
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
  lCoord: TGridCoord;
  lIndice: Integer;
begin
  if Assigned(FUpAnterior) then
    FUpAnterior(Sender, AButton, AShift, AX, AY);

  lCoord := FGrid.MouseCoord(AX, AY);
  if (AButton = mbRight) and (lCoord.Y = 0) then
  begin
    FCampoMenu := '';
    lIndice := lCoord.X - TRejillaAbierta(FGrid).FixedCols;
    if (lIndice >= 0) and (lIndice < FGrid.Columns.Count) then
    begin
      FCampoMenu := FGrid.Columns[lIndice].FieldName;
      if HayDatos and not FGrid.DataSource.DataSet.IsEmpty then
        FGrid.SelectedIndex := lIndice;
    end;
    lPunto := FGrid.ClientToScreen(Point(AX, AY));
    FMenu.Popup(lPunto.X, lPunto.Y);
  end
  else if (AButton = mbLeft) and (FAnchosAlPresionar <> '') and
    (AnchosActuales <> FAnchosAlPresionar) then
  begin
    FGrid.ColumnWidth := cwNone;
    GuardarConAnchos(True);
  end;
end;

procedure TColumnasRejilla.AbrirMenu(Sender: TObject);
var
  lCampo: TField;
  lFilas: Integer;
begin
  lFilas := 0;
  if HayDatos then
    lFilas := FGrid.DataSource.DataSet.RecordCount;
  FOpcionPagina.Caption := Format(SMenuEnPagina, [lFilas]);
  FOpcionQuitarOrden.Enabled := FGrid.SortFieldName <> '';
  FOpcionQuitarFiltro.Enabled := HayDatos and FGrid.DataSource.DataSet.Filtered;
  lCampo := nil;
  if HayDatos and (FCampoMenu <> '') then
    lCampo := FGrid.DataSource.DataSet.FindField(FCampoMenu);
  FOpcionFiltrar.Enabled := (lCampo <> nil) and (lCampo.FieldKind = fkData) and
    (lFilas > 0) and not SameText(FCampoMenu, CampoAcciones);
end;

procedure TColumnasRejilla.ElegirColumnas(Sender: TObject);
begin
  Configurar;
end;

procedure TColumnasRejilla.ElegirRestablecer(Sender: TObject);
begin
  Restablecer;
end;

procedure TColumnasRejilla.ElegirOrdenAsc(Sender: TObject);
begin
  if FCampoMenu <> '' then
    FGrid.ChangeSort(FCampoMenu, False);
end;

procedure TColumnasRejilla.ElegirOrdenDesc(Sender: TObject);
begin
  if FCampoMenu <> '' then
    FGrid.ChangeSort(FCampoMenu, True);
end;

procedure TColumnasRejilla.ElegirQuitarOrden(Sender: TObject);
begin
  FGrid.SortFieldName := '';
  FGrid.ChangeSort('', False);
end;

procedure TColumnasRejilla.ElegirBuscar(Sender: TObject);
var
  I: Integer;
  lCampos, lTitulos: TArray<string>;
begin
  if not HayDatos then
    Exit;
  for I := 0 to FGrid.Columns.Count - 1 do
    if FGrid.Columns[I].Visible and (FGrid.Columns[I].Field <> nil) and
      not SameText(FGrid.Columns[I].FieldName, CampoAcciones) then
    begin
      lCampos := lCampos + [FGrid.Columns[I].FieldName];
      lTitulos := lTitulos + [FGrid.Columns[I].Title.Caption];
    end;
  TfrmBuscarRejilla.Buscar(GetParentForm(FGrid), FGrid.DataSource.DataSet,
    lCampos, lTitulos, FCampoMenu);
end;

procedure TColumnasRejilla.ElegirFiltrar(Sender: TObject);
begin
  if HayDatos and FilterBySel(FGrid) then
    FGrid.FilterChangedNotification;
end;

procedure TColumnasRejilla.ElegirQuitarFiltro(Sender: TObject);
begin
  if HayDatos and SetFilterString(FGrid.DataSource.DataSet, '', True) then
    FGrid.FilterChangedNotification;
end;

procedure TColumnasRejilla.ElegirAnchoAutomatico(Sender: TObject);
begin
  AnchoAutomatico;
  GuardarConAnchos(False);
end;

procedure TColumnasRejilla.ElegirAnchoDatos(Sender: TObject);
begin
  FGrid.ColumnWidth := cwDataLabelWidth;
  FGrid.ColumnWidth := cwNone;
  AjustarAcciones;
  GuardarConAnchos(True);
end;

function TColumnasRejilla.HayExcel: Boolean;
var
  lExcel: TrXLSExport;
begin
  lExcel := TrXLSExport.Create(nil);
  try
    Result := lExcel.IsAppExist;
  finally
    lExcel.Free;
  end;
end;

function TColumnasRejilla.PedirArchivo(const AFormato: TFormatoExportacion;
  out ARuta: string): Boolean;
var
  lDialogo: TSaveDialog;
begin
  lDialogo := TSaveDialog.Create(nil);
  try
    lDialogo.Options := lDialogo.Options + [ofOverwritePrompt, ofPathMustExist];
    if AFormato = feExcel then
    begin
      lDialogo.Filter := SFiltroExcel;
      lDialogo.DefaultExt := EXTENSION_EXCEL;
    end
    else
    begin
      lDialogo.Filter := SFiltroCsv;
      lDialogo.DefaultExt := EXTENSION_CSV;
    end;
    lDialogo.FileName := StringReplace(Trim(GetParentForm(FGrid).Caption), ' ', '_',
      [rfReplaceAll]) + FormatDateTime(SUFIJO_FECHA, Now);
    Result := lDialogo.Execute;
    ARuta := lDialogo.FileName;
  finally
    lDialogo.Free;
  end;
end;

procedure TColumnasRejilla.Exportar(const AOpciones: TOpcionesExportacion;
  const ARuta: string);
var
  lExcel: TrXLSExport;
  lTexto: TTXTExport;
begin
  if AOpciones.Formato = feExcel then
  begin
    lExcel := TrXLSExport.Create(nil);
    try
      lExcel.ExportFile := ARuta;
      if AOpciones.Abrir then
        lExcel.ActionAfter := aaShow
      else
        lExcel.ActionAfter := aaNone;
      lExcel.ExportDBTable(FGrid, True);
    finally
      lExcel.Free;
    end;
  end
  else
  begin
    lTexto := TTXTExport.Create(nil);
    try
      lTexto.ExportFile := ARuta;
      lTexto.FieldSeparator := SEPARADOR_CSV;
      lTexto.TextApostrophe := '"';
      if AOpciones.Abrir then
        lTexto.ActionAfter := aaShow
      else
        lTexto.ActionAfter := aaNone;
      lTexto.Execute(FGrid);
    finally
      lTexto.Free;
    end;
  end;
  if not AOpciones.Abrir and FileExists(ARuta) then
    Informar(Format(SExportado, [ARuta]));
end;

procedure TColumnasRejilla.ElegirExportar(Sender: TObject);
var
  lOpciones: TOpcionesExportacion;
  lRuta: string;
begin
  if not HayDatos then
    Exit;
  if not TfrmExportarRejilla.Elegir(GetParentForm(FGrid),
    FGrid.DataSource.DataSet.RecordCount, HayExcel, lOpciones) then
    Exit;
  if PedirArchivo(lOpciones.Formato, lRuta) then
    Exportar(lOpciones, lRuta);
end;

procedure TColumnasRejilla.ElegirVista(Sender: TObject);
begin
  Configurar(PESTANA_VISTA);
end;

initialization

finalization
  FreeAndNil(GArchivo);

end.
