unit Anovo.Frames.Solicitudes;

// Seccion Solicitudes del asesor: las del mes y el
// historial completo.

interface

uses
  Anovo.UI.Tema,
  Anovo.UI.DBGridExtend,
  System.UITypes,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.WinXCtrls, Vcl.WinXPanels,
  Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  FlatVcl.BotonWin, VclPlano.Pestanas, VclPlano.BotonWin,
  Anovo.DTOs.Dashboard,
  Anovo.Vistas.Intf.Solicitudes,
  Anovo.Presentadores.Solicitudes;

type
  TfraSolicitudes = class(TFrame, IVistaSolicitudes)
    pnlBarra: TPanel;
    sbBuscar: TSearchBox;
    btnLimpiar: TPlanoBotonWin;
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pstPeriodo: TPlanoPestanas;
    pnclient: TRelativePanel;
    grSolicitudes: TrDBGrid;
    pnlPie: TPanel;
    lblPaginacion: TLabel;
    btnAnterior: TPlanoBotonWin;
    btnSiguiente: TPlanoBotonWin;
    procedure sbBuscarInvokeSearch(Sender: TObject);
    procedure btnLimpiarClick(Sender: TObject);
    procedure pstPeriodoChange(Sender: TObject);
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnSiguienteClick(Sender: TObject);
  private
    FPresentador: TPresentadorSolicitudes;
    procedure EstadoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarBusqueda(const ATexto: string;
      const APuedeLimpiar: Boolean);
    procedure MostrarPeriodo(const AHistorial: Boolean;
      const ADesde: TDateTime);
    procedure MostrarSolicitudes(const AFilas: TObjectList<TSolicitudAsesorDTO>);
    procedure MostrarPaginacion(const APagina, ATotalPaginas: Integer;
      const ATotal: Int64);
    procedure MostrarError(const AMensaje: string);
  protected
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Api.Solicitudes,
  Anovo.Mapeo.Datos,
  Anovo.Formato,
  Anovo.Textos,
  Anovo.Datos.Memoria;

const
  CAMPO_ESTADO = 'ESTADO';

constructor TfraSolicitudes.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  AplicarTemaGrid(grSolicitudes);
  TDBGridExtend.De(grSolicitudes).ColumnaEstado(CAMPO_ESTADO);
  dmMemoria.mtSeguimientoESTADO.OnGetText := EstadoGetText;

  FPresentador := TPresentadorSolicitudes.Create(Self, TApiSolicitudes.Create);
  FPresentador.Iniciar;
end;

destructor TfraSolicitudes.Destroy;
begin
  dmMemoria.mtSeguimientoESTADO.OnGetText := nil;
  FPresentador.Free;
  inherited;
end;

procedure TfraSolicitudes.Resize;
begin
  inherited;
  OcultarScrollVertical(grSolicitudes);
  Anovo.UI.DBGridExtend.AjustarColumnas(grSolicitudes);
end;

procedure TfraSolicitudes.EstadoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := TFormato.Estado(Sender.AsString);
end;

procedure TfraSolicitudes.sbBuscarInvokeSearch(Sender: TObject);
begin
  FPresentador.Buscar(sbBuscar.Text);
end;

procedure TfraSolicitudes.btnLimpiarClick(Sender: TObject);
begin
  FPresentador.Limpiar;
end;

procedure TfraSolicitudes.pstPeriodoChange(Sender: TObject);
begin
  if not Assigned(FPresentador) then
    Exit;
  FPresentador.VerHistorial(pstPeriodo.ItemIndex = 1);
end;

procedure TfraSolicitudes.btnAnteriorClick(Sender: TObject);
begin
  FPresentador.PaginaAnterior;
end;

procedure TfraSolicitudes.btnSiguienteClick(Sender: TObject);
begin
  FPresentador.PaginaSiguiente;
end;

procedure TfraSolicitudes.MostrarCargando(const AActivo: Boolean);
begin
  if AActivo then
  begin
    lblPaginacion.Caption := SCargandoSolicitudes;
    Screen.Cursor := crAppStart;
  end
  else
    Screen.Cursor := crDefault;
  sbBuscar.Enabled := not AActivo;
  pstPeriodo.Enabled := not AActivo;
end;

procedure TfraSolicitudes.MostrarBusqueda(const ATexto: string;
  const APuedeLimpiar: Boolean);
begin
  if sbBuscar.Text <> ATexto then
    sbBuscar.Text := ATexto;
  btnLimpiar.Visible := APuedeLimpiar;
end;

procedure TfraSolicitudes.MostrarPeriodo(const AHistorial: Boolean;
  const ADesde: TDateTime);
begin

end;

procedure TfraSolicitudes.MostrarSolicitudes(const AFilas
  : TObjectList<TSolicitudAsesorDTO>);
begin
  TMapeoDatos.AListaTabla<TSolicitudAsesorDTO>(AFilas,
    dmMemoria.mtSeguimiento);
  Anovo.UI.DBGridExtend.AjustarColumnas(grSolicitudes);
end;

procedure TfraSolicitudes.MostrarPaginacion(const APagina,
  ATotalPaginas: Integer; const ATotal: Int64);
begin
  if ATotal = 0 then
    lblPaginacion.Caption := SSinSolicitudes
  else
    lblPaginacion.Caption := Format(SPaginacionSolicitudes,
      [ATotal, APagina, ATotalPaginas]);

  btnAnterior.Enabled := APagina > 1;
  btnSiguiente.Enabled := APagina < ATotalPaginas;
end;

procedure TfraSolicitudes.MostrarError(const AMensaje: string);
begin
  lblPaginacion.Caption := '';
  MessageDlg(AMensaje, mtWarning, [mbOK], 0);
end;

end.
