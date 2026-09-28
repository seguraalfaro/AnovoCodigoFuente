unit Anovo.Frames.SolicitudesAsistente;

// Seccion Solicitudes del asistente y el supervisor: la cola comun
// de las sin procesar y las que cada uno tomo.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.WinXCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.BotonWin, VclPlano.Pestanas,
  Anovo.Frames.Listado,
  Anovo.DTOs.Dashboard,
  Anovo.DTOs.Solicitudes,
  Anovo.Vistas.Intf.SolicitudesAsistente,
  Anovo.Presentadores.SolicitudesAsistente;

type
  TfraSolicitudesAsistente = class(TfraListado, IVistaSolicitudesAsistente)
    pstModo: TPlanoPestanas;
    procedure pstModoChange(Sender: TObject);
  private
    FPresentador: TPresentadorSolicitudesAsistente;
    procedure Accion(Sender: TObject; const AClave: string);
    procedure VerColumnas(const ACampos: array of string);
    procedure MostrarModo(const AModo: TModoSolicitudes);
    procedure MostrarCola(const AFilas: TObjectList<TSolicitudPorCotizarDTO>);
    procedure MostrarEnTrabajo(const AFilas
      : TObjectList<TSolicitudEnTrabajoDTO>);
  protected
    procedure Buscar(const ATexto: string); override;
    procedure Limpiar; override;
    procedure PaginaAnterior; override;
    procedure PaginaSiguiente; override;
    procedure MostrarCargando(const AActivo: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.DBGridExtend,
  Anovo.UI.Vista,
  Anovo.Api.Solicitudes,
  Anovo.Api.Cotizaciones,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Textos;

const
  CAMPO_ACCIONES = 'ACCIONES';
  CAMPO_ESTADO = 'ESTADO';
  ACCION_TOMAR = 'tomar';

  COLUMNAS_COLA: array [0 .. 5] of string = ('FECHA_RECEPCION',
    'CLIENTE_NOMBRE', 'ASESOR_NOMBRE', 'DESCRIPCION', 'DIAS_ESPERA',
    'ACCIONES');
  COLUMNAS_EN_TRABAJO: array [0 .. 5] of string = ('NUMERO',
    'FECHA_MODIFICACION', 'CLIENTE_NOMBRE', 'DESCRIPCION_TRABAJO', 'ESTADO',
    'MOTIVO_RECHAZO');

constructor TfraSolicitudesAsistente.Create(AOwner: TComponent);
var
  lRejilla: TDBGridExtend;
begin
  inherited Create(AOwner);
  FTextoCargando := SCargandoSolicitudes;
  FTextoPaginacion := SPaginacionSolicitudes;

  lRejilla := TDBGridExtend.De(grDatos);
  lRejilla.ColumnaEstado(CAMPO_ESTADO);
  lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
  lRejilla.Agregar(ACCION_TOMAR, SAccionTomar);
  lRejilla.AjustarAcciones;
  lRejilla.OnAccion := Accion;

  FPresentador := TPresentadorSolicitudesAsistente.Create(Self,
    TApiSolicitudes.Create, TApiCotizaciones.Create);
  FPresentador.Iniciar;
end;

destructor TfraSolicitudesAsistente.Destroy;
begin
  FPresentador.Free;
  inherited;
end;

procedure TfraSolicitudesAsistente.Buscar(const ATexto: string);
begin
  FPresentador.Buscar(ATexto);
end;

procedure TfraSolicitudesAsistente.Limpiar;
begin
  FPresentador.Limpiar;
end;

procedure TfraSolicitudesAsistente.PaginaAnterior;
begin
  FPresentador.PaginaAnterior;
end;

procedure TfraSolicitudesAsistente.PaginaSiguiente;
begin
  FPresentador.PaginaSiguiente;
end;

procedure TfraSolicitudesAsistente.MostrarCargando(const AActivo: Boolean);
begin
  inherited;
  pstModo.Enabled := not AActivo;
end;

procedure TfraSolicitudesAsistente.VerColumnas(const ACampos: array of string);
var
  I: Integer;
  lCampo: string;
  lVisible: Boolean;
begin
  for I := 0 to grDatos.Columns.Count - 1 do
  begin
    lVisible := False;
    for lCampo in ACampos do
      if SameText(grDatos.Columns[I].FieldName, lCampo) then
        lVisible := True;
    grDatos.Columns[I].Visible := lVisible;
  end;
  Anovo.UI.DBGridExtend.AjustarColumnas(grDatos);
end;

procedure TfraSolicitudesAsistente.MostrarModo(const AModo: TModoSolicitudes);
begin
  pstModo.ItemIndex := Ord(AModo);
  if AModo = msCola then
  begin
    FTextoSinRegistros := SSinCola;
    VerColumnas(COLUMNAS_COLA);
  end
  else
  begin
    FTextoSinRegistros := SSinEnTrabajo;
    VerColumnas(COLUMNAS_EN_TRABAJO);
  end;
end;

procedure TfraSolicitudesAsistente.MostrarCola(const AFilas
  : TObjectList<TSolicitudPorCotizarDTO>);
begin
  TMapeoDatos.AListaTabla<TSolicitudPorCotizarDTO>(AFilas,
    dmMemoria.mtSolicitudesAsistente);
end;

procedure TfraSolicitudesAsistente.MostrarEnTrabajo(const AFilas
  : TObjectList<TSolicitudEnTrabajoDTO>);
begin
  TMapeoDatos.AListaTabla<TSolicitudEnTrabajoDTO>(AFilas,
    dmMemoria.mtSolicitudesAsistente);
end;

procedure TfraSolicitudesAsistente.Accion(Sender: TObject;
  const AClave: string);
begin
  if dmMemoria.mtSolicitudesAsistente.IsEmpty or
    (pstModo.ItemIndex <> Ord(msCola)) then
    Exit;
  if SameText(AClave, ACCION_TOMAR) and
    Confirmar(Format(SConfirmarTomar,
    [dmMemoria.mtSolicitudesAsistenteCLIENTE_NOMBRE.AsString])) then
    FPresentador.Tomar(dmMemoria.mtSolicitudesAsistenteID.AsInteger);
end;

procedure TfraSolicitudesAsistente.pstModoChange(Sender: TObject);
begin
  if FPresentador = nil then
    Exit;
  FPresentador.CambiarModo(TModoSolicitudes(pstModo.ItemIndex));
end;

end.
