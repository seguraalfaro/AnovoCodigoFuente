unit Anovo.Frames.Cotizaciones;

// Seccion Listado de cotizaciones.

interface

uses
  Anovo.UI.Tema,
  Anovo.UI.DBGridExtend,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  VclPlano.BotonWin, Vcl.WinXCtrls, Vcl.ExtCtrls, VclPlano.Pestanas, Data.DB,
  Vcl.Grids, Vcl.DBGrids, rDBGrid;

type
  TfraCotizaciones = class(TFrame)
    pnlBarra: TPanel;
    sbBuscar: TSearchBox;
    btnExportar: TPlanoBotonWin;
    btnNuevo: TPlanoBotonWin;
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pstFiltros: TPlanoPestanas;
    pnbottom: TRelativePanel;
    pnclient: TRelativePanel;
    grDatos: TrDBGrid;
  private
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TfraCotizaciones.Create(AOwner: TComponent);
begin
  inherited;
  AplicarTemaGrid(grDatos);

end;

end.
