unit Anovo.Presentadores.SolicitudesAsesor;

// Presentador de la seccion Solicitudes del asesor.

interface

uses
  Anovo.Api.Intf.Solicitudes,
  Anovo.Cancelacion,
  Anovo.Vistas.Intf.SolicitudesAsesor;

type
  TPresentadorSolicitudesAsesor = class
  private
    FVista: IVistaSolicitudesAsesor;
    FApi: IApiSolicitudes;
    FCancelacion: ICancelacion;
    FTexto: string;
    FHistorial: Boolean;
    FPagina: Integer;
    FTotalPaginas: Integer;
    FSolicitud: Integer;
    procedure Cargar;
  public
    constructor Create(const AVista: IVistaSolicitudesAsesor;
      const AApi: IApiSolicitudes);
    destructor Destroy; override;
    procedure Iniciar;
    procedure Buscar(const ATexto: string);
    procedure Limpiar;
    procedure VerHistorial(const AHistorial: Boolean);
    procedure IrAPagina(const APagina: Integer);
    procedure PaginaSiguiente;
    procedure PaginaAnterior;
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
  Anovo.Textos;

function MensajeInesperado: string;
begin
  Result := Format(SErrorInesperado, [SAccionCargarSolicitudes]);
end;

constructor TPresentadorSolicitudesAsesor.Create(const AVista: IVistaSolicitudesAsesor;
  const AApi: IApiSolicitudes);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCancelacion := TCancelacion.Create;
  FHistorial := False;
  FPagina := 1;
end;

destructor TPresentadorSolicitudesAsesor.Destroy;
begin
  FCancelacion.Cancelar;
  inherited;
end;

procedure TPresentadorSolicitudesAsesor.Iniciar;
begin
  FVista.MostrarBusqueda('', False);
  Cargar;
end;

procedure TPresentadorSolicitudesAsesor.Buscar(const ATexto: string);
begin
  FTexto := Trim(ATexto);
  FPagina := 1;
  FVista.MostrarBusqueda(FTexto, not FTexto.IsEmpty);
  Cargar;
end;

procedure TPresentadorSolicitudesAsesor.Limpiar;
begin
  Buscar('');
end;

procedure TPresentadorSolicitudesAsesor.VerHistorial(const AHistorial: Boolean);
begin
  if AHistorial = FHistorial then
    Exit;
  FHistorial := AHistorial;
  FPagina := 1;
  Cargar;
end;

procedure TPresentadorSolicitudesAsesor.IrAPagina(const APagina: Integer);
begin
  if (APagina < 1) or ((FTotalPaginas > 0) and (APagina > FTotalPaginas)) then
    Exit;
  FPagina := APagina;
  Cargar;
end;

procedure TPresentadorSolicitudesAsesor.PaginaSiguiente;
begin
  IrAPagina(FPagina + 1);
end;

procedure TPresentadorSolicitudesAsesor.PaginaAnterior;
begin
  IrAPagina(FPagina - 1);
end;

procedure TPresentadorSolicitudesAsesor.Cargar;
var
  lCancelacion: ICancelacion;
  lApi: IApiSolicitudes;
  lNumero, lPagina: Integer;
  lTexto: string;
  lHistorial: Boolean;
begin
  Inc(FSolicitud);
  lNumero := FSolicitud;
  lCancelacion := FCancelacion;
  lApi := FApi;
  lTexto := FTexto;
  lPagina := FPagina;
  lHistorial := FHistorial;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lLista: TObjectList<TSolicitudAsesorDTO>;
      lTotal: Int64;
      lDesde: TDateTime;
      lError: string;
    begin
      lLista := nil;
      lTotal := 0;
      lDesde := 0;
      lError := '';
      try
        lLista := lApi.Seguimiento(lTexto, lHistorial, lPagina,
          SOLICITUDES_POR_PAGINA, lTotal, lDesde);
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := MensajeInesperado;
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
            FVista.MostrarPeriodo(lHistorial, lDesde);
            FVista.MostrarSolicitudes(lLista);
            FVista.MostrarPaginacion(lPagina, FTotalPaginas, lTotal);
          finally
            lLista.Free;
          end;
        end);
    end);
end;

end.
