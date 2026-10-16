unit Anovo.DTOs.Empresa;

// DTO de los datos de la empresa y sus parametros. Compartido con el
// escritorio.

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables;

type

  [MVCNameCase(ncSnakeCase)]
  TEmpresaDTO = class
  private
    fRazonSocial: string;
    fCedulaJuridica: string;
    fDireccion: NullableString;
    fTelefonoFijo: NullableString;
    fCelular: NullableString;
    fCorreo: NullableString;
    fRepresentanteLegal: NullableString;
    fCuentaBancaria: NullableString;
    fPorcentajeIva: Currency;
    fDiasSinRespuesta: Integer;
    fFormaPagoId: NullableInt32;
    fPlazoEntregaCantidad: NullableInt32;
    fPlazoEntregaUnidad: NullableString;
    fGarantiaCantidad: NullableInt32;
    fGarantiaUnidad: NullableString;
    fFirmante: NullableString;
    fCartaPresentacion: NullableString;
  public
    property RazonSocial: string read fRazonSocial write fRazonSocial;
    property CedulaJuridica: string read fCedulaJuridica write fCedulaJuridica;
    property Direccion: NullableString read fDireccion write fDireccion;
    property TelefonoFijo: NullableString read fTelefonoFijo write fTelefonoFijo;
    property Celular: NullableString read fCelular write fCelular;
    property Correo: NullableString read fCorreo write fCorreo;
    property RepresentanteLegal: NullableString read fRepresentanteLegal
      write fRepresentanteLegal;
    property CuentaBancaria: NullableString read fCuentaBancaria
      write fCuentaBancaria;
    property PorcentajeIva: Currency read fPorcentajeIva write fPorcentajeIva;
    property DiasSinRespuesta: Integer read fDiasSinRespuesta
      write fDiasSinRespuesta;
    property FormaPagoId: NullableInt32 read fFormaPagoId write fFormaPagoId;
    property PlazoEntregaCantidad: NullableInt32 read fPlazoEntregaCantidad
      write fPlazoEntregaCantidad;
    property PlazoEntregaUnidad: NullableString read fPlazoEntregaUnidad
      write fPlazoEntregaUnidad;
    property GarantiaCantidad: NullableInt32 read fGarantiaCantidad
      write fGarantiaCantidad;
    property GarantiaUnidad: NullableString read fGarantiaUnidad
      write fGarantiaUnidad;
    property Firmante: NullableString read fFirmante write fFirmante;
    property CartaPresentacion: NullableString read fCartaPresentacion
      write fCartaPresentacion;
  end;

implementation

end.
