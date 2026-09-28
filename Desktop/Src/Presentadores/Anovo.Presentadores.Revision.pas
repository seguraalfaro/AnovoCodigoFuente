unit Anovo.Presentadores.Revision;

// Presentador de la revision: carga la cotizacion y registra
// la decision del supervisor.

interface

uses
  Anovo.Api.Intf.Cotizaciones,
  Anovo.Cancelacion,
  Anovo.Vistas.Intf.Revision;

type
  TPresentadorRevision = class
  private
    FVista: IVistaRevision;
    FApi: IApiCotizaciones;
    FCancelacion: ICancelacion;
    FId: Integer;
    procedure Decidir(const ADecision: TDecision; const AMotivo: string);
  public
    constructor Create(const AVista: IVistaRevision;
      const AApi: IApiCotizaciones; const AId: Integer);
    destructor Destroy; override;
    procedure Iniciar;
    procedure Aprobar;
    procedure Devolver(const AMotivo: string);
    procedure Rechazar(const AMotivo: string);
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.Threading,
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.DTOs.Cotizaciones,
  Anovo.Mensajes,
  Anovo.Textos;

constructor TPresentadorRevision.Create(const AVista: IVistaRevision;
  const AApi: IApiCotizaciones; const AId: Integer);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FId := AId;
  FCancelacion := TCancelacion.Create;
end;

destructor TPresentadorRevision.Destroy;
begin
  FCancelacion.Cancelar;
  inherited;
end;

procedure TPresentadorRevision.Iniciar;
var
  lCancelacion: ICancelacion;
  lApi: IApiCotizaciones;
  lId: Integer;
begin
  lCancelacion := FCancelacion;
  lApi := FApi;
  lId := FId;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lCotizacion: TCotizacionDTO;
      lLineas: TObjectList<TLineaDTO>;
      lError: string;
    begin
      lCotizacion := nil;
      lLineas := nil;
      lError := '';
      try
        lCotizacion := lApi.Obtener(lId);
        lLineas := lApi.Detalle(lId);
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := Format(SErrorInesperado, [SAccionCargarCotizacion]);
      end;

      TThread.Queue(nil,
        procedure
        begin
          try
            if lCancelacion.Cancelada then
              Exit;

            FVista.MostrarCargando(False);
            if not lError.IsEmpty then
            begin
              FVista.MostrarError(lError);
              Exit;
            end;

            FVista.MostrarCotizacion(lCotizacion, lLineas);
          finally
            lLineas.Free;
            lCotizacion.Free;
          end;
        end);
    end);
end;

procedure TPresentadorRevision.Aprobar;
begin
  Decidir(dcAprobar, '');
end;

procedure TPresentadorRevision.Devolver(const AMotivo: string);
begin
  Decidir(dcDevolver, AMotivo);
end;

procedure TPresentadorRevision.Rechazar(const AMotivo: string);
begin
  Decidir(dcRechazar, AMotivo);
end;

procedure TPresentadorRevision.Decidir(const ADecision: TDecision;
  const AMotivo: string);
var
  lCancelacion: ICancelacion;
  lApi: IApiCotizaciones;
  lId: Integer;
  lMotivo: string;
begin
  lCancelacion := FCancelacion;
  lApi := FApi;
  lId := FId;
  lMotivo := AMotivo.Trim;

  FVista.MostrarProcesando(True);

  TTask.Run(
    procedure
    var
      lError: string;
    begin
      lError := '';
      try
        case ADecision of
          dcAprobar:
            lApi.Aprobar(lId);
          dcDevolver:
            lApi.Devolver(lId, lMotivo);
          dcRechazar:
            lApi.Rechazar(lId, lMotivo);
        end;
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := Format(SErrorInesperado, [SAccionRevisarCotizacion]);
      end;

      TThread.Queue(nil,
        procedure
        begin
          if lCancelacion.Cancelada then
            Exit;

          FVista.MostrarProcesando(False);
          if not lError.IsEmpty then
          begin
            FVista.MostrarError(lError);
            Exit;
          end;

          AvisarCambioEnAvisos;
          FVista.Revisada;
        end);
    end);
end;

end.
