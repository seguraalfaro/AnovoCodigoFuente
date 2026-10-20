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
  TReporteFilaDTO = class
  private
    fCantidad: Integer;
    fAprobadas: Integer;
    fRechazadas: Integer;
    fDescartadas: Integer;
    fTasaAprobacion: Currency;
    fMontoAprobado: NullableCurrency;
    fMontoTotal: NullableCurrency;
  public
    property Cantidad: Integer read fCantidad write fCantidad;
    property Aprobadas: Integer read fAprobadas write fAprobadas;
    property Rechazadas: Integer read fRechazadas write fRechazadas;
    property Descartadas: Integer read fDescartadas write fDescartadas;
    property TasaAprobacion: Currency read fTasaAprobacion write fTasaAprobacion;
    property MontoAprobado: NullableCurrency read fMontoAprobado write fMontoAprobado;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
  end;

  [MVCNameCase(ncSnakeCase)]
  TReporteAsesorDTO = class(TReporteFilaDTO)
  private
    fAsesorId: Integer;
    fAsesorNombre: string;
  public
    property AsesorId: Integer read fAsesorId write fAsesorId;
    property AsesorNombre: string read fAsesorNombre write fAsesorNombre;
  end;

  [MVCNameCase(ncSnakeCase)]
  TReporteTipoDTO = class(TReporteFilaDTO)
  private
    fTipoTrabajoId: NullableInt32;
    fTipoTrabajoNombre: string;
  public
    property TipoTrabajoId: NullableInt32 read fTipoTrabajoId write fTipoTrabajoId;
    property TipoTrabajoNombre: string read fTipoTrabajoNombre write fTipoTrabajoNombre;
  end;

  [MVCNameCase(ncSnakeCase)]
  TReporteMesDTO = class(TReporteFilaDTO)
  private
    fAnio: Integer;
    fMes: Integer;
  public
    property Anio: Integer read fAnio write fAnio;
    property Mes: Integer read fMes write fMes;
  end;

  [MVCNameCase(ncSnakeCase)]
  TReporteClienteDTO = class
  private
    fClienteId: Integer;
    fClienteNombre: string;
    fEnviadas: Integer;
    fAprobadas: Integer;
    fRechazadas: Integer;
    fEnEspera: Integer;
    fSinRespuesta: Integer;
    fPorcentajeSinRespuesta: Currency;
    fMontoSinRespuesta: NullableCurrency;
    fUltimoEnvio: NullableTDateTime;
  public
    property ClienteId: Integer read fClienteId write fClienteId;
    property ClienteNombre: string read fClienteNombre write fClienteNombre;
    property Enviadas: Integer read fEnviadas write fEnviadas;
    property Aprobadas: Integer read fAprobadas write fAprobadas;
    property Rechazadas: Integer read fRechazadas write fRechazadas;
    property EnEspera: Integer read fEnEspera write fEnEspera;
    property SinRespuesta: Integer read fSinRespuesta write fSinRespuesta;
    property PorcentajeSinRespuesta: Currency read fPorcentajeSinRespuesta
      write fPorcentajeSinRespuesta;
    property MontoSinRespuesta: NullableCurrency read fMontoSinRespuesta
      write fMontoSinRespuesta;
    property UltimoEnvio: NullableTDateTime read fUltimoEnvio
      write fUltimoEnvio;
  end;

  [MVCNameCase(ncSnakeCase)]
  TReporteResumenDTO = class
  private
    fDesde: TDateTime;
    fHasta: TDateTime;
    fTotal: Integer;
    fMontoTotal: Currency;
    fAprobadas: Integer;
    fMontoAprobado: Currency;
    fRechazadas: Integer;
    fDescartadas: Integer;
    fTasaAprobacion: Currency;
    fRespuestaMedia: Integer;
  public
    property Desde: TDateTime read fDesde write fDesde;
    property Hasta: TDateTime read fHasta write fHasta;
    property Total: Integer read fTotal write fTotal;
    property MontoTotal: Currency read fMontoTotal write fMontoTotal;
    property Aprobadas: Integer read fAprobadas write fAprobadas;
    property MontoAprobado: Currency read fMontoAprobado write fMontoAprobado;
    property Rechazadas: Integer read fRechazadas write fRechazadas;
    property Descartadas: Integer read fDescartadas write fDescartadas;
    property TasaAprobacion: Currency read fTasaAprobacion write fTasaAprobacion;
    property RespuestaMedia: Integer read fRespuestaMedia write fRespuestaMedia;
  end;

  [MVCNameCase(ncSnakeCase)]
  TReporteCotizacionesDTO = class(TReporteResumenDTO)
  private
    fEmpresaRazonSocial: string;
    fEmpresaCedula: string;
    fEmpresaTelefono: string;
    fEmpresaCorreo: string;
    fAnterior: TReporteResumenDTO;
    fPorEstado: TObjectList<TCotizacionesPorEstadoDTO>;
    fPorAsesor: TObjectList<TReporteAsesorDTO>;
    fPorTipo: TObjectList<TReporteTipoDTO>;
    fPorMes: TObjectList<TReporteMesDTO>;
    fPorCliente: TObjectList<TReporteClienteDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    property EmpresaRazonSocial: string read fEmpresaRazonSocial
      write fEmpresaRazonSocial;
    property EmpresaCedula: string read fEmpresaCedula write fEmpresaCedula;
    property EmpresaTelefono: string read fEmpresaTelefono
      write fEmpresaTelefono;
    property EmpresaCorreo: string read fEmpresaCorreo write fEmpresaCorreo;
    property Anterior: TReporteResumenDTO read fAnterior write fAnterior;
    property PorEstado: TObjectList<TCotizacionesPorEstadoDTO> read fPorEstado
      write fPorEstado;
    property PorAsesor: TObjectList<TReporteAsesorDTO> read fPorAsesor
      write fPorAsesor;
    property PorTipo: TObjectList<TReporteTipoDTO> read fPorTipo
      write fPorTipo;
    property PorMes: TObjectList<TReporteMesDTO> read fPorMes
      write fPorMes;
    property PorCliente: TObjectList<TReporteClienteDTO> read fPorCliente
      write fPorCliente;
  end;

implementation

constructor TReporteCotizacionesDTO.Create;
begin
  inherited Create;
  fAnterior := TReporteResumenDTO.Create;
  fPorEstado := TObjectList<TCotizacionesPorEstadoDTO>.Create(True);
  fPorAsesor := TObjectList<TReporteAsesorDTO>.Create(True);
  fPorTipo := TObjectList<TReporteTipoDTO>.Create(True);
  fPorMes := TObjectList<TReporteMesDTO>.Create(True);
  fPorCliente := TObjectList<TReporteClienteDTO>.Create(True);
end;

destructor TReporteCotizacionesDTO.Destroy;
begin
  fPorCliente.Free;
  fPorMes.Free;
  fPorTipo.Free;
  fPorAsesor.Free;
  fPorEstado.Free;
  fAnterior.Free;
  inherited;
end;

end.
