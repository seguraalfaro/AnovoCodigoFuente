unit Anovo.Frames.Roles;

// Seccion Roles y permisos: el paquete basico de cada rol. Los permisos
// adicionales de una persona se dan en su ficha de usuario.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.WinXCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.BotonWin,
  Anovo.Vistas.Intf.Roles,
  Anovo.Presentadores.Roles;

type
  TfraRoles = class(TFrame, IVistaRoles)
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pnlBarra: TPanel;
    lblRoles: TLabel;
    btnDescartar: TPlanoBotonWin;
    btnGuardar: TPlanoBotonWin;
    pnclient: TRelativePanel;
    grMatriz: TrDBGrid;
    pnlPie: TPanel;
    lblCambios: TLabel;
    procedure grMatrizCellClick(Column: TColumn);
    procedure btnGuardarClick(Sender: TObject);
    procedure btnDescartarClick(Sender: TObject);
  private
    FPresentador: TPresentadorRoles;
    procedure MarcarRolPropio;
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarRoles(const ATexto: string);
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
  MarcarRolPropio;
  btnGuardar.Visible := TPresentadorRoles.PuedeEditar;
  btnDescartar.Visible := TPresentadorRoles.PuedeEditar;
  FPresentador := TPresentadorRoles.Create(Self, TApiRoles.Create);
  FPresentador.Iniciar;
end;

destructor TfraRoles.Destroy;
begin
  FPresentador.Free;
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

procedure TfraRoles.MostrarRoles(const ATexto: string);
begin
  lblRoles.Caption := ATexto;
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

procedure TfraRoles.grMatrizCellClick(Column: TColumn);
var
  lCampo: TField;
begin
    lCampo := Column.Field;
  if (lCampo = nil) or (lCampo.DataType <> ftBoolean) or lCampo.IsNull or
    dmMemoria.mtMatrizRoles.IsEmpty then
    Exit;
  if not FPresentador.MarcarPermiso(lCampo.FieldName,
    dmMemoria.mtMatrizRolesPERMISO_ID.AsInteger, not lCampo.AsBoolean) then
    Exit;
  dmMemoria.mtMatrizRoles.Edit;
  lCampo.AsBoolean := not lCampo.AsBoolean;
  dmMemoria.mtMatrizRoles.Post;
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
