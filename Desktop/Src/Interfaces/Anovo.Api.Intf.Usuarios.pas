unit Anovo.Api.Intf.Usuarios;

// Contrato de la API de usuarios.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Dispositivos,
  Anovo.DTOs.Usuarios;

type
  IApiUsuarios = interface
    ['{4C7E2A91-6D3B-4F80-B5A2-9E1D7C43F860}']
    function Buscar(const ATexto, AEstado: string;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TUsuarioDTO>;
    function Obtener(const AId: Integer): TUsuarioDTO;
    function Crear(const ADto: TUsuarioEdicionDTO): TUsuarioDTO;
    procedure Editar(const AId: Integer; const ADto: TUsuarioEdicionDTO);
    procedure Inactivar(const AId: Integer);
    procedure Activar(const AId: Integer);
    procedure RestablecerClave(const AId: Integer; const AClave: string);
    procedure PedirCambioClave(const AId: Integer);
    function Excepciones(const AId: Integer): TObjectList<TExcepcionDTO>;
    procedure CambiarExcepciones(const AId: Integer;
      const ADto: TCambiosExcepcionesDTO);
    function Dispositivos(const AId: Integer): TObjectList<TDispositivoDTO>;
    procedure InactivarDispositivo(const AId, ADispositivoId: Integer);
  end;

implementation

end.
