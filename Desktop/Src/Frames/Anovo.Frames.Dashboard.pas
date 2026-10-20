unit Anovo.Frames.Dashboard;

// Base de los dashboards: saludo, cuatro cifras, las filas que dibujan las
// tarjetas de barras, avisos, etapas y datos, y la cotizacion abierta encima.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  FireDAC.Comp.Client,
  VclPlano.Tarjeta,
  Anovo.UI.CeldasRejilla,
  Anovo.UI.Dashboard,
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
    FEncima: TPantallaEncima;
    procedure CerrarCotizacion(Sender: TObject);
  protected
    procedure MostrarCargando(const AActivo: Boolean); virtual;
    procedure MostrarError(const AMensaje: string);
    procedure MostrarLista<T: class>(const AFilas: TObjectList<T>;
      const ATabla: TFDMemTable);
    procedure Resize; override;
    function NuevosAvisos(const APintura: TPaintBox): TDibujoAvisos;
    function FilasDeBarras(const AFilas: TObjectList<TDashboardBarraDTO>;
      const AColorFijo: TColor = clNone): TArray<TFilaBarra>;
    function AvisosPorLlamar(const AFilas: TObjectList<TDashboardAvisoDTO>)
      : TArray<TFilaAviso>;
    function AvisosParaHoy(const AFilas: TObjectList<TDashboardAvisoDTO>)
      : TArray<TFilaAviso>;
    function AvisosEstancados(const AFilas: TObjectList<TDashboardAvisoDTO>)
      : TArray<TFilaAviso>;
    function RecuadrosDeEtapas(const AFilas: TObjectList<TDashboardBarraDTO>)
      : TArray<TRecuadroEtapa>;
    function FilasDeDatos(const AFilas: TObjectList<TDashboardDatoDTO>)
      : TArray<TFilaDato>;
    procedure AbrirCotizacion(const AId: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.Tema,
  Anovo.Frames.Cotizacion,
  Anovo.Formato,
  Anovo.Textos;

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
begin
  inherited;
  Anovo.UI.CeldasRejilla.AjustarColumnas(grLista);
end;

function TfraDashboard.NuevosAvisos(const APintura: TPaintBox): TDibujoAvisos;
begin
  Result := TDibujoAvisos.Crear(APintura);
  Result.OnAbrir :=
    procedure(AId: Integer)
    begin
      AbrirCotizacion(AId);
    end;
end;

function TfraDashboard.FilasDeBarras(const AFilas
  : TObjectList<TDashboardBarraDTO>; const AColorFijo: TColor)
  : TArray<TFilaBarra>;
var
  I: Integer;
begin
  SetLength(Result, AFilas.Count);
  for I := 0 to AFilas.Count - 1 do
  begin
    Result[I].Etiqueta := AFilas[I].Etiqueta;
    Result[I].Cantidad := AFilas[I].Cantidad;
    if AColorFijo = clNone then
      Result[I].Color := ColorDeGrupo(AFilas[I].Clave)
    else
      Result[I].Color := AColorFijo;
  end;
end;

function TfraDashboard.AvisosPorLlamar(const AFilas
  : TObjectList<TDashboardAvisoDTO>): TArray<TFilaAviso>;
var
  I: Integer;
begin
  SetLength(Result, AFilas.Count);
  for I := 0 to AFilas.Count - 1 do
  begin
    Result[I] := Default(TFilaAviso);
    Result[I].Id := AFilas[I].CotizacionId;
    Result[I].Texto := Format(SAvisoClienteNumero, [AFilas[I].ClienteNombre,
      AFilas[I].Numero]);
    Result[I].Derecha := TFormato.Dias(AFilas[I].Dias);
    Result[I].ColorDerecha := ColorDeNivel(AFilas[I].Nivel);
    Result[I].DerechaEnPastilla := True;
  end;
end;

function TfraDashboard.AvisosParaHoy(const AFilas
  : TObjectList<TDashboardAvisoDTO>): TArray<TFilaAviso>;
var
  I: Integer;
begin
  SetLength(Result, AFilas.Count);
  for I := 0 to AFilas.Count - 1 do
  begin
    Result[I] := Default(TFilaAviso);
    Result[I].Id := AFilas[I].CotizacionId;
    Result[I].Pastilla := AFilas[I].Etiqueta;
    Result[I].ColorPastilla := ColorDeEstado(AFilas[I].Estado);
    Result[I].Texto := Format(SAvisoNumeroDetalle, [AFilas[I].Numero,
      AFilas[I].Detalle]);
    Result[I].Derecha := TFormato.Hace(AFilas[I].Dias);
  end;
end;

function TfraDashboard.AvisosEstancados(const AFilas
  : TObjectList<TDashboardAvisoDTO>): TArray<TFilaAviso>;
var
  I: Integer;
begin
  SetLength(Result, AFilas.Count);
  for I := 0 to AFilas.Count - 1 do
  begin
    Result[I] := Default(TFilaAviso);
    Result[I].Id := AFilas[I].CotizacionId;
    Result[I].Texto := Format(SAvisoNumeroEtapa, [AFilas[I].Numero,
      AFilas[I].Etiqueta, AFilas[I].Detalle]);
    Result[I].Derecha := TFormato.Dias(AFilas[I].Dias);
    Result[I].ColorDerecha := ColorDeNivel(AFilas[I].Nivel);
    Result[I].DerechaEnPastilla := True;
  end;
end;

function TfraDashboard.RecuadrosDeEtapas(const AFilas
  : TObjectList<TDashboardBarraDTO>): TArray<TRecuadroEtapa>;
var
  I: Integer;
begin
  SetLength(Result, AFilas.Count);
  for I := 0 to AFilas.Count - 1 do
  begin
    Result[I].Etiqueta := AFilas[I].Etiqueta;
    Result[I].Cantidad := AFilas[I].Cantidad;
    Result[I].Color := ColorDeEstado(AFilas[I].Clave);
  end;
end;

function TfraDashboard.FilasDeDatos(const AFilas
  : TObjectList<TDashboardDatoDTO>): TArray<TFilaDato>;
var
  I: Integer;
begin
  SetLength(Result, AFilas.Count);
  for I := 0 to AFilas.Count - 1 do
  begin
    Result[I].Concepto := AFilas[I].Concepto;
    Result[I].Valor := AFilas[I].Valor;
  end;
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
