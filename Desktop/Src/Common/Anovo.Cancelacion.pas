unit Anovo.Cancelacion;

// Bandera que comparte un presentador con sus tareas, para tirar
// la respuesta que llega cuando la pantalla ya se cerro.

interface

type
  ICancelacion = interface
    ['{D2B87F16-4A93-4E0C-8C51-6F3A90E27B18}']
    function Cancelada: Boolean;
    procedure Cancelar;
  end;

  TCancelacion = class(TInterfacedObject, ICancelacion)
  private
    FCancelada: Boolean;
  public
    function Cancelada: Boolean;
    procedure Cancelar;
  end;

implementation

function TCancelacion.Cancelada: Boolean;
begin
  Result := FCancelada;
end;

procedure TCancelacion.Cancelar;
begin
  FCancelada := True;
end;

end.
