unit Anovo.Presentadores.Consentimiento;

// Presentador de los textos del consentimiento: carga las versiones y
// publica una nueva, que queda vigente. Una version publicada no se edita.

interface

uses
  System.Generics.Collections,
  Anovo.Api.Intf.Configuracion,
  Anovo.DTOs.Clientes,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.Consentimiento;

type
  TPresentadorConsentimiento = class(TPresentadorBase)
  private
    FVista: IVistaConsentimiento;
    FApi: IApiConfiguracion;
    procedure MostrarError(AMensaje: string);
    procedure MostrarCargando(AActivo: Boolean);
  public
    constructor Create(const AVista: IVistaConsentimiento;
      const AApi: IApiConfiguracion);
    procedure Cargar;
    procedure Publicar(const ADto: TConsentimientoTextoNuevoDTO);
  end;

implementation

uses
  System.SysUtils,
  Anovo.Textos;

constructor TPresentadorConsentimiento.Create(const AVista
  : IVistaConsentimiento; const AApi: IApiConfiguracion);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
end;

procedure TPresentadorConsentimiento.MostrarError(AMensaje: string);
begin
  FVista.MostrarError(AMensaje);
end;

procedure TPresentadorConsentimiento.MostrarCargando(AActivo: Boolean);
begin
  FVista.MostrarCargando(AActivo);
end;

procedure TPresentadorConsentimiento.Cargar;
var
  lApi: IApiConfiguracion;
begin
  lApi := FApi;
  Ejecutar<TObjectList<TConsentimientoTextoDTO>>(SAccionCargarConsentimiento,
    function: TObjectList<TConsentimientoTextoDTO>
    begin
      Result := lApi.VersionesConsentimiento;
    end,
    procedure(AVersiones: TObjectList<TConsentimientoTextoDTO>)
    begin
      FVista.MostrarVersiones(AVersiones);
    end, MostrarError, MostrarCargando);
end;

procedure TPresentadorConsentimiento.Publicar(const ADto
  : TConsentimientoTextoNuevoDTO);
var
  lApi: IApiConfiguracion;
begin
  ADto.Version := ADto.Version.Trim;
  ADto.Titulo := ADto.Titulo.Trim;
  ADto.Contenido := ADto.Contenido.Trim;
  if ADto.Version.IsEmpty or ADto.Titulo.IsEmpty or ADto.Contenido.IsEmpty then
  begin
    ADto.Free;
    FVista.MostrarError(SFaltanDatosConsentimiento);
    Exit;
  end;
  if not FVista.Confirmar(Format(SConfirmarPublicarConsentimiento,
    [ADto.Version])) then
  begin
    ADto.Free;
    Exit;
  end;
  lApi := FApi;

  Ejecutar(SAccionPublicarConsentimiento,
    procedure
    begin
      lApi.PublicarConsentimiento(ADto);
    end,
    procedure
    begin
      FVista.Publicado;
    end, MostrarError, MostrarCargando,
    procedure
    begin
      ADto.Free;
    end);
end;

end.
