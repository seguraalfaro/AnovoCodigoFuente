unit Anovo.Forms.Recordatorio;

// Notificaciones: cotizaciones enviadas que llevan mas de los dias
// configurados sin respuesta del cliente, con Abrir y Descartar (HU-07).

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.TitleBarCtrls, Vcl.WinXCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB,
  rDBGrid, Anovo.UI.PanelRelativo,
  VclPlano.BotonWin,
  Anovo.Forms.Edicion,
  Anovo.Cancelacion,
  Anovo.Vistas.Intf.Principal,
  Anovo.DTOs.Cotizaciones;

type
  TfrmRecordatorio = class(TfrmEdicion)
    grSinRespuesta: TrDBGrid;
    lblPie: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure grSinRespuestaDblClick(Sender: TObject);
  private
    FAcciones: TAccionesNotificacion;
    FDescartar: TDescartarNotificacion;
    FAbrir: Integer;
    FAbierta: ICancelacion;
    procedure Accion(Sender: TObject; const AClave: string);
    procedure Abrir;
    procedure Descartar;
    procedure Quitar(const AId: Integer);
    procedure MostrarPie;
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    class function Mostrar(AOwner: TComponent;
      const ACotizaciones: TObjectList<TCotizacionDTO>;
      const AAcciones: TAccionesNotificacion;
      const ADescartar: TDescartarNotificacion): Integer;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.UI.CeldasRejilla,
  Anovo.Textos;

const
  CAMPO_ACCIONES = 'ACCIONES';
  ACCIONES: array [TAccionNotificacion] of TAccionRejilla = ((Clave: 'abrir';
    Rotulo: SAccionAbrir), (Clave: 'descartar'; Rotulo: SAccionDescartar));

class function TfrmRecordatorio.Mostrar(AOwner: TComponent;
  const ACotizaciones: TObjectList<TCotizacionDTO>;
  const AAcciones: TAccionesNotificacion;
  const ADescartar: TDescartarNotificacion): Integer;
var
  lForma: TfrmRecordatorio;
begin
  lForma := TfrmRecordatorio.Create(AOwner);
  try
    lForma.FAcciones := AAcciones;
    lForma.FDescartar := ADescartar;
    TCeldasRejilla.De(lForma.grSinRespuesta)
      .PonerAcciones<TAccionesNotificacion>(ACCIONES, AAcciones);
    TMapeoDatos.AListaTabla<TCotizacionDTO>(ACotizaciones,
      dmMemoria.mtSinRespuesta);
    lForma.MostrarPie;
    TCeldasRejilla.De(lForma.grSinRespuesta).AjustarColumnas;
    lForma.ShowModal;
    Result := lForma.FAbrir;
  finally
    lForma.Free;
  end;
end;

procedure TfrmRecordatorio.FormCreate(Sender: TObject);
var
  lRejilla: TCeldasRejilla;
begin
  FAbierta := TCancelacion.Create;
  AplicarTemaGrid(grSinRespuesta);
  lRejilla := TCeldasRejilla.De(grSinRespuesta);
  lRejilla.TextoVacio := SVacioNotificaciones;
  lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
  lRejilla.OnAccion := Accion;
  lblTitulo.Caption := SRecordatorioTitulo;
  lblSubtitulo.Caption := SRecordatorioAyuda;
  btnGuardar.Caption := SBotonCerrar;
  btnCancelar.Visible := False;
end;

procedure TfrmRecordatorio.FormDestroy(Sender: TObject);
begin
  FAbierta.Cancelar;
  dmMemoria.mtSinRespuesta.Close;
end;

function TfrmRecordatorio.ControlesEdicion: TArray<TControl>;
begin
  Result := [grSinRespuesta];
end;

procedure TfrmRecordatorio.MostrarPie;
begin
  lblPie.Caption := Format(SRecordatorioPie,
    [dmMemoria.mtSinRespuesta.RecordCount]);
end;

procedure TfrmRecordatorio.Accion(Sender: TObject; const AClave: string);
begin
  if SameText(AClave, ACCIONES[anAbrir].Clave) then
    Abrir
  else if SameText(AClave, ACCIONES[anDescartar].Clave) then
    Descartar;
end;

procedure TfrmRecordatorio.Abrir;
begin
  if not(anAbrir in FAcciones) or dmMemoria.mtSinRespuesta.IsEmpty then
    Exit;
  FAbrir := dmMemoria.mtSinRespuestaID.AsInteger;
  ModalResult := mrOk;
end;

procedure TfrmRecordatorio.Descartar;
var
  lId: Integer;
  lAbierta: ICancelacion;
  lRejilla: TCeldasRejilla;
begin
  if not(anDescartar in FAcciones) or dmMemoria.mtSinRespuesta.IsEmpty or
    not Assigned(FDescartar) then
    Exit;
  lId := dmMemoria.mtSinRespuestaID.AsInteger;
  lAbierta := FAbierta;
  lRejilla := TCeldasRejilla.De(grSinRespuesta);
  FDescartar(lId, dmMemoria.mtSinRespuestaNUMERO.AsInteger,
    procedure
    begin
      if not lAbierta.Cancelada then
        Quitar(lId);
    end,
    procedure(AActivo: Boolean)
    begin
      if not lAbierta.Cancelada then
        lRejilla.Ocupada := AActivo;
    end);
end;

procedure TfrmRecordatorio.Quitar(const AId: Integer);
begin
  if dmMemoria.mtSinRespuesta.Locate(dmMemoria.mtSinRespuestaID.FieldName,
    AId, []) then
    dmMemoria.mtSinRespuesta.Delete;
  MostrarPie;
end;

procedure TfrmRecordatorio.btnGuardarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmRecordatorio.grSinRespuestaDblClick(Sender: TObject);
begin
  Abrir;
end;

end.
