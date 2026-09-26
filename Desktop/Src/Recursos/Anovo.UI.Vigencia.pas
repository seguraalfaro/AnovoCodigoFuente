unit Anovo.UI.Vigencia;

// El check de "programado", el campo de fecha y la nota que explica que va a
// pasar con el precio. Lo usan las dos ventanas que registran un precio: la del
// item (precio inicial o cambio al editar) y la del boton Precio de la fila.
//
// Estaba escrito dentro de la ventana del item. Al aparecer la segunda, copiarlo
// dejaba dos versiones que tarde o temprano se iban a separar, y las dos
// pantallas tienen que comportarse igual: es la misma regla de negocio.
//
// Se engancha sola al OnClick del check y al OnChange del campo: la ventana solo
// la crea, le pide Error antes de guardar y la libera.
//
// El campo de fecha se recibe como TDBEdit porque es lo que tienen en comun el
// TrDBEdit y el TrDBEditDate que usan las dos ventanas.

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
    // AProgramadoExistente es la fecha del cambio que el item ya tiene en cola,
    // 0 si no hay: ver ProgramadoDeLaFila.
    constructor Create(const ACheck: TCheckBox; const AFecha: TDBEdit;
      const ANota: TLabel; const AProgramadoExistente: TDateTime);
    destructor Destroy; override;

    procedure MostrarNota;
    // Vacio si se puede guardar; si no, el mensaje para la persona.
    function Error: string;
    function Programado: Boolean;
  end;

// La fecha del cambio que el item de la fila ya tiene en cola, leida del
// listado que la trae en PROGRAMADO_FECHA. 0 si no hay, si la fila no existe o
// si ese listado no tiene la columna.
function ProgramadoDeLaFila(const AFila: TDataSet): TDateTime;

implementation

uses
  System.SysUtils,
  System.UITypes,
  Vcl.Graphics,
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

{ TVigenciaPrecio }

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
  // Los controles son de la ventana y pueden sobrevivir un instante a este
  // objeto mientras ella se destruye: que no queden apuntando a el.
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
      // Manana, que es la primera fecha que de verdad programa algo. Asi el
      // campo no arranca vacio ni con una fecha que no serviria.
      Campo.AsDateTime := Date + 1
    else
      // Hoy y no vacio. Si alguien marca, pone una fecha futura y desmarca, la
      // fecha futura no se puede quedar en el campo: el servidor decide por la
      // fecha, y el precio se programaria aunque el check diga que no.
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
  // Un precio programado no cambia nada hoy: queda esperando y lo aplica el
  // servidor cuando llega la fecha. Sin este aviso, la persona guarda, ve el
  // listado igual que antes y cree que no se guardo.
  FNota.Font.Color := clGrayText;
  FNota.Font.Style := [];

  if not FCheck.Checked then
  begin
    // Avisarlo importa: sin esto se programa un segundo cambio sin saber que
    // ya habia uno, y el listado se ve igual porque el precio de hoy no cambio.
    if FProgramadoExistente > 0 then
    begin
      FNota.Font.Style := [fsBold];
      FNota.Caption := Format(SProgramadoExistente,
        [FormatDateTime('dd/mm/yyyy', FProgramadoExistente)]);
    end
    else
      FNota.Caption := SRigeDeUnaVez;
    Exit;
  end;

  if not TryStrToDateTime(FFecha.Text, lFecha) then
  begin
    // A medio escribir. Mejor sin texto que con uno que cambia en cada tecla.
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
    [FormatDateTime('dd/mm/yyyy', lFecha)]);
end;

function TVigenciaPrecio.Error: string;
begin
  // Se mira el campo y no el texto: para cuando se valida, la ventana ya hizo
  // Post. Vacio da nulo, que tambien cae aqui: programar sin fecha no es
  // programar.
  //
  // Esto no lo ataja el servidor. Una fecha de hoy la toma como "rige ya" y
  // guarda sin avisar, y la persona cree que dejo algo programado.
  Result := '';
  if not FCheck.Checked then
    Exit;
  if (Campo = nil) or Campo.IsNull or (Campo.AsDateTime <= Now) then
    Result := SProgramadoSinFecha;
end;

end.
