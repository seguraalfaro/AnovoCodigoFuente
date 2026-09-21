unit Anovo.Frames.Clientes;






// Gestion de clientes (HU-01, lado escritorio): la vista del listado.
//
// No decide nada. Pasa al presentador lo que se escribio, la pestana y la
// pagina, y muestra lo que el presentador le manda. Que acciones y botones se
// ven tambien lo decide el presentador, con los permisos.
//
// La rejilla lee de dmMemoria.mtClientes: la lista de DTO que llega del
// presentador se copia ahi y se libera alla. Asi la vista no guarda objetos
// que no son suyos.
//
// El consentimiento se otorga y registra en el movil, en pantalla propia. Aqui
// solo se muestra: la carga de la prueba recae en el responsable, asi que
// nunca se edita desde el escritorio.

interface

uses
  Anovo.UI.Tema,
  Anovo.UI.DBGridExtend,
  System.UITypes,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  VclPlano.BotonWin, Vcl.WinXCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.Pestanas,
  Anovo.DTOs.Clientes,
  Anovo.Forms.ClienteNuevo,
  Anovo.Frames.ClienteDatos,
  Anovo.Vistas.Intf.Clientes,
  Anovo.Presentadores.Clientes;

type
  TfraClientes = class(TFrame, IVistaClientes)
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pnlBarra: TPanel;
    sbBuscar: TSearchBox;
    btnLimpiar: TPlanoBotonWin;
    btnExportar: TPlanoBotonWin;
    btnNuevo: TPlanoBotonWin;
    pnclient: TRelativePanel;
    pstFiltros: TPlanoPestanas;
    grClientes: TrDBGrid;
    pnlPie: TPanel;
    lblPaginacion: TLabel;
    btnAnterior: TPlanoBotonWin;
    btnSiguiente: TPlanoBotonWin;
    procedure sbBuscarInvokeSearch(Sender: TObject);
    procedure btnLimpiarClick(Sender: TObject);
    procedure pstFiltrosChange(Sender: TObject);
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnSiguienteClick(Sender: TObject);
    procedure btnNuevoClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);

  private
    FPresentador: TPresentadorClientes;
    FDetalle: TfraClienteDatos;
    procedure CerrarDetalle(Sender: TObject);
    procedure Accion(Sender: TObject; const AClave: string);
    // IVistaClientes
    procedure MostrarAcciones(const AAcciones: TAccionesCliente;
      const APuedeCrear: Boolean);
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarBusqueda(const ATexto: string;
      const APuedeLimpiar: Boolean);
    procedure MostrarClientes(const AClientes: TObjectList<TClienteDTO>);
    procedure MostrarPaginacion(const APagina, ATotalPaginas: Integer;
      const ATotal: Int64);
    procedure MostrarError(const AMensaje: string);
    procedure MostrarDetalle(const AId: Integer);
    procedure MostrarListado;
  protected
    procedure Resize; override;
  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Api.Clientes,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria;

const
  CAMPO_ACCIONES = 'ACCIONES';
  CAMPO_CONSENTIMIENTO = 'CONSENTIMIENTO_ESTADO';

  // Mismo orden que TAccionCliente. La clave es la que llega a Accion.
  ACCIONES: array [TAccionCliente] of TAccionRejilla = ((Clave: 'detalles';
    Rotulo: 'Detalles'));

  MENSAJE_PENDIENTE = 'Esta opcion todavia no esta disponible.';

constructor TfraClientes.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AplicarTemaGrid(grClientes);
  FPresentador := TPresentadorClientes.Create(Self, TApiClientes.Create);
  FPresentador.Iniciar;
end;

destructor TfraClientes.Destroy;
begin

  FPresentador.Free;
  Screen.Cursor := crDefault;
  inherited;
end;

procedure TfraClientes.Resize;
begin
  inherited;
  OcultarScrollVertical(grClientes);

end;

procedure TfraClientes.MostrarAcciones(const AAcciones: TAccionesCliente;
  const APuedeCrear: Boolean);
var
  lAccion: TAccionCliente;
  lRejilla: TDBGridExtend;
  I: Integer;
begin
  btnNuevo.Visible := APuedeCrear;

  // El dibujo es del TDBGridExtend que AplicarTemaGrid le dejo a la rejilla:
  // aqui solo se le dice que columnas son suyas.
  lRejilla := TDBGridExtend.De(grClientes);
  lRejilla.ColumnaEstado(CAMPO_CONSENTIMIENTO);
  lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
  for lAccion in AAcciones do
    lRejilla.Agregar(ACCIONES[lAccion].Clave, ACCIONES[lAccion].Rotulo);
  lRejilla.OnAccion := Accion;

  for I := 0 to grClientes.Columns.Count - 1 do
    if SameText(grClientes.Columns[I].FieldName, CAMPO_ACCIONES) then
    begin
      grClientes.Columns[I].Visible := AAcciones <> [];
      grClientes.Columns[I].Width := lRejilla.AnchoAcciones;
    end;
end;

procedure TfraClientes.MostrarCargando(const AActivo: Boolean);
begin
  if AActivo then
  begin
    lblPaginacion.Caption := 'Cargando clientes...';
    Screen.Cursor := crAppStart;
  end
  else
    Screen.Cursor := crDefault;
  sbBuscar.Enabled := not AActivo;
  pstFiltros.Enabled := not AActivo;
end;

procedure TfraClientes.MostrarBusqueda(const ATexto: string;
  const APuedeLimpiar: Boolean);
begin
  sbBuscar.Text := ATexto;
  btnLimpiar.Enabled := APuedeLimpiar;
end;

procedure TfraClientes.MostrarClientes(const AClientes
  : TObjectList<TClienteDTO>);
begin
  TMapeoDatos.AListaTabla<TClienteDTO>(AClientes, dmMemoria.mtClientes);
end;

procedure TfraClientes.MostrarPaginacion(const APagina, ATotalPaginas: Integer;
  const ATotal: Int64);
begin
  if ATotal = 0 then
    lblPaginacion.Caption := 'No hay clientes que coincidan'
  else
    lblPaginacion.Caption := Format('%d clientes '#183' p'#225'gina %d de %d',
      [ATotal, APagina, ATotalPaginas]);
  btnAnterior.Enabled := APagina > 1;
  btnSiguiente.Enabled := APagina < ATotalPaginas;
end;

procedure TfraClientes.MostrarError(const AMensaje: string);
begin
  lblPaginacion.Caption := '';
  MessageDlg(AMensaje, mtWarning, [mbOK], 0);
end;

procedure TfraClientes.Accion(Sender: TObject; const AClave: string);
begin
  // La rejilla ya movio el cursor a la fila pulsada: el ID es el de esa fila.
  if dmMemoria.mtClientes.IsEmpty then
    Exit;
  if SameText(AClave, ACCIONES[acDetalles].Clave) then
    FPresentador.VerDetalle(dmMemoria.mtClientesID.AsInteger);
end;

procedure TfraClientes.MostrarDetalle(const AId: Integer);
begin
  // La anterior ya estaba oculta; liberarla aqui es seguro porque no estamos
  // dentro de ninguno de sus eventos.
  FreeAndNil(FDetalle);
  FDetalle := TfraClienteDatos.Crear(Self, AId);
  FDetalle.OnRegresar := CerrarDetalle;
  // Tapa todo el frame, barra y pie incluidos. alClient no sirve: se
  // repartiria el hueco con la rejilla, que tambien es alClient.
  FDetalle.Parent := Self;
  FDetalle.SetBounds(0, 0, ClientWidth, ClientHeight);
  FDetalle.Anchors := [akLeft, akTop, akRight, akBottom];
  FDetalle.BringToFront;
end;

procedure TfraClientes.CerrarDetalle(Sender: TObject);
begin
  // El boton de la ficha no cierra nada por su cuenta: avisa al presentador,
  // que es quien sabe en que estado esta la pantalla.
  FPresentador.VolverAlListado;
end;

procedure TfraClientes.MostrarListado;
begin
  // Se oculta, no se libera: estamos dentro del evento del boton de la ficha.
  // La libera la proxima MostrarDetalle o el propio frame al destruirse. El
  // listado sigue con la busqueda, el filtro y la pagina que tenia.
  if Assigned(FDetalle) then
    FDetalle.Visible := False;
end;

procedure TfraClientes.sbBuscarInvokeSearch(Sender: TObject);
begin
  FPresentador.Buscar(sbBuscar.Text);
end;

procedure TfraClientes.btnLimpiarClick(Sender: TObject);
begin
  FPresentador.Limpiar;
end;

procedure TfraClientes.pstFiltrosChange(Sender: TObject);
begin
  // TPlanoPestanas dispara OnChange desde su Loaded, al leer el DFM: eso es
  // dentro del inherited Create, antes de que exista el presentador.
  if FPresentador = nil then
    Exit;
  FPresentador.Filtrar(TFiltroConsentimiento(pstFiltros.ItemIndex));
end;

procedure TfraClientes.btnAnteriorClick(Sender: TObject);
begin
  FPresentador.PaginaAnterior;
end;

procedure TfraClientes.btnSiguienteClick(Sender: TObject);
begin
  FPresentador.PaginaSiguiente;
end;

procedure TfraClientes.btnNuevoClick(Sender: TObject);
var
  lVentana: TfrmClienteNuevo;
begin
  lVentana := TfrmClienteNuevo.Create(Self);
  try
    if lVentana.ShowModal = mrOk then
      // Vuelve a pedir la pagina: el cliente nuevo tiene que aparecer, y el
      // total de la paginacion cambio.
      FPresentador.Buscar(sbBuscar.Text);
  finally
    lVentana.Free;
  end;
end;

procedure TfraClientes.btnExportarClick(Sender: TObject);
begin
  MessageDlg(MENSAJE_PENDIENTE, mtInformation, [mbOK], 0);
end;

end.
