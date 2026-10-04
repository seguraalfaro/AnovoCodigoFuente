unit Anovo.Forms.Usuario;

// Ventana de un usuario: datos de la cuenta, clave temporal y permisos
// adicionales o quitados sobre el paquete basico de su rol.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.TitleBarCtrls, Vcl.WinXPanels, Vcl.Grids, Vcl.DBGrids,
  Vcl.DBCtrls, Data.DB, rDBGrid, rDBComponents,
  VclPlano.BotonWin, VclPlano.Pestanas, VclPlano.Tarjeta, VclPlano.Pastilla,
  Anovo.Forms.Edicion,
  Anovo.DTOs.Usuarios,
  Anovo.DTOs.Roles,
  Anovo.Vistas.Intf.Usuario,
  Anovo.Presentadores.Usuario, Vcl.Mask, Vcl.WinXCtrls;

type
  TfrmUsuario = class(TfrmEdicion, IVistaUsuario)
    pstSecciones: TPlanoPestanas;
    cpUsuario: TCardPanel;
    crdDatos: TCard;
    edNombre: TrDBEdit;
    edCorreo: TrDBEdit;
    cbRol: TrDBLookupComboBox;
    lblAviso: TLabel;
    tjClave: TPlanoTarjeta;
    pstClave: TPlanoPastilla;
    lblClaveEstado: TLabel;
    btnPedirCambio: TPlanoBotonWin;
    btnGenerar: TPlanoBotonWin;
    edClave: TrDBEdit;
    btnCopiar: TPlanoBotonWin;
    lblClaveNota: TLabel;
    lblFechas: TLabel;
    crdPermisos: TCard;
    lblResumen: TLabel;
    grPermisos: TrDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure cbRolClick(Sender: TObject);
    procedure grPermisosCellClick(Column: TColumn);
    procedure btnGenerarClick(Sender: TObject);
    procedure btnCopiarClick(Sender: TObject);
    procedure btnPedirCambioClick(Sender: TObject);
  private
    FPresentador: TPresentadorUsuario;
    FId: Integer;
    FGuardado: Boolean;
    FPropia: Boolean;
    FFechaClave: string;
    procedure PonerClaveNueva;
    procedure MostrarClave;
    function RolEscogido: Integer;
    function CambioRol: Boolean;
    function ValidarCampos: Boolean;
    procedure MostrarResumen;
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarRoles(const ARoles: TObjectList<TRolDTO>);
    procedure MostrarUsuario(const AUsuario: TUsuarioDTO);
    procedure MostrarPermisos(const AFilas: TObjectList<TFilaPermiso>);
    procedure Guardado;
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    class function Mostrar(AOwner: TComponent; const AId: Integer): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Vcl.Clipbrd,
  VclPlano.Paleta,
  Anovo.Api.Usuarios,
  Anovo.Api.Roles,
  Anovo.Forms.Motivo,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.UI.DBGridExtend,
  Anovo.Formato,
  Anovo.Sesion,
  Anovo.Textos;

const
  CAMPO_TIENE = 'TIENE';
  CAMPO_ORIGEN = 'ORIGEN';
  PERMISO_EDITAR_PERMISOS = 'permisos.editar';

class function TfrmUsuario.Mostrar(AOwner: TComponent;
  const AId: Integer): Boolean;
var
  lForma: TfrmUsuario;
begin
  lForma := TfrmUsuario.Create(AOwner);
  try
    lForma.FId := AId;
    lForma.FPropia := AId = TSesion.UsuarioId;
    if AId = 0 then
    begin
      lForma.lblTitulo.Caption := SNuevoUsuarioTitulo;
      lForma.lblSubtitulo.Caption := SNuevoUsuarioAyuda;
      lForma.pstSecciones.Visible := False;
      lForma.cpUsuario.ActiveCard := lForma.crdDatos;
      lForma.tjClave.Caption := SClaveTemporalTitulo;
      dmMemoria.PrepararUsuario;
      lForma.PonerClaveNueva;
    end;
    lForma.FPresentador.Cargar(AId);
    lForma.ShowModal;
    Result := lForma.FGuardado;
  finally
    lForma.Free;
  end;
end;

procedure TfrmUsuario.FormCreate(Sender: TObject);
var
  lRejilla: TDBGridExtend;
begin
  AplicarTemaGrid(grPermisos);
  lRejilla := TDBGridExtend.De(grPermisos);
  lRejilla.ColumnaEstado(CAMPO_ORIGEN);
  dmMemoria.mtPermisosUsuario.Close;
  dmMemoria.mtUsuario.Close;
  lblAviso.Visible := False;
  FPresentador := TPresentadorUsuario.Create(Self, TApiUsuarios.Create,
    TApiRoles.Create);
end;

procedure TfrmUsuario.FormDestroy(Sender: TObject);
begin
  FPresentador.Free;
  dmMemoria.mtUsuario.Close;
  dmMemoria.mtRoles.Close;
  dmMemoria.mtPermisosUsuario.Close;
end;

function TfrmUsuario.ControlesEdicion: TArray<TControl>;
begin
  Result := [cpUsuario, pstSecciones];
end;

procedure TfrmUsuario.MostrarCargando(const AActivo: Boolean);
begin
  MostrarGuardando(AActivo);
end;

procedure TfrmUsuario.MostrarRoles(const ARoles: TObjectList<TRolDTO>);
begin
  TMapeoDatos.AListaTabla<TRolDTO>(ARoles, dmMemoria.mtRoles);
end;

procedure TfrmUsuario.MostrarUsuario(const AUsuario: TUsuarioDTO);
begin
  TMapeoDatos.ATabla(AUsuario, dmMemoria.mtUsuario);
  lblTitulo.Caption := AUsuario.Nombre;
  lblSubtitulo.Caption := AUsuario.Correo;
  cbRol.Enabled := not FPropia;
  lblFechas.Caption := Format(SUsuarioRegistrado,
    [TFormato.FechaHora(AUsuario.FechaCreacion.ValueOrDefault)]);
  FFechaClave := '';
  if AUsuario.FechaClave.HasValue then
    FFechaClave := TFormato.FechaHora(AUsuario.FechaClave.Value);

  pstSecciones.Visible := not FPropia and
    TSesion.Tiene(PERMISO_EDITAR_PERMISOS);

  MostrarClave;
end;

procedure TfrmUsuario.PonerClaveNueva;
begin
  dmMemoria.mtUsuario.Edit;
  dmMemoria.mtUsuarioCLAVE_TEMPORAL.AsString :=
    TPresentadorUsuario.GenerarClave;
  FPresentador.PedirCambio(False);
  btnCopiar.Caption := SCopiar;
  MostrarClave;
end;

procedure TfrmUsuario.MostrarClave;
var
  lHayClave, lPuede: Boolean;
begin
  lHayClave := not dmMemoria.mtUsuarioCLAVE_TEMPORAL.AsString.IsEmpty;
  lPuede := (FId = 0) or FPresentador.PuedeRestablecer;

  edClave.Visible := lHayClave;
  btnCopiar.Visible := lHayClave;
  btnGenerar.Visible := lPuede;
  if lHayClave then
    btnGenerar.Caption := SGenerarOtra
  else
    btnGenerar.Caption := SGenerarClave;
  btnPedirCambio.Visible := lPuede and (FId > 0) and not lHayClave and
    not FPresentador.DebeCambiarClave;
  if FPresentador.PideCambio then
    btnPedirCambio.Caption := SNoPedirCambio
  else
    btnPedirCambio.Caption := SPedirCambio;

  pstClave.Visible := FId > 0;
  lblClaveEstado.Visible := not lHayClave;
  lblClaveNota.Visible := lHayClave or FPresentador.PideCambio;

  if FId = 0 then
    lblClaveNota.Caption := SClaveNuevaNota
  else if lHayClave then
  begin
    pstClave.Status := fsPending;
    pstClave.Caption := SSinGuardar;
    lblClaveNota.Caption := SClaveSeAplica;
  end
  else if FPresentador.PideCambio then
  begin
    pstClave.Status := fsPending;
    pstClave.Caption := SSinGuardar;
    lblClaveEstado.Caption := Format(SClaveCambiadaEl, [FFechaClave]);
    lblClaveNota.Caption := SCambioPedidoNota;
  end
  else if FPresentador.DebeCambiarClave then
  begin
    pstClave.Status := fsPending;
    pstClave.Caption := SEstClavePendiente;
    lblClaveEstado.Caption := SClaveDebeCambiar;
  end
  else
  begin
    pstClave.Status := fsInfo;
    pstClave.Caption := SClaveVigente;
    lblClaveEstado.Caption := Format(SClaveCambiadaEl, [FFechaClave]);
  end;
end;

procedure TfrmUsuario.btnGenerarClick(Sender: TObject);
begin
  PonerClaveNueva;
end;

procedure TfrmUsuario.btnCopiarClick(Sender: TObject);
begin
  Clipboard.AsText := dmMemoria.mtUsuarioCLAVE_TEMPORAL.AsString;
  btnCopiar.Caption := SCopiada;
end;

procedure TfrmUsuario.btnPedirCambioClick(Sender: TObject);
begin
  FPresentador.PedirCambio(not FPresentador.PideCambio);
  MostrarClave;
end;

procedure TfrmUsuario.MostrarPermisos(const AFilas: TObjectList<TFilaPermiso>);
begin
  TMapeoDatos.AListaTabla<TFilaPermiso>(AFilas, dmMemoria.mtPermisosUsuario);
  MostrarResumen;
end;

procedure TfrmUsuario.MostrarResumen;
var
  lBasicos, lAdicionales, lQuitados, lCambios: Integer;
begin
  if dmMemoria.mtPermisosUsuario.IsEmpty then
    Exit;
  grPermisos.Enabled := not CambioRol;
  if CambioRol then
  begin
    lblResumen.Caption := SPermisosTrasCambioRol;
    Exit;
  end;
  lBasicos := dmMemoria.mtPermisosUsuarioBASICOS.Value;
  lAdicionales := dmMemoria.mtPermisosUsuarioADICIONALES.Value;
  lQuitados := dmMemoria.mtPermisosUsuarioQUITADOS.Value;
  lCambios := dmMemoria.mtPermisosUsuarioCAMBIOS.Value;
  lblResumen.Caption := Format(SPermisosResumen, [cbRol.Text, lBasicos,
    lAdicionales, lQuitados, lCambios]);
end;

procedure TfrmUsuario.grPermisosCellClick(Column: TColumn);
var
  lTabla: TDataSet;
begin
  lTabla := dmMemoria.mtPermisosUsuario;
  if (Column.FieldName <> CAMPO_TIENE) or lTabla.IsEmpty or CambioRol then
    Exit;
  lTabla.Edit;
  dmMemoria.mtPermisosUsuarioTIENE.AsBoolean :=
    not dmMemoria.mtPermisosUsuarioTIENE.AsBoolean;
  lTabla.Post;
  FPresentador.MarcarPermiso(dmMemoria.mtPermisosUsuarioPERMISO_ID.AsInteger,
    dmMemoria.mtPermisosUsuarioTIENE.AsBoolean);
  MostrarResumen;
end;

function TfrmUsuario.RolEscogido: Integer;
begin
  Result := dmMemoria.mtUsuarioROL_ID.AsInteger;
end;

function TfrmUsuario.CambioRol: Boolean;
begin
  Result := FPresentador.CambioRol(RolEscogido);
end;

procedure TfrmUsuario.cbRolClick(Sender: TObject);
begin
  lblAviso.Visible := CambioRol and (FPresentador.Adicionales > 0);
  if lblAviso.Visible then
    lblAviso.Caption := Format(SAvisoCambioRol, [FPresentador.Adicionales]);
  MostrarResumen;
end;

function TfrmUsuario.ValidarCampos: Boolean;
begin
  Result := False;
  if dmMemoria.mtUsuarioNOMBRE.AsString.Trim.IsEmpty then
  begin
    MostrarError(SFaltaNombreUsuario);
    edNombre.SetFocus;
    Exit;
  end;
  if dmMemoria.mtUsuarioCORREO.AsString.Trim.IsEmpty then
  begin
    MostrarError(SCorreoInvalido);
    edCorreo.SetFocus;
    Exit;
  end;
  if RolEscogido = 0 then
  begin
    MostrarError(SFaltaRol);
    cbRol.SetFocus;
    Exit;
  end;
  Result := True;
end;

procedure TfrmUsuario.btnGuardarClick(Sender: TObject);
var
  lDatos: TUsuarioEdicionDTO;
  lConPermisos: Boolean;
  lMotivo: string;
begin
  dmMemoria.Confirmar(dmMemoria.mtUsuario);
  if not ValidarCampos then
    Exit;

  lConPermisos := FPresentador.GuardaPermisos(RolEscogido);
  lDatos := TMapeoDatos.ADto<TUsuarioEdicionDTO>(dmMemoria.mtUsuario);
  if not FPresentador.HayCambios(lDatos, lConPermisos) then
  begin
    lDatos.Free;
    ModalResult := mrCancel;
    Exit;
  end;

  lMotivo := '';
  if lConPermisos and not TfrmMotivo.Pedir(Self, SMotivoPermisosTitulo,
    SMotivoPermisosAyuda, SBotonGuardar, lMotivo) then
  begin
    lDatos.Free;
    Exit;
  end;

  FPresentador.Guardar(lDatos, lMotivo, lConPermisos);
end;

procedure TfrmUsuario.Guardado;
begin
  FGuardado := True;
  ModalResult := mrOk;
end;

end.
