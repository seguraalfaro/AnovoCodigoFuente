unit Anovo.Services.Documento;

// Arma el documento de la cotizacion para el cliente: encabezado de EMPRESA,
// cliente y contacto principal, una linea con el trabajo y los totales.

interface

uses
  MVCFramework,
  Anovo.DTOs.Documento,
  Anovo.Repositories.Intf.Clientes,
  Anovo.Repositories.Intf.Empresa,
  Anovo.Services.Intf.Cotizaciones,
  Anovo.Services.Intf.Documento;

type
  TCotizacionDocumentoService = class(TInterfacedObject,
    ICotizacionDocumentoService)
  private
    fCotizaciones: ICotizacionService;
    fClientes: IClienteRepository;
    fContactos: IClienteContactoRepository;
    fEmpresa: IEmpresaRepository;
    procedure LlenarEmpresa(const ADocumento: TCotizacionDocumentoDTO);
    procedure LlenarCliente(const ADocumento: TCotizacionDocumentoDTO;
      const AClienteId: Integer);
  public
    [MVCInject]
    constructor Create(ACotizaciones: ICotizacionService;
      AClientes: IClienteRepository; AContactos: IClienteContactoRepository;
      AEmpresa: IEmpresaRepository); reintroduce;
    function Documento(const AId, AUsuarioId: Integer;
      const ARoles: TArray<string>): TCotizacionDocumentoDTO;
  end;

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
  MVCFramework.Commons,
  Anovo.DTOs.Cotizaciones,
  Anovo.Entities.Clientes,
  Anovo.Entities.Empresa;

const
  AVISO_POR_DEFECTO = '1.1';

constructor TCotizacionDocumentoService.Create(ACotizaciones: ICotizacionService;
  AClientes: IClienteRepository; AContactos: IClienteContactoRepository;
  AEmpresa: IEmpresaRepository);
begin
  inherited Create;
  fCotizaciones := ACotizaciones;
  fClientes := AClientes;
  fContactos := AContactos;
  fEmpresa := AEmpresa;
end;

procedure TCotizacionDocumentoService.LlenarEmpresa(const ADocumento
  : TCotizacionDocumentoDTO);
var
  lEmpresa: TEmpresa;
begin
  lEmpresa := fEmpresa.GetByPK(EMPRESA_ID, False);
  if lEmpresa = nil then
    Exit;
  try
    ADocumento.EmpresaRazonSocial := lEmpresa.RazonSocial;
    ADocumento.EmpresaCedula := lEmpresa.CedulaJuridica;
    ADocumento.EmpresaDireccion := lEmpresa.Direccion.ValueOrDefault;
    ADocumento.EmpresaTelefonoFijo := lEmpresa.TelefonoFijo.ValueOrDefault;
    ADocumento.EmpresaCelular := lEmpresa.Celular.ValueOrDefault;
    ADocumento.EmpresaCorreo := lEmpresa.Correo.ValueOrDefault;
    ADocumento.CuentaBancaria := lEmpresa.CuentaBancaria.ValueOrDefault;
    ADocumento.Firmante := lEmpresa.Firmante.ValueOrDefault;
    ADocumento.CartaPresentacion := lEmpresa.CartaPresentacion.ValueOrDefault;
  finally
    lEmpresa.Free;
  end;
end;

procedure TCotizacionDocumentoService.LlenarCliente(const ADocumento
  : TCotizacionDocumentoDTO; const AClienteId: Integer);
var
  lCliente: TClientes;
  lContactos: TObjectList<TClienteContactos>;
  lContacto: TClienteContactos;
begin
  lCliente := fClientes.GetByPK(AClienteId, False);
  if lCliente <> nil then
    try
      ADocumento.ClienteNombre := lCliente.Nombre;
      ADocumento.ClienteTelefono := lCliente.Telefono.ValueOrDefault;
    finally
      lCliente.Free;
    end;

  lContactos := fContactos.ContactosDe(AClienteId);
  try
    for lContacto in lContactos do
      if lContacto.Principal and lContacto.Activo.ValueOrDefault and
        not lContacto.Anonimizado then
      begin
        ADocumento.ContactoNombre := lContacto.Nombre;
        Break;
      end;
  finally
    lContactos.Free;
  end;
end;

function TCotizacionDocumentoService.Documento(const AId, AUsuarioId: Integer;
  const ARoles: TArray<string>): TCotizacionDocumentoDTO;
var
  lCotizacion: TCotizacionDTO;
  lLinea: TLineaDocumentoDTO;
begin
  lCotizacion := fCotizaciones.Obtener(AId, AUsuarioId, ARoles);
  try
    Result := TCotizacionDocumentoDTO.Create;
    try
      Result.Numero := lCotizacion.Numero;
      Result.Fecha := Date;
      Result.DescripcionTrabajo := lCotizacion.DescripcionTrabajo;
      Result.PorcentajeIva := lCotizacion.PorcentajeIva;
      Result.MontoImpuesto := lCotizacion.MontoImpuesto.ValueOrDefault;
      Result.MontoTotal := lCotizacion.MontoTotal.ValueOrDefault;
      Result.Subtotal := Result.MontoTotal - Result.MontoImpuesto;
      Result.FormaPago := lCotizacion.FormaPago.ValueOrDefault;
      Result.PlazoEntrega := lCotizacion.PlazoEntrega.ValueOrDefault;
      Result.Garantia := lCotizacion.Garantia.ValueOrDefault;
      Result.AvisoPrivacidad := dotEnv.Env('anovo.aviso_privacidad.version',
        AVISO_POR_DEFECTO);

      lLinea := TLineaDocumentoDTO.Create;
      Result.Lineas.Add(lLinea);
      lLinea.Descripcion := lCotizacion.DescripcionTrabajo;
      lLinea.Cantidad := 1;
      lLinea.PrecioUnitario := Result.Subtotal;
      lLinea.Total := Result.Subtotal;

      LlenarEmpresa(Result);
      LlenarCliente(Result, lCotizacion.ClienteId);
    except
      Result.Free;
      raise;
    end;
  finally
    lCotizacion.Free;
  end;
end;

end.
