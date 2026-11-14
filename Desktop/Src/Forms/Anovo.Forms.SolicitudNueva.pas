unit Anovo.Forms.SolicitudNueva;

// Ventana de solicitud nueva registrada en la oficina (minuta 19/2026).

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.WinXPanels, Vcl.Grids,
  Vcl.DBGrids, Data.DB,
  rDBComponents, rDBGrid,
  VclPlano.BotonWin, VclPlano.Pestanas,
  Anovo.Forms.Edicion,
  Anovo.DTOs.Clientes,
  Anovo.DTOs.Catalogos,
  Anovo.Vistas.Intf.SolicitudNueva,
  Anovo.Presentadores.SolicitudNueva, Vcl.TitleBarCtrls;

type
  TfrmSolicitudNueva = class(TfrmEdicion, IVistaSolicitudNueva)
    pstSecciones: TPlanoPestanas;
    cpSolicitud: TCardPanel;
    crdSolicitud: TCard;
    crdPieza: TCard;
    crdPlanos: TCard;
    cbContacto: TrDBLookupComboBox;
    edProyecto: TrDBEdit;
    meDescripcion: TrDBMemo;
    meObservaciones: TrDBMemo;
    edPieza: TrDBEdit;
    cbTrabajo: TrDBLookupComboBox;
    cbMaterial: TrDBLookupComboBox;
    cbAcabado: TrDBLookupComboBox;
    cbTipoMedida: TrDBLookupComboBox;
    edValor: TrDBEdit;
    cbUnidad: TrDBLookupComboBox;
    edCantidad: TrDBEdit;
    edObservacion: TrDBEdit;
    btnAgregarMedida: TPlanoBotonWin;
    btnQuitarMedida: TPlanoBotonWin;
    grMedidas: TrDBGrid;
    lblPlanos: TLabel;
    btnAdjuntar: TPlanoBotonWin;
    btnQuitarPlano: TPlanoBotonWin;
    grPlanos: TrDBGrid;
    odPlanos: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure btnAgregarMedidaClick(Sender: TObject);
    procedure btnQuitarMedidaClick(Sender: TObject);
    procedure btnAdjuntarClick(Sender: TObject);
    procedure btnQuitarPlanoClick(Sender: TObject);
    procedure cbTipoMedidaClick(Sender: TObject);
  private
    FPresentador: TPresentadorSolicitudNueva;
    FClienteId: Integer;
    FSolicitudId: Integer;
    procedure Guardado(const AId: Integer);
    procedure MostrarContactos(const AContactos: TObjectList<TContactoDTO>;
      const APrincipal: Integer);
    procedure MostrarTiposTrabajo(const ATipos: TObjectList<TTipoTrabajoDTO>);
    procedure MostrarMateriales(const AMateriales
      : TObjectList<TCatalogoSimpleDTO>);
    procedure MostrarAcabados(const AAcabados: TObjectList<TCatalogoSimpleDTO>);
    procedure MostrarUnidades(const AUnidades: TObjectList<TUnidadMedidaDTO>);
    procedure MostrarUnidadesDe(const AMagnitud: string);
    procedure MostrarMedidas(const AMedidas: TObjectList<TMedidaOficina>);
    procedure MostrarPlanos(const APlanos: TObjectList<TPlanoOficina>);
    procedure AvisarReparos(const AReparos: TStrings);
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    constructor Crear(AOwner: TComponent; const AClienteId: Integer);
    property SolicitudId: Integer read FSolicitudId;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Api.Clientes,
  Anovo.Api.Catalogos,
  Anovo.Api.Solicitudes,
  Anovo.DTOs.Solicitudes,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.UI.CeldasRejilla,
  Anovo.Textos;

constructor TfrmSolicitudNueva.Crear(AOwner: TComponent;
  const AClienteId: Integer);
begin
  FClienteId := AClienteId;
  dmMemoria.PrepararSolicitudNueva(AClienteId);
  inherited Create(AOwner);
end;

procedure TfrmSolicitudNueva.FormCreate(Sender: TObject);
begin
  AplicarTemaGrid(grMedidas);
  AplicarTemaGrid(grPlanos);
  cpSolicitud.ActiveCard := crdSolicitud;
  odPlanos.Filter := SPlanosFiltro;
  FPresentador := TPresentadorSolicitudNueva.Create(Self,
    TApiSolicitudes.Create, TApiClientes.Create, TApiCatalogos.Create,
    FClienteId);
  FPresentador.Iniciar;
end;

procedure TfrmSolicitudNueva.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPresentador);
end;

function TfrmSolicitudNueva.ControlesEdicion: TArray<TControl>;
begin
  Result := [cpSolicitud, pstSecciones];
end;

procedure TfrmSolicitudNueva.MostrarContactos(const AContactos
  : TObjectList<TContactoDTO>; const APrincipal: Integer);
begin
  TMapeoDatos.AListaTabla<TContactoDTO>(AContactos,
    dmMemoria.mtContactosSolicitud);
  if APrincipal > 0 then
  begin
    if not(dmMemoria.mtSolicitudNueva.State in dsEditModes) then
      dmMemoria.mtSolicitudNueva.Edit;
    dmMemoria.mtSolicitudNuevaCLIENTE_CONTACTO_ID.AsInteger := APrincipal;
  end;
end;

procedure TfrmSolicitudNueva.MostrarTiposTrabajo(const ATipos
  : TObjectList<TTipoTrabajoDTO>);
begin
  TMapeoDatos.AListaTabla<TTipoTrabajoDTO>(ATipos,
    dmMemoria.mtTiposTrabajoOficina);
end;

procedure TfrmSolicitudNueva.MostrarMateriales(const AMateriales
  : TObjectList<TCatalogoSimpleDTO>);
begin
  TMapeoDatos.AListaTabla<TCatalogoSimpleDTO>(AMateriales,
    dmMemoria.mtMaterialesOficina);
end;

procedure TfrmSolicitudNueva.MostrarAcabados(const AAcabados
  : TObjectList<TCatalogoSimpleDTO>);
begin
  TMapeoDatos.AListaTabla<TCatalogoSimpleDTO>(AAcabados,
    dmMemoria.mtAcabadosOficina);
end;

procedure TfrmSolicitudNueva.MostrarUnidades(const AUnidades
  : TObjectList<TUnidadMedidaDTO>);
begin
  dmMemoria.UnidadesDeMagnitud('');
  TMapeoDatos.AListaTabla<TUnidadMedidaDTO>(AUnidades,
    dmMemoria.mtUnidadesOficina);
end;

procedure TfrmSolicitudNueva.MostrarUnidadesDe(const AMagnitud: string);
begin
  with dmMemoria do
  begin
    UnidadesDeMagnitud(AMagnitud);
    if mtMedidaOficinaUNIDAD_MEDIDA.AsString.IsEmpty or
      UnidadEnLista(mtMedidaOficinaUNIDAD_MEDIDA.AsString) then
      Exit;
    mtMedidaOficina.Edit;
    mtMedidaOficinaUNIDAD_MEDIDA.Clear;
  end;
end;

procedure TfrmSolicitudNueva.cbTipoMedidaClick(Sender: TObject);
begin
  FPresentador.ElegirTipoMedida(VarToStr(cbTipoMedida.KeyValue));
end;

procedure TfrmSolicitudNueva.MostrarMedidas(const AMedidas
  : TObjectList<TMedidaOficina>);
begin
  TMapeoDatos.AListaTabla<TMedidaOficina>(AMedidas,
    dmMemoria.mtMedidasOficina);
  TCeldasRejilla.De(grMedidas).AjustarColumnas;
end;

procedure TfrmSolicitudNueva.MostrarPlanos(const APlanos
  : TObjectList<TPlanoOficina>);
begin
  TMapeoDatos.AListaTabla<TPlanoOficina>(APlanos, dmMemoria.mtPlanosOficina);
  TCeldasRejilla.De(grPlanos).AjustarColumnas;
end;

procedure TfrmSolicitudNueva.AvisarReparos(const AReparos: TStrings);
begin
  MostrarReparos(AReparos, SReparosSolicitud);
end;

procedure TfrmSolicitudNueva.btnAgregarMedidaClick(Sender: TObject);
begin
  with dmMemoria do
  begin
    Confirmar(mtMedidaOficina);
    if FPresentador.AgregarMedida(mtMedidaOficinaTIPO_MEDIDA.AsString,
      VarToStr(mtTiposMedidaOficina.Lookup('CODIGO',
      mtMedidaOficinaTIPO_MEDIDA.AsString, 'NOMBRE')),
      mtMedidaOficinaVALOR.AsFloat, mtMedidaOficinaUNIDAD_MEDIDA.AsString,
      mtMedidaOficinaCANTIDAD.AsInteger,
      mtMedidaOficinaOBSERVACION.AsString) then
    begin
      PrepararMedidaOficina;
      FPresentador.ElegirTipoMedida('');
    end;
  end;
end;

procedure TfrmSolicitudNueva.btnQuitarMedidaClick(Sender: TObject);
begin
  if not dmMemoria.mtMedidasOficina.IsEmpty then
    FPresentador.QuitarMedida(dmMemoria.mtMedidasOficina.RecNo - 1);
end;

procedure TfrmSolicitudNueva.btnAdjuntarClick(Sender: TObject);
begin
  if odPlanos.Execute then
    FPresentador.AgregarPlanos(odPlanos.Files);
end;

procedure TfrmSolicitudNueva.btnQuitarPlanoClick(Sender: TObject);
begin
  if not dmMemoria.mtPlanosOficina.IsEmpty then
    FPresentador.QuitarPlano(dmMemoria.mtPlanosOficina.RecNo - 1);
end;

procedure TfrmSolicitudNueva.btnGuardarClick(Sender: TObject);
begin
  dmMemoria.Confirmar(dmMemoria.mtSolicitudNueva);
  dmMemoria.Confirmar(dmMemoria.mtPiezaOficina);
  FPresentador.Guardar(TMapeoDatos.ADto<TSolicitudNuevaDTO>
    (dmMemoria.mtSolicitudNueva), TMapeoDatos.ADto<TPiezaNuevaDTO>
    (dmMemoria.mtPiezaOficina));
end;

procedure TfrmSolicitudNueva.Guardado(const AId: Integer);
begin
  FSolicitudId := AId;
  ModalResult := mrOk;
end;

end.
