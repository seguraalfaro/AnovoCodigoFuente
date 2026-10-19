unit Anovo.UI.Vista;

// Apoyos comunes de las vistas: cursor de espera por contador, avisos fuera
// del callback en curso, busqueda, paginacion y la pantalla encima.

interface

uses
  System.Classes, System.SysUtils, Vcl.Controls, Vcl.StdCtrls, Vcl.WinXCtrls,
  Vcl.Forms,
  Anovo.Retardo;

type
  TBusquedaAlEscribir = class(TComponent)
  private
    FCaja: TSearchBox;
    FRetardo: TRetardo;
    FBuscar: TProc<string>;
    FUltimo: string;
    procedure Cambio(Sender: TObject);
    procedure Invocar(Sender: TObject);
    procedure Lanzar;
  public
    constructor Crear(const ACaja: TSearchBox; const ABuscar: TProc<string>);
    procedure Mostrar(const ATexto: string);
  end;

  TPantallaEncima = class(TComponent)
  private
    FPadre: TWinControl;
    FFrame: TFrame;
  public
    constructor Crear(const APadre: TWinControl);
    procedure Mostrar(const AFrame: TFrame);
    procedure Cerrar(const ADespues: TProc = nil);
  end;

procedure CursorOcupado(const AActivo: Boolean);

procedure AvisarError(const AMensaje: string);

procedure Informar(const AMensaje: string);

function Confirmar(const AMensaje: string): Boolean;

function Preguntar(const AMensaje, ATitulo, ASi, ANo: string): Boolean;

function AvisarReparos(const AReparos: TStrings;
  const AEncabezado: string): Boolean;

procedure BloquearEdicion(const AControles: array of TControl;
  const AActivo: Boolean);

procedure PintarBusqueda(ABuscar: TSearchBox; ALimpiar: TControl;
  const ATexto: string; const APuedeLimpiar: Boolean);

procedure PintarPaginacion(AEtiqueta: TLabel; AAnterior, ASiguiente: TControl;
  const APagina, ATotalPaginas: Integer; const ATotal: Int64;
  const ASinRegistros, APaginacion: string; const ASoloTotal: string = '');

implementation

uses
  System.UITypes, System.Math, Vcl.Dialogs,
  Anovo.Textos,
  Anovo.UI.Tema,
  Anovo.UI.Cargando;

const
  RETARDO_BUSQUEDA = 400;

constructor TBusquedaAlEscribir.Crear(const ACaja: TSearchBox;
  const ABuscar: TProc<string>);
begin
  inherited Create(ACaja);
  FCaja := ACaja;
  FBuscar := ABuscar;
  FUltimo := Trim(ACaja.Text);
  FRetardo := TRetardo.Crear(Self, RETARDO_BUSQUEDA, Lanzar);
  FCaja.OnChange := Cambio;
  FCaja.OnInvokeSearch := Invocar;
end;

constructor TPantallaEncima.Crear(const APadre: TWinControl);
begin
  inherited Create(APadre);
  FPadre := APadre;
end;

procedure TPantallaEncima.Mostrar(const AFrame: TFrame);
begin
  FreeAndNil(FFrame);
  FFrame := AFrame;
  FFrame.Parent := FPadre;
  FFrame.SetBounds(0, 0, FPadre.ClientWidth, FPadre.ClientHeight);
  FFrame.Anchors := [akLeft, akTop, akRight, akBottom];
  FFrame.BringToFront;
  AplicarTemaFrame(FFrame);
end;

procedure TPantallaEncima.Cerrar(const ADespues: TProc);
begin
  if FFrame = nil then
    Exit;
  FFrame.Visible := False;
  TThread.ForceQueue(nil,
    procedure
    begin
      FreeAndNil(FFrame);
      if Assigned(ADespues) then
        ADespues;
    end);
end;

procedure TBusquedaAlEscribir.Mostrar(const ATexto: string);
begin
  FUltimo := Trim(ATexto);
end;

procedure TBusquedaAlEscribir.Cambio(Sender: TObject);
begin
  if Trim(FCaja.Text) = FUltimo then
    FRetardo.Cancelar
  else
    FRetardo.Programar;
end;

procedure TBusquedaAlEscribir.Invocar(Sender: TObject);
begin
  Lanzar;
end;

procedure TBusquedaAlEscribir.Lanzar;
begin
  FRetardo.Cancelar;
  FUltimo := Trim(FCaja.Text);
  FBuscar(FUltimo);
end;

var
  Ocupados: Integer;

procedure CursorOcupado(const AActivo: Boolean);
begin
  if AActivo then
    Inc(Ocupados)
  else if Ocupados > 0 then
    Dec(Ocupados);

  if Ocupados > 0 then
    Screen.Cursor := crAppStart
  else
    Screen.Cursor := crDefault;
  IndicadorCarga(Ocupados > 0);
end;

procedure AnchoDeBotones(AForma: TForm);
const
  RELLENO = 24;
  MARGEN = 16;
var
  I, lSeparacion, lTotal, lX: Integer;
  lBotones: TArray<TButton>;
begin
  lBotones := nil;
  for I := 0 to AForma.ComponentCount - 1 do
    if AForma.Components[I] is TButton then
      lBotones := lBotones + [TButton(AForma.Components[I])];
  if Length(lBotones) < 2 then
    Exit;
  lSeparacion := lBotones[1].Left - lBotones[0].Left - lBotones[0].Width;
  lTotal := lSeparacion * (Length(lBotones) - 1);
  AForma.Canvas.Font := lBotones[0].Font;
  for I := 0 to High(lBotones) do
  begin
    lBotones[I].Width := Max(lBotones[I].Width,
      AForma.Canvas.TextWidth(lBotones[I].Caption) + RELLENO);
    Inc(lTotal, lBotones[I].Width);
  end;
  if lTotal + 2 * MARGEN > AForma.ClientWidth then
    AForma.ClientWidth := lTotal + 2 * MARGEN;
  lX := (AForma.ClientWidth - lTotal) div 2;
  for I := 0 to High(lBotones) do
  begin
    lBotones[I].Left := lX;
    Inc(lX, lBotones[I].Width + lSeparacion);
  end;
end;

function Dialogo(const AMensaje, ATitulo: string; const ATipo: TMsgDlgType;
  const ABotones: TMsgDlgButtons; const ASi: string = '';
  const ANo: string = ''): Integer;
var
  lForma: TForm;
  I: Integer;
  lBoton: TButton;
begin
  lForma := CreateMessageDialog(AMensaje, ATipo, ABotones);
  try
    lForma.Caption := ATitulo;
    for I := 0 to lForma.ComponentCount - 1 do
      if lForma.Components[I] is TButton then
      begin
        lBoton := TButton(lForma.Components[I]);
        case lBoton.ModalResult of
          mrOk:
            lBoton.Caption := SDialogoAceptar;
          mrYes:
            if ASi.IsEmpty then
              lBoton.Caption := SDialogoSi
            else
              lBoton.Caption := ASi;
          mrNo:
            if ANo.IsEmpty then
              lBoton.Caption := SDialogoNo
            else
              lBoton.Caption := ANo;
        end;
      end;
    if not (ASi.IsEmpty and ANo.IsEmpty) then
      AnchoDeBotones(lForma);
    Result := lForma.ShowModal;
  finally
    lForma.Free;
  end;
end;

procedure AvisarError(const AMensaje: string);
begin
  TThread.ForceQueue(nil,
    procedure
    begin
      Dialogo(AMensaje, SDialogoError, mtError, [mbOK]);
    end);
end;

procedure Informar(const AMensaje: string);
begin
  TThread.ForceQueue(nil,
    procedure
    begin
      Dialogo(AMensaje, SDialogoAviso, mtInformation, [mbOK]);
    end);
end;

function Confirmar(const AMensaje: string): Boolean;
begin
  Result := Dialogo(AMensaje, SDialogoConfirmar, mtConfirmation,
    [mbYes, mbNo]) = mrYes;
end;

function Preguntar(const AMensaje, ATitulo, ASi, ANo: string): Boolean;
begin
  Result := Dialogo(AMensaje, ATitulo, mtInformation, [mbYes, mbNo], ASi,
    ANo) = mrYes;
end;

function AvisarReparos(const AReparos: TStrings;
  const AEncabezado: string): Boolean;
const
  VINETA = '   ' + #$2022 + '  ';
var
  lMensaje: string;
  I: Integer;
begin
  Result := AReparos.Count = 0;
  if Result then
    Exit;
  if AReparos.Count = 1 then
    lMensaje := AReparos[0]
  else
  begin
    lMensaje := AEncabezado + sLineBreak;
    for I := 0 to AReparos.Count - 1 do
      lMensaje := lMensaje + sLineBreak + VINETA + AReparos[I];
  end;
  AvisarError(lMensaje);
end;

procedure BloquearEdicion(const AControles: array of TControl;
  const AActivo: Boolean);
var
  lControl: TControl;
begin
  for lControl in AControles do
    lControl.Enabled := not AActivo;
  CursorOcupado(AActivo);
end;

procedure PintarBusqueda(ABuscar: TSearchBox; ALimpiar: TControl;
  const ATexto: string; const APuedeLimpiar: Boolean);
begin
  if Trim(ABuscar.Text) <> ATexto then
    ABuscar.Text := ATexto;
  ALimpiar.Enabled := APuedeLimpiar;
end;

procedure PintarPaginacion(AEtiqueta: TLabel; AAnterior, ASiguiente: TControl;
  const APagina, ATotalPaginas: Integer; const ATotal: Int64;
  const ASinRegistros, APaginacion: string; const ASoloTotal: string);
begin
  if ATotal = 0 then
    AEtiqueta.Caption := ASinRegistros
  else if (ATotalPaginas = 0) and (ASoloTotal <> '') then
    AEtiqueta.Caption := Format(ASoloTotal, [ATotal])
  else
    AEtiqueta.Caption := Format(APaginacion, [ATotal, APagina, ATotalPaginas]);

  AAnterior.Enabled := APagina > 1;
  ASiguiente.Enabled := APagina < ATotalPaginas;
end;

end.
