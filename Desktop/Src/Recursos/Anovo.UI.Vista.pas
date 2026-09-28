unit Anovo.UI.Vista;

// Apoyos comunes de las vistas: cursor de espera, errores, busqueda y paginacion.

interface

uses
  Vcl.Controls, Vcl.StdCtrls, Vcl.WinXCtrls;

procedure CursorOcupado(const AActivo: Boolean);

procedure AvisarError(const AMensaje: string);

function Confirmar(const AMensaje: string): Boolean;

procedure BloquearEdicion(const AControles: array of TControl;
  const AActivo: Boolean);

procedure PintarBusqueda(ABuscar: TSearchBox; ALimpiar: TControl;
  const ATexto: string; const APuedeLimpiar: Boolean);

procedure PintarPaginacion(AEtiqueta: TLabel; AAnterior, ASiguiente: TControl;
  const APagina, ATotalPaginas: Integer; const ATotal: Int64;
  const ASinRegistros, APaginacion: string; const ASoloTotal: string = '');

implementation

uses
  System.SysUtils, System.UITypes, Vcl.Forms, Vcl.Dialogs;

procedure CursorOcupado(const AActivo: Boolean);
begin
  if AActivo then
    Screen.Cursor := crAppStart
  else
    Screen.Cursor := crDefault;
end;

procedure AvisarError(const AMensaje: string);
begin
  MessageDlg(AMensaje, mtError, [mbOK], 0);
end;

function Confirmar(const AMensaje: string): Boolean;
begin
  Result := MessageDlg(AMensaje, mtConfirmation, [mbYes, mbNo], 0) = mrYes;
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
