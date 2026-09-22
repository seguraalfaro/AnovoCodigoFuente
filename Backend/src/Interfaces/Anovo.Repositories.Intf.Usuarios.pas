unit Anovo.Repositories.Intf.Usuarios;

// Contrato del repositorio de usuarios.
//
// Hoy tiene un solo metodo, el que la bitacora necesita para poner nombres
// donde la tabla guarda numeros. Cuando se haga el modulo de usuarios, aqui
// se le agregan los suyos; la tabla es la misma y el repositorio tambien.
//
// Por que no lo resuelve el repositorio de auditoria con un JOIN: cada
// repositorio atiende su tabla, y lo que cruza dos lo junta el servicio.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Usuarios;

type
  IUsuarioRepository = interface(IMVCRepository<TUsuarios>)
    ['{6F2A1C94-8E3B-4D57-9A16-C0B4E7D82F35}']

    // Los nombres de esos numeros, en una sola consulta. La bitacora trae
    // cincuenta filas de pocos usuarios distintos: preguntar uno por uno
    // serian cincuenta viajes para diez respuestas.
    //
    // Un numero que ya no existe no sale en el diccionario, y quien llama
    // decide que poner en su lugar.
    function NombresDe(const AIds: TArray<Integer>)
      : TDictionary<Integer, string>;
  end;

implementation

end.
