unit Anovo.Vistas.Intf.Registro;

// Lo que los presentadores de las ventanas de registro necesitan de la
// pantalla. Es el mismo contrato para el cliente nuevo y para el contacto
// nuevo: los dos llenan un formulario, lo mandan y se cierran.

interface

type
  IVistaRegistro = interface
    ['{9B41D7E2-0C36-4F58-A7D1-6E2530B94C8F}']
    // Mientras guarda, la ventana no deja tocar nada.
    procedure MostrarGuardando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    // Guardado: la ventana se cierra y devuelve el numero al que la abrio.
    procedure Guardado(const AId: Integer);
  end;

implementation

end.
