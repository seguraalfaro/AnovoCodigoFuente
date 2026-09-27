unit Anovo.Entities.Vistas.Dashboard;

// Filas de solo lectura que devuelven las consultas
// de los dashboards.

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables,
  MVCFramework.ActiveRecord;

type

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  TCifrasAsesorVista = class(TMVCActiveRecord)
  private
    [MVCTableField('SOLICITUDES_MES')]
    fSolicitudesMes: Integer;
    [MVCTableField('ESPERANDO_COTIZACION')]
    fEsperandoCotizacion: Integer;
    [MVCTableField('APROBADAS_MES')]
    fAprobadasMes: Integer;
    [MVCTableField('MONTO_APROBADO_MES')]
    fMontoAprobadoMes: Currency;
  public
    property SolicitudesMes: Integer read fSolicitudesMes write fSolicitudesMes;
    property EsperandoCotizacion: Integer read fEsperandoCotizacion write fEsperandoCotizacion;
    property AprobadasMes: Integer read fAprobadasMes write fAprobadasMes;
    property MontoAprobadoMes: Currency read fMontoAprobadoMes write fMontoAprobadoMes;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  TCifrasAsistenteVista = class(TMVCActiveRecord)
  private
    [MVCTableField('POR_COTIZAR')]
    fPorCotizar: Integer;
    [MVCTableField('MIS_BORRADORES')]
    fMisBorradores: Integer;
    [MVCTableField('EN_APROBACION')]
    fEnAprobacion: Integer;
    [MVCTableField('POR_ENVIAR')]
    fPorEnviar: Integer;
  public
    property PorCotizar: Integer read fPorCotizar write fPorCotizar;
    property MisBorradores: Integer read fMisBorradores write fMisBorradores;
    property EnAprobacion: Integer read fEnAprobacion write fEnAprobacion;
    property PorEnviar: Integer read fPorEnviar write fPorEnviar;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  TCifrasSupervisorVista = class(TMVCActiveRecord)
  private
    [MVCTableField('POR_APROBAR')]
    fPorAprobar: Integer;
    [MVCTableField('DIAS_MAS_ANTIGUA')]
    fDiasMasAntigua: Integer;
    [MVCTableField('APROBADAS_MES')]
    fAprobadasMes: Integer;
    [MVCTableField('MONTO_APROBADO_MES')]
    fMontoAprobadoMes: Currency;
    [MVCTableField('RECHAZADAS_MES')]
    fRechazadasMes: Integer;
  public
    property PorAprobar: Integer read fPorAprobar write fPorAprobar;
    property DiasMasAntigua: Integer read fDiasMasAntigua write fDiasMasAntigua;
    property AprobadasMes: Integer read fAprobadasMes write fAprobadasMes;
    property MontoAprobadoMes: Currency read fMontoAprobadoMes write fMontoAprobadoMes;
    property RechazadasMes: Integer read fRechazadasMes write fRechazadasMes;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  TSolicitudAsesorVista = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('FECHA_CAPTURA')]
    fFechaCaptura: NullableTDateTime;
    [MVCTableField('CLIENTE_NOMBRE')]
    fClienteNombre: String;
    [MVCTableField('DESCRIPCION')]
    fDescripcion: String;
    [MVCTableField('ESTADO')]
    fEstado: String;
    [MVCTableField('COTIZACION_ID')]
    fCotizacionId: NullableInt32;
    [MVCTableField('MONTO_APROBADO')]
    fMontoAprobado: NullableCurrency;
  public
    property ID: NullableInt32 read fID write fID;
    property FechaCaptura: NullableTDateTime read fFechaCaptura
      write fFechaCaptura;
    property ClienteNombre: String read fClienteNombre write fClienteNombre;
    property Descripcion: String read fDescripcion write fDescripcion;
    property Estado: String read fEstado write fEstado;
    property CotizacionId: NullableInt32 read fCotizacionId
      write fCotizacionId;
    property MontoAprobado: NullableCurrency read fMontoAprobado
      write fMontoAprobado;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  TSolicitudPorCotizarVista = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('FECHA_RECEPCION')]
    fFechaRecepcion: NullableTDateTime;
    [MVCTableField('CLIENTE_NOMBRE')]
    fClienteNombre: String;
    [MVCTableField('ASESOR_NOMBRE')]
    fAsesorNombre: String;
    [MVCTableField('DESCRIPCION')]
    fDescripcion: String;
    [MVCTableField('DIAS_ESPERA')]
    fDiasEspera: NullableInt32;
  public
    property ID: NullableInt32 read fID write fID;
    property FechaRecepcion: NullableTDateTime read fFechaRecepcion
      write fFechaRecepcion;
    property ClienteNombre: String read fClienteNombre write fClienteNombre;
    property AsesorNombre: String read fAsesorNombre write fAsesorNombre;
    property Descripcion: String read fDescripcion write fDescripcion;
    property DiasEspera: NullableInt32 read fDiasEspera write fDiasEspera;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  TCotizacionPorAprobarVista = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('NUMERO')]
    fNumero: NullableInt32;
    [MVCTableField('FECHA_PRESENTADA')]
    fFechaPresentada: NullableTDateTime;
    [MVCTableField('CLIENTE_NOMBRE')]
    fClienteNombre: String;
    [MVCTableField('ELABORADA_POR_NOMBRE')]
    fElaboradaPorNombre: String;
    [MVCTableField('MONTO_TOTAL')]
    fMontoTotal: NullableCurrency;
    [MVCTableField('DIAS_ESPERA')]
    fDiasEspera: NullableInt32;
  public
    property ID: NullableInt32 read fID write fID;
    property Numero: NullableInt32 read fNumero write fNumero;
    property FechaPresentada: NullableTDateTime read fFechaPresentada
      write fFechaPresentada;
    property ClienteNombre: String read fClienteNombre write fClienteNombre;
    property ElaboradaPorNombre: String read fElaboradaPorNombre
      write fElaboradaPorNombre;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
    property DiasEspera: NullableInt32 read fDiasEspera write fDiasEspera;
  end;

implementation

end.
