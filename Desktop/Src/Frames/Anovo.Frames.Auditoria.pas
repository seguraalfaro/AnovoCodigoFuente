unit Anovo.Frames.Auditoria;

// Seccion Bitacora de auditoria (HU-09).

interface

uses
  Anovo.UI.Tema,
  Anovo.UI.DBGridExtend,
  System.UITypes,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls,
  VclPlano.BotonWin, Vcl.WinXCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.Pestanas,
  Anovo.DTOs.Auditoria,
  Anovo.Vistas.Intf.Auditoria,
  Anovo.Presentadores.Auditoria;

type
  TfraAuditoria = class(TFrame, IVistaAuditoria)
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pnlBarra: TPanel;
    lblDesde: TLabel;
    lblHasta: TLabel;
    dtpDesde: TDateTimePicker;
    dtpHasta: TDateTimePicker;
    sbBuscar: TSearchBox;
    btnLimpiar: TPlanoBotonWin;
    pnclient: TRelativePanel;
    grAuditoria: TrDBGrid;
    pnlPie: TPanel;
    lblPaginacion: TLabel;
    btnAnterior: TPlanoBotonWin;
    btnSiguiente: TPlanoBotonWin;
    pstFiltros: TPlanoPestanas;
    procedure sbBuscarInvokeSearch(Sender: TObject);
    procedure btnLimpiarClick(Sender: TObject);
    procedure pstFiltrosChange(Sender: TObject);
    procedure PeriodoChange(Sender: TObject);
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnSiguienteClick(Sender: TObject);
  private
    FPresentador: TPresentadorAuditoria;

    FPoniendoPeriodo: Boolean;
    procedure MostrarAlcance(const APuedeVerTodo: Boolean);
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarPeriodo(const ADesde, AHasta: TDateTime);
    procedure MostrarBusqueda(const ATexto: string;
      const APuedeLimpiar: Boolean);
    procedure MostrarAuditoria(const AFilas: TObjectList<TAuditoriaDTO>);
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
  Anovo.Api.Auditoria,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Textos;

constructor TfraAuditoria.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AplicarTemaGrid(grAuditoria);
  FPresentador := TPresentadorAuditoria.Create(Self, TApiAuditoria.Create);
  FPresentador.Iniciar;
end;

destructor TfraAuditoria.Destroy;
begin
  FPresentador.Free;
  Screen.Cursor := crDefault;
  inherited;
end;

procedure TfraAuditoria.Resize;
begin
  inherited;
  OcultarScrollVertical(grAuditoria);
end;

procedure TfraAuditoria.MostrarAlcance(const APuedeVerTodo: Boolean);
begin
  pstFiltros.Visible := APuedeVerTodo;
end;

procedure TfraAuditoria.MostrarCargando(const AActivo: Boolean);
begin
  if AActivo then
  begin
    lblPaginacion.Caption := SCargandoBitacora;
    Screen.Cursor := crAppStart;
  end
  else
    Screen.Cursor := crDefault;
  sbBuscar.Enabled := not AActivo;
  pstFiltros.Enabled := not AActivo;
  dtpDesde.Enabled := not AActivo;
  dtpHasta.Enabled := not AActivo;
end;

procedure TfraAuditoria.MostrarPeriodo(const ADesde, AHasta: TDateTime);
begin
  FPoniendoPeriodo := True;
  try
    dtpDesde.Date := ADesde;
    dtpHasta.Date := AHasta;
  finally
    FPoniendoPeriodo := False;
  end;
end;

procedure TfraAuditoria.MostrarBusqueda(const ATexto: string;
  const APuedeLimpiar: Boolean);
begin
  sbBuscar.Text := ATexto;
  btnLimpiar.Enabled := APuedeLimpiar;
end;

procedure TfraAuditoria.MostrarAuditoria(const AFilas
  : TObjectList<TAuditoriaDTO>);
begin
  TMapeoDatos.AListaTabla<TAuditoriaDTO>(AFilas, dmMemoria.mtAuditoria);
end;

procedure TfraAuditoria.MostrarPaginacion(const APagina, ATotalPaginas: Integer;
  const ATotal: Int64);
begin
  if ATotal = 0 then
    lblPaginacion.Caption := SSinMovimientos
  else
    lblPaginacion.Caption :=
      Format(SPaginacionMovimientos,
      [ATotal, APagina, ATotalPaginas]);
  btnAnterior.Enabled := APagina > 1;
  btnSiguiente.Enabled := APagina < ATotalPaginas;
end;

procedure TfraAuditoria.MostrarError(const AMensaje: string);
begin
  lblPaginacion.Caption := '';
  MessageDlg(AMensaje, mtWarning, [mbOK], 0);
end;

procedure TfraAuditoria.sbBuscarInvokeSearch(Sender: TObject);
begin
  FPresentador.Buscar(sbBuscar.Text);
end;

procedure TfraAuditoria.btnLimpiarClick(Sender: TObject);
begin
  FPresentador.Limpiar;
end;

procedure TfraAuditoria.pstFiltrosChange(Sender: TObject);
begin
  if not Assigned(FPresentador) then
    Exit;

  FPresentador.Filtrar(TFiltroEntidad(pstFiltros.ItemIndex));
end;

procedure TfraAuditoria.PeriodoChange(Sender: TObject);
begin
  if FPoniendoPeriodo then
    Exit;
  FPresentador.CambiarPeriodo(dtpDesde.Date, dtpHasta.Date);
end;

procedure TfraAuditoria.btnAnteriorClick(Sender: TObject);
begin
  FPresentador.PaginaAnterior;
end;

procedure TfraAuditoria.btnSiguienteClick(Sender: TObject);
begin
  FPresentador.PaginaSiguiente;
end;

end.
