unit Anovo.Presentadores.SolicitudesAsistente;

// Presentador de las solicitudes del asistente: la cola comun,
// las que tomo y la accion de tomar.

interface

uses
  Anovo.Api.Intf.Solicitudes,
  Anovo.Api.Intf.Cotizaciones,
  Anovo.Cancelacion,
  Anovo.Vistas.Intf.SolicitudesAsistente;

type
  TPresentadorSolicitudesAsistente = class
  private
    FVista: IVistaSolicitudesAsistente;
    FApi: IApiSolicitudes;
    FCotizaciones: IApiCotizaciones;
    FCancelacion: ICancelacion;
    FModo: TModoSolicitudes;
    FTexto: string;
    FPagina: Integer;
    FTotalPaginas: Integer;
    FSolicitud: Integer;
    procedure Cargar;
  public
    constructor Create(const AVista: IVistaSolicitudesAsistente;
      const AApi: IApiSolicitudes; const ACotizaciones: IApiCotizaciones);
    destructor Destroy; override;
    procedure Iniciar;
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
  System.Classes,
  System.Threading,
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.DTOs.Dashboard,
  Anovo.DTOs.Solicitudes,
  Anovo.Mensajes,
  Anovo.Textos;

constructor TPresentadorSolicitudesAsistente.Create(const AVista
  : IVistaSolicitudesAsistente; const AApi: IApiSolicitudes;
  const ACotizaciones: IApiCotizaciones);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCotizaciones := ACotizaciones;
  FCancelacion := TCancelacion.Create;
  FPagina := 1;
end;

destructor TPresentadorSolicitudesAsistente.Destroy;
begin
  FCancelacion.Cancelar;
  inherited;
end;

procedure TPresentadorSolicitudesAsistente.Iniciar;
begin
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

procedure TPresentadorSolicitudesAsistente.Cargar;
var
  lCancelacion: ICancelacion;
  lApi: IApiSolicitudes;
  lNumero: Integer;
  lModo: TModoSolicitudes;
  lTexto: string;
  lPagina: Integer;
begin
  Inc(FSolicitud);
  lNumero := FSolicitud;
  lCancelacion := FCancelacion;
  lApi := FApi;
  lModo := FModo;
  lTexto := FTexto;
  lPagina := FPagina;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lCola: TObjectList<TSolicitudPorCotizarDTO>;
      lPropias: TObjectList<TSolicitudEnTrabajoDTO>;
      lTotal: Int64;
      lError: string;
    begin
      lCola := nil;
      lPropias := nil;
      lTotal := 0;
      lError := '';
      try
        if lModo = msCola then
          lCola := lApi.Cola(lTexto, lPagina, SOLICITUDES_POR_PAGINA, lTotal)
        else
          lPropias := lApi.EnTrabajo(lTexto, lPagina, SOLICITUDES_POR_PAGINA,
            lTotal);
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := Format(SErrorInesperado, [SAccionCargarSolicitudes]);
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

            FTotalPaginas := (lTotal + SOLICITUDES_POR_PAGINA - 1) div
              SOLICITUDES_POR_PAGINA;
            if lModo = msCola then
              FVista.MostrarCola(lCola)
            else
              FVista.MostrarEnTrabajo(lPropias);
            FVista.MostrarPaginacion(lPagina, FTotalPaginas, lTotal);
          finally
            lPropias.Free;
            lCola.Free;
          end;
        end);
    end);
end;

procedure TPresentadorSolicitudesAsistente.Tomar(const ASolicitudId: Integer);
var
  lCancelacion: ICancelacion;
  lApi: IApiCotizaciones;
begin
  if ASolicitudId <= 0 then
    Exit;
  lCancelacion := FCancelacion;
  lApi := FCotizaciones;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lError: string;
    begin
      lError := '';
      try
        lApi.Tomar(ASolicitudId);
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := Format(SErrorInesperado, [SAccionTomarSolicitud]);
      end;

      TThread.Queue(nil,
        procedure
        begin
          if lCancelacion.Cancelada then
            Exit;

          FVista.MostrarCargando(False);
          AvisarCambioEnAvisos;
          if not lError.IsEmpty then
          begin
            FVista.MostrarError(lError);
            Cargar;
            Exit;
          end;

          FModo := msEnTrabajo;
          FPagina := 1;
          FVista.MostrarModo(FModo);
          Cargar;
        end);
    end);
end;

end.
