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
    pstPeriodo: TPlanoPestanas;
    btnPeriodo: TPlanoBotonWin;
    procedure pstPeriodoChange(Sender: TObject);
  private
    FSelector: TSelectorPeriodo;
    FPresentador: TPresentadorSolicitudesAsesor;
    FCotizacion: TfraCotizacion;
    procedure Accion(Sender: TObject; const AClave: string);
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
    procedure MostrarCargando(const AActivo: Boolean); override;
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
  ACCION_VER = 'ver';

constructor TfraSolicitudesAsesor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTextoCargando := SCargandoSolicitudes;
  FTextoSinRegistros := SSinSolicitudes;
  FTextoPaginacion := SPaginacionSolicitudes;
  TCeldasRejilla.De(grDatos).ColumnaEstado(CAMPO_ESTADO);
  TCeldasRejilla.De(grDatos).ColumnaAcciones(CAMPO_ACCIONES);
  TCeldasRejilla.De(grDatos).AgregarAlterna(ACCION_VER, SAccionVerCotizacion,
    '', CAMPO_VER_COTIZACION);
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
  if SameText(AClave, ACCION_VER) and not dmMemoria.mtSeguimiento.IsEmpty and
    dmMemoria.mtSeguimientoVER_COTIZACION.AsBoolean then
    AbrirCotizacion(dmMemoria.mtSeguimientoCOTIZACION_ID.AsInteger);
end;

procedure TfraSolicitudesAsesor.AbrirCotizacion(const AId: Integer);
begin
  FreeAndNil(FCotizacion);
  FCotizacion := TfraCotizacion.Crear(Self, AId);
  FCotizacion.OnRegresar := CerrarCotizacion;
  FCotizacion.Parent := Self;
  FCotizacion.SetBounds(0, 0, ClientWidth, ClientHeight);
  FCotizacion.Anchors := [akLeft, akTop, akRight, akBottom];
  FCotizacion.BringToFront;
  AplicarTemaFrame(FCotizacion);
end;

procedure TfraSolicitudesAsesor.CerrarCotizacion(Sender: TObject);
begin
  FCotizacion.Visible := False;
  TThread.ForceQueue(nil,
    procedure
    begin
      FreeAndNil(FCotizacion);
    end);
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

procedure TfraSolicitudesAsesor.pstPeriodoChange(Sender: TObject);
begin
  if not Assigned(FPresentador) then
    Exit;
  FPresentador.VerHistorial(pstPeriodo.ItemIndex = 1);
end;

procedure TfraSolicitudesAsesor.MostrarCargando(const AActivo: Boolean);
begin
  inherited;
  pstPeriodo.Enabled := not AActivo;
  btnPeriodo.Enabled := not AActivo;
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
