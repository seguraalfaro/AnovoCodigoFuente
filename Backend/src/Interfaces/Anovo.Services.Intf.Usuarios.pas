unit Anovo.Services.Intf.Usuarios;

// Contrato del servicio de usuarios.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Usuarios;

type
  IUsuarioService = interface
    ['{2F6D8A14-B7C3-4E59-9A01-D4E8F2C6B375}']
    function Buscar(const ATexto, AEstado: string;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TUsuarioDTO>;
    function Obtener(const AId: Integer): TUsuarioDTO;
    function Excepciones(const AId: Integer): TObjectList<TExcepcionDTO>;
    function Crear(const ADto: TUsuarioEdicionDTO): TUsuarioDTO;
    procedure Editar(const AId: Integer; const ADto: TUsuarioEdicionDTO);
    procedure Inactivar(const AId: Integer);
    procedure Activar(const AId: Integer);
    procedure RestablecerClave(const AId: Integer; const AClave: string);
    procedure PedirCambioClave(const AId: Integer);
    procedure CambiarExcepciones(const AId: Integer;
      const ADto: TCambiosExcepcionesDTO);
  end;

implementation

end.
