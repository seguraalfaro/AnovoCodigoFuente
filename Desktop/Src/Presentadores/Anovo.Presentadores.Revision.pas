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
    FNumero: Integer;
    procedure Decidir(const ADecision: TDecision; const AMotivo: string);
    procedure MostrarError(AMensaje: string);
  public
    constructor Create(const AVista: IVistaRevision;
      const AApi: IApiCotizaciones);
    procedure Iniciar(const AId: Integer);
    procedure DarVistoBueno;
    procedure Devolver;
  end;

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
  Anovo.DTOs.Cotizaciones,
  Anovo.Mensajes,
  Anovo.Textos;

constructor TPresentadorRevision.Create(const AVista: IVistaRevision;
  const AApi: IApiCotizaciones);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
end;

procedure TPresentadorRevision.MostrarError(AMensaje: string);
begin
  FVista.MostrarError(AMensaje);
end;

procedure TPresentadorRevision.Iniciar(const AId: Integer);
var
  lApi: IApiCotizaciones;
  lId: Integer;
  lCotizacion: TCotizacionDTO;
  lLineas: TObjectList<TLineaDTO>;
begin
  FId := AId;
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
      FNumero := lCotizacion.Numero;
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
  if FVista.Confirmar(Format(SConfirmarAprobar, [FNumero])) then
    Decidir(dcVistoBueno, '');
end;

procedure TPresentadorRevision.Devolver;
var
  lMotivo: string;
begin
  if FVista.PedirMotivo(Format(SDevolverTitulo, [FNumero]), lMotivo) then
    Decidir(dcDevolver, lMotivo);
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
