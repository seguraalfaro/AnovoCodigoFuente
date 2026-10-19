unit Anovo.Frames.Cotizaciones;

// Seccion Listado de cotizaciones (HU-03): busqueda, fechas y estado en una
// barra, y la cotizacion abierta encima del listado.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.WinXCtrls, Anovo.UI.PanelRelativo, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.BotonWin, VclPlano.Pestanas,
  Anovo.PeriodoBusqueda,
  Anovo.Forms.Periodo,
  Anovo.Frames.Listado,
  Anovo.Frames.Cotizacion,
  Anovo.DTOs.Cotizaciones,
  Anovo.Vistas.Intf.Cotizaciones,
  Anovo.Presentadores.Cotizaciones;

type
  TfraCotizaciones = class(TfraListado, IVistaCotizaciones)
    btnPeriodo: TPlanoBotonWin;
    cbEstado: TComboBox;
    procedure cbEstadoChange(Sender: TObject);
    procedure grDatosDblClick(Sender: TObject);
  private
    FInicialId: Integer;
    FSelector: TSelectorPeriodo;
    FPresentador: TPresentadorCotizaciones;
    procedure PeriodoCambio(const APeriodo: TPeriodoBusqueda);
    procedure Accion(Sender: TObject; const AClave: string);
    procedure MostrarAcciones(const AAcciones: TAccionesListaCotizacion);
    procedure MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure MostrarFiltro(const AFiltro: TFiltroCotizaciones);
    procedure MostrarCotizaciones(const AFilas: TObjectList<TCotizacionDTO>);
    procedure AbrirCotizacion(const AId: Integer);
    procedure CerrarCotizacion(Sender: TObject);
  protected
    procedure Buscar(const ATexto: string); override;
    procedure Limpiar; override;
    procedure PaginaAnterior; override;
    procedure PaginaSiguiente; override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor Crear(AOwner: TComponent; const ACotizacionId: Integer);
    procedure Abrir(const AId: Integer);
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.CeldasRejilla,
  Anovo.UI.Tema,
  Anovo.Api.Cotizaciones,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Textos;

const
  CAMPO_ACCIONES = 'ACCIONES';
  CAMPO_ESTADO = 'ESTADO';
  ACCIONES: array [TAccionListaCotizacion] of TAccionRejilla =
    ((Clave: 'abrir'; Rotulo: SAccionAbrir));

constructor TfraCotizaciones.Create(AOwner: TComponent);
var
  lRejilla: TCeldasRejilla;
begin
  inherited Create(AOwner);
  FTextoCargando := SCargandoCotizaciones;
  FTextoSinRegistros := SSinCotizaciones;
  FTextoPaginacion := SPaginacionCotizaciones;

  lRejilla := TCeldasRejilla.De(grDatos);
  lRejilla.ColumnaEstado(CAMPO_ESTADO);
  lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
  lRejilla.OnAccion := Accion;

  FSelector := TSelectorPeriodo.Crear(btnPeriodo, False, PeriodoCambio);

  FPresentador := TPresentadorCotizaciones.Create(Self,
    TApiCotizaciones.Create);
  FPresentador.Iniciar(FInicialId = 0);
  if FInicialId > 0 then
    FPresentador.Abrir(FInicialId);
end;

constructor TfraCotizaciones.Crear(AOwner: TComponent;
  const ACotizacionId: Integer);
begin
  FInicialId := ACotizacionId;
  Create(AOwner);
end;

destructor TfraCotizaciones.Destroy;
begin
  FreeAndNil(FPresentador);
  inherited;
end;

procedure TfraCotizaciones.Buscar(const ATexto: string);
begin
  FPresentador.Buscar(ATexto);
end;

procedure TfraCotizaciones.Limpiar;
begin
  FPresentador.Limpiar;
end;

procedure TfraCotizaciones.MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
begin
  FSelector.Mostrar(APeriodo);
end;

procedure TfraCotizaciones.MostrarFiltro(const AFiltro: TFiltroCotizaciones);
begin
  cbEstado.OnChange := nil;
  try
    cbEstado.ItemIndex := Ord(AFiltro);
  finally
    cbEstado.OnChange := cbEstadoChange;
  end;
end;

procedure TfraCotizaciones.PeriodoCambio(const APeriodo: TPeriodoBusqueda);
begin
  FPresentador.FiltrarPeriodo(APeriodo);
end;

procedure TfraCotizaciones.PaginaAnterior;
begin
  FPresentador.PaginaAnterior;
end;

procedure TfraCotizaciones.PaginaSiguiente;
begin
  FPresentador.PaginaSiguiente;
end;

procedure TfraCotizaciones.MostrarAcciones(const AAcciones
  : TAccionesListaCotizacion);
begin
  TCeldasRejilla.De(grDatos).PonerAcciones<TAccionesListaCotizacion>(ACCIONES,
    AAcciones);
end;

procedure TfraCotizaciones.MostrarCotizaciones(const AFilas
  : TObjectList<TCotizacionDTO>);
begin
  TMapeoDatos.AListaTabla<TCotizacionDTO>(AFilas,
    dmMemoria.mtCotizacionesLista);
  TCeldasRejilla.De(grDatos).AjustarColumnas;
end;

procedure TfraCotizaciones.Accion(Sender: TObject; const AClave: string);
begin
  if dmMemoria.mtCotizacionesLista.IsEmpty then
    Exit;
  if SameText(AClave, ACCIONES[alcAbrir].Clave) then
    FPresentador.Abrir(dmMemoria.mtCotizacionesListaID.AsInteger);
end;

procedure TfraCotizaciones.grDatosDblClick(Sender: TObject);
begin
  if not dmMemoria.mtCotizacionesLista.IsEmpty then
    FPresentador.Abrir(dmMemoria.mtCotizacionesListaID.AsInteger);
end;

procedure TfraCotizaciones.cbEstadoChange(Sender: TObject);
begin
  if (FPresentador = nil) or (cbEstado.ItemIndex < 0) then
    Exit;
  FPresentador.Filtrar(TFiltroCotizaciones(cbEstado.ItemIndex));
end;

procedure TfraCotizaciones.Abrir(const AId: Integer);
begin
  FPresentador.Abrir(AId);
end;

procedure TfraCotizaciones.AbrirCotizacion(const AId: Integer);
var
  lCotizacion: TfraCotizacion;
begin
  lCotizacion := TfraCotizacion.Crear(Self, AId);
  lCotizacion.OnRegresar := CerrarCotizacion;
  MostrarEncima(lCotizacion);
end;

procedure TfraCotizaciones.CerrarCotizacion(Sender: TObject);
begin
  CerrarEncima(
    procedure
    begin
      FPresentador.Recargar;
    end);
end;

end.
