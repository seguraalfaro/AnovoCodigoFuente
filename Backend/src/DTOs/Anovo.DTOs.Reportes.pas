unit Anovo.DTOs.Reportes;

// DTOs de los reportes del proceso de cotizaciones (RF-008).
// Compartidos con el escritorio.

interface

uses
  System.Generics.Collections,
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables,
  Anovo.DTOs.Dashboard;

type

  [MVCNameCase(ncSnakeCase)]
  TReporteAsesorDTO = class
  private
    fAsesorId: Integer;
    fAsesorNombre: string;
    fCantidad: Integer;
    fAprobadas: Integer;
    fRechazadas: Integer;
    fTasaAprobacion: Integer;
    fMontoAprobado: NullableCurrency;
    fMontoTotal: NullableCurrency;
  public
    property AsesorId: Integer read fAsesorId write fAsesorId;
    property AsesorNombre: string read fAsesorNombre write fAsesorNombre;
    property Cantidad: Integer read fCantidad write fCantidad;
    property Aprobadas: Integer read fAprobadas write fAprobadas;
    property Rechazadas: Integer read fRechazadas write fRechazadas;
    property TasaAprobacion: Integer read fTasaAprobacion write fTasaAprobacion;
    property MontoAprobado: NullableCurrency read fMontoAprobado write fMontoAprobado;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
  end;

  [MVCNameCase(ncSnakeCase)]
  TReporteTipoDTO = class
  private
    fTipoTrabajoId: NullableInt32;
    fTipoTrabajoNombre: string;
    fCantidad: Integer;
    fAprobadas: Integer;
    fMontoTotal: NullableCurrency;
  public
    property TipoTrabajoId: NullableInt32 read fTipoTrabajoId write fTipoTrabajoId;
    property TipoTrabajoNombre: string read fTipoTrabajoNombre write fTipoTrabajoNombre;
    property Cantidad: Integer read fCantidad write fCantidad;
    property Aprobadas: Integer read fAprobadas write fAprobadas;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
  end;

  [MVCNameCase(ncSnakeCase)]
  TReporteMesDTO = class
  private
    fAnio: Integer;
    fMes: Integer;
    fCantidad: Integer;
    fAprobadas: Integer;
    fRechazadas: Integer;
    fTasaAprobacion: Integer;
    fMontoTotal: NullableCurrency;
  public
    property Anio: Integer read fAnio write fAnio;
    property Mes: Integer read fMes write fMes;
    property Cantidad: Integer read fCantidad write fCantidad;
    property Aprobadas: Integer read fAprobadas write fAprobadas;
    property Rechazadas: Integer read fRechazadas write fRechazadas;
    property TasaAprobacion: Integer read fTasaAprobacion write fTasaAprobacion;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
  end;

  [MVCNameCase(ncSnakeCase)]
  TReporteCotizacionesDTO = class
  private
    fDesde: TDateTime;
    fHasta: TDateTime;
    fTotal: Integer;
    fMontoTotal: Currency;
    fAprobadas: Integer;
    fRechazadas: Integer;
    fTasaAprobacion: Integer;
    fRespuestaMedia: Integer;
    fPorEstado: TObjectList<TCotizacionesPorEstadoDTO>;
    fPorAsesor: TObjectList<TReporteAsesorDTO>;
    fPorTipo: TObjectList<TReporteTipoDTO>;
    fPorMes: TObjectList<TReporteMesDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    property Desde: TDateTime read fDesde write fDesde;
    property Hasta: TDateTime read fHasta write fHasta;
    property Total: Integer read fTotal write fTotal;
    property MontoTotal: Currency read fMontoTotal write fMontoTotal;
    property Aprobadas: Integer read fAprobadas write fAprobadas;
    property Rechazadas: Integer read fRechazadas write fRechazadas;
    property TasaAprobacion: Integer read fTasaAprobacion write fTasaAprobacion;
    property RespuestaMedia: Integer read fRespuestaMedia write fRespuestaMedia;
    property PorEstado: TObjectList<TCotizacionesPorEstadoDTO> read fPorEstado
      write fPorEstado;
    property PorAsesor: TObjectList<TReporteAsesorDTO> read fPorAsesor
      write fPorAsesor;
    property PorTipo: TObjectList<TReporteTipoDTO> read fPorTipo
      write fPorTipo;
    property PorMes: TObjectList<TReporteMesDTO> read fPorMes
      write fPorMes;
  end;

implementation

constructor TReporteCotizacionesDTO.Create;
begin
  inherited Create;
  fPorEstado := TObjectList<TCotizacionesPorEstadoDTO>.Create(True);
  fPorAsesor := TObjectList<TReporteAsesorDTO>.Create(True);
  fPorTipo := TObjectList<TReporteTipoDTO>.Create(True);
  fPorMes := TObjectList<TReporteMesDTO>.Create(True);
end;

destructor TReporteCotizacionesDTO.Destroy;
begin
  fPorMes.Free;
  fPorTipo.Free;
  fPorAsesor.Free;
  fPorEstado.Free;
  inherited;
end;

end.
