unit Anovo.Frames.Dashboard.Gerencia;

// Seccion Vista de gerencia.

interface

uses
  Anovo.UI.Tema,
  Anovo.UI.DBGridExtend,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.WinXCtrls, VclPlano.Tarjeta, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid;

type
  TfraDashboardGerencia = class(TFrame)
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    RelativePanel1: TRelativePanel;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    tjBorradores: TPlanoTarjeta;
    lblBorradores: TLabel;
    tjPendientes: TPlanoTarjeta;
    lblPendientes: TLabel;
    tjAprobadas: TPlanoTarjeta;
    lblAprobadas: TLabel;
    tjMontoMes: TPlanoTarjeta;
    lblMontoMes: TLabel;
    RelativePanel2: TRelativePanel;
    PlanoTarjeta1: TPlanoTarjeta;
    PlanoTarjeta2: TPlanoTarjeta;
    grDatos: TrDBGrid;
    rDBGrid1: TrDBGrid;
  private

  public
      constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TfraDashboardGerencia.Create(AOwner: TComponent);
begin
  inherited;
end;

end.
