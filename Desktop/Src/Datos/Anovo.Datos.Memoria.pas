unit Anovo.Datos.Memoria;

// Las tablas en memoria de la aplicacion, en un solo sitio.
//
// Son parte de la vista, no del presentador: el presentador trabaja con DTO y
// no sabe que esto existe. La pantalla copia los DTO a su tabla y la enlaza a
// la rejilla, o a los controles con LiveBindings en las fichas.
//
// Campos persistentes a proposito: la pantalla escribe
// dmMemoria.mtClientesNOMBRE y no FieldByName('NOMBRE'). Un nombre mal escrito
// no compila, en vez de fallar al ejecutar.
//
// Una tabla por uso, no una compartida: si la lista y la ficha usaran la misma,
// abrir la ficha moveria el cursor de la lista.
//
// Viven lo que vive la aplicacion, asi que guardan datos personales de terceros
// mas alla de la pantalla que los mostro. Limpiar va al cerrar sesion: Ley 8968.
//
// mtClientes              Gestion de clientes: la lista
// mtClienteDetalle        Ficha de un cliente: un registro, para LiveBindings
// mtContactos             Contactos del cliente abierto
// mtConsentimientos       Historial de consentimiento del cliente abierto
// mtClienteCotizaciones   Cotizaciones del cliente abierto
// mtSolicitudes           Solicitudes del asesor
// mtPorCotizar            Bandeja: solicitudes sin cotizacion
// mtPorAprobar            Bandeja: cotizaciones pendientes, sin las propias
// mtCotizaciones          Listado de cotizaciones
// mtCotizacionLineas      Lineas de la cotizacion que se arma
// mtRecientes             Dashboard: ultimas cotizaciones
// mtGerenciaPendientes    Vista de gerencia: por aprobar
// mtGerenciaRecientes     Vista de gerencia: movimiento reciente
// mtMateriales            Catalogo de materiales
// mtManoObra              Catalogo de mano de obra
// mtMaquinas              Catalogo de maquinas
// mtTiposTrabajo          Catalogo de tipos de trabajo
// mtHistorialPrecios      Historial de precios del item abierto
// mtFotos                 Fotos y croquis de la solicitud abierta
// mtUsuarios              Gestion de usuarios
// mtRoles                 Roles y permisos: los roles
// mtPermisos              Roles y permisos: la matriz del rol abierto
// mtAuditoria             Bitacora de auditoria
// mtTiposIdentificacion  Catalogo: los tres tipos de identificacion

interface

uses
  Anovo.DTOs.Clientes, Anovo.Validacion, Anovo.Formato,
  System.Generics.Collections,
  System.SysUtils, System.Classes, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.FBDef, FireDAC.Phys,
  FireDAC.Phys.IBBase, FireDAC.Phys.FB;

type
  TdmMemoria = class(TDataModule)
    mtClientes: TFDMemTable;
    mtClientesID: TIntegerField;
    mtClientesIDENTIFICACION: TStringField;
    mtClientesNOMBRE: TStringField;
    mtClientesTELEFONO: TStringField;
    mtClientesCORREO: TStringField;
    mtClientesCONSENTIMIENTO_ESTADO: TStringField;
    mtClientesACCIONES: TStringField;
    mtClienteDetalle: TFDMemTable;
    mtClienteDetalleID: TIntegerField;
    mtClienteDetalleUUID_LOCAL: TStringField;
    mtClienteDetalleNOMBRE: TStringField;
    mtClienteDetalleIDENTIFICACION: TStringField;
    mtClienteDetalleTIPO_IDENTIFICACION: TSmallintField;
    mtClienteDetalleTIPO_IDENTIFICACION_TEXTO: TStringField;
    mtClienteDetalleCONTACTO: TStringField;
    mtClienteDetalleTELEFONO: TStringField;
    mtClienteDetalleCORREO: TStringField;
    mtClienteDetalleDIRECCION: TStringField;
    mtClienteDetalleLATITUD: TFloatField;
    mtClienteDetalleLONGITUD: TFloatField;
    mtClienteDetalleACTIVO: TBooleanField;
    mtClienteDetalleEXONERADO: TBooleanField;
    mtClienteDetalleCODIGO_EXONERACION: TStringField;
    mtClienteDetalleCONSENTIMIENTO_ESTADO: TStringField;
    mtClienteDetalleCONSENTIMIENTO_FECHA: TDateTimeField;
    mtClienteDetalleCONSENTIMIENTO_VERSION: TStringField;
    mtClienteDetalleOBJVERSION: TIntegerField;
    mtContactos: TFDMemTable;
    mtContactosID: TIntegerField;
    mtContactosNOMBRE: TStringField;
    mtContactosAREA: TStringField;
    mtContactosTELEFONO: TStringField;
    mtContactosCORREO: TStringField;
    mtContactosPRINCIPAL: TStringField;
    mtContactosACCIONES: TStringField;
    mtConsentimientos: TFDMemTable;
    mtConsentimientosFECHA: TDateTimeField;
    mtConsentimientosACCION: TStringField;
    mtConsentimientosVERSION_TEXTO: TStringField;
    mtConsentimientosFIRMANTE_NOMBRE: TStringField;
    mtClienteCotizaciones: TFDMemTable;
    mtClienteCotizacionesID: TIntegerField;
    mtClienteCotizacionesNUMERO: TStringField;
    mtClienteCotizacionesTIPO: TStringField;
    mtClienteCotizacionesFECHA_ELABORACION: TDateField;
    mtClienteCotizacionesASESOR: TStringField;
    mtClienteCotizacionesMONTO_TOTAL: TCurrencyField;
    mtClienteCotizacionesESTADO: TStringField;
    mtClienteCotizacionesACCIONES: TStringField;
    mtSolicitudes: TFDMemTable;
    mtSolicitudesID: TIntegerField;
    mtSolicitudesCODIGO: TStringField;
    mtSolicitudesCLIENTE: TStringField;
    mtSolicitudesASESOR: TStringField;
    mtSolicitudesFECHA_RECEPCION: TDateTimeField;
    mtSolicitudesFOTOS: TIntegerField;
    mtSolicitudesCROQUIS: TStringField;
    mtSolicitudesESTADO: TStringField;
    mtSolicitudesACCIONES: TStringField;
    mtPorCotizar: TFDMemTable;
    mtPorCotizarID: TIntegerField;
    mtPorCotizarCODIGO: TStringField;
    mtPorCotizarCLIENTE: TStringField;
    mtPorCotizarFECHA_RECEPCION: TDateField;
    mtPorCotizarASESOR: TStringField;
    mtPorCotizarESTADO: TStringField;
    mtPorCotizarACCIONES: TStringField;
    mtPorAprobar: TFDMemTable;
    mtPorAprobarID: TIntegerField;
    mtPorAprobarNUMERO: TStringField;
    mtPorAprobarCLIENTE: TStringField;
    mtPorAprobarFECHA_ELABORACION: TDateField;
    mtPorAprobarASESOR: TStringField;
    mtPorAprobarMONTO_TOTAL: TCurrencyField;
    mtPorAprobarESTADO: TStringField;
    mtPorAprobarACCIONES: TStringField;
    mtCotizaciones: TFDMemTable;
    mtCotizacionesID: TIntegerField;
    mtCotizacionesNUMERO: TStringField;
    mtCotizacionesCLIENTE: TStringField;
    mtCotizacionesFECHA_ELABORACION: TDateField;
    mtCotizacionesASESOR: TStringField;
    mtCotizacionesMONTO_TOTAL: TCurrencyField;
    mtCotizacionesESTADO: TStringField;
    mtCotizacionesACCIONES: TStringField;
    mtCotizacionLineas: TFDMemTable;
    mtCotizacionLineasID: TIntegerField;
    mtCotizacionLineasCODIGO: TStringField;
    mtCotizacionLineasDESCRIPCION: TStringField;
    mtCotizacionLineasUNIDAD_MEDIDA: TStringField;
    mtCotizacionLineasCANTIDAD: TFloatField;
    mtCotizacionLineasPRECIO_UNITARIO: TCurrencyField;
    mtCotizacionLineasSUBTOTAL: TCurrencyField;
    mtCotizacionLineasACCIONES: TStringField;
    mtRecientes: TFDMemTable;
    mtRecientesID: TIntegerField;
    mtRecientesNUMERO: TStringField;
    mtRecientesCLIENTE: TStringField;
    mtRecientesFECHA_ELABORACION: TDateField;
    mtRecientesMONTO_TOTAL: TCurrencyField;
    mtRecientesESTADO: TStringField;
    mtGerenciaPendientes: TFDMemTable;
    mtGerenciaPendientesID: TIntegerField;
    mtGerenciaPendientesNUMERO: TStringField;
    mtGerenciaPendientesCLIENTE: TStringField;
    mtGerenciaPendientesFECHA_ELABORACION: TDateField;
    mtGerenciaPendientesASESOR: TStringField;
    mtGerenciaPendientesMONTO_TOTAL: TCurrencyField;
    mtGerenciaPendientesESTADO: TStringField;
    mtGerenciaPendientesACCIONES: TStringField;
    mtGerenciaRecientes: TFDMemTable;
    mtGerenciaRecientesID: TIntegerField;
    mtGerenciaRecientesNUMERO: TStringField;
    mtGerenciaRecientesCLIENTE: TStringField;
    mtGerenciaRecientesFECHA_ELABORACION: TDateField;
    mtGerenciaRecientesASESOR: TStringField;
    mtGerenciaRecientesMONTO_TOTAL: TCurrencyField;
    mtGerenciaRecientesESTADO: TStringField;
    mtGerenciaRecientesACCIONES: TStringField;
    mtMateriales: TFDMemTable;
    mtMaterialesID: TIntegerField;
    mtMaterialesCODIGO: TStringField;
    mtMaterialesNOMBRE: TStringField;
    mtMaterialesDESCRIPCION: TStringField;
    mtMaterialesUNIDAD_MEDIDA: TStringField;
    mtMaterialesCOSTO_UNITARIO: TCurrencyField;
    mtMaterialesPRECIO_UNITARIO: TCurrencyField;
    mtMaterialesFECHA_VIGENCIA: TDateField;
    mtMaterialesPROGRAMADO_FECHA: TDateField;
    mtMaterialesACTIVO: TBooleanField;
    mtMaterialesESTADO: TStringField;
    mtMaterialesACCIONES: TStringField;
    mtManoObra: TFDMemTable;
    mtManoObraID: TIntegerField;
    mtManoObraCODIGO: TStringField;
    mtManoObraCATEGORIA_ID: TIntegerField;
    mtManoObraCATEGORIA_NOMBRE: TStringField;
    mtManoObraNOMBRE: TStringField;
    mtManoObraDESCRIPCION: TStringField;
    mtManoObraUNIDAD_MEDIDA: TStringField;
    mtManoObraCOSTO_UNITARIO: TCurrencyField;
    mtManoObraFECHA_VIGENCIA: TDateField;
    mtManoObraPROGRAMADO_FECHA: TDateField;
    mtManoObraACTIVO: TBooleanField;
    mtManoObraESTADO: TStringField;
    mtManoObraACCIONES: TStringField;
    mtMaquinas: TFDMemTable;
    mtMaquinasID: TIntegerField;
    mtMaquinasCODIGO: TStringField;
    mtMaquinasNOMBRE: TStringField;
    mtMaquinasDESCRIPCION: TStringField;
    mtMaquinasCOSTO_HORA: TCurrencyField;
    mtMaquinasFECHA_VIGENCIA: TDateField;
    mtMaquinasPROGRAMADO_FECHA: TDateField;
    mtMaquinasACTIVO: TBooleanField;
    mtMaquinasESTADO: TStringField;
    mtMaquinasACCIONES: TStringField;
    mtTodos: TFDMemTable;
    mtTodosTIPO: TStringField;
    mtTodosID: TIntegerField;
    mtTodosCODIGO: TStringField;
    mtTodosNOMBRE: TStringField;
    mtTodosDESCRIPCION: TStringField;
    mtTodosUNIDAD_MEDIDA: TStringField;
    mtTodosCATEGORIA_ID: TIntegerField;
    mtTodosCOSTO_UNITARIO: TCurrencyField;
    mtTodosPRECIO_UNITARIO: TCurrencyField;
    mtTodosCOSTO_HORA: TCurrencyField;
    mtTodosCOSTO: TCurrencyField;
    mtTodosFECHA_VIGENCIA: TDateField;
    mtTodosPROGRAMADO_FECHA: TDateField;
    mtTodosACTIVO: TBooleanField;
    mtTodosESTADO: TStringField;
    mtTodosACCIONES: TStringField;
    mtTiposTrabajo: TFDMemTable;
    mtTiposTrabajoID: TIntegerField;
    mtTiposTrabajoNOMBRE: TStringField;
    mtTiposTrabajoACTIVO: TBooleanField;
    mtTiposTrabajoESTADO: TStringField;
    mtTiposTrabajoACCIONES: TStringField;
    mtHistorialPrecios: TFDMemTable;
    mtHistorialPreciosFECHA_VIGENCIA: TDateField;
    mtHistorialPreciosPRECIO_UNITARIO: TCurrencyField;
    mtHistorialPreciosVARIACION: TStringField;
    mtHistorialPreciosMODIFICADO_POR: TStringField;
    mtHistorialPreciosREGISTRADO: TDateTimeField;
    mtFotos: TFDMemTable;
    mtFotosID: TIntegerField;
    mtFotosNOMBRE_ARCHIVO: TStringField;
    mtFotosFECHA_CREACION: TDateTimeField;
    mtFotosACCIONES: TStringField;
    mtUsuarios: TFDMemTable;
    mtUsuariosID: TIntegerField;
    mtUsuariosUSUARIO: TStringField;
    mtUsuariosNOMBRE: TStringField;
    mtUsuariosCORREO: TStringField;
    mtUsuariosROL: TStringField;
    mtUsuariosULTIMO_ACCESO: TDateTimeField;
    mtUsuariosACTIVO: TStringField;
    mtUsuariosACCIONES: TStringField;
    mtRoles: TFDMemTable;
    mtRolesID: TIntegerField;
    mtRolesCODIGO: TStringField;
    mtRolesNOMBRE: TStringField;
    mtRolesUSUARIOS: TIntegerField;
    mtRolesPERMISOS: TIntegerField;
    mtRolesACTIVO: TStringField;
    mtRolesACCIONES: TStringField;
    mtPermisos: TFDMemTable;
    mtPermisosID: TIntegerField;
    mtPermisosCODIGO: TStringField;
    mtPermisosNOMBRE: TStringField;
    mtPermisosMODULO: TStringField;
    mtPermisosOTORGADO: TBooleanField;
    mtAuditoria: TFDMemTable;
    mtAuditoriaID: TIntegerField;
    mtAuditoriaFECHA: TDateTimeField;
    mtAuditoriaUSUARIO: TStringField;
    mtAuditoriaACCION: TStringField;
    mtAuditoriaENTIDAD: TStringField;
    mtAuditoriaENTIDAD_ID: TIntegerField;
    mtAuditoriaDETALLE: TStringField;
    dsAuditoria: TDataSource;
    mtItemCatalogo: TFDMemTable;
    mtItemCatalogoCODIGO: TStringField;
    mtItemCatalogoNOMBRE: TStringField;
    mtItemCatalogoDESCRIPCION: TStringField;
    mtItemCatalogoUNIDAD_MEDIDA: TStringField;
    mtPrecioCatalogo: TFDMemTable;
    mtPrecioCatalogoCOSTO_UNITARIO: TCurrencyField;
    mtPrecioCatalogoPRECIO_UNITARIO: TCurrencyField;
    mtPrecioCatalogoCOSTO_HORA: TCurrencyField;
    mtPrecioCatalogoFECHA_VIGENCIA: TDateField;
    mtHistorialPrecio: TFDMemTable;
    mtHistorialPrecioFECHA_VIGENCIA: TDateField;
    mtHistorialPrecioCOSTO_UNITARIO: TCurrencyField;
    mtHistorialPrecioPRECIO_UNITARIO: TCurrencyField;
    mtHistorialPrecioCOSTO_HORA: TCurrencyField;
    mtHistorialPrecioACTIVO: TBooleanField;
    mtHistorialPrecioESTADO: TStringField;
    dsCatalogo: TDataSource;
    mtUnidadesMedida: TFDMemTable;
    mtUnidadesMedidaNOMBRE: TStringField;
    dsUnidadesMedida: TDataSource;
    dsItemCatalogo: TDataSource;
    dsPrecioCatalogo: TDataSource;
    dsHistorialPrecio: TDataSource;
    dsClientes: TDataSource;
    dsClienteDetalle: TDataSource;
    dsContactos: TDataSource;
    dsConsentimientos: TDataSource;
    mtClienteNuevo: TFDMemTable;
    mtClienteNuevoUUID_LOCAL: TStringField;
    mtClienteNuevoNOMBRE: TStringField;
    mtClienteNuevoIDENTIFICACION: TStringField;
    mtClienteNuevoTIPO_IDENTIFICACION: TSmallintField;
    mtClienteNuevoTIPO_IDENTIFICACION_TEXTO: TStringField;
    mtClienteNuevoCONTACTO: TStringField;
    mtClienteNuevoTELEFONO: TStringField;
    mtClienteNuevoCORREO: TStringField;
    mtClienteNuevoDIRECCION: TStringField;
    mtClienteNuevoLATITUD: TFloatField;
    mtClienteNuevoLONGITUD: TFloatField;
    mtClienteNuevoACTIVO: TBooleanField;
    mtClienteNuevoEXONERADO: TBooleanField;
    mtClienteNuevoCODIGO_EXONERACION: TStringField;
    mtClienteNuevoCONSENTIMIENTO_ESTADO: TStringField;
    mtClienteNuevoCONSENTIMIENTO_FECHA: TDateTimeField;
    mtClienteNuevoCONSENTIMIENTO_VERSION: TStringField;
    mtClienteNuevoANONIMIZADO: TBooleanField;
    mtContactoNuevo: TFDMemTable;
    mtContactoNuevoUUID_LOCAL: TStringField;
    mtContactoNuevoCLIENTE_ID: TIntegerField;
    mtContactoNuevoNOMBRE: TStringField;
    mtContactoNuevoAREA: TStringField;
    mtContactoNuevoTELEFONO: TStringField;
    mtContactoNuevoCELULAR: TStringField;
    mtContactoNuevoCORREO: TStringField;
    mtContactoNuevoPRINCIPAL: TBooleanField;
    mtContactoNuevoCONSENTIMIENTO_ESTADO: TStringField;
    mtContactoNuevoANONIMIZADO: TBooleanField;
    mtContactoNuevoACTIVO: TBooleanField;
    dsClienteNuevo: TDataSource;
    dsContactoNuevo: TDataSource;
    mtTiposIdentificacion: TFDMemTable;
    mtTiposIdentificacionID: TSmallintField;
    mtTiposIdentificacionNOMBRE: TStringField;
    dsTiposIdentificacion: TDataSource;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
    procedure mtContactoNuevoBeforePost(DataSet: TDataSet);
  private
    procedure CargarTiposIdentificacion;
  public
    // Dejan la tabla con una fila lista para escribir encima: el uuid y
    // lo que decide la aplicacion, que no se pregunta en el formulario.
    procedure CargarUnidadesMedida;
    procedure PrepararItemCatalogo;
    procedure PrepararPrecioCatalogo;
    procedure PrepararClienteNuevo;
    procedure PrepararContactoNuevo(const AClienteId: Integer);
  end;

var
  dmMemoria: TdmMemoria;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

const
  // Ni el cliente ni el contacto han firmado nada al crearse.
  CONSENTIMIENTO_PENDIENTE = 'pendiente';

  UNIDADES_MEDIDA: array [0 .. 9] of string = ('unidad', 'metro',
    'metro cuadrado', 'kilogramo', 'tonelada', 'litro', 'hora', 'pulgada',
    'lamina', 'tubo');

// El uuid lo genera quien crea el registro, aqui el escritorio. Es lo que
// hace idempotente reenviarlo si la respuesta se pierde de vuelta: el
// servidor lo usa para no duplicar.
function NuevoUuid: string;
begin
  Result := LowerCase(TGUID.NewGuid.ToString.Trim(['{', '}']));
end;

procedure TdmMemoria.DataModuleCreate(Sender: TObject);
begin
  CargarTiposIdentificacion;
  CargarUnidadesMedida;
end;

// El catalogo sale del enum, no de una lista escrita aparte: el valor que se
// guarda es el orden del enum -1 fisica, 2 juridica, 3 DIMEX-, el mismo que
// admite CK_CLIENTES_TIPO_IDENT y el mismo que manda el movil.
// tiSinEspecificar no entra: sin tipo elegido la columna queda nula.
procedure TdmMemoria.CargarTiposIdentificacion;
var
  lTipo: TTipoIdentificacion;
begin
  mtTiposIdentificacion.Close;
  mtTiposIdentificacion.CreateDataSet;
  for lTipo := tiFisica to High(TTipoIdentificacion) do
    mtTiposIdentificacion.AppendRecord([Ord(lTipo),
      TIPOS_IDENTIFICACION[lTipo]]);
  mtTiposIdentificacion.First;
end;


procedure TdmMemoria.mtContactoNuevoBeforePost(DataSet: TDataSet);
begin
  mtContactoNuevoTELEFONO.AsString :=
    TFormato.TelefonoExt(mtContactoNuevoTELEFONO.AsString);
end;

// Las unidades con las que Anovo cotiza. Lista local y no del servidor: la
// columna es texto libre de 20, asi que esto guia lo que se escribe pero no
// lo limita, y un valor viejo que no este aqui se sigue mostrando igual.
procedure TdmMemoria.CargarUnidadesMedida;
var
  lUnidad: string;
begin
  mtUnidadesMedida.Close;
  mtUnidadesMedida.CreateDataSet;
  for lUnidad in UNIDADES_MEDIDA do
    mtUnidadesMedida.AppendRecord([lUnidad]);
  mtUnidadesMedida.First;
end;

procedure TdmMemoria.PrepararItemCatalogo;
begin
  mtItemCatalogo.Close;
  mtItemCatalogo.CreateDataSet;
  mtItemCatalogo.Append;
end;

procedure TdmMemoria.PrepararPrecioCatalogo;
begin
  mtPrecioCatalogo.Close;
  mtPrecioCatalogo.CreateDataSet;
  mtPrecioCatalogo.Append;
  // Rige desde hoy salvo que la persona ponga otra.
  mtPrecioCatalogoFECHA_VIGENCIA.AsDateTime := Date;
end;

procedure TdmMemoria.PrepararClienteNuevo;
begin
  mtClienteNuevo.Close;
  mtClienteNuevo.CreateDataSet;
  mtClienteNuevo.Append;
  mtClienteNuevoUUID_LOCAL.AsString := NuevoUuid;
  // Lo que decide la aplicacion y no se pregunta en la ventana.
  mtClienteNuevoACTIVO.AsBoolean := True;
  mtClienteNuevoANONIMIZADO.AsBoolean := False;
  mtClienteNuevoEXONERADO.AsBoolean := False;
  mtClienteNuevoCONSENTIMIENTO_ESTADO.AsString := CONSENTIMIENTO_PENDIENTE;
end;

procedure TdmMemoria.PrepararContactoNuevo(const AClienteId: Integer);
begin
  mtContactoNuevo.Close;
  mtContactoNuevo.CreateDataSet;
  mtContactoNuevo.Append;
  mtContactoNuevoUUID_LOCAL.AsString := NuevoUuid;
  // De que cliente es lo dice quien abre la ventana, no lo que se escriba.
  mtContactoNuevoCLIENTE_ID.AsInteger := AClienteId;
  mtContactoNuevoACTIVO.AsBoolean := True;
  mtContactoNuevoANONIMIZADO.AsBoolean := False;
  mtContactoNuevoPRINCIPAL.AsBoolean := False;
  // El consentimiento es del cliente, no de cada persona de contacto.
  mtContactoNuevoCONSENTIMIENTO_ESTADO.AsString := CONSENTIMIENTO_PENDIENTE;
end;

end.
