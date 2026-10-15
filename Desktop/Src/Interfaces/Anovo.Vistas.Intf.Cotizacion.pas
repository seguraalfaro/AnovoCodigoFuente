unit Anovo.Vistas.Intf.Cotizacion;

// Contratos de la cotizacion: la pantalla de elaboracion y detalle,
// la ventana de una linea y la del ajuste.

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  MVCFramework.Nullables,
  Anovo.DTOs.Catalogos,
  Anovo.DTOs.Cotizaciones,
  Anovo.DTOs.Documento,
  Anovo.DTOs.Solicitudes,
  Anovo.Vistas.Intf.Registro;

type
  TAccionLinea = (alEditar, alQuitar);
  TAccionesLinea = set of TAccionLinea;

  TBotonCotizacion = (bcGuardar, bcPresentar, bcEnviar, bcRespuesta,
    bcAgregarLinea, bcAjuste, bcNuevoTipo, bcDocumento);
  TBotonesCotizacion = set of TBotonCotizacion;

  TModoLinea = (mlMaterial, mlManoObra, mlMaquina, mlNota, mlEditar);

  TItemLinea = class
  private
    fID: Integer;
    fCodigo: string;
    fNombre: string;
    fCategoria: string;
    fUnidadMedida: string;
    fPrecio: Currency;
    fProgramadoFecha: NullableTDateTime;
  public
    property ID: Integer read fID write fID;
    property Codigo: string read fCodigo write fCodigo;
    property Nombre: string read fNombre write fNombre;
    property Categoria: string read fCategoria write fCategoria;
    property UnidadMedida: string read fUnidadMedida write fUnidadMedida;
    property Precio: Currency read fPrecio write fPrecio;
    property ProgramadoFecha: NullableTDateTime read fProgramadoFecha
      write fProgramadoFecha;
  end;

  IVistaCotizacion = interface
    ['{3C7A1E58-92B4-4F06-8D1E-5B2A9C64F07D}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    function Confirmar(const AMensaje: string): Boolean;
    procedure MostrarCotizacion(const ACotizacion: TCotizacionDTO;
      const AConEncabezado: Boolean);
    procedure MostrarDevolucion(const AMotivo: string);
    procedure MostrarDocumento(const ADocumento: TCotizacionDocumentoDTO;
      const ARuta: string);
    procedure MostrarEnvio(const ADocumento: TCotizacionDocumentoDTO);
    procedure MostrarBotones(const ABotones: TBotonesCotizacion;
      const AAcciones: TAccionesLinea);
    procedure MostrarLineas(const ALineas: TObjectList<TLineaDTO>);
    procedure MostrarTiposTrabajo(const ATipos: TObjectList<TTipoTrabajoDTO>);
    procedure MostrarSolicitud(const AProyecto, AContacto: string);
    procedure MostrarPiezas(const APiezas: TObjectList<TPiezaDTO>);
    procedure MostrarMedidas(const APieza: string;
      const AMedidas: TObjectList<TMedidaDTO>);
    procedure MostrarEvidencia(const APieza, ACroquis: string;
      const AFotos: TList<TBytes>; const ACargando: Boolean);
    procedure Regresar;
  end;

  IVistaLineaCotizacion = interface(IVistaRegistro)
    ['{6E0B4D27-1A93-4C85-B7F2-0D8E3A51C946}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarItems(const AItems: TObjectList<TItemLinea>);
    procedure MostrarCategorias(const ACategorias: TObjectList<TCategoriaDTO>);
  end;

  IVistaAjuste = interface(IVistaRegistro)
    ['{A1F58C3E-7D20-4B69-9E14-62C0B7D8E35A}']
    procedure MostrarVistaPrevia(const AAjuste, AIva, ATotal: Currency);
  end;

implementation

end.
