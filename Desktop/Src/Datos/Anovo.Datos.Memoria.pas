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

interface

uses
  Anovo.DTOs.Clientes, System.Generics.Collections,
  System.SysUtils, System.Classes, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TdmMemoria = class(TDataModule)
    mtClientes: TFDMemTable;
    mtClientesID: TIntegerField;
    mtClientesIDENTIFICACION: TStringField;
    mtClientesNOMBRE: TStringField;
    mtClientesTELEFONO: TStringField;
    mtClientesCORREO: TStringField;
    mtClientesCONSENTIMIENTO: TStringField;
    mtClientesACCIONES: TStringField;
    mtClienteDetalle: TFDMemTable;
    mtClienteDetalleID: TIntegerField;
    mtClienteDetalleUUID_LOCAL: TStringField;
    mtClienteDetalleNOMBRE: TStringField;
    mtClienteDetalleIDENTIFICACION: TStringField;
    mtClienteDetalleTIPO_IDENTIFICACION: TSmallintField;
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
    mtContactosCARGO: TStringField;
    mtContactosTELEFONO: TStringField;
    mtContactosCORREO: TStringField;
    mtContactosPRINCIPAL: TStringField;
    mtContactosACCIONES: TStringField;
    mtConsentimientos: TFDMemTable;
    mtConsentimientosMOMENTO: TDateTimeField;
    mtConsentimientosACCION: TStringField;
    mtConsentimientosVERSION: TStringField;
    mtConsentimientosUSUARIO: TStringField;
    mtClienteCotizaciones: TFDMemTable;
    mtClienteCotizacionesID: TIntegerField;
    mtClienteCotizacionesCODIGO: TStringField;
    mtClienteCotizacionesTIPO: TStringField;
    mtClienteCotizacionesFECHA: TDateField;
    mtClienteCotizacionesASESOR: TStringField;
    mtClienteCotizacionesMONTO: TCurrencyField;
    mtClienteCotizacionesESTADO: TStringField;
    mtSolicitudes: TFDMemTable;
    mtSolicitudesID: TIntegerField;
    mtSolicitudesCODIGO: TStringField;
    mtSolicitudesCLIENTE: TStringField;
    mtSolicitudesASESOR: TStringField;
    mtSolicitudesRECIBIDA: TDateTimeField;
    mtSolicitudesFOTOS: TIntegerField;
    mtSolicitudesCROQUIS: TStringField;
    mtSolicitudesESTADO: TStringField;
    mtSolicitudesACCIONES: TStringField;
    mtPorCotizar: TFDMemTable;
    mtPorCotizarID: TIntegerField;
    mtPorCotizarCODIGO: TStringField;
    mtPorCotizarCLIENTE: TStringField;
    mtPorCotizarFECHA: TDateField;
    mtPorCotizarASESOR: TStringField;
    mtPorCotizarESTADO: TStringField;
    mtPorCotizarACCIONES: TStringField;
    mtPorAprobar: TFDMemTable;
    mtPorAprobarID: TIntegerField;
    mtPorAprobarCODIGO: TStringField;
    mtPorAprobarCLIENTE: TStringField;
    mtPorAprobarFECHA: TDateField;
    mtPorAprobarASESOR: TStringField;
    mtPorAprobarMONTO: TCurrencyField;
    mtPorAprobarESTADO: TStringField;
    mtPorAprobarACCIONES: TStringField;
    mtCotizaciones: TFDMemTable;
    mtCotizacionesID: TIntegerField;
    mtCotizacionesCODIGO: TStringField;
    mtCotizacionesCLIENTE: TStringField;
    mtCotizacionesFECHA: TDateField;
    mtCotizacionesASESOR: TStringField;
    mtCotizacionesMONTO: TCurrencyField;
    mtCotizacionesESTADO: TStringField;
    mtCotizacionesACCIONES: TStringField;
    mtCotizacionLineas: TFDMemTable;
    mtCotizacionLineasID: TIntegerField;
    mtCotizacionLineasCODIGO: TStringField;
    mtCotizacionLineasDESCRIPCION: TStringField;
    mtCotizacionLineasUNIDAD: TStringField;
    mtCotizacionLineasCANTIDAD: TFloatField;
    mtCotizacionLineasPRECIO: TCurrencyField;
    mtCotizacionLineasSUBTOTAL: TCurrencyField;
    mtCotizacionLineasACCIONES: TStringField;
    mtRecientes: TFDMemTable;
    mtRecientesID: TIntegerField;
    mtRecientesCODIGO: TStringField;
    mtRecientesCLIENTE: TStringField;
    mtRecientesFECHA: TDateField;
    mtRecientesMONTO: TCurrencyField;
    mtRecientesESTADO: TStringField;
    mtGerenciaPendientes: TFDMemTable;
    mtGerenciaPendientesID: TIntegerField;
    mtGerenciaPendientesCODIGO: TStringField;
    mtGerenciaPendientesCLIENTE: TStringField;
    mtGerenciaPendientesFECHA: TDateField;
    mtGerenciaPendientesASESOR: TStringField;
    mtGerenciaPendientesMONTO: TCurrencyField;
    mtGerenciaPendientesESTADO: TStringField;
    mtGerenciaPendientesACCIONES: TStringField;
    mtGerenciaRecientes: TFDMemTable;
    mtGerenciaRecientesID: TIntegerField;
    mtGerenciaRecientesCODIGO: TStringField;
    mtGerenciaRecientesCLIENTE: TStringField;
    mtGerenciaRecientesFECHA: TDateField;
    mtGerenciaRecientesASESOR: TStringField;
    mtGerenciaRecientesMONTO: TCurrencyField;
    mtGerenciaRecientesESTADO: TStringField;
    mtGerenciaRecientesACCIONES: TStringField;
    mtMateriales: TFDMemTable;
    mtMaterialesID: TIntegerField;
    mtMaterialesCODIGO: TStringField;
    mtMaterialesDESCRIPCION: TStringField;
    mtMaterialesUNIDAD: TStringField;
    mtMaterialesPRECIO: TCurrencyField;
    mtMaterialesVIGENTE: TDateField;
    mtMaterialesESTADO: TStringField;
    mtMaterialesACCIONES: TStringField;
    mtManoObra: TFDMemTable;
    mtManoObraID: TIntegerField;
    mtManoObraCODIGO: TStringField;
    mtManoObraDESCRIPCION: TStringField;
    mtManoObraUNIDAD: TStringField;
    mtManoObraTARIFA: TCurrencyField;
    mtManoObraVIGENTE: TDateField;
    mtManoObraESTADO: TStringField;
    mtManoObraACCIONES: TStringField;
    mtMaquinas: TFDMemTable;
    mtMaquinasID: TIntegerField;
    mtMaquinasCODIGO: TStringField;
    mtMaquinasDESCRIPCION: TStringField;
    mtMaquinasUNIDAD: TStringField;
    mtMaquinasTARIFA: TCurrencyField;
    mtMaquinasVIGENTE: TDateField;
    mtMaquinasESTADO: TStringField;
    mtMaquinasACCIONES: TStringField;
    mtTiposTrabajo: TFDMemTable;
    mtTiposTrabajoID: TIntegerField;
    mtTiposTrabajoCODIGO: TStringField;
    mtTiposTrabajoDESCRIPCION: TStringField;
    mtTiposTrabajoMARGEN: TFloatField;
    mtTiposTrabajoESTADO: TStringField;
    mtTiposTrabajoACCIONES: TStringField;
    mtHistorialPrecios: TFDMemTable;
    mtHistorialPreciosVIGENTE: TDateField;
    mtHistorialPreciosPRECIO: TCurrencyField;
    mtHistorialPreciosVARIACION: TStringField;
    mtHistorialPreciosUSUARIO: TStringField;
    mtHistorialPreciosREGISTRADO: TDateTimeField;
    mtFotos: TFDMemTable;
    mtFotosID: TIntegerField;
    mtFotosARCHIVO: TStringField;
    mtFotosTOMADA: TDateTimeField;
    mtFotosACCIONES: TStringField;
    mtUsuarios: TFDMemTable;
    mtUsuariosID: TIntegerField;
    mtUsuariosUSUARIO: TStringField;
    mtUsuariosNOMBRE: TStringField;
    mtUsuariosCORREO: TStringField;
    mtUsuariosROL: TStringField;
    mtUsuariosULTIMO_ACCESO: TDateTimeField;
    mtUsuariosESTADO: TStringField;
    mtUsuariosACCIONES: TStringField;
    mtRoles: TFDMemTable;
    mtRolesID: TIntegerField;
    mtRolesROL: TStringField;
    mtRolesDESCRIPCION: TStringField;
    mtRolesUSUARIOS: TIntegerField;
    mtRolesPERMISOS: TIntegerField;
    mtRolesESTADO: TStringField;
    mtRolesACCIONES: TStringField;
    mtPermisos: TFDMemTable;
    mtPermisosID: TIntegerField;
    mtPermisosCODIGO: TStringField;
    mtPermisosNOMBRE: TStringField;
    mtPermisosMODULO: TStringField;
    mtPermisosOTORGADO: TBooleanField;
    mtAuditoria: TFDMemTable;
    mtAuditoriaMOMENTO: TDateTimeField;
    mtAuditoriaUSUARIO: TStringField;
    mtAuditoriaACCION: TStringField;
    mtAuditoriaENTIDAD: TStringField;
    mtAuditoriaREFERENCIA: TStringField;
    mtAuditoriaORIGEN: TStringField;
    mtAuditoriaACCIONES: TStringField;
    dsClientes: TDataSource;
  public
    procedure MostrarClientes(const AClientes: TObjectList<TClienteDTO>);
  end;

var
  dmMemoria: TdmMemoria;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TdmMemoria.MostrarClientes(const AClientes: TObjectList<TClienteDTO>);
var
  lCliente: TClienteDTO;
  lEstado: string;

begin
  mtClientes.Close;
  mtClientes.CreateDataSet;
  mtClientes.DisableControls;
  try

    mtClientes.EmptyDataSet;
    for lCliente in AClientes do
    begin
      // La pastilla muestra el texto tal cual: con mayuscula inicial se lee
      // como etiqueta y no como valor de base.
      lEstado := lCliente.ConsentimientoEstado;
      if lEstado <> '' then
        lEstado := UpperCase(lEstado[1]) + Copy(lEstado, 2, MaxInt);

      // ACCIONES no se llena: la columna lo necesita para enlazarse y el
      // dibujo de los botones lo tapa.
      mtClientes.Append;
      mtClientesID.AsInteger := lCliente.ID;
      mtClientesIDENTIFICACION.AsString :=
        lCliente.Identificacion.ValueOrDefault;
      mtClientesNOMBRE.AsString := lCliente.Nombre;
      mtClientesTELEFONO.AsString := lCliente.Telefono.ValueOrDefault;
      mtClientesCORREO.AsString := lCliente.Correo.ValueOrDefault;
      mtClientesCONSENTIMIENTO.AsString := lEstado;
      mtClientes.Post;
    end;
    mtClientes.First;
  finally
    mtClientes.EnableControls;
  end;

end;

end.
