unit Anovo.Frames.SolicitudesAsesor;

// Seccion Solicitudes del asesor: las del mes y el
// historial completo.

interface

uses
  System.UITypes,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.WinXCtrls, Vcl.WinXPanels,
  Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  FlatVcl.BotonWin, VclPlano.Pestanas, VclPlano.BotonWin,
  Anovo.Frames.Listado,
  Anovo.DTOs.Dashboard,
  Anovo.Vistas.Intf.SolicitudesAsesor,
  Anovo.Presentadores.SolicitudesAsesor;

type
  TfraSolicitudesAsesor = class(TfraListado, IVistaSolicitudesAsesor)
    pstPeriodo: TPlanoPestanas;
    procedure pstPeriodoChange(Sender: TObject);
  private
    FPresentador: TPresentadorSolicitudesAsesor;
    procedure MostrarPeriodo(const AHistorial: Boolean;
      const ADesde: TDateTime);
    procedure MostrarSolicitudes(const AFilas: TObjectList<TSolicitudAsesorDTO>);
  protected
    procedure Buscar(const ATexto: string); override;
    procedure Limpiar; override;
    procedure PaginaAnterior; override;
    procedure PaginaSiguiente; override;
    procedure MostrarCargando(const AActivo: Boolean); override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.DBGridExtend,
  Anovo.Api.Solicitudes,
  Anovo.Mapeo.Datos,
  Anovo.Textos,
  Anovo.Datos.Memoria;

const
  CAMPO_ESTADO = 'ESTADO';

constructor TfraSolicitudesAsesor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTextoCargando := SCargandoSolicitudes;
  FTextoSinRegistros := SSinSolicitudes;
  FTextoPaginacion := SPaginacionSolicitudes;
  TDBGridExtend.De(grDatos).ColumnaEstado(CAMPO_ESTADO);

  FPresentador := TPresentadorSolicitudesAsesor.Create(Self, TApiSolicitudes.Create);
  FPresentador.Iniciar;
end;

destructor TfraSolicitudesAsesor.Destroy;
begin
  FreeAndNil(FPresentador);
  inherited;
end;

procedure TfraSolicitudesAsesor.Resize;
begin
  inherited;
  Anovo.UI.DBGridExtend.AjustarColumnas(grDatos);
end;

procedure TfraSolicitudesAsesor.Buscar(const ATexto: string);
begin
  FPresentador.Buscar(ATexto);
end;

procedure TfraSolicitudesAsesor.Limpiar;
begin
  FPresentador.Limpiar;
end;

procedure TfraSolicitudesAsesor.PaginaAnterior;
begin
  FPresentador.PaginaAnterior;
end;

procedure TfraSolicitudesAsesor.PaginaSiguiente;
begin
  FPresentador.PaginaSiguiente;
end;

procedure TfraSolicitudesAsesor.pstPeriodoChange(Sender: TObject);
begin
  if not Assigned(FPresentador) then
    Exit;
  FPresentador.VerHistorial(pstPeriodo.ItemIndex = 1);
end;

procedure TfraSolicitudesAsesor.MostrarCargando(const AActivo: Boolean);
begin
  inherited;
  pstPeriodo.Enabled := not AActivo;
end;

procedure TfraSolicitudesAsesor.MostrarPeriodo(const AHistorial: Boolean;
  const ADesde: TDateTime);
begin

end;

procedure TfraSolicitudesAsesor.MostrarSolicitudes(const AFilas
  : TObjectList<TSolicitudAsesorDTO>);
begin
  TMapeoDatos.AListaTabla<TSolicitudAsesorDTO>(AFilas,
    dmMemoria.mtSeguimiento);
  Anovo.UI.DBGridExtend.AjustarColumnas(grDatos);
end;

end.
