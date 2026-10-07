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
    fFormaPago: NullableString;
    fPlazoEntrega: NullableString;
    fGarantia: NullableString;
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
    property FormaPago: NullableString read fFormaPago write fFormaPago;
    property PlazoEntrega: NullableString read fPlazoEntrega
      write fPlazoEntrega;
    property Garantia: NullableString read fGarantia write fGarantia;
    property Firmante: NullableString read fFirmante write fFirmante;
    property CartaPresentacion: NullableString read fCartaPresentacion
      write fCartaPresentacion;
  end;

implementation

end.
