unit Anovo.Cancelacion;

// La bandera que comparten un presentador y las tareas que lanzo.
//
// El frame se destruye al cambiar de seccion y la respuesta puede llegar
// despues. El destructor del presentador cancela, y lo que vuelva se tira sin
// tocar una pantalla que ya no existe.
//
// Es una interfaz y no un campo del presentador porque la tarea la conserva
// aunque el presentador ya se haya liberado.

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
