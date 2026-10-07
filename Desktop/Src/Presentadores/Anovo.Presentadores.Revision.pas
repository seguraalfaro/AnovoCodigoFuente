unit Anovo.Presentadores.Revision;

// Presentador de la revision: carga la cotizacion y registra
// la decision del supervisor: visto bueno o devolucion.

interface

uses
  Anovo.Api.Intf.Cotizaciones,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.Revision;

type
  TPresentadorRevision = class(TPresentadorBase)
  private
    FVista: IVistaRevision;
    FApi: IApiCotizaciones;
    FId: Integer;
    procedure Decidir(const ADecision: TDecision; const AMotivo: string);
    procedure MostrarError(AMensaje: string);
  public
    constructor Create(const AVista: IVistaRevision;
      const AApi: IApiCotizaciones; const AId: Integer);
    procedure Iniciar;
    procedure DarVistoBueno;
    procedure Devolver(const AMotivo: string);
  end;

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
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
end;

procedure TPresentadorRevision.MostrarError(AMensaje: string);
begin
  FVista.MostrarError(AMensaje);
end;

procedure TPresentadorRevision.Iniciar;
var
  lApi: IApiCotizaciones;
  lId: Integer;
  lCotizacion: TCotizacionDTO;
  lLineas: TObjectList<TLineaDTO>;
begin
  lApi := FApi;
  lId := FId;
  lCotizacion := nil;
  lLineas := nil;

  Ejecutar(SAccionCargarCotizacion,
    procedure
    begin
      lCotizacion := lApi.Obtener(lId);
      lLineas := lApi.Detalle(lId);
    end,
    procedure
    begin
      FVista.MostrarCotizacion(lCotizacion, lLineas);
    end, MostrarError,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarCargando(AActivo);
    end,
    procedure
    begin
      lLineas.Free;
      lCotizacion.Free;
    end);
end;

procedure TPresentadorRevision.DarVistoBueno;
begin
  Decidir(dcVistoBueno, '');
end;

procedure TPresentadorRevision.Devolver(const AMotivo: string);
begin
  Decidir(dcDevolver, AMotivo);
end;

procedure TPresentadorRevision.Decidir(const ADecision: TDecision;
  const AMotivo: string);
var
  lApi: IApiCotizaciones;
  lId: Integer;
  lMotivo: string;
  lDecision: TDecision;
begin
  lApi := FApi;
  lId := FId;
  lMotivo := AMotivo.Trim;
  lDecision := ADecision;

  Ejecutar(SAccionRevisarCotizacion,
    procedure
    begin
      case lDecision of
        dcVistoBueno:
          lApi.DarVistoBueno(lId);
        dcDevolver:
          lApi.Devolver(lId, lMotivo);
      end;
    end,
    procedure
    begin
      AvisarCambioEnAvisos;
      FVista.Revisada;
    end, MostrarError,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarProcesando(AActivo);
    end);
end;

end.
