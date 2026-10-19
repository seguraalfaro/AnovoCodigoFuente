unit Anovo.Frames.Dashboard;

// Base de los dashboards: titulo con periodo, cuatro cifras, tarjetas de
// barras, avisos y datos, y la cotizacion abierta encima.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  FireDAC.Comp.Client,
  VclPlano.Tarjeta,
  Anovo.UI.CeldasRejilla,
  Anovo.UI.Vista,
  Anovo.Mapeo.Datos,
  Anovo.DTOs.Dashboard;

type
  TfraDashboard = class(TFrame)
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    lblPeriodo: TLabel;
    pnlKpi: TPanel;
    tjCifra1: TPlanoTarjeta;
    lblCifra1: TLabel;
    tjCifra2: TPlanoTarjeta;
    lblCifra2: TLabel;
    tjCifra3: TPlanoTarjeta;
    lblCifra3: TLabel;
    tjCifra4: TPlanoTarjeta;
    lblCifra4: TLabel;
    tjLista: TPlanoTarjeta;
    grLista: TrDBGrid;
  private
    FRejillas: TArray<TrDBGrid>;
    FEncima: TPantallaEncima;
    procedure AvisoDblClick(Sender: TObject);
    procedure CerrarCotizacion(Sender: TObject);
  protected
    procedure MostrarCargando(const AActivo: Boolean); virtual;
    procedure MostrarError(const AMensaje: string);
    procedure MostrarLista<T: class>(const AFilas: TObjectList<T>;
      const ATabla: TFDMemTable);
    procedure Resize; override;
    procedure PrepararRejilla(const ARejilla: TrDBGrid;
      const ACampoEstado: string = '');
    procedure PrepararAvisos(const ARejilla: TrDBGrid);
    procedure MostrarBarras(const ARejilla: TrDBGrid;
      const AFilas: TObjectList<TDashboardBarraDTO>);
    procedure MostrarAvisos(const ARejilla: TrDBGrid;
      const AFilas: TObjectList<TDashboardAvisoDTO>);
    procedure MostrarDatos(const ARejilla: TrDBGrid;
      const AFilas: TObjectList<TDashboardDatoDTO>);
    procedure AbrirCotizacion(const AId: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  System.Math,
  RosiCompGlobalCfg,
  Anovo.UI.Tema,
  Anovo.Datos.Memoria,
  Anovo.Frames.Cotizacion,
  Anovo.Textos;

const
  CAMPO_CANTIDAD = 'CANTIDAD';
  CAMPO_ESTADO = 'ESTADO';

constructor TfraDashboard.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEncima := TPantallaEncima.Crear(Self);
  AplicarTemaGrid(grLista);
  TCeldasRejilla.De(grLista).TextoVacio := SVacioDashboard;
end;

destructor TfraDashboard.Destroy;
begin
  inherited;
end;

procedure TfraDashboard.Resize;
var
  lRejilla: TrDBGrid;
begin
  inherited;
  Anovo.UI.CeldasRejilla.AjustarColumnas(grLista);
  for lRejilla in FRejillas do
    Anovo.UI.CeldasRejilla.AjustarColumnas(lRejilla);
end;

procedure TfraDashboard.PrepararRejilla(const ARejilla: TrDBGrid;
  const ACampoEstado: string);
begin
  AplicarTemaGrid(ARejilla);
  TCeldasRejilla.De(ARejilla).TextoVacio := SVacioDashboard;
  if ACampoEstado <> '' then
    TCeldasRejilla.De(ARejilla).ColumnaEstado(ACampoEstado);
  FRejillas := FRejillas + [ARejilla];
end;

procedure TfraDashboard.PrepararAvisos(const ARejilla: TrDBGrid);
begin
  PrepararRejilla(ARejilla, CAMPO_ESTADO);
  ARejilla.OnDblClick := AvisoDblClick;
end;

procedure TfraDashboard.MostrarBarras(const ARejilla: TrDBGrid;
  const AFilas: TObjectList<TDashboardBarraDTO>);
var
  lFila: TDashboardBarraDTO;
  lMaximo: Integer;
begin
  lMaximo := 1;
  for lFila in AFilas do
    lMaximo := Max(lMaximo, lFila.Cantidad);
  TMapeoDatos.AListaTabla<TDashboardBarraDTO>(AFilas, dmMemoria.mtPanelBarras);
  ARejilla.FieldsAsDataBar.Clear;
  ARejilla.Fields_SetDataBarSettings(CAMPO_CANTIDAD, 0, lMaximo, dbtValue);
  Anovo.UI.CeldasRejilla.AjustarColumnas(ARejilla);
end;

procedure TfraDashboard.MostrarAvisos(const ARejilla: TrDBGrid;
  const AFilas: TObjectList<TDashboardAvisoDTO>);
begin
  TMapeoDatos.AListaTabla<TDashboardAvisoDTO>(AFilas, dmMemoria.mtPanelAvisos);
  Anovo.UI.CeldasRejilla.AjustarColumnas(ARejilla);
end;

procedure TfraDashboard.MostrarDatos(const ARejilla: TrDBGrid;
  const AFilas: TObjectList<TDashboardDatoDTO>);
begin
  TMapeoDatos.AListaTabla<TDashboardDatoDTO>(AFilas, dmMemoria.mtPanelDatos);
  Anovo.UI.CeldasRejilla.AjustarColumnas(ARejilla);
end;

procedure TfraDashboard.AvisoDblClick(Sender: TObject);
begin
  if not dmMemoria.mtPanelAvisos.IsEmpty then
    AbrirCotizacion(dmMemoria.mtPanelAvisosCOTIZACION_ID.AsInteger);
end;

procedure TfraDashboard.AbrirCotizacion(const AId: Integer);
var
  lCotizacion: TfraCotizacion;
begin
  if AId <= 0 then
    Exit;
  lCotizacion := TfraCotizacion.Crear(Self, AId);
  lCotizacion.OnRegresar := CerrarCotizacion;
  FEncima.Mostrar(lCotizacion);
end;

procedure TfraDashboard.CerrarCotizacion(Sender: TObject);
begin
  FEncima.Cerrar;
end;

procedure TfraDashboard.MostrarCargando(const AActivo: Boolean);
begin
  CursorOcupado(AActivo);
end;

procedure TfraDashboard.MostrarError(const AMensaje: string);
begin
  AvisarError(AMensaje);
end;

procedure TfraDashboard.MostrarLista<T>(const AFilas: TObjectList<T>;
  const ATabla: TFDMemTable);
begin
  TMapeoDatos.AListaTabla<T>(AFilas, ATabla);
  Anovo.UI.CeldasRejilla.AjustarColumnas(grLista);
end;

end.
