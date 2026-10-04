unit Anovo.Presentadores.SolicitudesAsistente;

// Presentador de las solicitudes del asistente: la cola comun,
// las que tomo y la accion de tomar.

interface

uses
  Anovo.Api.Intf.Solicitudes,
  Anovo.Api.Intf.Cotizaciones,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.SolicitudesAsistente,
  Anovo.Permisos;

type
  TPresentadorSolicitudesAsistente = class(TPresentadorBase)
  private
    FVista: IVistaSolicitudesAsistente;
    FApi: IApiSolicitudes;
    FCotizaciones: IApiCotizaciones;
    FModo: TModoSolicitudes;
    FTexto: string;
    FPagina: Integer;
    FTotalPaginas: Integer;
    procedure Cargar;
    procedure MostrarPagina(const APagina: Integer; const ATotal: Int64);
    procedure MostrarError(AMensaje: string);
    procedure MostrarCargando(AActivo: Boolean);
  public
    constructor Create(const AVista: IVistaSolicitudesAsistente;
      const AApi: IApiSolicitudes; const ACotizaciones: IApiCotizaciones);
    procedure Iniciar;
    class function AccionesPermitidas: TAccionesCola;
    procedure CambiarModo(const AModo: TModoSolicitudes);
    procedure Buscar(const ATexto: string);
    procedure Limpiar;
    procedure IrAPagina(const APagina: Integer);
    procedure PaginaSiguiente;
    procedure PaginaAnterior;
    procedure Tomar(const ASolicitudId: Integer);
  end;

const
  SOLICITUDES_POR_PAGINA = 50;

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
  Anovo.DTOs.Dashboard,
  Anovo.DTOs.Solicitudes,
  Anovo.Mensajes,
  Anovo.Sesion,
  Anovo.Textos;

constructor TPresentadorSolicitudesAsistente.Create(const AVista
  : IVistaSolicitudesAsistente; const AApi: IApiSolicitudes;
  const ACotizaciones: IApiCotizaciones);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCotizaciones := ACotizaciones;
  FPagina := 1;
end;

class function TPresentadorSolicitudesAsistente.AccionesPermitidas
  : TAccionesCola;
begin
  Result := [];
  if TSesion.Tiene(PERMISO_COTIZACIONES_ELABORAR) then
    Include(Result, acTomar);
end;

procedure TPresentadorSolicitudesAsistente.Iniciar;
begin
  FVista.MostrarAcciones(AccionesPermitidas);
  FVista.MostrarModo(FModo);
  FVista.MostrarBusqueda('', False);
  Cargar;
end;

procedure TPresentadorSolicitudesAsistente.CambiarModo(const AModo
  : TModoSolicitudes);
begin
  if AModo = FModo then
    Exit;
  FModo := AModo;
  FPagina := 1;
  FVista.MostrarModo(FModo);
  Cargar;
end;

procedure TPresentadorSolicitudesAsistente.Buscar(const ATexto: string);
begin
  FTexto := ATexto.Trim;
  FPagina := 1;
  FVista.MostrarBusqueda(FTexto, not FTexto.IsEmpty);
  Cargar;
end;

procedure TPresentadorSolicitudesAsistente.Limpiar;
begin
  Buscar('');
end;

procedure TPresentadorSolicitudesAsistente.IrAPagina(const APagina: Integer);
begin
  if (APagina < 1) or ((FTotalPaginas > 0) and (APagina > FTotalPaginas)) then
    Exit;
  FPagina := APagina;
  Cargar;
end;

procedure TPresentadorSolicitudesAsistente.PaginaSiguiente;
begin
  IrAPagina(FPagina + 1);
end;

procedure TPresentadorSolicitudesAsistente.PaginaAnterior;
begin
  IrAPagina(FPagina - 1);
end;

procedure TPresentadorSolicitudesAsistente.MostrarPagina(const APagina
  : Integer; const ATotal: Int64);
begin
  FTotalPaginas := (ATotal + SOLICITUDES_POR_PAGINA - 1) div
    SOLICITUDES_POR_PAGINA;
  FVista.MostrarPaginacion(APagina, FTotalPaginas, ATotal);
end;

procedure TPresentadorSolicitudesAsistente.MostrarError(AMensaje: string);
begin
  FVista.MostrarError(AMensaje);
end;

procedure TPresentadorSolicitudesAsistente.MostrarCargando(AActivo: Boolean);
begin
  FVista.MostrarCargando(AActivo);
end;

procedure TPresentadorSolicitudesAsistente.Cargar;
var
  lApi: IApiSolicitudes;
  lTexto: string;
  lPagina: Integer;
  lTotal: Int64;
begin
  lApi := FApi;
  lTexto := FTexto;
  lPagina := FPagina;
  lTotal := 0;

  if FModo = msCola then
    EjecutarUltima<TObjectList<TSolicitudPorCotizarDTO>>
      (SAccionCargarSolicitudes,
      function: TObjectList<TSolicitudPorCotizarDTO>
      begin
        Result := lApi.Cola(lTexto, lPagina, SOLICITUDES_POR_PAGINA, lTotal);
      end,
      procedure(ALista: TObjectList<TSolicitudPorCotizarDTO>)
      begin
        FVista.MostrarCola(ALista);
        MostrarPagina(lPagina, lTotal);
      end, MostrarError, MostrarCargando)
  else
    EjecutarUltima<TObjectList<TSolicitudEnTrabajoDTO>>
      (SAccionCargarSolicitudes,
      function: TObjectList<TSolicitudEnTrabajoDTO>
      begin
        Result := lApi.EnTrabajo(lTexto, lPagina, SOLICITUDES_POR_PAGINA,
          lTotal);
      end,
      procedure(ALista: TObjectList<TSolicitudEnTrabajoDTO>)
      begin
        FVista.MostrarEnTrabajo(ALista);
        MostrarPagina(lPagina, lTotal);
      end, MostrarError, MostrarCargando);
end;

procedure TPresentadorSolicitudesAsistente.Tomar(const ASolicitudId: Integer);
var
  lApi: IApiCotizaciones;
begin
  if (ASolicitudId <= 0) or not (acTomar in AccionesPermitidas) then
    Exit;
  lApi := FCotizaciones;

  Ejecutar(SAccionTomarSolicitud,
    procedure
    begin
      lApi.Tomar(ASolicitudId);
    end,
    procedure
    begin
      AvisarCambioEnAvisos;
      FModo := msEnTrabajo;
      FPagina := 1;
      FVista.MostrarModo(FModo);
      Cargar;
    end,
    procedure(AMensaje: string)
    begin
      AvisarCambioEnAvisos;
      FVista.MostrarError(AMensaje);
      Cargar;
    end, MostrarCargando);
end;

end.
