unit Anovo.Services.Empresa;

// Servicio de los datos de la empresa: una sola fila (EMPRESA_ID). Valida
// obligatorios y rangos; el cambio queda en la auditoria por TR_EMPRESA_AUD.

interface

uses
  MVCFramework,
  Anovo.DTOs.Empresa,
  Anovo.Repositories.Intf.Catalogos,
  Anovo.Repositories.Intf.Empresa,
  Anovo.Services.Intf.Empresa;

type
  TEmpresaService = class(TInterfacedObject, IEmpresaService)
  private
    fRepo: IEmpresaRepository;
    fFormasPago: IFormaPagoRepository;
    procedure Validar(const ADto: TEmpresaDTO);
  public
    [MVCInject]
    constructor Create(ARepo: IEmpresaRepository;
      AFormasPago: IFormaPagoRepository); reintroduce;
    function Obtener: TEmpresaDTO;
    procedure Actualizar(const ADto: TEmpresaDTO);
  end;

const
  IVA_MAXIMO = 100;
  DIAS_SIN_RESPUESTA_MINIMO = 1;
  DIAS_SIN_RESPUESTA_MAXIMO = 90;
  LARGO_RAZON_SOCIAL = 120;
  LARGO_CEDULA_JURIDICA = 20;

implementation

uses
  System.SysUtils,
  MVCFramework.Repository,
  Anovo.Auditoria.Contexto,
  Anovo.Condiciones,
  Anovo.Entities.Catalogos,
  Anovo.Entities.Empresa,
  Anovo.Errors,
  Anovo.Mapeo,
  Anovo.Textos;

constructor TEmpresaService.Create(ARepo: IEmpresaRepository;
  AFormasPago: IFormaPagoRepository);
begin
  inherited Create;
  fRepo := ARepo;
  fFormasPago := AFormasPago;
end;

function TEmpresaService.Obtener: TEmpresaDTO;
var
  lEmpresa: TEmpresa;
begin
  lEmpresa := fRepo.GetByPK(EMPRESA_ID, False);
  if lEmpresa = nil then
    raise ERecursoNoEncontrado.Create(SRecursoEmpresa, EMPRESA_ID);
  try
    Result := TMapeo.ADto<TEmpresaDTO>(lEmpresa);
  finally
    lEmpresa.Free;
  end;
end;

procedure TEmpresaService.Validar(const ADto: TEmpresaDTO);
var
  lError: string;
begin
  if Trim(ADto.RazonSocial).IsEmpty then
    raise EDatoInvalido.Create(SEmpresaFaltaRazonSocial);
  if Length(Trim(ADto.RazonSocial)) > LARGO_RAZON_SOCIAL then
    raise EDatoInvalido.Create(Format(SEmpresaRazonSocialLarga,
      [LARGO_RAZON_SOCIAL]));
  if Trim(ADto.CedulaJuridica).IsEmpty then
    raise EDatoInvalido.Create(SEmpresaFaltaCedula);
  if Length(Trim(ADto.CedulaJuridica)) > LARGO_CEDULA_JURIDICA then
    raise EDatoInvalido.Create(Format(SEmpresaCedulaLarga,
      [LARGO_CEDULA_JURIDICA]));
  if (ADto.PorcentajeIva < 0) or (ADto.PorcentajeIva > IVA_MAXIMO) then
    raise EDatoInvalido.Create(SEmpresaIvaFueraDeRango);
  if (ADto.DiasSinRespuesta < DIAS_SIN_RESPUESTA_MINIMO) or
    (ADto.DiasSinRespuesta > DIAS_SIN_RESPUESTA_MAXIMO) then
    raise EDatoInvalido.Create(Format(SEmpresaDiasFueraDeRango,
      [DIAS_SIN_RESPUESTA_MINIMO, DIAS_SIN_RESPUESTA_MAXIMO]));
  lError := ErrorDePlazos(ADto.PlazoEntregaCantidad, ADto.PlazoEntregaUnidad,
    ADto.GarantiaCantidad, ADto.GarantiaUnidad);
  if not lError.IsEmpty then
    raise EDatoInvalido.Create(lError);
end;

procedure TEmpresaService.Actualizar(const ADto: TEmpresaDTO);
var
  lEmpresa: TEmpresa;
  lForma: TFormasPago;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  Validar(ADto);
  lEmpresa := fRepo.GetByPK(EMPRESA_ID, False);
  if lEmpresa = nil then
    raise ERecursoNoEncontrado.Create(SRecursoEmpresa, EMPRESA_ID);
  try
    ADto.RazonSocial := Trim(ADto.RazonSocial);
    ADto.CedulaJuridica := Trim(ADto.CedulaJuridica);
    if ADto.FormaPagoId.HasValue and
      (lEmpresa.FormaPagoId.ValueOrDefault <> ADto.FormaPagoId.Value) then
    begin
      lForma := fFormasPago.Activa(ADto.FormaPagoId.Value);
      if lForma = nil then
        raise EDatoInvalido.Create(SFormaPagoNoDisponible);
      lForma.Free;
    end;
    TMapeo.Copiar(ADto, lEmpresa);
    lEmpresa.FormaPagoId := ADto.FormaPagoId;
    lEmpresa.PlazoEntregaCantidad := ACorto(ADto.PlazoEntregaCantidad);
    lEmpresa.PlazoEntregaUnidad := UnidadONula(ADto.PlazoEntregaUnidad);
    lEmpresa.GarantiaCantidad := ACorto(ADto.GarantiaCantidad);
    lEmpresa.GarantiaUnidad := UnidadONula(ADto.GarantiaUnidad);
    FijarDetalle(SDetalleCambioEmpresa);
    fRepo.Update(lEmpresa);
  finally
    lEmpresa.Free;
  end;
end;

end.
