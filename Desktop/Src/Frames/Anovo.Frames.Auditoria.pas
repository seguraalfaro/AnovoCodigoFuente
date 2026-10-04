unit Anovo.Frames.Auditoria;

// Seccion Bitacora de auditoria (HU-09).

interface

uses
  System.UITypes,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls,
  VclPlano.BotonWin, Vcl.WinXCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.Pestanas,
  Anovo.Frames.Listado,
  Anovo.DTOs.Auditoria,
  Anovo.Vistas.Intf.Auditoria,
  Anovo.Presentadores.Auditoria;

type
  TfraAuditoria = class(TfraListado, IVistaAuditoria)
    lblDesde: TLabel;
    lblHasta: TLabel;
    dtpDesde: TDateTimePicker;
    dtpHasta: TDateTimePicker;
    pstFiltros: TPlanoPestanas;
    procedure pstFiltrosChange(Sender: TObject);
    procedure PeriodoChange(Sender: TObject);
  private
    FPresentador: TPresentadorAuditoria;
    FPoniendoPeriodo: Boolean;
    procedure MostrarFiltros(const ARotulos: TArray<string>);
    procedure MostrarPeriodo(const ADesde, AHasta: TDateTime);
    procedure MostrarAuditoria(const AFilas: TObjectList<TAuditoriaDTO>);
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
  Anovo.Api.Auditoria,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Textos;

constructor TfraAuditoria.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTextoCargando := SCargandoBitacora;
  FTextoSinRegistros := SSinMovimientos;
  FTextoPaginacion := SPaginacionMovimientos;
  FPresentador := TPresentadorAuditoria.Create(Self, TApiAuditoria.Create);
  FPresentador.Iniciar;
end;

destructor TfraAuditoria.Destroy;
begin
  FreeAndNil(FPresentador);
  inherited;
end;

procedure TfraAuditoria.Buscar(const ATexto: string);
begin
  FPresentador.Buscar(ATexto);
end;

procedure TfraAuditoria.Limpiar;
begin
  FPresentador.Limpiar;
end;

procedure TfraAuditoria.PaginaAnterior;
begin
  FPresentador.PaginaAnterior;
end;

procedure TfraAuditoria.PaginaSiguiente;
begin
  FPresentador.PaginaSiguiente;
end;

procedure TfraAuditoria.MostrarFiltros(const ARotulos: TArray<string>);
begin
  pstFiltros.Items.BeginUpdate;
  try
    pstFiltros.Items.Clear;
    pstFiltros.Items.AddStrings(ARotulos);
  finally
    pstFiltros.Items.EndUpdate;
  end;
end;

procedure TfraAuditoria.MostrarCargando(const AActivo: Boolean);
begin
  inherited;
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

procedure TfraAuditoria.MostrarAuditoria(const AFilas
  : TObjectList<TAuditoriaDTO>);
begin
  TMapeoDatos.AListaTabla<TAuditoriaDTO>(AFilas, dmMemoria.mtAuditoria);
end;

procedure TfraAuditoria.pstFiltrosChange(Sender: TObject);
begin
  if not Assigned(FPresentador) then
    Exit;

  FPresentador.Filtrar(pstFiltros.ItemIndex);
end;

procedure TfraAuditoria.PeriodoChange(Sender: TObject);
begin
  if FPoniendoPeriodo then
    Exit;
  FPresentador.CambiarPeriodo(dtpDesde.Date, dtpHasta.Date);
end;

end.
