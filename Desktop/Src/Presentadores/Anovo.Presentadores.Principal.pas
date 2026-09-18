unit Anovo.Presentadores.Principal;

{ La logica de la ventana principal, fuera del formulario.

  Que seccion se ve lo deciden los permisos que trajo /api/sesion, no el rol.
  SeccionesPermitidas no toca la vista: es lo que se prueba con DUnitX,
  asignando permisos a TSesion y mirando el conjunto que devuelve. }

interface

uses
  Anovo.Vistas.Intf.Principal;

type
  TPresentadorPrincipal = class
  private
    FVista: IVistaPrincipal;
    FPermitidas: TSecciones;
  public
    constructor Create(const AVista: IVistaPrincipal);
    procedure Iniciar;
    procedure Navegar(const ASeccion: TSeccion);
    class function SeccionesPermitidas: TSecciones;
  end;

implementation

uses
  System.SysUtils,
  Anovo.Sesion;

const
  SIEMPRE = '*';

  { Codigos de PERMISOS por seccion; separados por ; vale cualquiera. Vacio es
    nadie: una seccion nueva que se agregue sin permiso queda oculta, no
    abierta. Uno mal escrito no da error, esconde la seccion a todos. }
  PERMISOS_SECCION: array [TSeccion] of string = (
    { secDashboard }     'cotizaciones.ver_todas;cotizaciones.ver_aprobadas_propias',
    { secCotizaciones }  'cotizaciones.ver_todas;cotizaciones.ver_aprobadas_propias',
    { secGeneracion }    'cotizaciones.elaborar',
    { secDetalle }       'cotizaciones.ver_todas;cotizaciones.ver_aprobadas_propias',
    { secMateriales }    'catalogos.ver',
    { secClientes }      'clientes.ver',
    { secReportes }      'reportes.ver',
    { secBandeja }       'cotizaciones.aprobar',
    { secGerencia }      'auditoria.ver_toda',
    { secUsuarios }      'usuarios.administrar',
    { secRoles }         'permisos.ver',
    { secConfiguracion } SIEMPRE);

  { Donde se abre al entrar: la primera de estas que se pueda ver. El admin no
    ve el Dashboard y abre en Usuarios. }
  ORDEN_INICIO: array [0 .. 2] of TSeccion = (secDashboard, secUsuarios,
    secConfiguracion);

constructor TPresentadorPrincipal.Create(const AVista: IVistaPrincipal);
begin
  inherited Create;
  FVista := AVista;
end;

class function TPresentadorPrincipal.SeccionesPermitidas: TSecciones;
var
  lSeccion: TSeccion;
  lCodigos: string;
begin
  Result := [];
  for lSeccion := Low(TSeccion) to High(TSeccion) do
  begin
    lCodigos := PERMISOS_SECCION[lSeccion];
    if (lCodigos = SIEMPRE) or
      TSesion.TieneAlguno(lCodigos.Split([';'],
      TStringSplitOptions.ExcludeEmpty)) then
      Include(Result, lSeccion);
  end;
end;

procedure TPresentadorPrincipal.Iniciar;
var
  lSeccion: TSeccion;
begin
  FPermitidas := SeccionesPermitidas;
  FVista.MostrarUsuario(TSesion.Nombre, NombreDeRol(TSesion.Rol),
    InicialesDe(TSesion.Nombre));
  FVista.MostrarSecciones(FPermitidas);

  for lSeccion in ORDEN_INICIO do
    if lSeccion in FPermitidas then
    begin
      FVista.AbrirSeccion(lSeccion);
      Exit;
    end;
end;

procedure TPresentadorPrincipal.Navegar(const ASeccion: TSeccion);
begin
  { Una opcion oculta no deberia poder dispararse, pero un atajo de teclado
    de la accion si puede. }
  if ASeccion in FPermitidas then
    FVista.AbrirSeccion(ASeccion);
end;

end.
