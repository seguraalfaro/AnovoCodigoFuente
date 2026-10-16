unit Anovo.Forms.Consentimiento;

// Ventana de los textos del consentimiento (Ley 8968): las versiones
// publicadas, cada una tal como se firma, y la publicacion de una nueva.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.TitleBarCtrls, Vcl.WinXPanels, Vcl.Grids, Vcl.DBGrids,
  Vcl.Mask, Vcl.DBCtrls, Data.DB, rDBGrid, rDBComponents,
  VclPlano.BotonWin, VclPlano.Pestanas,
  Anovo.Forms.Edicion,
  Anovo.DTOs.Clientes,
  Anovo.Vistas.Intf.Consentimiento,
  Anovo.Presentadores.Consentimiento;

type
  TfrmConsentimiento = class(TfrmEdicion, IVistaConsentimiento)
    pstSecciones: TPlanoPestanas;
    cpSecciones: TCardPanel;
    crdVersiones: TCard;
    grVersiones: TrDBGrid;
    meVersion: TrDBMemo;
    lblSinVersiones: TLabel;
    crdNueva: TCard;
    lblNotaNueva: TLabel;
    edVersion: TrDBEdit;
    edTituloTexto: TrDBEdit;
    meContenido: TrDBMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure pstSeccionesChange(Sender: TObject);
  private
    FPresentador: TPresentadorConsentimiento;
    FPublicado: Boolean;
    procedure MostrarCargando(const AActivo: Boolean);
    function Confirmar(const AMensaje: string): Boolean;
    procedure MostrarVersiones(const AVersiones
      : TObjectList<TConsentimientoTextoDTO>);
    procedure Publicado;
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    class function Mostrar(AOwner: TComponent): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Api.Configuracion,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.UI.DBGridExtend,
  Anovo.UI.Vista,
  Anovo.Textos;

const
  CAMPO_ESTADO = 'ESTADO';
  PESTANA_NUEVA = 1;

class function TfrmConsentimiento.Mostrar(AOwner: TComponent): Boolean;
var
  lForma: TfrmConsentimiento;
begin
  lForma := TfrmConsentimiento.Create(AOwner);
  try
    lForma.FPresentador.Cargar;
    lForma.ShowModal;
    Result := lForma.FPublicado;
  finally
    lForma.Free;
  end;
end;

procedure TfrmConsentimiento.FormCreate(Sender: TObject);
begin
  FPublicado := False;
  AplicarTemaGrid(grVersiones);
  TDBGridExtend.De(grVersiones).ColumnaEstado(CAMPO_ESTADO);
  lblNotaNueva.Caption := SNotaNuevaVersion;
  lblSinVersiones.Caption := SSinTextoConsentimiento;
  btnGuardar.Caption := SBotonPublicar;
  btnGuardar.Visible := False;
  dmMemoria.PrepararConsentimientoNuevo;
  FPresentador := TPresentadorConsentimiento.Create(Self,
    TApiConfiguracion.Create);
end;

procedure TfrmConsentimiento.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPresentador);
  dmMemoria.mtTextosConsentimiento.Close;
  dmMemoria.mtConsentimientoNuevo.Close;
end;

function TfrmConsentimiento.ControlesEdicion: TArray<TControl>;
begin
  Result := [cpSecciones, pstSecciones];
end;

procedure TfrmConsentimiento.MostrarCargando(const AActivo: Boolean);
begin
  MostrarOcupado(AActivo);
end;

function TfrmConsentimiento.Confirmar(const AMensaje: string): Boolean;
begin
  Result := Anovo.UI.Vista.Confirmar(AMensaje);
end;

procedure TfrmConsentimiento.MostrarVersiones(const AVersiones
  : TObjectList<TConsentimientoTextoDTO>);
var
  lVacia: Boolean;
begin
  TMapeoDatos.AListaTabla<TConsentimientoTextoDTO>(AVersiones,
    dmMemoria.mtTextosConsentimiento);
  lVacia := dmMemoria.mtTextosConsentimiento.IsEmpty;
  grVersiones.Visible := not lVacia;
  meVersion.Visible := not lVacia;
  lblSinVersiones.Visible := lVacia;
  TDBGridExtend.De(grVersiones).AjustarColumnas;
end;

procedure TfrmConsentimiento.pstSeccionesChange(Sender: TObject);
begin
  btnGuardar.Visible := pstSecciones.ItemIndex = PESTANA_NUEVA;
end;

procedure TfrmConsentimiento.btnGuardarClick(Sender: TObject);
begin
  dmMemoria.Confirmar(dmMemoria.mtConsentimientoNuevo);
  FPresentador.Publicar(TMapeoDatos.ADto<TConsentimientoTextoNuevoDTO>
    (dmMemoria.mtConsentimientoNuevo));
end;

procedure TfrmConsentimiento.Publicado;
begin
  FPublicado := True;
  Informar(SConsentimientoPublicado);
  ModalResult := mrOk;
end;

end.
