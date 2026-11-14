unit Anovo.Vistas.Intf.SolicitudNueva;

// Contrato de la ventana de solicitud nueva en la oficina (minuta 19/2026).

interface

uses
  System.Classes,
  System.Generics.Collections,
  Anovo.DTOs.Clientes,
  Anovo.DTOs.Catalogos,
  Anovo.Vistas.Intf.Registro;

type
  TMedidaOficina = class
  private
    fTipoMedida: string;
    fTipoNombre: string;
    fValor: Double;
    fUnidadMedida: string;
    fCantidad: Integer;
    fObservacion: string;
  public
    property TipoMedida: string read fTipoMedida write fTipoMedida;
    property TipoNombre: string read fTipoNombre write fTipoNombre;
    property Valor: Double read fValor write fValor;
    property UnidadMedida: string read fUnidadMedida write fUnidadMedida;
    property Cantidad: Integer read fCantidad write fCantidad;
    property Observacion: string read fObservacion write fObservacion;
  end;

  TPlanoOficina = class
  private
    fNombre: string;
    fRuta: string;
    fTamanoKb: Integer;
  public
    property Nombre: string read fNombre write fNombre;
    property Ruta: string read fRuta write fRuta;
    property TamanoKb: Integer read fTamanoKb write fTamanoKb;
  end;

  IVistaSolicitudNueva = interface(IVistaRegistro)
    ['{6F2C8A41-93D7-4B1E-A5C0-2E7D94B1F638}']
    procedure MostrarContactos(const AContactos: TObjectList<TContactoDTO>;
      const APrincipal: Integer);
    procedure MostrarTiposTrabajo(const ATipos: TObjectList<TTipoTrabajoDTO>);
    procedure MostrarMateriales(const AMateriales
      : TObjectList<TCatalogoSimpleDTO>);
    procedure MostrarAcabados(const AAcabados: TObjectList<TCatalogoSimpleDTO>);
    procedure MostrarUnidades(const AUnidades: TObjectList<TUnidadMedidaDTO>);
    procedure MostrarUnidadesDe(const AMagnitud: string);
    procedure MostrarMedidas(const AMedidas: TObjectList<TMedidaOficina>);
    procedure MostrarPlanos(const APlanos: TObjectList<TPlanoOficina>);
    procedure AvisarReparos(const AReparos: TStrings);
  end;

implementation

end.
