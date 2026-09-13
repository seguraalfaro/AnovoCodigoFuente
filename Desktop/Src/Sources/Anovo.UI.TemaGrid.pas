unit Anovo.UI.TemaGrid;


interface

uses
  Vcl.Controls, Vcl.Forms, Vcl.Graphics, Vcl.Grids, Vcl.DBGrids, rDBGrid;

{ Deja la rejilla con el aspecto de los mockups: encabezado azul liso, sin
  lineas verticales, filas alternas y fila activa en azul tenue. }
procedure AplicarTemaGrid(AGrid: TrDBGrid; ASoloLectura: Boolean = True);

{ Alinea a la derecha los campos indicados, titulo incluido. Para montos. }
procedure AlinearDerecha(AGrid: TrDBGrid; const ACampos: array of string);
procedure OcultarScrollVertical(AGrid: TrDBGrid);

implementation

uses
  Winapi.Windows, System.SysUtils, System.Classes, RosiCompGlobalCfg,
  Anovo.UI.Tema;

procedure AplicarTemaGrid(AGrid: TrDBGrid; ASoloLectura: Boolean = True);
begin
  if AGrid = nil then
    Exit;

  { Con gdsThemed o gdsGradient el encabezado lo pinta el tema de Windows y
    FixedColor se ignora. Sin esta linea el resto no se ve. }
  AGrid.DrawingStyle := gdsClassic;
  { Los demas estilos meten degradados propios que pelean con el azul liso. }
  AGrid.GridLookStyle := grs_Default;

  { Encabezado }
  AGrid.FixedColor := clAnovoMarca;
  AGrid.TitleFont.Name := FUENTE_SEMI;
  AGrid.TitleFont.Height := -11;
  AGrid.TitleFont.Color := clWhite;
  AGrid.TitleLines := 2;

  { Los botoncitos que Rosi dibuja dentro del encabezado vienen encendidos de
    fabrica y rompen la franja lisa. }
  AGrid.OptionsEx2.FixedCell.TitleExBtn := False;
  AGrid.OptionsEx2.FixedCell.TitleBtn := False;
  AGrid.OptionsEx2.FixedCell.FixedColBtn := False;
  AGrid.OptionsEx2.FixedCell.TitlePopup := False;



  { Datos }
  AGrid.Color := clAnovoTarjeta;
  AGrid.Font.Name := FUENTE;
  AGrid.Font.Height := -12;
  AGrid.Font.Color :=clAnovoTexto;
  AGrid.RowFixHeight := ALTO_FILA;

  { Ojo: el rayado solo funciona con dataset bidireccional; con un query
    unidireccional las filas salen todas iguales y no es culpa de esto. }
  AGrid.ColorOddRow := clAnovoFilaAlterna;
  AGrid.ColorActiveRow := clAnovoSeleccion;
  AGrid.ColorHotTrackRow := clAnovoFilaAlterna;

  { Lineas: solo la raya horizontal entre filas. Las verticales se quitan por
    Options; el color se deja igual por si alguien las vuelve a encender. }
  AGrid.OptionsEx2.Appearance.DataRowLineColor := clAnovoBorde;
  AGrid.OptionsEx2.Appearance.DataColLineColor := clNone;
  AGrid.OptionsEx2.Appearance.TitleRowLineColor := clNone;
  AGrid.OptionsEx2.Appearance.TitleColLineColor := clNone;

  { La fila entera se resalta; la celda activa dentro de ella, no. }
  AGrid.OptionsEx2.Appearance.SkipCellHighlight := True;
  AGrid.OptionsEx2.Appearance.DrawRowFocus := False;

  { Barra horizontal fuera. La vertical no se puede quitar por propiedad:
    UpdateScrollBar la fuerza con ShowScrollBar en cada refresco. }
 // AGrid.OptionsEx2.Appearance.HideHScrollBar := True;

  AGrid.Options := AGrid.Options - [dgColLines, dgIndicator] +
    [dgRowLines, dgTitles, dgRowSelect, dgAlwaysShowSelection];
  if ASoloLectura then
  begin
    AGrid.Options := AGrid.Options - [dgEditing];
    AGrid.ReadOnly := True;
  end;

  { El borde redondeado de la tarjeta no sale de la rejilla: se consigue
    metiendola dentro de un TPanel con TAG_CARD. }
  AGrid.BorderStyle := bsNone;
  AGrid.Ctl3D := False;
  //OcultarScrollVertical(AGrid) ;
end;

procedure OcultarScrollVertical(AGrid: TrDBGrid);
var
  lBarra: Integer;
begin
  if (AGrid = nil) or (AGrid.Parent = nil) then
    Exit;

  { Ancho de la barra segun el sistema; a 150 % de DPI no son 17 pixeles. }
  lBarra := GetSystemMetrics(SM_CXVSCROLL);

  AGrid.Align := alNone;
  { Anclada a los cuatro lados conserva el desborde al cambiar de tamaño: el
    borde derecho se queda siempre a -lBarra del padre. }
  AGrid.Anchors := [akLeft, akTop, akRight, akBottom];
  AGrid.SetBounds(0, 0, AGrid.Parent.ClientWidth + lBarra,
    AGrid.Parent.ClientHeight);
end;

procedure AlinearDerecha(AGrid: TrDBGrid; const ACampos: array of string);
var
  i, j: Integer;
begin
  if AGrid = nil then
    Exit;
  for i := 0 to AGrid.Columns.Count - 1 do
    for j := Low(ACampos) to High(ACampos) do
      if SameText(AGrid.Columns[i].FieldName, ACampos[j]) then
      begin
        AGrid.Columns[i].Alignment := taRightJustify;
        { El titulo se alinea por separado, o el monto queda a la derecha y su
          encabezado a la izquierda. }
        AGrid.Columns[i].Title.Alignment := taRightJustify;
      end;
end;

end.
