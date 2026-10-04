unit Anovo.Vistas.Intf.Roles;

// Contrato de la vista Roles y permisos: el paquete basico de cada rol.

interface

uses
  System.Generics.Collections,
  MVCFramework.Nullables;

type
  TFilaMatriz = class
  private
    FPermisoId: Integer;
    FModulo: string;
    FNombre: string;
    FAsesor: NullableBoolean;
    FAsistente: NullableBoolean;
    FSupervisor: NullableBoolean;
    FGerencia: NullableBoolean;
    FAdmin: NullableBoolean;
  public
    property PermisoId: Integer read FPermisoId write FPermisoId;
    property Modulo: string read FModulo write FModulo;
    property Nombre: string read FNombre write FNombre;
    property Asesor: NullableBoolean read FAsesor write FAsesor;
    property Asistente: NullableBoolean read FAsistente write FAsistente;
    property Supervisor: NullableBoolean read FSupervisor write FSupervisor;
    property Gerencia: NullableBoolean read FGerencia write FGerencia;
    property Admin: NullableBoolean read FAdmin write FAdmin;
  end;

  IVistaRoles = interface
    ['{7F3C5A92-1E64-4B08-A9D7-2C8B0E61F435}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarRoles(const ATexto: string);
    procedure MostrarMatriz(const AFilas: TObjectList<TFilaMatriz>);
    procedure MostrarCambios(const ACantidad: Integer);
    procedure MostrarError(const AMensaje: string);
  end;

implementation

end.
