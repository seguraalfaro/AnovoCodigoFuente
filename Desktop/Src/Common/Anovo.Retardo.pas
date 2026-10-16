unit Anovo.Retardo;

// Retardo de un solo disparo: agrupa cambios seguidos de un control
// y pide los datos una sola vez cuando el usuario deja de tocarlo.

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.ExtCtrls;

const
  RETARDO_FECHAS = 400;
  RETARDO_REVISION = 800;

type
  TRetardo = class(TComponent)
  private
    FTimer: TTimer;
    FProc: TProc;
    procedure Disparar(Sender: TObject);
  public
    constructor Crear(AOwner: TComponent; const AMilisegundos: Integer;
      const AProc: TProc);
    procedure Programar;
    procedure Cancelar;
    function Pendiente: Boolean;
  end;

implementation

constructor TRetardo.Crear(AOwner: TComponent; const AMilisegundos: Integer;
  const AProc: TProc);
begin
  inherited Create(AOwner);
  FProc := AProc;
  FTimer := TTimer.Create(Self);
  FTimer.Enabled := False;
  FTimer.Interval := AMilisegundos;
  FTimer.OnTimer := Disparar;
end;

procedure TRetardo.Programar;
begin
  FTimer.Enabled := False;
  FTimer.Enabled := True;
end;

procedure TRetardo.Cancelar;
begin
  FTimer.Enabled := False;
end;

function TRetardo.Pendiente: Boolean;
begin
  Result := FTimer.Enabled;
end;

procedure TRetardo.Disparar(Sender: TObject);
begin
  FTimer.Enabled := False;
  if Assigned(FProc) then
    FProc();
end;

end.
