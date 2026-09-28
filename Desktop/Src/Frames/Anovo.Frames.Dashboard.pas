unit Anovo.Frames.Dashboard;

// Base de los dashboards: titulo con periodo, cuatro cifras
// y una lista.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  FireDAC.Comp.Client,
  VclPlano.Tarjeta,
  Anovo.UI.DBGridExtend,
  Anovo.Mapeo.Datos;

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
  protected
    procedure MostrarCargando(const AActivo: Boolean); virtual;
    procedure MostrarError(const AMensaje: string);
    procedure MostrarLista<T: class>(const AFilas: TObjectList<T>;
      const ATabla: TFDMemTable);
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.Vista,
  Anovo.UI.Tema;

constructor TfraDashboard.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AplicarTemaGrid(grLista);
end;

destructor TfraDashboard.Destroy;
begin
  CursorOcupado(False);
  inherited;
end;

procedure TfraDashboard.Resize;
begin
  inherited;
  Anovo.UI.DBGridExtend.AjustarColumnas(grLista);
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
  Anovo.UI.DBGridExtend.AjustarColumnas(grLista);
end;

end.
