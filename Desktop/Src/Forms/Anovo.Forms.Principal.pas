unit Anovo.Forms.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.TitleBarCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Anovo.UI.Tema,
  Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.VirtualImage,
  Vcl.WinXCtrls, Vcl.CategoryButtons;

type
  TfrmPrincipal = class(TForm)
    TitleBarPanel1: TTitleBarPanel;
    VirtualImage1: TVirtualImage;
    pnlContenido: TPanel;
    SV: TSplitView;
    procedure FormCreate(Sender: TObject);
    procedure VirtualImage1Click(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses
  Anovo.UI.Iconos;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  AplicarTemaBarraTitulo(Self, TitleBarPanel1, 55);
  AplicarTema(Self);
end;

procedure TfrmPrincipal.VirtualImage1Click(Sender: TObject);
begin
  sv.Opened := not sv.Opened;
end;

end.
