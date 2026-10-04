unit Anovo.UI.PanelRelativo;

// TRelativePanel de la VCL 10.4 libera su coleccion antes que sus hijos y las
// etiquetas de RosiComp la siguen avisando al morir; aqui los hijos van primero.
// Va en el uses despues de Vcl.WinXCtrls.

interface

uses
  Vcl.WinXCtrls;

type
  TRelativePanel = class(Vcl.WinXCtrls.TRelativePanel)
  public
    destructor Destroy; override;
  end;

implementation

destructor TRelativePanel.Destroy;
begin
  while ControlCount > 0 do
    Controls[ControlCount - 1].Free;
  inherited;
end;

end.
