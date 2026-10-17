unit Anovo.Forms.Usuario;

// Ventana de un usuario: datos de la cuenta, clave temporal, telefonos y
// permisos adicionales o quitados sobre el paquete basico de su rol.

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
  Anovo.Presentadores.Usuario, Vcl.Mask, Vcl.WinXCtrls, Anovo.UI.PanelRelativo,
  Anovo.Permisos;

type
  TfrmUsuario = class(TfrmEdicion, IVistaUsuario)
    pnlAvatar: TPanel;
    lblIniciales: TLabel;
    pstEstado: TPlanoPastilla;
    pstSecciones: TPlanoPestanas;
    cpUsuario: TCardPanel;
    crdDatos: TCard;
    edNombre: TrDBEdit;
    edCorreo: TrDBEdit;
    cbRol: TrDBLookupComboBox;
    lblPaquete: TLabel;
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
    pnlResumen: TPanel;
    pstDelRol: TPlanoPastilla;
    pstAdicionales: TPlanoPastilla;
    pstQuitados: TPlanoPastilla;
    pstSinGuardar: TPlanoPastilla;
    chkSoloExcepciones: TCheckBox;
    lblResumen: TLabel;
    grPermisos: TrDBGrid;
    crdTelefonos: TCard;
    lblTelefonosNota: TLabel;
    grTelefonos: TrDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure cbRolClick(Sender: TObject);
    procedure grPermisosCanEdit(Sender: TObject; Field: TField;
      Column: TColumn; var CanEdit: Boolean);
    procedure grPermisosBoolClick(Sender: TObject; DataSet: TDataSet;
      Column: TColumn; Field: TField; Value: Variant);
    procedure btnGenerarClick(Sender: TObject);
    procedure btnCopiarClick(Sender: TObject);
    procedure btnPedirCambioClick(Sender: TObject);
    procedure chkSoloExcepcionesClick(Sender: TObject);
    procedure grPermisosGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; ActiveRow, Highlight: Boolean);
    procedure grTelefonosCanEdit(Sender: TObject; Field: TField;
      Column: TColumn; var CanEdit: Boolean);
    procedure grTelefonosBoolClick(Sender: TObject; DataSet: TDataSet;
      Column: TColumn; Field: TField; Value: Variant);
  private
    FPresentador: TPresentadorUsuario;
    FId: Integer;
    FGuardado: Boolean;
    FPropia: Boolean;
    FFechaClave: string;
    procedure PonerClaveNueva;
    procedure MostrarClave;
    procedure MostrarPaquete;
    procedure MostrarSiHayPermisos;
    function RolEscogido: Integer;
    function CambioRol: Boolean;
    function ValidarCampos: Boolean;
    procedure MostrarResumen;
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarRoles(const ARoles: TObjectList<TRolDTO>);
    procedure MostrarUsuario(const AUsuario: TUsuarioDTO);
    procedure MostrarPermisos(const AFilas: TObjectList<TFilaPermiso>);
    procedure MostrarTelefonos(const AFilas: TObjectList<TFilaTelefono>);
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
  Anovo.UI.CeldasRejilla,
  Anovo.UI.Tema,
  Anovo.Formato,
  Anovo.Sesion,
  Anovo.Textos;

const
  CAMPO_ORIGEN = 'ORIGEN';
  CAMPO_ESTADO = 'ESTADO';
  PESTANA_PERMISOS = 2;

class function TfrmUsuario.Mostrar(AOwner: TComponent;
  const AId: Integer): Boolean;
var
  lForma: TfrmUsuario;
begin
  lForma := TfrmUsuario.Create(AOwner);
  try
    lForma.FId := AId;
    lForma.FPropia := TPresentadorUsuario.EsCuentaPropia(AId);
    if AId = 0 then
    begin
      lForma.lblTitulo.Caption := SNuevoUsuarioTitulo;
      lForma.lblSubtitulo.Caption := SNuevoUsuarioAyuda;
      lForma.lblIniciales.Caption := SIconoNuevo;
      lForma.pstEstado.Visible := False;
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
  lRejilla: TCeldasRejilla;
begin
  AplicarTemaGrid(grPermisos);
  EditarCasillas(grPermisos);
  lRejilla := TCeldasRejilla.De(grPermisos);
  lRejilla.ColumnaEstado(CAMPO_ORIGEN);
  AplicarTemaGrid(grTelefonos);
  EditarCasillas(grTelefonos);
  TCeldasRejilla.De(grTelefonos).ColumnaEstado(CAMPO_ESTADO);
  lblTelefonosNota.Caption := STelefonosNota;
  pstSecciones.Items[1] := SPestanaTelefonos;
  dmMemoria.mtTelefonos.Close;
  dmMemoria.SoloExcepciones(False);
  dmMemoria.mtPermisosUsuario.Close;
  dmMemoria.mtUsuario.Close;
  lblAviso.Visible := False;
  lblPaquete.Visible := False;
  lblResumen.Visible := False;
  chkSoloExcepciones.Caption := SSoloExcepciones;
  FPresentador := TPresentadorUsuario.Create(Self, TApiUsuarios.Create,
    TApiRoles.Create);
end;

procedure TfrmUsuario.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPresentador);
  dmMemoria.SoloExcepciones(False);
  dmMemoria.mtUsuario.Close;
  dmMemoria.mtRoles.Close;
  dmMemoria.mtPermisosUsuario.Close;
  dmMemoria.mtTelefonos.Close;
end;

function TfrmUsuario.ControlesEdicion: TArray<TControl>;
begin
  Result := [cpUsuario, pstSecciones];
end;

procedure TfrmUsuario.MostrarCargando(const AActivo: Boolean);
begin
  MostrarOcupado(AActivo);
end;

procedure TfrmUsuario.MostrarRoles(const ARoles: TObjectList<TRolDTO>);
begin
  TMapeoDatos.AListaTabla<TRolDTO>(ARoles, dmMemoria.mtRoles);
end;

procedure TfrmUsuario.MostrarUsuario(const AUsuario: TUsuarioDTO);
begin
  TMapeoDatos.ATabla(AUsuario, dmMemoria.mtUsuario);
  lblTitulo.Caption := AUsuario.Nombre;
  lblSubtitulo.Caption := Format(SCorreoYRol, [AUsuario.Correo,
    AUsuario.RolNombre]);
  lblIniciales.Caption := InicialesDe(AUsuario.Nombre);
  if AUsuario.Activo then
  begin
    pstEstado.Status := fsSuccess;
    pstEstado.Caption := SEstActivo;
  end
  else
  begin
    pstEstado.Status := fsDanger;
    pstEstado.Caption := SEstInactivo;
  end;
  pstEstado.Left := lblTitulo.Left + lblTitulo.Width + 10;
  if not TPresentadorUsuario.MuestraPermisos(FId) then
  begin
    if pstSecciones.Items.Count > PESTANA_PERMISOS then
      pstSecciones.Items.Delete(PESTANA_PERMISOS);
  end
  else
    pstSecciones.Items[PESTANA_PERMISOS] :=
      TPresentadorUsuario.RotuloPermisos(AUsuario.Excepciones);
  cbRol.Enabled := not FPropia;
  lblFechas.Caption := Format(SUsuarioRegistrado,
    [TFormato.FechaHora(AUsuario.FechaCreacion.ValueOrDefault)]);
  FFechaClave := '';
  if AUsuario.FechaClave.HasValue then
    FFechaClave := TFormato.FechaHora(AUsuario.FechaClave.Value);

  pstSecciones.Visible := True;

  MostrarPaquete;
  MostrarClave;
end;

procedure TfrmUsuario.MostrarPaquete;
begin
  lblPaquete.Visible := RolEscogido > 0;
  if lblPaquete.Visible then
    lblPaquete.Caption := Format(SPaqueteBasico,
      [FPresentador.BasicosDelRol(RolEscogido)]);
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
  lEstado: TEstadoClave;
begin
  lEstado := FPresentador.EstadoClave(
    not dmMemoria.mtUsuarioCLAVE_TEMPORAL.AsString.IsEmpty, FFechaClave);
  edClave.Visible := lEstado.HayClave;
  btnCopiar.Visible := lEstado.HayClave;
  btnGenerar.Visible := lEstado.PuedeGenerar;
  btnGenerar.Caption := lEstado.RotuloGenerar;
  btnPedirCambio.Visible := lEstado.PuedePedirCambio;
  btnPedirCambio.Caption := lEstado.RotuloPedirCambio;
  pstClave.Visible := lEstado.ConPastilla;
  lblClaveEstado.Visible := lEstado.ConEstado;
  lblClaveNota.Visible := lEstado.ConNota;
  if lEstado.Pastilla <> '' then
  begin
    pstClave.Caption := lEstado.Pastilla;
    if lEstado.Pendiente then
      pstClave.Status := fsPending
    else
      pstClave.Status := fsInfo;
  end;
  if lEstado.Estado <> '' then
    lblClaveEstado.Caption := lEstado.Estado;
  if lEstado.Nota <> '' then
    lblClaveNota.Caption := lEstado.Nota;
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
  MostrarSiHayPermisos;
  MostrarResumen;
end;

procedure TfrmUsuario.MostrarSiHayPermisos;
begin
  if chkSoloExcepciones.Checked then
    TCeldasRejilla.De(grPermisos).TextoVacio := SSinExcepciones
  else
    TCeldasRejilla.De(grPermisos).TextoVacio := SSinPermisosParaMostrar;
end;

procedure TfrmUsuario.MostrarResumen;
var
  lAdicionales, lQuitados, lCambios: Integer;
begin
  if not dmMemoria.mtPermisosUsuario.Active then
    Exit;
  grPermisos.Enabled := not CambioRol;
  pnlResumen.Visible := not CambioRol;
  lblResumen.Visible := CambioRol;
  if CambioRol then
  begin
    lblResumen.Caption := SPermisosTrasCambioRol;
    Exit;
  end;

  lAdicionales := 0;
  lQuitados := 0;
  if not dmMemoria.mtPermisosUsuario.IsEmpty then
  begin
    lAdicionales := dmMemoria.mtPermisosUsuarioADICIONALES.Value;
    lQuitados := dmMemoria.mtPermisosUsuarioQUITADOS.Value;
  end;
  lCambios := FPresentador.CambiosDePermisos;

  pstDelRol.Caption := Format(SPastillaDelRol,
    [FPresentador.BasicosDelRol(RolEscogido)]);
  pstAdicionales.Caption := TFormato.Cantidad(lAdicionales, SUnAdicional,
    SVariosAdicionales);
  pstAdicionales.Visible := lAdicionales > 0;
  pstQuitados.Caption := TFormato.Cantidad(lQuitados, SUnQuitado,
    SVariosQuitados);
  pstQuitados.Visible := lQuitados > 0;
  pstSinGuardar.Caption := Format(SSinGuardarCantidad, [lCambios]);
  pstSinGuardar.Visible := lCambios > 0;
end;

procedure TfrmUsuario.chkSoloExcepcionesClick(Sender: TObject);
begin
  dmMemoria.SoloExcepciones(chkSoloExcepciones.Checked);
  MostrarSiHayPermisos;
  MostrarResumen;
end;

procedure TfrmUsuario.grPermisosGetCellParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; ActiveRow, Highlight: Boolean);
begin
  if not dmMemoria.PermisoSinGuardar then
    Exit;
  Background := clAnovoAvisoMedio;
  AFont.Style := AFont.Style + [fsBold];
end;

procedure TfrmUsuario.grPermisosCanEdit(Sender: TObject; Field: TField;
  Column: TColumn; var CanEdit: Boolean);
begin
  CanEdit := CanEdit and (Field = dmMemoria.mtPermisosUsuarioTIENE) and
    not dmMemoria.mtPermisosUsuario.IsEmpty and not CambioRol;
end;

procedure TfrmUsuario.grPermisosBoolClick(Sender: TObject; DataSet: TDataSet;
  Column: TColumn; Field: TField; Value: Variant);
begin
  dmMemoria.Confirmar(DataSet);
  FPresentador.MarcarPermiso(dmMemoria.mtPermisosUsuarioPERMISO_ID.AsInteger,
    Field.AsBoolean);
  MostrarResumen;
end;

procedure TfrmUsuario.MostrarTelefonos(const AFilas
  : TObjectList<TFilaTelefono>);
begin
  TMapeoDatos.AListaTabla<TFilaTelefono>(AFilas, dmMemoria.mtTelefonos);
  TCeldasRejilla.De(grTelefonos).TextoVacio := SSinTelefonos;
  TCeldasRejilla.De(grTelefonos).AjustarColumnas;
end;

procedure TfrmUsuario.grTelefonosCanEdit(Sender: TObject; Field: TField;
  Column: TColumn; var CanEdit: Boolean);
begin
  CanEdit := CanEdit and (Field = dmMemoria.mtTelefonosINACTIVAR) and
    not dmMemoria.mtTelefonos.IsEmpty and
    dmMemoria.mtTelefonosACTIVO.AsBoolean;
end;

procedure TfrmUsuario.grTelefonosBoolClick(Sender: TObject; DataSet: TDataSet;
  Column: TColumn; Field: TField; Value: Variant);
begin
  dmMemoria.Confirmar(DataSet);
  FPresentador.MarcarTelefono(dmMemoria.mtTelefonosID.AsInteger,
    Field.AsBoolean);
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
  MostrarPaquete;
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
