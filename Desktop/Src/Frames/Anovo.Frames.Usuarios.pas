unit Anovo.Frames.Usuarios;

// Seccion Gestion de usuarios: cuentas, clave temporal y acceso a los
// permisos adicionales de cada persona.

interface

uses
  Anovo.UI.DBGridExtend,
  System.UITypes,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  VclPlano.BotonWin, Vcl.WinXCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.Pestanas,
  Anovo.Frames.Listado,
  Anovo.DTOs.Usuarios,
  Anovo.Vistas.Intf.Usuarios,
  Anovo.Presentadores.Usuarios;

type
  TfraUsuarios = class(TfraListado, IVistaUsuarios)
    btnExportar: TPlanoBotonWin;
    btnNuevo: TPlanoBotonWin;
    pstFiltros: TPlanoPestanas;
    procedure pstFiltrosChange(Sender: TObject);
    procedure btnNuevoClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
  private
    FPresentador: TPresentadorUsuarios;
    procedure Accion(Sender: TObject; const AClave: string);
    procedure MostrarAcciones(const AAcciones: TAccionesUsuario;
      const APuedeCrear: Boolean);
    procedure MostrarUsuarios(const AUsuarios: TObjectList<TUsuarioDTO>);
    function Confirmar(const AMensaje: string): Boolean;
    procedure AbrirUsuario(const AId: Integer);
  protected
    procedure Buscar(const ATexto: string); override;
    procedure Limpiar; override;
    procedure PaginaAnterior; override;
    procedure PaginaSiguiente; override;
    procedure MostrarCargando(const AActivo: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  rDBExport,
  Anovo.Api.Usuarios,
  Anovo.Forms.Usuario,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.UI.Vista,
  Anovo.Textos;

const
  CAMPO_ACCIONES = 'ACCIONES';
  CAMPO_ESTADO = 'ESTADO';

  CAMPO_ACTIVO = 'ACTIVO';

  ACCIONES: array [TAccionUsuario] of TAccionRejilla = ((Clave: 'editar';
    Rotulo: 'Editar'), (Clave: 'estado'; Rotulo: 'Inactivar';
    Alterno: 'Activar'; Campo: CAMPO_ACTIVO));

constructor TfraUsuarios.Create(AOwner: TComponent);
var
  lRejilla: TDBGridExtend;
begin
  inherited Create(AOwner);
  FTextoCargando := SCargandoUsuarios;
  FTextoSinRegistros := SSinUsuarios;
  FTextoPaginacion := SPaginacionUsuarios;

  lRejilla := TDBGridExtend.De(grDatos);
  lRejilla.ColumnaEstado(CAMPO_ESTADO);
  lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
  lRejilla.OnAccion := Accion;

  FPresentador := TPresentadorUsuarios.Create(Self, TApiUsuarios.Create);
  FPresentador.Iniciar;
end;

destructor TfraUsuarios.Destroy;
begin
  FPresentador.Free;
  inherited;
end;

procedure TfraUsuarios.Buscar(const ATexto: string);
begin
  FPresentador.Buscar(ATexto);
end;

procedure TfraUsuarios.Limpiar;
begin
  FPresentador.Limpiar;
end;

procedure TfraUsuarios.PaginaAnterior;
begin
  FPresentador.PaginaAnterior;
end;

procedure TfraUsuarios.PaginaSiguiente;
begin
  FPresentador.PaginaSiguiente;
end;

procedure TfraUsuarios.MostrarAcciones(const AAcciones: TAccionesUsuario;
  const APuedeCrear: Boolean);
begin
  btnNuevo.Visible := APuedeCrear;
  TDBGridExtend.De(grDatos).PonerAcciones<TAccionesUsuario>(ACCIONES,
    AAcciones);
end;

procedure TfraUsuarios.MostrarCargando(const AActivo: Boolean);
begin
  inherited;
  pstFiltros.Enabled := not AActivo;
end;

procedure TfraUsuarios.MostrarUsuarios(const AUsuarios
  : TObjectList<TUsuarioDTO>);
begin
  TMapeoDatos.AListaTabla<TUsuarioDTO>(AUsuarios, dmMemoria.mtUsuarios);
end;

function TfraUsuarios.Confirmar(const AMensaje: string): Boolean;
begin
  Result := Anovo.UI.Vista.Confirmar(AMensaje);
end;

procedure TfraUsuarios.AbrirUsuario(const AId: Integer);
begin
  if TfrmUsuario.Mostrar(Self, AId) then
    FPresentador.Recargar;
end;

procedure TfraUsuarios.Accion(Sender: TObject; const AClave: string);
var
  lId: Integer;
  lNombre: string;
begin
  if dmMemoria.mtUsuarios.IsEmpty then
    Exit;
  lId := dmMemoria.mtUsuariosID.AsInteger;
  lNombre := dmMemoria.mtUsuariosNOMBRE.AsString;

  if SameText(AClave, ACCIONES[auEditar].Clave) then
    FPresentador.Editar(lId)
  else if SameText(AClave, ACCIONES[auEstado].Clave) then
    FPresentador.CambiarEstado(lId, lNombre,
      dmMemoria.mtUsuariosACTIVO.AsBoolean);
end;

procedure TfraUsuarios.pstFiltrosChange(Sender: TObject);
begin
  if FPresentador = nil then
    Exit;
  FPresentador.Filtrar(TFiltroUsuarios(pstFiltros.ItemIndex));
end;

procedure TfraUsuarios.btnExportarClick(Sender: TObject);
begin
  rDBExport.DBExport(grDatos, True, True);
end;

procedure TfraUsuarios.btnNuevoClick(Sender: TObject);
begin
  if TfrmUsuario.Mostrar(Self, 0) then
    FPresentador.Recargar;
end;

end.
