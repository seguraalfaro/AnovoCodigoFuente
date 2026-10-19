unit Anovo.Frames.Listado;

// Base de las secciones de listado: titulo, busqueda, rejilla y paginacion.

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Anovo.UI.PanelRelativo, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.BotonWin,
  Anovo.UI.Vista;

type
  TfraListado = class(TFrame)
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pnlBarra: TPanel;
    sbBuscar: TSearchBox;
    btnLimpiar: TPlanoBotonWin;
    pnclient: TRelativePanel;
    grDatos: TrDBGrid;
    pnlPie: TPanel;
    lblPaginacion: TLabel;
    btnAnterior: TPlanoBotonWin;
    btnSiguiente: TPlanoBotonWin;
    procedure btnLimpiarClick(Sender: TObject);
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnSiguienteClick(Sender: TObject);
  private
    FTextoPie: string;
    FEncima: TPantallaEncima;
    FBusqueda: TBusquedaAlEscribir;
  protected
    FTextoCargando: string;
    FTextoSinRegistros: string;
    FTextoPaginacion: string;
    FTextoSoloTotal: string;
    procedure Buscar(const ATexto: string); virtual; abstract;
    procedure Limpiar; virtual; abstract;
    procedure PaginaAnterior; virtual; abstract;
    procedure PaginaSiguiente; virtual; abstract;
    procedure MostrarCargando(const AActivo: Boolean); virtual;
    function RejillaActiva: TrDBGrid; virtual;
    procedure MostrarBusqueda(const ATexto: string;
      const APuedeLimpiar: Boolean);
    procedure MostrarPaginacion(const APagina, ATotalPaginas: Integer;
      const ATotal: Int64);
    procedure MostrarError(const AMensaje: string);
    procedure MostrarEncima(AFrame: TFrame);
    procedure CerrarEncima(const ADespues: TProc = nil);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.Tema,
  Anovo.UI.CeldasRejilla,
  Anovo.Textos;

constructor TfraListado.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AplicarTemaGrid(grDatos);
  FEncima := TPantallaEncima.Crear(Self);
  FBusqueda := TBusquedaAlEscribir.Crear(sbBuscar,
    procedure(ATexto: string)
    begin
      Buscar(ATexto);
    end);
end;

destructor TfraListado.Destroy;
begin
  inherited;
end;

procedure TfraListado.MostrarCargando(const AActivo: Boolean);
begin
  if AActivo then
  begin
    if lblPaginacion.Caption <> FTextoCargando then
      FTextoPie := lblPaginacion.Caption;
    lblPaginacion.Caption := FTextoCargando;
  end
  else if lblPaginacion.Caption = FTextoCargando then
    lblPaginacion.Caption := FTextoPie;
  CursorOcupado(AActivo);
end;

procedure TfraListado.MostrarBusqueda(const ATexto: string;
  const APuedeLimpiar: Boolean);
begin
  FBusqueda.Mostrar(ATexto);
  PintarBusqueda(sbBuscar, btnLimpiar, ATexto, APuedeLimpiar);
end;

procedure TfraListado.MostrarPaginacion(const APagina, ATotalPaginas: Integer;
  const ATotal: Int64);
begin
  PintarPaginacion(lblPaginacion, btnAnterior, btnSiguiente, APagina,
    ATotalPaginas, ATotal, FTextoSinRegistros, FTextoPaginacion,
    FTextoSoloTotal);
  TCeldasRejilla.De(RejillaActiva).TextoVacio := FTextoSinRegistros;
  if ATotal > 0 then
    TCeldasRejilla.De(RejillaActiva).AjustarColumnas;
end;

function TfraListado.RejillaActiva: TrDBGrid;
begin
  Result := grDatos;
end;

procedure TfraListado.MostrarError(const AMensaje: string);
begin
  lblPaginacion.Caption := '';
  AvisarError(AMensaje);
end;

procedure TfraListado.MostrarEncima(AFrame: TFrame);
begin
  FEncima.Mostrar(AFrame);
end;

procedure TfraListado.CerrarEncima(const ADespues: TProc);
begin
  FEncima.Cerrar(ADespues);
end;

procedure TfraListado.btnLimpiarClick(Sender: TObject);
begin
  Limpiar;
end;

procedure TfraListado.btnAnteriorClick(Sender: TObject);
begin
  PaginaAnterior;
end;

procedure TfraListado.btnSiguienteClick(Sender: TObject);
begin
  PaginaSiguiente;
end;

end.
