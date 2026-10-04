unit Anovo.UI.Vigencia;

// Casilla de programado, fecha y nota de vigencia que comparten
// las ventanas que registran un precio.

interface

uses
  Data.DB,
  Vcl.StdCtrls,
  Vcl.DBCtrls;

type
  TVigenciaPrecio = class
  private
    FCheck: TCheckBox;
    FFecha: TDBEdit;
    FNota: TLabel;
    FProgramadoExistente: TDateTime;
    function Campo: TField;
    procedure CheckClick(Sender: TObject);
    procedure FechaChange(Sender: TObject);
  public
    constructor Create(const ACheck: TCheckBox; const AFecha: TDBEdit;
      const ANota: TLabel; const AProgramadoExistente: TDateTime);
    destructor Destroy; override;

    procedure MostrarNota;
    function Error: string;
    function Programado: Boolean;
  end;

function ProgramadoDeLaFila(const AFila: TDataSet): TDateTime;

implementation

uses
  System.SysUtils,
  System.UITypes,
  Vcl.Graphics,
  Anovo.Formato,
  Anovo.Textos;

function ProgramadoDeLaFila(const AFila: TDataSet): TDateTime;
var
  lCampo: TField;
begin
  Result := 0;
  if (AFila = nil) or AFila.IsEmpty then
    Exit;
  lCampo := AFila.FindField('PROGRAMADO_FECHA');
  if (lCampo <> nil) and not lCampo.IsNull then
    Result := lCampo.AsDateTime;
end;

constructor TVigenciaPrecio.Create(const ACheck: TCheckBox;
  const AFecha: TDBEdit; const ANota: TLabel;
  const AProgramadoExistente: TDateTime);
begin
  inherited Create;
  FCheck := ACheck;
  FFecha := AFecha;
  FNota := ANota;
  FProgramadoExistente := AProgramadoExistente;

  FCheck.Checked := False;
  FFecha.Enabled := False;
  FCheck.OnClick := CheckClick;
  FFecha.OnChange := FechaChange;
end;

destructor TVigenciaPrecio.Destroy;
begin
  FCheck.OnClick := nil;
  FFecha.OnChange := nil;
  inherited;
end;

function TVigenciaPrecio.Campo: TField;
begin
  Result := FFecha.Field;
end;

function TVigenciaPrecio.Programado: Boolean;
begin
  Result := FCheck.Checked;
end;

procedure TVigenciaPrecio.CheckClick(Sender: TObject);
begin
  FFecha.Enabled := FCheck.Checked;

  if (Campo <> nil) and (Campo.DataSet.State in dsEditModes) then
  begin
    if FCheck.Checked then
      Campo.AsDateTime := Date + 1
    else
      Campo.AsDateTime := Date;
  end;

  if FCheck.Checked and FFecha.CanFocus then
    FFecha.SetFocus;

  MostrarNota;
end;

procedure TVigenciaPrecio.FechaChange(Sender: TObject);
begin
  MostrarNota;
end;

procedure TVigenciaPrecio.MostrarNota;
var
  lFecha: TDateTime;
begin
  FNota.Font.Color := clGrayText;
  FNota.Font.Style := [];

  if not FCheck.Checked then
  begin
    if FProgramadoExistente > 0 then
    begin
      FNota.Font.Style := [fsBold];
      FNota.Caption := Format(SProgramadoExistente,
        [TFormato.Fecha(FProgramadoExistente)]);
    end
    else
      FNota.Caption := SRigeDeUnaVez;
    Exit;
  end;

  if not TryStrToDateTime(FFecha.Text, lFecha) then
  begin
    FNota.Caption := '';
    Exit;
  end;

  if lFecha <= Now then
  begin
    FNota.Font.Color := clRed;
    FNota.Caption := SProgramadoFechaInvalida;
    Exit;
  end;

  FNota.Caption := Format(SProgramadoAviso,
    [TFormato.Fecha(lFecha)]);
end;

function TVigenciaPrecio.Error: string;
begin
  Result := '';
  if not FCheck.Checked then
    Exit;
  if (Campo = nil) or Campo.IsNull or (Campo.AsDateTime <= Now) then
    Result := SProgramadoSinFecha;
end;

end.
