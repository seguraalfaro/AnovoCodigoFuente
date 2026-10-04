unit Anovo.Frames.Reportes;

// Seccion Reportes (HU-06): cifras del periodo y detalle por estado, asesor,
// tipo de trabajo y mes, con exportacion.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.Tarjeta, VclPlano.BotonWin, VclPlano.Pestanas,
  Anovo.Frames.Dashboard;

type
  TfraReportes = class(TfraDashboard)
    pnlFiltros: TPanel;
    lblDesde: TLabel;
    dtpDesde: TDateTimePicker;
    lblHasta: TLabel;
    dtpHasta: TDateTimePicker;
    pstPeriodo: TPlanoPestanas;
    btnConsultar: TPlanoBotonWin;
    btnExportar: TPlanoBotonWin;
    tjCifra5: TPlanoTarjeta;
    lblCifra5: TLabel;
    pstVistas: TPlanoPestanas;
  end;

implementation

{$R *.dfm}

end.
