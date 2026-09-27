unit Anovo.Frames.CotizacionNueva;

// Frame de cotizacion nueva. Sin uso por ahora.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.StdCtrls, VclPlano.BotonWin, Vcl.ComCtrls, VclPlano.Tarjeta,
  Vcl.WinXPanels;

type
  TfraCotizacionNueva = class(TFrame)
  private
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TfraCotizacionNueva.Create(AOwner: TComponent);
begin
  inherited;

end;

end.
