unit Anovo.Services.Intf.Clientes;

// Contrato del servicio de clientes.
//
// Detras de interfaz para poder sustituirlo por un doble en las pruebas: sin
// esto, probar el controller obliga a levantar Firebird.
//
// El servicio no sabe nada de HTTP. No recibe TWebContext ni devuelve codigos
// de estado: lanza las excepciones de Anovo.Errors y el manejador global las
// traduce. Asi la misma regla vale si manana la llama un proceso por lotes.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Clientes;

type
  IClienteService = interface
    ['{8B3F0D51-6A27-4E94-A0C8-5F71D2B6E438}']

    // ATotal sale aparte porque el cliente necesita saber cuantas paginas hay,
    // y contar los que caben en una pagina no lo dice.
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean; out ATotal: Int64)
      : TObjectList<TClienteDTO>;

    function Obtener(const AId: Integer): TClienteDTO;

    // Devuelve el id. Si el alta ya habia subido con ese uuid_local, devuelve
    // el id existente sin crear nada: el telefono reenvia lo que no sabe si
    // llego, y dos altas iguales no pueden ser dos clientes.
    function Crear(const ADto: TClienteNuevoDTO): Integer;

    procedure Actualizar(const AId: Integer; const ADto: TClienteEdicionDTO);

    procedure Inactivar(const AId: Integer);

    function RegistrarCompleto(const ADto: TClienteRegistroCompletoDTO)
      : Integer;
  end;

implementation

end.
