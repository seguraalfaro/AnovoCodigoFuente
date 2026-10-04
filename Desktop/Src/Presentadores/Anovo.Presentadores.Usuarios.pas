unit Anovo.Presentadores.Usuarios;

// Presentador de Gestion de usuarios: listado, edicion y activar o
// inactivar, sin acciones sobre la cuenta propia.

interface

uses
  System.SysUtils,
  Anovo.Api.Intf.Usuarios,
  Anovo.Cancelacion,
  Anovo.Vistas.Intf.Usuarios,
  Anovo.Permisos;

type
  TPresentadorUsuarios = class
  private
    FVista: IVistaUsuarios;
    FApi: IApiUsuarios;
    FCancelacion: ICancelacion;
    FTexto: string;
    FFiltro: TFiltroUsuarios;
    FPagina: Integer;
    FTotalPaginas: Integer;
    FSolicitud: Integer;
    procedure Cargar;
    procedure Ejecutar(const ALlamada: TProc; const AAccion: string);
  public
    constructor Create(const AVista: IVistaUsuarios;
      const AApi: IApiUsuarios);
    destructor Destroy; override;
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
  System.Classes,
  System.Threading,
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.DTOs.Usuarios,
  Anovo.Sesion,
  Anovo.Textos;

const

  ESTADO_API: array [TFiltroUsuarios] of string = ('', 'activos', 'inactivos',
    'clave_pendiente', 'con_adicionales');

function MensajeInesperado(const AAccion: string): string;
begin
  Result := Format(SErrorInesperado, [AAccion]);
end;

constructor TPresentadorUsuarios.Create(const AVista: IVistaUsuarios;
  const AApi: IApiUsuarios);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCancelacion := TCancelacion.Create;
  FPagina := 1;
end;

destructor TPresentadorUsuarios.Destroy;
begin
  FCancelacion.Cancelar;
  inherited;
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
  Ejecutar(
    procedure
    begin
      if AEstaActivo then
        lApi.Inactivar(AId)
      else
        lApi.Activar(AId);
    end, SAccionCambiarEstadoUsuario);
end;

procedure TPresentadorUsuarios.Ejecutar(const ALlamada: TProc;
  const AAccion: string);
var
  lCancelacion: ICancelacion;
begin
  lCancelacion := FCancelacion;
  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lError: string;
    begin
      lError := '';
      try
        ALlamada();
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := MensajeInesperado(AAccion);
      end;

      TThread.Queue(nil,
        procedure
        begin
          if lCancelacion.Cancelada then
            Exit;
          FVista.MostrarCargando(False);
          if not lError.IsEmpty then
          begin
            FVista.MostrarError(lError);
            Exit;
          end;
          Cargar;
        end);
    end);
end;

procedure TPresentadorUsuarios.Cargar;
var
  lCancelacion: ICancelacion;
  lApi: IApiUsuarios;
  lNumero: Integer;
  lTexto, lEstado: string;
  lPagina: Integer;
begin
  Inc(FSolicitud);
  lNumero := FSolicitud;
  lCancelacion := FCancelacion;
  lApi := FApi;
  lTexto := FTexto;
  lEstado := ESTADO_API[FFiltro];
  lPagina := FPagina;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lLista: TObjectList<TUsuarioDTO>;
      lTotal: Int64;
      lError: string;
    begin
      lLista := nil;
      lTotal := 0;
      lError := '';
      try
        lLista := lApi.Buscar(lTexto, lEstado, lPagina, USUARIOS_POR_PAGINA,
          lTotal);
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := MensajeInesperado(SAccionCargarUsuarios);
      end;

      TThread.Queue(nil,
        procedure
        begin
          try
            if lCancelacion.Cancelada or (lNumero <> FSolicitud) then
              Exit;

            FVista.MostrarCargando(False);
            if not lError.IsEmpty then
            begin
              FVista.MostrarError(lError);
              Exit;
            end;

            FTotalPaginas := (lTotal + USUARIOS_POR_PAGINA - 1) div
              USUARIOS_POR_PAGINA;
            FVista.MostrarUsuarios(lLista);
            FVista.MostrarPaginacion(lPagina, FTotalPaginas, lTotal);
          finally
            lLista.Free;
          end;
        end);
    end);
end;

end.
