unit Anovo.Presentadores.Principal;

{ La logica de la ventana principal, fuera del formulario.

  Que seccion se ve lo deciden los permisos que trajo /api/sesion, no el rol.
  El presentador decide cuales y en que orden; la vista, con que texto e icono.
  SeccionesPermitidas y MenuOrdenado no tocan la vista: son lo que se prueba
  con DUnitX, asignando permisos a TSesion y mirando lo que devuelven. }

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
    class function MenuOrdenado(const APermitidas: TSecciones)
      : TArray<TSeccion>;
  end;

implementation

uses
  System.SysUtils,
  Anovo.Sesion;

const
  SIEMPRE = '*';

  { Codigos de PERMISOS por seccion; separados por ; vale cualquiera. Vacio es
    nadie: una seccion nueva que se agregue sin permiso queda oculta, no
    abierta. Uno mal escrito no da error, esconde la seccion a todos.

    Es la regla del menu, no la del servidor. Materiales pide armar
    cotizaciones o editar el catalogo: el asesor tiene catalogos.ver porque el
    movil lo necesita, pero en el escritorio no le sirve. Si la pidiera por la
    API, el servidor se la daria igual. }
  PERMISOS_SECCION: array [TSeccion] of string = (
    { Mismo orden que TSeccion: el arreglo se llena por posicion, no por el
      comentario. Una fila fuera de lugar corre todas las de abajo y compila. }
    { secDashboard }        'cotizaciones.ver_todas;cotizaciones.ver_aprobadas_propias',
    { secDashboardCuentas } 'usuarios.administrar',
    { secSolicitudes }      'solicitudes.ver_propias',
    { secBandeja }          'cotizaciones.elaborar;cotizaciones.aprobar',
    { secCotizaciones }     'cotizaciones.ver_todas',
    { secGeneracion }       'cotizaciones.elaborar',
    { secDetalle }          'cotizaciones.ver_todas;cotizaciones.ver_aprobadas_propias',
    { secClientes }         'clientes.ver',
    { secMateriales }       'cotizaciones.elaborar;catalogos.editar',
    { secReportes }         'reportes.ver',
    { secGerencia }         'auditoria.ver_toda',
    { secUsuarios }         'usuarios.administrar',
    { secRoles }            'permisos.ver',
    { secConfiguracion }    SIEMPRE);

  { Orden del menu lateral. Detalle no esta: se abre desde una lista. }
  ORDEN_MENU: array [0 .. 12] of TSeccion = (secDashboard, secDashboardCuentas,
    secSolicitudes, secBandeja, secCotizaciones, secGeneracion, secClientes,
    secMateriales, secReportes, secGerencia, secUsuarios, secRoles,
    secConfiguracion);

  { Donde se abre al entrar: la primera de estas que se pueda ver. El admin no
    ve el Dashboard de negocio y abre en el de cuentas. }
  ORDEN_INICIO: array [0 .. 3] of TSeccion = (secDashboard, secDashboardCuentas,
    secUsuarios, secConfiguracion);

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
    if (lCodigos = SIEMPRE) or TSesion.TieneAlguno
      (lCodigos.Split([';'], TStringSplitOptions.ExcludeEmpty)) then
      Include(Result, lSeccion);
  end;
end;

class function TPresentadorPrincipal.MenuOrdenado(const APermitidas: TSecciones)
  : TArray<TSeccion>;
var
  lSeccion: TSeccion;
begin
  Result := nil;
  for lSeccion in ORDEN_MENU do
    if lSeccion in APermitidas then
      Result := Result + [lSeccion];
end;

procedure TPresentadorPrincipal.Iniciar;
var
  lSeccion: TSeccion;
begin
  FPermitidas := SeccionesPermitidas;
  FVista.MostrarUsuario(TSesion.Nombre, NombreDeRol(TSesion.Rol),
    InicialesDe(TSesion.Nombre));
  FVista.MostrarSecciones(MenuOrdenado(FPermitidas));

  for lSeccion in ORDEN_INICIO do
    if lSeccion in FPermitidas then
    begin
      FVista.AbrirSeccion(lSeccion);
      Exit;
    end;
end;

procedure TPresentadorPrincipal.Navegar(const ASeccion: TSeccion);
begin
  { El menu solo tiene las permitidas, pero Navegar tambien lo van a llamar
    las listas, por ejemplo para abrir el detalle de una cotizacion. }
  if ASeccion in FPermitidas then
    FVista.AbrirSeccion(ASeccion);
end;

end.
