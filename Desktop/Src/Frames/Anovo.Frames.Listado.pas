unit Anovo.Frames.Listado;

// Base de las secciones de listado: titulo, busqueda, rejilla y paginacion.

interface

uses
  System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Anovo.UI.PanelRelativo, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.BotonWin;

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
    procedure sbBuscarInvokeSearch(Sender: TObject);
    procedure btnLimpiarClick(Sender: TObject);
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnSiguienteClick(Sender: TObject);
  private
    FTextoPie: string;
    FEncima: TFrame;
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
  Anovo.UI.Vista,
  Anovo.Textos;

constructor TfraListado.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AplicarTemaGrid(grDatos);
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
  sbBuscar.Enabled := not AActivo;
end;

procedure TfraListado.MostrarBusqueda(const ATexto: string;
  const APuedeLimpiar: Boolean);
begin
  PintarBusqueda(sbBuscar, btnLimpiar, ATexto, APuedeLimpiar);
end;

procedure TfraListado.MostrarPaginacion(const APagina, ATotalPaginas: Integer;
  const ATotal: Int64);
begin
  PintarPaginacion(lblPaginacion, btnAnterior, btnSiguiente, APagina,
    ATotalPaginas, ATotal, FTextoSinRegistros, FTextoPaginacion,
    FTextoSoloTotal);
  TCeldasRejilla.De(grDatos).TextoVacio := FTextoSinRegistros;
  if ATotal > 0 then
    TCeldasRejilla.De(grDatos).AjustarColumnas;
end;

procedure TfraListado.MostrarError(const AMensaje: string);
begin
  lblPaginacion.Caption := '';
  AvisarError(AMensaje);
end;

procedure TfraListado.MostrarEncima(AFrame: TFrame);
begin
  FreeAndNil(FEncima);
  FEncima := AFrame;
  FEncima.Parent := Self;
  FEncima.SetBounds(0, 0, ClientWidth, ClientHeight);
  FEncima.Anchors := [akLeft, akTop, akRight, akBottom];
  FEncima.BringToFront;
  AplicarTemaFrame(FEncima);
end;

procedure TfraListado.CerrarEncima(const ADespues: TProc);
begin
  if FEncima = nil then
    Exit;
  FEncima.Visible := False;
  TThread.ForceQueue(nil,
    procedure
    begin
      FreeAndNil(FEncima);
      if Assigned(ADespues) then
        ADespues;
    end);
end;

procedure TfraListado.sbBuscarInvokeSearch(Sender: TObject);
begin
  Buscar(sbBuscar.Text);
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
