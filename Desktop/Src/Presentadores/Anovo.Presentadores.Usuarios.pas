unit Anovo.Presentadores.Usuarios;

// Presentador de Gestion de usuarios: listado, edicion y activar o
// inactivar, sin acciones sobre la cuenta propia.

interface

uses
  System.SysUtils,
  Anovo.Api.Intf.Usuarios,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.Usuarios,
  Anovo.Permisos;

type
  TPresentadorUsuarios = class(TPresentadorBase)
  private
    FVista: IVistaUsuarios;
    FApi: IApiUsuarios;
    FTexto: string;
    FFiltro: TFiltroUsuarios;
    FPagina: Integer;
    FTotalPaginas: Integer;
    procedure Cargar;
    procedure MostrarError(AMensaje: string);
    procedure MostrarCargando(AActivo: Boolean);
  public
    constructor Create(const AVista: IVistaUsuarios;
      const AApi: IApiUsuarios);
    procedure Iniciar;
    procedure Recargar;
    procedure Buscar(const ATexto: string);
    procedure Limpiar;
    procedure Filtrar(const AFiltro: TFiltroUsuarios);
    procedure IrAPagina(const APagina: Integer);
    procedure PaginaSiguiente;
    procedure PaginaAnterior;
    procedure Editar(const AId: Integer);
    procedure CambiarEstado(const AId: Integer; const ANombre: string;
      const AEstaActivo: Boolean);
    class function AccionesPermitidas: TAccionesUsuario;
    class function PuedeCrear: Boolean;
  end;

const
  USUARIOS_POR_PAGINA = 50;

implementation

uses
  System.Generics.Collections,
  Anovo.DTOs.Usuarios,
  Anovo.Sesion,
  Anovo.Textos;

const
  ESTADO_API: array [TFiltroUsuarios] of string = ('', 'activos', 'inactivos',
    'clave_pendiente', 'con_adicionales');

constructor TPresentadorUsuarios.Create(const AVista: IVistaUsuarios;
  const AApi: IApiUsuarios);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FPagina := 1;
end;

class function TPresentadorUsuarios.AccionesPermitidas: TAccionesUsuario;
begin
  Result := [auEditar, auEstado];
end;

class function TPresentadorUsuarios.PuedeCrear: Boolean;
begin
  Result := TSesion.Tiene(PERMISO_USUARIOS_ADMINISTRAR);
end;

procedure TPresentadorUsuarios.Iniciar;
begin
  FVista.MostrarAcciones(AccionesPermitidas, PuedeCrear);
  FVista.MostrarBusqueda('', False);
  Cargar;
end;

procedure TPresentadorUsuarios.Recargar;
begin
  Cargar;
end;

procedure TPresentadorUsuarios.Buscar(const ATexto: string);
begin
  FTexto := ATexto.Trim;
  FPagina := 1;
  FVista.MostrarBusqueda(FTexto, not FTexto.IsEmpty);
  Cargar;
end;

procedure TPresentadorUsuarios.Limpiar;
begin
  Buscar('');
end;

procedure TPresentadorUsuarios.Filtrar(const AFiltro: TFiltroUsuarios);
begin
  FFiltro := AFiltro;
  FPagina := 1;
  Cargar;
end;

procedure TPresentadorUsuarios.IrAPagina(const APagina: Integer);
begin
  if (APagina < 1) or ((FTotalPaginas > 0) and (APagina > FTotalPaginas)) then
    Exit;
  FPagina := APagina;
  Cargar;
end;

procedure TPresentadorUsuarios.PaginaSiguiente;
begin
  IrAPagina(FPagina + 1);
end;

procedure TPresentadorUsuarios.PaginaAnterior;
begin
  IrAPagina(FPagina - 1);
end;

procedure TPresentadorUsuarios.Editar(const AId: Integer);
begin
  if AId > 0 then
    FVista.AbrirUsuario(AId);
end;

procedure TPresentadorUsuarios.MostrarError(AMensaje: string);
begin
  FVista.MostrarError(AMensaje);
end;

procedure TPresentadorUsuarios.MostrarCargando(AActivo: Boolean);
begin
  FVista.MostrarCargando(AActivo);
end;

procedure TPresentadorUsuarios.CambiarEstado(const AId: Integer;
  const ANombre: string; const AEstaActivo: Boolean);
var
  lApi: IApiUsuarios;
  lMensaje: string;
begin
  if AId <= 0 then
    Exit;
  if AEstaActivo and (AId = TSesion.UsuarioId) then
  begin
    FVista.MostrarError(Format(SSinPermiso, [SAccionInactivarPropiaCuenta]));
    Exit;
  end;

  if AEstaActivo then
    lMensaje := Format(SConfirmarInactivarUsuario, [ANombre])
  else
    lMensaje := Format(SConfirmarActivarUsuario, [ANombre]);
  if not FVista.Confirmar(lMensaje) then
    Exit;

  lApi := FApi;
  Ejecutar(SAccionCambiarEstadoUsuario,
    procedure
    begin
      if AEstaActivo then
        lApi.Inactivar(AId)
      else
        lApi.Activar(AId);
    end,
    procedure
    begin
      Cargar;
    end, MostrarError, MostrarCargando);
end;

procedure TPresentadorUsuarios.Cargar;
var
  lApi: IApiUsuarios;
  lTexto, lEstado: string;
  lPagina: Integer;
  lTotal: Int64;
begin
  lApi := FApi;
  lTexto := FTexto;
  lEstado := ESTADO_API[FFiltro];
  lPagina := FPagina;
  lTotal := 0;

  EjecutarUltima<TObjectList<TUsuarioDTO>>(SAccionCargarUsuarios,
    function: TObjectList<TUsuarioDTO>
    begin
      Result := lApi.Buscar(lTexto, lEstado, lPagina, USUARIOS_POR_PAGINA,
        lTotal);
    end,
    procedure(ALista: TObjectList<TUsuarioDTO>)
    begin
      FTotalPaginas := (lTotal + USUARIOS_POR_PAGINA - 1) div
        USUARIOS_POR_PAGINA;
      FVista.MostrarUsuarios(ALista);
      FVista.MostrarPaginacion(lPagina, FTotalPaginas, lTotal);
    end, MostrarError, MostrarCargando);
end;

end.
