unit Anovo.Frames.SolicitudesAsistente;

// Seccion Solicitudes de la oficina: la cola comun de las que nadie ha
// tomado y la accion de tomar una, que abre la cotizacion.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.WinXCtrls, Anovo.UI.PanelRelativo, Vcl.WinXPanels, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.BotonWin, VclPlano.Pestanas,
  Anovo.PeriodoBusqueda,
  Anovo.Forms.Periodo,
  Anovo.Frames.Listado,
  Anovo.Frames.Cotizacion,
  Anovo.DTOs.Dashboard,
  Anovo.DTOs.Solicitudes,
  Anovo.Vistas.Intf.SolicitudesAsistente,
  Anovo.Presentadores.SolicitudesAsistente;

type
  TfraSolicitudesAsistente = class(TfraListado, IVistaSolicitudesAsistente)
    btnPeriodo: TPlanoBotonWin;
    cpModo: TCardPanel;
    crdCola: TCard;
    grCola: TrDBGrid;
  private
    FPresentador: TPresentadorSolicitudesAsistente;
    FSelector: TSelectorPeriodo;
    procedure PeriodoCambio(const APeriodo: TPeriodoBusqueda);
    procedure MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure Accion(Sender: TObject; const AClave: string);
    procedure AbrirCotizacion(const AId: Integer);
    procedure CerrarCotizacion(Sender: TObject);
    procedure MostrarAcciones(const AAcciones: TAccionesCola);
    function Confirmar(const AMensaje: string): Boolean;
    procedure MostrarCola(const AFilas: TObjectList<TSolicitudPorCotizarDTO>);
  protected
    procedure Buscar(const ATexto: string); override;
    procedure Limpiar; override;
    procedure PaginaAnterior; override;
    procedure PaginaSiguiente; override;
    function RejillaActiva: TrDBGrid; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.CeldasRejilla,
  Anovo.UI.Vista,
  Anovo.UI.Tema,
  Anovo.Api.Solicitudes,
  Anovo.Api.Cotizaciones,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Textos;

const
  CAMPO_ACCIONES = 'ACCIONES';
  ACCIONES: array [TAccionCola] of TAccionRejilla = ((Clave: 'tomar';
    Rotulo: SAccionTomar));


constructor TfraSolicitudesAsistente.Create(AOwner: TComponent);
var
  lRejilla: TCeldasRejilla;
begin
  inherited Create(AOwner);
  FTextoCargando := SCargandoSolicitudes;
  FTextoPaginacion := SPaginacionSolicitudes;

  AplicarTemaGrid(grCola);
  lRejilla := TCeldasRejilla.De(grCola);
  lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
  lRejilla.OnAccion := Accion;
  FTextoSinRegistros := SSinCola;
  lRejilla.TextoVacio := FTextoSinRegistros;

  FSelector := TSelectorPeriodo.Crear(btnPeriodo, False, PeriodoCambio);

  FPresentador := TPresentadorSolicitudesAsistente.Create(Self,
    TApiSolicitudes.Create, TApiCotizaciones.Create);
  FPresentador.Iniciar;
end;

destructor TfraSolicitudesAsistente.Destroy;
begin
  FreeAndNil(FPresentador);
  inherited;
end;

procedure TfraSolicitudesAsistente.Buscar(const ATexto: string);
begin
  FPresentador.Buscar(ATexto);
end;

procedure TfraSolicitudesAsistente.Limpiar;
begin
  FPresentador.Limpiar;
end;

procedure TfraSolicitudesAsistente.MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
begin
  FSelector.Mostrar(APeriodo);
end;

procedure TfraSolicitudesAsistente.PeriodoCambio(const APeriodo: TPeriodoBusqueda);
begin
  FPresentador.FiltrarPeriodo(APeriodo);
end;

procedure TfraSolicitudesAsistente.PaginaAnterior;
begin
  FPresentador.PaginaAnterior;
end;

procedure TfraSolicitudesAsistente.PaginaSiguiente;
begin
  FPresentador.PaginaSiguiente;
end;

function TfraSolicitudesAsistente.RejillaActiva: TrDBGrid;
begin
  Result := grCola;
end;

procedure TfraSolicitudesAsistente.MostrarCola(const AFilas
  : TObjectList<TSolicitudPorCotizarDTO>);
begin
  TMapeoDatos.AListaTabla<TSolicitudPorCotizarDTO>(AFilas,
    dmMemoria.mtSolicitudesCola);
  TCeldasRejilla.De(grCola).AjustarColumnas;
end;

procedure TfraSolicitudesAsistente.MostrarAcciones(const AAcciones
  : TAccionesCola);
begin
  TCeldasRejilla.De(grCola).PonerAcciones<TAccionesCola>(ACCIONES, AAcciones);
end;

procedure TfraSolicitudesAsistente.Accion(Sender: TObject;
  const AClave: string);
begin
  if SameText(AClave, ACCIONES[acTomar].Clave) and
    not dmMemoria.mtSolicitudesCola.IsEmpty then
    FPresentador.Tomar(dmMemoria.mtSolicitudesColaID.AsInteger,
      dmMemoria.mtSolicitudesColaCLIENTE_NOMBRE.AsString);
end;

function TfraSolicitudesAsistente.Confirmar(const AMensaje: string): Boolean;
begin
  Result := Anovo.UI.Vista.Confirmar(AMensaje);
end;

procedure TfraSolicitudesAsistente.AbrirCotizacion(const AId: Integer);
var
  lCotizacion: TfraCotizacion;
begin
  lCotizacion := TfraCotizacion.Crear(Self, AId);
  lCotizacion.OnRegresar := CerrarCotizacion;
  MostrarEncima(lCotizacion);
end;

procedure TfraSolicitudesAsistente.CerrarCotizacion(Sender: TObject);
begin
  CerrarEncima(
    procedure
    begin
      FPresentador.Recargar;
    end);
end;

end.
