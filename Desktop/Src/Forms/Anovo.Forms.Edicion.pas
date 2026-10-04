unit Anovo.Forms.Edicion;

// Base de las ventanas de edicion: barra de titulo, encabezado y pie con Guardar y Cancelar.

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.TitleBarCtrls, Vcl.WinXCtrls,
  VclPlano.BotonWin;

type
  TfrmEdicion = class(TForm)
    TitleBarPanel1: TTitleBarPanel;
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pnlPie: TRelativePanel;
    btnGuardar: TPlanoBotonWin;
    btnCancelar: TPlanoBotonWin;
    procedure btnCancelarClick(Sender: TObject);
  protected
    function ControlesEdicion: TArray<TControl>; virtual;
    procedure DoCreate; override;
    procedure MostrarOcupado(const AActivo: Boolean);
    procedure MostrarGuardando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    function MostrarReparos(const AReparos: TStrings;
      const AEncabezado: string): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.Tema,
  Anovo.UI.Vista;

procedure TfrmEdicion.DoCreate;
begin
  AplicarTema(Self);
  AplicarTemaBarraTitulo(Self, TitleBarPanel1);
  inherited;
end;

function TfrmEdicion.ControlesEdicion: TArray<TControl>;
begin
  Result := [];
end;

procedure TfrmEdicion.MostrarOcupado(const AActivo: Boolean);
var
  lControles: TArray<TControl>;
begin
  lControles := [btnGuardar, btnCancelar] + ControlesEdicion;
  BloquearEdicion(lControles, AActivo);
end;

procedure TfrmEdicion.MostrarGuardando(const AActivo: Boolean);
begin
  MostrarOcupado(AActivo);
end;

procedure TfrmEdicion.MostrarError(const AMensaje: string);
begin
  AvisarError(AMensaje);
end;

function TfrmEdicion.MostrarReparos(const AReparos: TStrings;
  const AEncabezado: string): Boolean;
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
      lMensaje := lMensaje + sLineBreak + '   ' + #$2022 + '  ' + AReparos[I];
  end;
  MostrarError(lMensaje);
end;

procedure TfrmEdicion.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
