unit Anovo.Frames.Roles;

// Seccion Roles y permisos: el paquete basico de cada rol. Los permisos
// adicionales de una persona se dan en su ficha de usuario.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.WinXCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.BotonWin, VclPlano.Pastilla,
  Anovo.Vistas.Intf.Roles,
  Anovo.Presentadores.Roles;

type
  TfraRoles = class(TFrame, IVistaRoles)
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pnlBarra: TPanel;
    pnlRoles: TPanel;
    pstRolAsesor: TPlanoPastilla;
    pstRolAsistente: TPlanoPastilla;
    pstRolSupervisor: TPlanoPastilla;
    pstRolGerencia: TPlanoPastilla;
    pstRolAdmin: TPlanoPastilla;
    btnDescartar: TPlanoBotonWin;
    btnGuardar: TPlanoBotonWin;
    pnclient: TRelativePanel;
    grMatriz: TrDBGrid;
    pnlPie: TPanel;
    lblCambios: TLabel;
    procedure grMatrizCanEdit(Sender: TObject; Field: TField; Column: TColumn;
      var CanEdit: Boolean);
    procedure grMatrizBoolClick(Sender: TObject; DataSet: TDataSet;
      Column: TColumn; Field: TField; Value: Variant);
    procedure grMatrizGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; ActiveRow, Highlight: Boolean);
    procedure btnGuardarClick(Sender: TObject);
    procedure btnDescartarClick(Sender: TObject);
  private
    FPresentador: TPresentadorRoles;
    procedure MarcarRolPropio;
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarRoles(const ARotulos: TArray<string>);
    procedure MostrarMatriz(const AFilas: TObjectList<TFilaMatriz>);
    procedure MostrarCambios(const ACantidad: Integer);
    procedure MostrarError(const AMensaje: string);
  protected
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Api.Roles,
  Anovo.Forms.Motivo,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.UI.DBGridExtend,
  Anovo.UI.Vista,
  Anovo.UI.Tema,
  Anovo.Sesion,
  Anovo.Textos;

constructor TfraRoles.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AplicarTemaGrid(grMatriz);
  EditarCasillas(grMatriz);
  MarcarRolPropio;
  btnGuardar.Visible := TPresentadorRoles.PuedeEditar;
  btnDescartar.Visible := TPresentadorRoles.PuedeEditar;
  FPresentador := TPresentadorRoles.Create(Self, TApiRoles.Create);
  FPresentador.Iniciar;
end;

destructor TfraRoles.Destroy;
begin
  FreeAndNil(FPresentador);
  CursorOcupado(False);
  inherited;
end;

procedure TfraRoles.MarcarRolPropio;
var
  I: Integer;
  lCampo: string;
begin
  lCampo := UpperCase(CodigoDeRol(TSesion.Rol));
  for I := 0 to grMatriz.Columns.Count - 1 do
    if SameText(grMatriz.Columns[I].FieldName, lCampo) then
    begin
      grMatriz.Columns[I].Color := clAnovoSuave;
      grMatriz.Columns[I].Title.Caption :=
        Format(SSuRol, [grMatriz.Columns[I].Title.Caption]);
    end;
end;

procedure TfraRoles.Resize;
begin
  inherited;
  OcultarScrollVertical(grMatriz);
end;

procedure TfraRoles.MostrarCargando(const AActivo: Boolean);
begin
  CursorOcupado(AActivo);
  BloquearEdicion([grMatriz, btnGuardar, btnDescartar], AActivo);
end;

procedure PonerPastilla(APastilla: TPlanoPastilla; const ARotulo: string);
begin
  APastilla.Caption := ARotulo;
  APastilla.Visible := ARotulo <> '';
end;

procedure TfraRoles.MostrarRoles(const ARotulos: TArray<string>);
begin
  PonerPastilla(pstRolAsesor, ARotulos[0]);
  PonerPastilla(pstRolAsistente, ARotulos[1]);
  PonerPastilla(pstRolSupervisor, ARotulos[2]);
  PonerPastilla(pstRolGerencia, ARotulos[3]);
  PonerPastilla(pstRolAdmin, ARotulos[4]);
end;

procedure TfraRoles.MostrarMatriz(const AFilas: TObjectList<TFilaMatriz>);
begin
  TMapeoDatos.AListaTabla<TFilaMatriz>(AFilas, dmMemoria.mtMatrizRoles);
end;

procedure TfraRoles.MostrarCambios(const ACantidad: Integer);
begin
  if ACantidad = 0 then
    lblCambios.Caption := SSinCambiosRoles
  else
    lblCambios.Caption := Format(SCambiosRolesPendientes, [ACantidad]);
end;

procedure TfraRoles.MostrarError(const AMensaje: string);
begin
  AvisarError(AMensaje);
end;

procedure TfraRoles.grMatrizCanEdit(Sender: TObject; Field: TField;
  Column: TColumn; var CanEdit: Boolean);
begin
  CanEdit := CanEdit and (Field <> nil) and (Field.DataType = ftBoolean) and
    not Field.IsNull and FPresentador.PuedeMarcar(Field.FieldName);
end;

procedure TfraRoles.grMatrizBoolClick(Sender: TObject; DataSet: TDataSet;
  Column: TColumn; Field: TField; Value: Variant);
begin
  dmMemoria.Confirmar(DataSet);
  FPresentador.MarcarPermiso(Field.FieldName,
    dmMemoria.mtMatrizRolesPERMISO_ID.AsInteger, Field.AsBoolean);
end;

procedure TfraRoles.grMatrizGetCellParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; ActiveRow, Highlight: Boolean);
begin
  if (FPresentador = nil) or dmMemoria.mtMatrizRoles.IsEmpty or
    not FPresentador.PermisoCambiado
    (dmMemoria.mtMatrizRolesPERMISO_ID.AsInteger) then
    Exit;
  Background := clAnovoAvisoMedio;
  AFont.Style := AFont.Style + [fsBold];
end;

procedure TfraRoles.btnGuardarClick(Sender: TObject);
var
  lMotivo: string;
begin
  if not FPresentador.HayCambios then
    Exit;
  if TfrmMotivo.Pedir(Self, SMotivoRolesTitulo, SMotivoRolesAyuda,
    SBotonGuardar, lMotivo) then
    FPresentador.Guardar(lMotivo);
end;

procedure TfraRoles.btnDescartarClick(Sender: TObject);
begin
  FPresentador.Iniciar;
end;

end.
