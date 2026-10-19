unit Anovo.Frames.SolicitudesAsesor;

// Seccion Solicitudes del asesor: las del mes y el
// historial completo.

interface

uses
  System.UITypes,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.WinXCtrls, Anovo.UI.PanelRelativo, Vcl.WinXPanels,
  Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  FlatVcl.BotonWin, VclPlano.Pestanas, VclPlano.BotonWin,
  Anovo.PeriodoBusqueda,
  Anovo.Forms.Periodo,
  Anovo.Frames.Listado,
  Anovo.Frames.Cotizacion,
  Anovo.DTOs.Dashboard,
  Anovo.Vistas.Intf.SolicitudesAsesor,
  Anovo.Presentadores.SolicitudesAsesor, Vcl.VirtualImage;

type
  TfraSolicitudesAsesor = class(TfraListado, IVistaSolicitudesAsesor)
    btnPeriodo: TPlanoBotonWin;
  private
    FSelector: TSelectorPeriodo;
    FPresentador: TPresentadorSolicitudesAsesor;
    procedure Accion(Sender: TObject; const AClave: string);
    procedure MostrarAcciones(const AAcciones: TAccionesSolicitudAsesor);
    procedure AbrirCotizacion(const AId: Integer);
    procedure CerrarCotizacion(Sender: TObject);
    procedure PeriodoCambio(const APeriodo: TPeriodoBusqueda);
    procedure MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure MostrarSolicitudes(const AFilas: TObjectList<TSolicitudAsesorDTO>);
  protected
    procedure Buscar(const ATexto: string); override;
    procedure Limpiar; override;
    procedure PaginaAnterior; override;
    procedure PaginaSiguiente; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.CeldasRejilla,
  Anovo.UI.Tema,
  Anovo.Api.Solicitudes,
  Anovo.Mapeo.Datos,
  Anovo.Textos,
  Anovo.Datos.Memoria;

const
  CAMPO_ESTADO = 'ESTADO';
  CAMPO_ACCIONES = 'ACCIONES';
  CAMPO_VER_COTIZACION = 'VER_COTIZACION';
  ACCIONES: array [TAccionSolicitudAsesor] of TAccionRejilla = ((Clave: 'ver';
    Rotulo: SAccionVerCotizacion; Alterno: ''; Campo: CAMPO_VER_COTIZACION));

constructor TfraSolicitudesAsesor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTextoCargando := SCargandoSolicitudes;
  FTextoSinRegistros := SSinSolicitudes;
  FTextoPaginacion := SPaginacionSolicitudes;
  TCeldasRejilla.De(grDatos).ColumnaEstado(CAMPO_ESTADO);
  TCeldasRejilla.De(grDatos).ColumnaAcciones(CAMPO_ACCIONES);
  TCeldasRejilla.De(grDatos).OnAccion := Accion;
  FSelector := TSelectorPeriodo.Crear(btnPeriodo, False, PeriodoCambio);

  FPresentador := TPresentadorSolicitudesAsesor.Create(Self, TApiSolicitudes.Create);
  FPresentador.Iniciar;
end;

destructor TfraSolicitudesAsesor.Destroy;
begin
  FreeAndNil(FPresentador);
  inherited;
end;

procedure TfraSolicitudesAsesor.Accion(Sender: TObject; const AClave: string);
begin
  if SameText(AClave, ACCIONES[asaVer].Clave) and
    not dmMemoria.mtSeguimiento.IsEmpty and
    dmMemoria.mtSeguimientoVER_COTIZACION.AsBoolean then
    FPresentador.Abrir(dmMemoria.mtSeguimientoCOTIZACION_ID.AsInteger);
end;

procedure TfraSolicitudesAsesor.MostrarAcciones(const AAcciones
  : TAccionesSolicitudAsesor);
begin
  TCeldasRejilla.De(grDatos).PonerAcciones<TAccionesSolicitudAsesor>(ACCIONES,
    AAcciones);
end;

procedure TfraSolicitudesAsesor.AbrirCotizacion(const AId: Integer);
var
  lCotizacion: TfraCotizacion;
begin
  lCotizacion := TfraCotizacion.Crear(Self, AId);
  lCotizacion.OnRegresar := CerrarCotizacion;
  MostrarEncima(lCotizacion);
end;

procedure TfraSolicitudesAsesor.CerrarCotizacion(Sender: TObject);
begin
  CerrarEncima;
end;

procedure TfraSolicitudesAsesor.Resize;
begin
  inherited;
  Anovo.UI.CeldasRejilla.AjustarColumnas(grDatos);
end;

procedure TfraSolicitudesAsesor.Buscar(const ATexto: string);
begin
  FPresentador.Buscar(ATexto);
end;

procedure TfraSolicitudesAsesor.Limpiar;
begin
  FPresentador.Limpiar;
end;

procedure TfraSolicitudesAsesor.PeriodoCambio(const APeriodo
  : TPeriodoBusqueda);
begin
  FPresentador.FiltrarPeriodo(APeriodo);
end;

procedure TfraSolicitudesAsesor.PaginaAnterior;
begin
  FPresentador.PaginaAnterior;
end;

procedure TfraSolicitudesAsesor.PaginaSiguiente;
begin
  FPresentador.PaginaSiguiente;
end;

procedure TfraSolicitudesAsesor.MostrarPeriodo(const APeriodo
  : TPeriodoBusqueda);
begin
  FSelector.Mostrar(APeriodo);
end;

procedure TfraSolicitudesAsesor.MostrarSolicitudes(const AFilas
  : TObjectList<TSolicitudAsesorDTO>);
begin
  TMapeoDatos.AListaTabla<TSolicitudAsesorDTO>(AFilas,
    dmMemoria.mtSeguimiento);
  Anovo.UI.CeldasRejilla.AjustarColumnas(grDatos);
end;

end.
