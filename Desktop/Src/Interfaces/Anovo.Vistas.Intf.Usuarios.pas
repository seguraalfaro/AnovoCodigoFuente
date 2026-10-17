unit Anovo.Vistas.Intf.Usuarios;

// Contrato de la vista de Gestion de usuarios.

interface

uses
  Anovo.Vistas.Intf.Listado,
  System.Generics.Collections,
  Anovo.DTOs.Usuarios;

type
  TFiltroUsuarios = (fuTodos, fuActivos, fuInactivos, fuClavePendiente,
    fuConAdicionales);
  TAccionUsuario = (auEditar, auEstado);
  TAccionesUsuario = set of TAccionUsuario;

  IVistaUsuarios = interface(IVistaListado)
    ['{5D2B8E41-7C06-4A93-9F18-E3A0B6C27D54}']
    procedure MostrarAcciones(const AAcciones: TAccionesUsuario;
      const APuedeCrear: Boolean);
    procedure MostrarUsuarios(const AUsuarios: TObjectList<TUsuarioDTO>);
    function Confirmar(const AMensaje: string): Boolean;
    procedure AbrirUsuario(const AId: Integer);
  end;

implementation

end.
