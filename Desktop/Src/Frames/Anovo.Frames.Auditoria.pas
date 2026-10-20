unit Anovo.Frames.Auditoria;

// Seccion Bitacora de auditoria (HU-09).

interface

uses
  System.UITypes,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls,
  VclPlano.BotonWin, Vcl.WinXCtrls, Anovo.UI.PanelRelativo, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  Anovo.PeriodoBusqueda,
  Anovo.Forms.Periodo,
  Anovo.Frames.Listado,
  Anovo.DTOs.Auditoria,
  Anovo.Vistas.Intf.Auditoria,
  Anovo.Presentadores.Auditoria;

type
  TfraAuditoria = class(TfraListado, IVistaAuditoria)
    btnPeriodo: TPlanoBotonWin;
    cbFiltro: TComboBox;
    procedure cbFiltroChange(Sender: TObject);
  private
    FPresentador: TPresentadorAuditoria;
    FSelector: TSelectorPeriodo;
    procedure PeriodoCambio(const APeriodo: TPeriodoBusqueda);
    procedure MostrarFiltros(const ARotulos: TArray<string>);
    procedure MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
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
  Anovo.UI.ColumnasRejilla,
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
  FSelector := TSelectorPeriodo.Crear(btnPeriodo, True, PeriodoCambio);
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
  cbFiltro.OnChange := nil;
  cbFiltro.Items.BeginUpdate;
  try
    cbFiltro.Items.Clear;
    cbFiltro.Items.AddStrings(ARotulos);
    cbFiltro.ItemIndex := 0;
  finally
    cbFiltro.Items.EndUpdate;
    cbFiltro.OnChange := cbFiltroChange;
  end;
end;

procedure TfraAuditoria.MostrarCargando(const AActivo: Boolean);
begin
  inherited;
  cbFiltro.Enabled := not AActivo;
end;

procedure TfraAuditoria.MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
begin
  FSelector.Mostrar(APeriodo);
end;

procedure TfraAuditoria.MostrarAuditoria(const AFilas
  : TObjectList<TAuditoriaDTO>);
begin
  TMapeoDatos.AListaTabla<TAuditoriaDTO>(AFilas, dmMemoria.mtAuditoria);
  TColumnasRejilla.AplicarEn(grDatos);
end;

procedure TfraAuditoria.cbFiltroChange(Sender: TObject);
begin
  if not Assigned(FPresentador) or (cbFiltro.ItemIndex < 0) then
    Exit;

  FPresentador.Filtrar(cbFiltro.ItemIndex);
end;

procedure TfraAuditoria.PeriodoCambio(const APeriodo: TPeriodoBusqueda);
begin
  FPresentador.FiltrarPeriodo(APeriodo);
end;

end.
