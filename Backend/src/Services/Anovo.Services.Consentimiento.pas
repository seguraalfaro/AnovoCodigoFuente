unit Anovo.Services.Consentimiento;

// Textos del consentimiento: una version publicada no se edita; publicar una
// nueva la deja vigente y quita la marca a la anterior.

interface

uses
  System.Generics.Collections,
  MVCFramework,
  Anovo.DTOs.Clientes,
  Anovo.Repositories.Intf.Clientes,
  Anovo.Services.Intf.Consentimiento;

type
  TConsentimientoTextoService = class(TInterfacedObject,
    IConsentimientoTextoService)
  private
    fTextos: IConsentimientoTextoRepository;
    procedure Validar(const ADto: TConsentimientoTextoNuevoDTO);
  public
    [MVCInject]
    constructor Create(ATextos: IConsentimientoTextoRepository); reintroduce;
    function Vigente: TConsentimientoTextoDTO;
    function Version(const AVersion: string): TConsentimientoTextoDTO;
    function Versiones: TObjectList<TConsentimientoTextoDTO>;
    function Publicar(const ADto: TConsentimientoTextoNuevoDTO;
      const AUsuarioId: Integer): Integer;
  end;

function VersionAvisoVigente(const ATextos: IConsentimientoTextoRepository)
  : string;

implementation

uses
  System.SysUtils,
  MVCFramework.Commons,
  MVCFramework.Repository,
  Anovo.Auditoria.Contexto,
  Anovo.Entities.Clientes,
  Anovo.Errors,
  Anovo.Mapeo,
  Anovo.Textos;

const
  LARGO_VERSION = 10;
  LARGO_TITULO = 120;
  LARGO_CONTENIDO = 8000;
  VERSION_POR_DEFECTO = '1.1';

function VersionAvisoVigente(const ATextos: IConsentimientoTextoRepository)
  : string;
var
  lFila: TConsentimientoTextos;
begin
  lFila := ATextos.Vigente;
  if lFila = nil then
    Exit(dotEnv.Env('anovo.aviso_privacidad.version', VERSION_POR_DEFECTO));
  try
    Result := lFila.Version;
  finally
    lFila.Free;
  end;
end;

constructor TConsentimientoTextoService.Create(ATextos
  : IConsentimientoTextoRepository);
begin
  inherited Create;
  fTextos := ATextos;
end;

function TConsentimientoTextoService.Vigente: TConsentimientoTextoDTO;
var
  lFila: TConsentimientoTextos;
begin
  lFila := fTextos.Vigente;
  if lFila = nil then
    raise EAnovoError.Create('SIN_TEXTO_VIGENTE', SSinTextoConsentimiento,
      HTTP_STATUS.NotFound);
  try
    Result := TMapeo.ADto<TConsentimientoTextoDTO>(lFila);
  finally
    lFila.Free;
  end;
end;

function TConsentimientoTextoService.Version(const AVersion: string)
  : TConsentimientoTextoDTO;
var
  lFila: TConsentimientoTextos;
begin
  lFila := fTextos.PorVersion(AVersion.Trim);
  if lFila = nil then
    raise EAnovoError.Create('VERSION_INEXISTENTE',
      Format(SVersionConsentimientoInexistente, [AVersion.Trim]),
      HTTP_STATUS.NotFound);
  try
    Result := TMapeo.ADto<TConsentimientoTextoDTO>(lFila);
  finally
    lFila.Free;
  end;
end;

function TConsentimientoTextoService.Versiones
  : TObjectList<TConsentimientoTextoDTO>;
var
  lFilas: TObjectList<TConsentimientoTextos>;
begin
  lFilas := fTextos.Todas;
  try
    Result := TMapeo.AListaDto<TConsentimientoTextos,
      TConsentimientoTextoDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

procedure TConsentimientoTextoService.Validar(const ADto
  : TConsentimientoTextoNuevoDTO);
var
  lExistente: TConsentimientoTextos;
begin
  if ADto.Version.Trim.IsEmpty or (ADto.Version.Trim.Length > LARGO_VERSION) then
    raise EDatoInvalido.Create(Format(SVersionConsentimientoInvalida,
      [LARGO_VERSION]));
  if ADto.Titulo.Trim.IsEmpty or (ADto.Titulo.Trim.Length > LARGO_TITULO) then
    raise EDatoInvalido.Create(Format(STituloConsentimientoInvalido,
      [LARGO_TITULO]));
  if ADto.Contenido.Trim.IsEmpty or
    (ADto.Contenido.Trim.Length > LARGO_CONTENIDO) then
    raise EDatoInvalido.Create(Format(SContenidoConsentimientoInvalido,
      [LARGO_CONTENIDO]));
  lExistente := fTextos.PorVersion(ADto.Version.Trim);
  if lExistente <> nil then
  begin
    lExistente.Free;
    raise EDatoInvalido.Create(Format(SVersionConsentimientoRepetida,
      [ADto.Version.Trim]));
  end;
end;

function TConsentimientoTextoService.Publicar(const ADto
  : TConsentimientoTextoNuevoDTO; const AUsuarioId: Integer): Integer;
var
  lAnterior, lNueva: TConsentimientoTextos;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  Validar(ADto);
  FijarDetalle(Format(SDetallePublicacionConsentimiento, [ADto.Version.Trim]));

  lAnterior := fTextos.Vigente;
  if lAnterior <> nil then
    try
      lAnterior.Vigente := False;
      fTextos.Update(lAnterior);
    finally
      lAnterior.Free;
    end;

  lNueva := TConsentimientoTextos.Create;
  try
    lNueva.Version := ADto.Version.Trim;
    lNueva.Titulo := ADto.Titulo.Trim;
    lNueva.Contenido := ADto.Contenido.Trim;
    lNueva.Vigente := True;
    lNueva.VigenteDesde := Now;
    lNueva.PublicadoPor := AUsuarioId;
    fTextos.Insert(lNueva);
    Result := lNueva.ID.ValueOrDefault;
  finally
    lNueva.Free;
  end;
end;

end.
