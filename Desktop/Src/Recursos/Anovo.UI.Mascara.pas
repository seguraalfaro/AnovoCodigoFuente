unit Anovo.UI.Mascara;

// Campos con mascara (telefono): si estan vacios, el cursor queda al
// inicio al entrar con Tab o con un clic.

interface

uses
  Vcl.Controls;

procedure CursorAlInicioEnMascaras(AContenedor: TWinControl);

implementation

uses
  System.Classes,
  System.SysUtils,
  System.Character,
  Vcl.Mask;

type
  TMascaraAbierta = class(TCustomMaskEdit);

  TCursorMascara = class(TComponent)
  private
    FCampo: TMascaraAbierta;
    FAlEntrar: TNotifyEvent;
    FAlHacerClic: TNotifyEvent;
    function Vacio: Boolean;
    procedure AlInicio;
    procedure Entrar(Sender: TObject);
    procedure HacerClic(Sender: TObject);
  public
    constructor Crear(ACampo: TCustomMaskEdit);
  end;

constructor TCursorMascara.Crear(ACampo: TCustomMaskEdit);
begin
  inherited Create(ACampo);
  FCampo := TMascaraAbierta(ACampo);
  FAlEntrar := FCampo.OnEnter;
  FAlHacerClic := FCampo.OnClick;
  FCampo.OnEnter := Entrar;
  FCampo.OnClick := HacerClic;
end;

function TCursorMascara.Vacio: Boolean;
var
  lCaracter: Char;
begin
  for lCaracter in FCampo.Text do
    if lCaracter.IsLetterOrDigit then
      Exit(False);
  Result := True;
end;

procedure TCursorMascara.AlInicio;
begin
  if FCampo.IsMasked and Vacio then
  begin
    FCampo.SelStart := 0;
    FCampo.SelLength := 0;
  end;
end;

procedure TCursorMascara.Entrar(Sender: TObject);
begin
  if Assigned(FAlEntrar) then
    FAlEntrar(Sender);
  AlInicio;
end;

procedure TCursorMascara.HacerClic(Sender: TObject);
begin
  if Assigned(FAlHacerClic) then
    FAlHacerClic(Sender);
  AlInicio;
end;

function YaTiene(ACampo: TCustomMaskEdit): Boolean;
var
  I: Integer;
begin
  for I := 0 to ACampo.ComponentCount - 1 do
    if ACampo.Components[I] is TCursorMascara then
      Exit(True);
  Result := False;
end;

procedure CursorAlInicioEnMascaras(AContenedor: TWinControl);
var
  I: Integer;
  lControl: TControl;
begin
  for I := 0 to AContenedor.ControlCount - 1 do
  begin
    lControl := AContenedor.Controls[I];
    if (lControl is TCustomMaskEdit) and not YaTiene(TCustomMaskEdit(lControl)) then
      TCursorMascara.Crear(TCustomMaskEdit(lControl))
    else if lControl is TWinControl then
      CursorAlInicioEnMascaras(TWinControl(lControl));
  end;
end;

end.
