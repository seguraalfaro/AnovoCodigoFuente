unit Anovo.UI.Vista;

// Apoyos comunes de las vistas: cursor de espera por contador, avisos
// fuera del callback en curso, busqueda y paginacion.

interface

uses
  System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.WinXCtrls;

procedure CursorOcupado(const AActivo: Boolean);

procedure AvisarError(const AMensaje: string);

procedure Informar(const AMensaje: string);

function Confirmar(const AMensaje: string): Boolean;

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
  System.SysUtils, System.UITypes, Vcl.Forms, Vcl.Dialogs, Anovo.Textos;

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
end;

function Dialogo(const AMensaje, ATitulo: string; const ATipo: TMsgDlgType;
  const ABotones: TMsgDlgButtons): Integer;
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
            lBoton.Caption := SDialogoSi;
          mrNo:
            lBoton.Caption := SDialogoNo;
        end;
      end;
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
  if ABuscar.Text <> ATexto then
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
