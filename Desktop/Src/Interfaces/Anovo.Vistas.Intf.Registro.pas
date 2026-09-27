unit Anovo.Vistas.Intf.Registro;

// Contrato de las ventanas de registro: llenan un
// formulario, lo mandan y se cierran.

interface

type
  IVistaRegistro = interface
    ['{9B41D7E2-0C36-4F58-A7D1-6E2530B94C8F}']
    procedure MostrarGuardando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure Guardado(const AId: Integer);
  end;

implementation

end.
