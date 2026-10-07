unit Anovo.DTOs.Documento;

// DTO del documento de la cotizacion que se envia al cliente. Compartido con
// el escritorio, que lo imprime con FortesReport.

interface

uses
  System.Generics.Collections,
  MVCFramework.Serializer.Commons;

type

  [MVCNameCase(ncSnakeCase)]
  TLineaDocumentoDTO = class
  private
    fDescripcion: string;
    fCantidad: Currency;
    fPrecioUnitario: Currency;
    fTotal: Currency;
  public
    property Descripcion: string read fDescripcion write fDescripcion;
    property Cantidad: Currency read fCantidad write fCantidad;
    property PrecioUnitario: Currency read fPrecioUnitario
      write fPrecioUnitario;
    property Total: Currency read fTotal write fTotal;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCotizacionDocumentoDTO = class
  private
    fNumero: Integer;
    fFecha: TDateTime;
    fEmpresaRazonSocial: string;
    fEmpresaCedula: string;
    fEmpresaDireccion: string;
    fEmpresaTelefonoFijo: string;
    fEmpresaCelular: string;
    fEmpresaCorreo: string;
    fCuentaBancaria: string;
    fFirmante: string;
    fCartaPresentacion: string;
    fClienteNombre: string;
    fClienteTelefono: string;
    fContactoNombre: string;
    fDescripcionTrabajo: string;
    fSubtotal: Currency;
    fPorcentajeIva: Currency;
    fMontoImpuesto: Currency;
    fMontoTotal: Currency;
    fFormaPago: string;
    fPlazoEntrega: string;
    fGarantia: string;
    fAvisoPrivacidad: string;
    fLineas: TObjectList<TLineaDocumentoDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    property Numero: Integer read fNumero write fNumero;
    property Fecha: TDateTime read fFecha write fFecha;
    property EmpresaRazonSocial: string read fEmpresaRazonSocial
      write fEmpresaRazonSocial;
    property EmpresaCedula: string read fEmpresaCedula write fEmpresaCedula;
    property EmpresaDireccion: string read fEmpresaDireccion
      write fEmpresaDireccion;
    property EmpresaTelefonoFijo: string read fEmpresaTelefonoFijo
      write fEmpresaTelefonoFijo;
    property EmpresaCelular: string read fEmpresaCelular write fEmpresaCelular;
    property EmpresaCorreo: string read fEmpresaCorreo write fEmpresaCorreo;
    property CuentaBancaria: string read fCuentaBancaria write fCuentaBancaria;
    property Firmante: string read fFirmante write fFirmante;
    property CartaPresentacion: string read fCartaPresentacion
      write fCartaPresentacion;
    property ClienteNombre: string read fClienteNombre write fClienteNombre;
    property ClienteTelefono: string read fClienteTelefono
      write fClienteTelefono;
    property ContactoNombre: string read fContactoNombre write fContactoNombre;
    property DescripcionTrabajo: string read fDescripcionTrabajo
      write fDescripcionTrabajo;
    property Subtotal: Currency read fSubtotal write fSubtotal;
    property PorcentajeIva: Currency read fPorcentajeIva write fPorcentajeIva;
    property MontoImpuesto: Currency read fMontoImpuesto write fMontoImpuesto;
    property MontoTotal: Currency read fMontoTotal write fMontoTotal;
    property FormaPago: string read fFormaPago write fFormaPago;
    property PlazoEntrega: string read fPlazoEntrega write fPlazoEntrega;
    property Garantia: string read fGarantia write fGarantia;
    property AvisoPrivacidad: string read fAvisoPrivacidad
      write fAvisoPrivacidad;
    property Lineas: TObjectList<TLineaDocumentoDTO> read fLineas
      write fLineas;
  end;

implementation

constructor TCotizacionDocumentoDTO.Create;
begin
  inherited Create;
  fLineas := TObjectList<TLineaDocumentoDTO>.Create(True);
end;

destructor TCotizacionDocumentoDTO.Destroy;
begin
  fLineas.Free;
  inherited;
end;

end.
