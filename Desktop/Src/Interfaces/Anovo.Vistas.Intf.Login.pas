unit Anovo.Vistas.Intf.Login;

{ Lo que el presentador del login necesita de la pantalla, y nada mas.

}

interface

type
  IVistaLogin = interface
    ['{A3F0C7D2-58B1-4E69-8D24-1C9E6B7F0A85}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure IrACambioDeClave;
    procedure IrAPrincipal;
  end;

implementation

end.
