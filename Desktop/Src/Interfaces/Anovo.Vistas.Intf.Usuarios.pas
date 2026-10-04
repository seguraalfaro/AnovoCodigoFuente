unit Anovo.Vistas.Intf.Usuarios;

// Contrato de la vista de Gestion de usuarios.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Usuarios;

type
  TFiltroUsuarios = (fuTodos, fuActivos, fuInactivos, fuClavePendiente,
    fuConAdicionales);
  TAccionUsuario = (auEditar, auEstado);
  TAccionesUsuario = set of TAccionUsuario;

  IVistaUsuarios = interface
    ['{5D2B8E41-7C06-4A93-9F18-E3A0B6C27D54}']
    procedure MostrarAcciones(const AAcciones: TAccionesUsuario;
      const APuedeCrear: Boolean);
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarBusqueda(const ATexto: string;
      const APuedeLimpiar: Boolean);
    procedure MostrarUsuarios(const AUsuarios: TObjectList<TUsuarioDTO>);
    procedure MostrarPaginacion(const APagina, ATotalPaginas: Integer;
      const ATotal: Int64);
    procedure MostrarError(const AMensaje: string);
    function Confirmar(const AMensaje: string): Boolean;
    procedure AbrirUsuario(const AId: Integer);
  end;

implementation

end.
