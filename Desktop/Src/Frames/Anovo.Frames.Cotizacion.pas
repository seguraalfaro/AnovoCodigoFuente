unit Anovo.Frames.Cotizacion;

// Cotizacion abierta (HU-04): encabezado, lineas, ajuste y totales a la
// derecha; a la izquierda la solicitud, sus piezas y el croquis, las fotos
// y las medidas de la pieza elegida.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Mask, Vcl.DBCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  rDBComponents, rImageZoom,
  VclPlano.Tarjeta, VclPlano.BotonWin, VclPlano.Pastilla,
  Anovo.DTOs.Catalogos,
  Anovo.DTOs.Cotizaciones,
  Anovo.DTOs.Documento,
  Anovo.DTOs.Solicitudes,
  Anovo.Vistas.Intf.Cotizacion,
  Anovo.Presentadores.Cotizacion, Vcl.WinXCtrls, Anovo.UI.PanelRelativo;

type
  TfraCotizacion = class(TFrame, IVistaCotizacion)
    pnlEncabezado: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    btnVolver: TPlanoBotonWin;
    btnGuardar: TPlanoBotonWin;
    btnPresentar: TPlanoBotonWin;
    btnEnviar: TPlanoBotonWin;
    btnClienteAprobo: TPlanoBotonWin;
    btnClienteRechazo: TPlanoBotonWin;
    btnVistaPrevia: TPlanoBotonWin;
    btnHistorial: TPlanoBotonWin;
    btnGuardarPdf: TPlanoBotonWin;
    pnlAviso: TPanel;
    lblAviso: TLabel;
    pnlCuerpo: TPanel;
    pnlEvidencia: TPanel;
    tjSolicitud: TPlanoTarjeta;
    lblProyectoRot: TLabel;
    lblProyecto: TLabel;
    lblContactoRot: TLabel;
    lblContacto: TLabel;
    tjPiezas: TPlanoTarjeta;
    grPiezas: TrDBGrid;
    tjCroquis: TPlanoTarjeta;
    pbCroquis: TPaintBox;
    lblSinCroquis: TLabel;
    tjFotos: TPlanoTarjeta;
    lblSinFotos: TLabel;
    sbFotos: TScrollBox;
    tjMedidas: TPlanoTarjeta;
    grMedidas: TrDBGrid;
    pnlDerecha: TPanel;
    tjQueSeCotiza: TPlanoTarjeta;
    pnlPie: TPanel;
    tjTotales: TPlanoTarjeta;
    lblMaterialesRot: TLabel;
    lblManoObraRot: TLabel;
    lblMaquinaRot: TLabel;
    lblCostoRot: TLabel;
    lblAjusteRot: TLabel;
    lblIvaRot: TLabel;
    lblTotalRot: TLabel;
    lblMateriales: TLabel;
    lblManoObra: TLabel;
    lblMaquina: TLabel;
    lblCosto: TLabel;
    lblAjuste: TLabel;
    lblIva: TLabel;
    lblTotal: TLabel;
    tjAjuste: TPlanoTarjeta;
    lblAjustePorcentaje: TLabel;
    lblAjusteMotivo: TLabel;
    btnAjuste: TPlanoBotonWin;
    tjCondiciones: TPlanoTarjeta;
    cbFormaPago: TrDBLookupComboBox;
    edEntrega: TrDBEdit;
    cbEntregaUnidad: TrDBLookupComboBox;
    edGarantia: TrDBEdit;
    cbGarantiaUnidad: TrDBLookupComboBox;
    tjLineas: TPlanoTarjeta;
    btnMaterial: TPlanoBotonWin;
    btnManoObra: TPlanoBotonWin;
    btnMaquina: TPlanoBotonWin;
    btnNota: TPlanoBotonWin;
    grLineas: TrDBGrid;
    RelativePanel1: TRelativePanel;
    lblQueSeCotiza: TLabel;
    cbTipoTrabajo: TrDBLookupComboBox;
    edDescripcion: TrDBEdit;
    btnNuevoTipo: TPlanoBotonWin;
    pstEstado: TPlanoPastilla;
    procedure pbCroquisPaint(Sender: TObject);
    procedure imgFotoClick(Sender: TObject);
    procedure btnVolverClick(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure btnPresentarClick(Sender: TObject);
    procedure btnEnviarClick(Sender: TObject);
    procedure btnClienteAproboClick(Sender: TObject);
    procedure btnClienteRechazoClick(Sender: TObject);
    procedure btnVistaPreviaClick(Sender: TObject);
    procedure btnHistorialClick(Sender: TObject);
    procedure btnGuardarPdfClick(Sender: TObject);
    procedure btnAjusteClick(Sender: TObject);
    procedure btnMaterialClick(Sender: TObject);
    procedure btnManoObraClick(Sender: TObject);
    procedure btnMaquinaClick(Sender: TObject);
    procedure btnNotaClick(Sender: TObject);
    procedure btnNuevoTipoClick(Sender: TObject);
    procedure grPiezasCellClick(Column: TColumn);
    procedure grPiezasKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FrameResize(Sender: TObject);
  private
    FPresentador: TPresentadorCotizacion;
    FOnRegresar: TNotifyEvent;
    FCroquis: string;
    procedure ElegirPieza;
    procedure PonerFotos(const AFotos: TList<TBytes>);
    procedure Accion(Sender: TObject; const AClave: string);
    procedure AbrirLinea(const AModo: TModoLinea; const ALinea: TLineaDTO);
    function DatosEscritos: TCotizacionEdicionDTO;
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    function Confirmar(const AMensaje: string): Boolean;
    procedure MostrarCotizacion(const ACotizacion: TCotizacionDTO;
      const AConEncabezado: Boolean);
    procedure MostrarDevolucion(const AMotivo: string);
    procedure MostrarHistorial(const AEstados: TObjectList<TEstadoCotizacionDTO>);
    procedure MostrarDocumento(const ADocumento: TCotizacionDocumentoDTO;
      const ARuta: string);
    procedure MostrarEnvio(const ADocumento: TCotizacionDocumentoDTO);
    procedure AcomodarBotones;
    procedure MostrarBotones(const ABotones: TBotonesCotizacion;
      const AAcciones: TAccionesLinea);
    procedure MostrarLineas(const ALineas: TObjectList<TLineaDTO>);
    procedure MostrarTiposTrabajo(const ATipos: TObjectList<TTipoTrabajoDTO>);
    procedure MostrarFormasPago(const AFormas
      : TObjectList<TCatalogoSimpleDTO>);
    procedure MostrarSolicitud(const AProyecto, AContacto: string);
    procedure MostrarPiezas(const APiezas: TObjectList<TPiezaDTO>);
    procedure MostrarMedidas(const APieza: string;
      const AMedidas: TObjectList<TMedidaDTO>);
    procedure MostrarEvidencia(const APieza, ACroquis: string;
      const AFotos: TList<TBytes>; const ACargando: Boolean);
    procedure Regresar;
  public
    constructor Crear(AOwner: TComponent; const AId: Integer);
    destructor Destroy; override;
    property OnRegresar: TNotifyEvent read FOnRegresar write FOnRegresar;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Forms.HistorialCotizacion,
  System.Math,
  Anovo.UI.Vista,
  Anovo.UI.Tema,
  Anovo.UI.DBGridExtend,
  Anovo.UI.Croquis,
  Anovo.UI.Imagen,
  Anovo.Api.Cotizaciones,
  Anovo.Api.Solicitudes,
  Anovo.Api.Catalogos,
  Anovo.Api.Clientes,
  Anovo.Forms.LineaCotizacion,
  Anovo.Forms.AjusteCotizacion,
  Anovo.Forms.ItemCatalogo,
  Anovo.Reportes.Cotizacion,
  Anovo.Forms.EnvioCotizacion,
  Vcl.Dialogs,
  Anovo.Vistas.Intf.Catalogos,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Formato,
  Anovo.Textos;

const
  CAMPO_ACCIONES = 'ACCIONES';
  EXTENSION_PDF = 'pdf';
  MARGEN_BOTONES = 20;
  SEPARACION_BOTONES = 10;
  ACCIONES: array [TAccionLinea] of TAccionRejilla = ((Clave: 'editar';
    Rotulo: SAccionEditar), (Clave: 'quitar'; Rotulo: SAccionQuitar));
  ANCHO_CROQUIS = 1000;
  ALTO_CROQUIS = 700;
  LADO_MINIATURA = 64;
  SEPARACION_MINIATURA = 6;
  FONDO_MINIATURA = TColor($F1EAE6);
  PORCENTAJE_EVIDENCIA = 35;
  ANCHO_EVIDENCIA_MINIMO = 330;
  ANCHO_EVIDENCIA_MAXIMO = 420;

constructor TfraCotizacion.Crear(AOwner: TComponent; const AId: Integer);
var
  lRejilla: TDBGridExtend;
begin
  inherited Create(AOwner);
  AplicarTemaGrid(grLineas);
  AplicarTemaGrid(grPiezas);
  AplicarTemaGrid(grMedidas);
  lblSinCroquis.Caption := SSinCroquis;
  lblSinFotos.Caption := SSinFotos;

  lRejilla := TDBGridExtend.De(grLineas);
  lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
  lRejilla.OnAccion := Accion;

  FPresentador := TPresentadorCotizacion.Create(Self, TApiCotizaciones.Create,
    TApiSolicitudes.Create, TApiCatalogos.Create, TApiClientes.Create);
  FPresentador.Iniciar(AId);
end;

destructor TfraCotizacion.Destroy;
begin
  FreeAndNil(FPresentador);
  dmMemoria.mtLineasCotizacion.Close;
  dmMemoria.mtCotizacionEdicion.Close;
  dmMemoria.mtMedidas.Close;
  dmMemoria.mtPiezas.Close;
  dmMemoria.mtTiposTrabajoLista.Close;
  dmMemoria.mtFormasPagoLista.Close;
  inherited;
end;

procedure TfraCotizacion.MostrarCargando(const AActivo: Boolean);
begin
  BloquearEdicion([pnlEncabezado, pnlDerecha], AActivo);
end;

procedure TfraCotizacion.MostrarError(const AMensaje: string);
begin
  AvisarError(AMensaje);
end;

function TfraCotizacion.Confirmar(const AMensaje: string): Boolean;
begin
  Result := Anovo.UI.Vista.Confirmar(AMensaje);
end;

procedure TfraCotizacion.MostrarCotizacion(const ACotizacion: TCotizacionDTO;
  const AConEncabezado: Boolean);
begin
  lblTitulo.Caption := Format(SCotizacionTitulo,
    [ACotizacion.Numero, ACotizacion.ClienteNombre]);
  lblSubtitulo.Caption := Format(SCotizacionSubtitulo,
    [ACotizacion.SolicitudId, ACotizacion.AsesorNombre,
    ACotizacion.ElaboradaPorNombre]);
  pstEstado.Caption := TFormato.Estado(ACotizacion.Estado);
  pstEstado.Status := EstadoPlano(ACotizacion.Estado);

  lblMateriales.Caption :=
    TFormato.Colones(ACotizacion.SubtotalMateriales.ValueOrDefault);
  lblManoObra.Caption :=
    TFormato.Colones(ACotizacion.SubtotalManoObra.ValueOrDefault);
  lblMaquina.Caption :=
    TFormato.Colones(ACotizacion.SubtotalMaquina.ValueOrDefault);
  lblCosto.Caption := TFormato.Colones(ACotizacion.CostoTotal.ValueOrDefault);
  lblAjuste.Caption := TFormato.Colones(ACotizacion.CostoTotal.ValueOrDefault *
    ACotizacion.PorcentajeAjuste / 100);
  lblIva.Caption := TFormato.Colones(ACotizacion.MontoImpuesto.ValueOrDefault);
  lblTotal.Caption := TFormato.Colones(ACotizacion.MontoTotal.ValueOrDefault);

  if ACotizacion.PorcentajeIva = 0 then
    lblIvaRot.Caption := SIvaExonerado
  else
    lblIvaRot.Caption := Format(SIvaPorcentaje,
      [TFormato.Porcentaje(ACotizacion.PorcentajeIva)]);

  if ACotizacion.PorcentajeAjuste = 0 then
  begin
    lblAjusteRot.Caption := SSinAjuste;
    lblAjustePorcentaje.Caption := SSinAjuste;
  end
  else
  begin
    lblAjusteRot.Caption := Format(SAjustePorcentaje,
      [TFormato.Porcentaje(ACotizacion.PorcentajeAjuste)]);
    lblAjustePorcentaje.Caption := lblAjusteRot.Caption;
  end;
  lblAjusteMotivo.Caption := ACotizacion.MotivoAjuste.ValueOrDefault;

  if AConEncabezado then
    TMapeoDatos.ATabla(ACotizacion, dmMemoria.mtCotizacionEdicion);
end;

procedure TfraCotizacion.MostrarDevolucion(const AMotivo: string);
begin
  lblAviso.Caption := Format(SCotizacionDevuelta, [AMotivo]);
  pnlAviso.Visible := not AMotivo.IsEmpty;
end;

procedure TfraCotizacion.MostrarBotones(const ABotones: TBotonesCotizacion;
  const AAcciones: TAccionesLinea);
var
  lEditable: Boolean;
begin
  lEditable := bcGuardar in ABotones;
  btnGuardar.Visible := lEditable;
  btnPresentar.Visible := bcPresentar in ABotones;
  btnEnviar.Visible := bcEnviar in ABotones;
  btnClienteAprobo.Visible := bcRespuesta in ABotones;
  btnClienteRechazo.Visible := bcRespuesta in ABotones;
  btnAjuste.Visible := bcAjuste in ABotones;
  btnNuevoTipo.Visible := bcNuevoTipo in ABotones;
  btnMaterial.Visible := bcAgregarLinea in ABotones;
  btnManoObra.Visible := bcAgregarLinea in ABotones;
  btnMaquina.Visible := bcAgregarLinea in ABotones;
  btnNota.Visible := bcAgregarLinea in ABotones;
  btnVistaPrevia.Visible := bcDocumento in ABotones;
  btnGuardarPdf.Visible := bcDocumento in ABotones;
  AcomodarBotones;
  cbTipoTrabajo.ReadOnly := not lEditable;
  edDescripcion.ReadOnly := not lEditable;
  cbFormaPago.ReadOnly := not lEditable;
  edEntrega.ReadOnly := not lEditable;
  cbEntregaUnidad.ReadOnly := not lEditable;
  edGarantia.ReadOnly := not lEditable;
  cbGarantiaUnidad.ReadOnly := not lEditable;
  if lEditable and dmMemoria.mtCotizacionEdicion.Active and
    not (dmMemoria.mtCotizacionEdicion.State in dsEditModes) then
    dmMemoria.mtCotizacionEdicion.Edit;
  TDBGridExtend.De(grLineas).PonerAcciones<TAccionesLinea>(ACCIONES, AAcciones);
end;

procedure TfraCotizacion.MostrarLineas(const ALineas: TObjectList<TLineaDTO>);
begin
  TMapeoDatos.AListaTabla<TLineaDTO>(ALineas, dmMemoria.mtLineasCotizacion);
  TDBGridExtend.De(grLineas).AjustarColumnas;
end;

procedure TfraCotizacion.MostrarTiposTrabajo(const ATipos
  : TObjectList<TTipoTrabajoDTO>);
begin
  TMapeoDatos.AListaTabla<TTipoTrabajoDTO>(ATipos,
    dmMemoria.mtTiposTrabajoLista);
end;

procedure TfraCotizacion.MostrarFormasPago(const AFormas
  : TObjectList<TCatalogoSimpleDTO>);
begin
  TMapeoDatos.AListaTabla<TCatalogoSimpleDTO>(AFormas,
    dmMemoria.mtFormasPagoLista);
end;

procedure TfraCotizacion.MostrarSolicitud(const AProyecto, AContacto: string);
begin
  lblProyecto.Caption := AProyecto;
  lblContacto.Caption := AContacto;
end;

procedure TfraCotizacion.MostrarPiezas(const APiezas: TObjectList<TPiezaDTO>);
begin
  tjPiezas.Caption := Format(SPiezasTotal, [APiezas.Count]);
  TMapeoDatos.AListaTabla<TPiezaDTO>(APiezas, dmMemoria.mtPiezas);
  dmMemoria.mtPiezas.First;
  TDBGridExtend.De(grPiezas).AjustarColumnas;
end;

procedure TfraCotizacion.MostrarMedidas(const APieza: string;
  const AMedidas: TObjectList<TMedidaDTO>);
begin
  tjMedidas.Caption := Format(SMedidasDePieza, [APieza]);
  TMapeoDatos.AListaTabla<TMedidaDTO>(AMedidas, dmMemoria.mtMedidas);
  TDBGridExtend.De(grMedidas).AjustarColumnas;
end;

procedure TfraCotizacion.MostrarEvidencia(const APieza, ACroquis: string;
  const AFotos: TList<TBytes>; const ACargando: Boolean);
var
  lTotal: Integer;
begin
  lTotal := 0;
  if AFotos <> nil then
    lTotal := AFotos.Count;
  if not APieza.IsEmpty then
  begin
    tjCroquis.Caption := Format(SCroquisDePieza, [APieza]);
    tjFotos.Caption := Format(SFotografiasDePieza, [APieza, lTotal]);
  end
  else
    tjFotos.Caption := Format(SFotografias, [lTotal]);

  if ACargando then
  begin
    lblSinCroquis.Caption := SCargandoEvidencia;
    lblSinFotos.Caption := SCargandoEvidencia;
  end
  else
  begin
    lblSinCroquis.Caption := SSinCroquis;
    lblSinFotos.Caption := SSinFotos;
  end;

  FCroquis := ACroquis;
  lblSinCroquis.Visible := ACroquis.IsEmpty;
  pbCroquis.Visible := not ACroquis.IsEmpty;
  pbCroquis.Invalidate;

  PonerFotos(AFotos);
  lblSinFotos.Visible := lTotal = 0;
  sbFotos.Visible := lTotal > 0;
end;

procedure TfraCotizacion.PonerFotos(const AFotos: TList<TBytes>);
var
  I: Integer;
  lMiniatura: TrImageZoom;
  lFlujo: TBytesStream;
  lImagen: TWICImage;
begin
  while sbFotos.ControlCount > 0 do
    sbFotos.Controls[0].Free;
  sbFotos.HorzScrollBar.Position := 0;
  if AFotos = nil then
    Exit;

  for I := 0 to AFotos.Count - 1 do
  begin
    lMiniatura := TrImageZoom.Create(Self);
    lMiniatura.Parent := sbFotos;
    lMiniatura.Tag := TAG_RAW;
    lMiniatura.SetBounds(I * (LADO_MINIATURA + SEPARACION_MINIATURA), 0,
      LADO_MINIATURA, LADO_MINIATURA);
    lMiniatura.Cursor := crHandPoint;
    lMiniatura.EnlargeToFit := True;
    lMiniatura.ReduceToFit := True;
    lMiniatura.DragAndMove := False;
    lMiniatura.BorderColor := clSilver;
    lMiniatura.BackgroundColor := FONDO_MINIATURA;
    lMiniatura.ShowEditor := ieNone;
    lMiniatura.ShowPopupMenu := False;
    lMiniatura.ReadOnly := True;
    lMiniatura.OnClick := imgFotoClick;

    lFlujo := TBytesStream.Create(AFotos[I]);
    lImagen := TWICImage.Create;
    try
      lImagen.LoadFromStream(lFlujo);
      lMiniatura.Picture.Assign(lImagen);
    finally
      lImagen.Free;
      lFlujo.Free;
    end;
  end;
end;

procedure TfraCotizacion.ElegirPieza;
begin
  if not dmMemoria.mtPiezas.IsEmpty then
    FPresentador.ElegirPieza(dmMemoria.mtPiezasID.AsInteger);
end;

procedure TfraCotizacion.FrameResize(Sender: TObject);
begin
  pnlEvidencia.Width := EnsureRange(ClientWidth * PORCENTAJE_EVIDENCIA div 100,
    ScaleValue(ANCHO_EVIDENCIA_MINIMO), ScaleValue(ANCHO_EVIDENCIA_MAXIMO));
end;

procedure TfraCotizacion.grPiezasCellClick(Column: TColumn);
begin
  ElegirPieza;
end;

procedure TfraCotizacion.grPiezasKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ElegirPieza;
end;

procedure TfraCotizacion.pbCroquisPaint(Sender: TObject);
begin
  pbCroquis.Canvas.Brush.Color := clWhite;
  pbCroquis.Canvas.FillRect(pbCroquis.ClientRect);
  DibujarCroquis(pbCroquis.Canvas, pbCroquis.ClientRect, FCroquis);
end;

procedure TfraCotizacion.imgFotoClick(Sender: TObject);
var
  lMapa: TBitmap;
begin
  if Sender = pbCroquis then
  begin
    lMapa := TBitmap.Create;
    try
      lMapa.SetSize(ANCHO_CROQUIS, ALTO_CROQUIS);
      lMapa.Canvas.Brush.Color := clWhite;
      lMapa.Canvas.FillRect(Rect(0, 0, ANCHO_CROQUIS, ALTO_CROQUIS));
      DibujarCroquis(lMapa.Canvas, Rect(0, 0, ANCHO_CROQUIS, ALTO_CROQUIS),
        FCroquis);
      MostrarAmpliada(Self, lMapa, tjCroquis.Caption);
    finally
      lMapa.Free;
    end;
  end
  else if (Sender is TrImageZoom) and
    (TrImageZoom(Sender).Picture.Graphic <> nil) then
    MostrarAmpliada(Self, TrImageZoom(Sender).Picture.Graphic,
      tjFotos.Caption);
end;

function TfraCotizacion.DatosEscritos: TCotizacionEdicionDTO;
begin
  dmMemoria.Confirmar(dmMemoria.mtCotizacionEdicion);
  Result := TMapeoDatos.ADto<TCotizacionEdicionDTO>
    (dmMemoria.mtCotizacionEdicion);
end;

procedure TfraCotizacion.btnGuardarClick(Sender: TObject);
begin
  FPresentador.Guardar(DatosEscritos);
end;

procedure TfraCotizacion.btnPresentarClick(Sender: TObject);
begin
  FPresentador.Presentar(DatosEscritos);
end;

procedure TfraCotizacion.btnEnviarClick(Sender: TObject);
begin
  FPresentador.PrepararEnvio;
end;

procedure TfraCotizacion.btnClienteAproboClick(Sender: TObject);
begin
  FPresentador.RegistrarRespuesta(True);
end;

procedure TfraCotizacion.btnClienteRechazoClick(Sender: TObject);
begin
  FPresentador.RegistrarRespuesta(False);
end;

procedure TfraCotizacion.btnVistaPreviaClick(Sender: TObject);
begin
  FPresentador.VerDocumento('');
end;

procedure TfraCotizacion.btnHistorialClick(Sender: TObject);
begin
  FPresentador.VerHistorial;
end;

procedure TfraCotizacion.MostrarHistorial(const AEstados
  : TObjectList<TEstadoCotizacionDTO>);
begin
  TfrmHistorialCotizacion.Mostrar(Self, FPresentador.Numero, AEstados);
end;

procedure TfraCotizacion.btnGuardarPdfClick(Sender: TObject);
var
  lDialogo: TSaveDialog;
begin
  lDialogo := TSaveDialog.Create(nil);
  try
    lDialogo.Filter := SFiltroPdf;
    lDialogo.DefaultExt := EXTENSION_PDF;
    lDialogo.FileName := Format(SNombrePdfCotizacion, [FPresentador.Numero]);
    lDialogo.Options := lDialogo.Options + [ofOverwritePrompt];
    if lDialogo.Execute then
      FPresentador.VerDocumento(lDialogo.FileName);
  finally
    lDialogo.Free;
  end;
end;

procedure TfraCotizacion.MostrarDocumento(const ADocumento
  : TCotizacionDocumentoDTO; const ARuta: string);
begin
  if ARuta.IsEmpty then
    TReporteCotizacion.VistaPrevia(ADocumento)
  else
  begin
    TReporteCotizacion.GuardarPdf(ADocumento, ARuta);
    Informar(Format(SDocumentoGuardado, [ARuta]));
  end;
end;

procedure TfraCotizacion.MostrarEnvio(const ADocumento
  : TCotizacionDocumentoDTO);
begin
  if TfrmEnvioCotizacion.Enviar(Self, ADocumento, FPresentador.Id) then
    Regresar;
end;

procedure TfraCotizacion.AcomodarBotones;
var
  lBoton: TPlanoBotonWin;
  lDerecha: Integer;
begin
  lDerecha := pnlEncabezado.ClientWidth - MARGEN_BOTONES;
  for lBoton in [btnClienteAprobo, btnClienteRechazo, btnEnviar, btnPresentar,
    btnGuardar, btnGuardarPdf, btnVistaPrevia, btnHistorial, btnVolver] do
    if lBoton.Visible then
    begin
      lBoton.Left := lDerecha - lBoton.Width;
      lDerecha := lBoton.Left - SEPARACION_BOTONES;
    end;
end;

procedure TfraCotizacion.btnVolverClick(Sender: TObject);
begin
  Regresar;
end;

procedure TfraCotizacion.Regresar;
begin
  if Assigned(FOnRegresar) then
    FOnRegresar(Self);
end;

procedure TfraCotizacion.btnAjusteClick(Sender: TObject);
begin
  if TfrmAjusteCotizacion.Mostrar(Self, FPresentador.Id, FPresentador.Costo,
    FPresentador.PorcentajeIva, FPresentador.PorcentajeAjuste,
    FPresentador.MotivoAjuste) then
    FPresentador.Recargar;
end;

procedure TfraCotizacion.AbrirLinea(const AModo: TModoLinea;
  const ALinea: TLineaDTO);
begin
  if TfrmLineaCotizacion.Mostrar(Self, FPresentador.Id, AModo, ALinea) then
    FPresentador.Recargar;
end;

procedure TfraCotizacion.btnMaterialClick(Sender: TObject);
begin
  AbrirLinea(mlMaterial, nil);
end;

procedure TfraCotizacion.btnManoObraClick(Sender: TObject);
begin
  AbrirLinea(mlManoObra, nil);
end;

procedure TfraCotizacion.btnMaquinaClick(Sender: TObject);
begin
  AbrirLinea(mlMaquina, nil);
end;

procedure TfraCotizacion.btnNotaClick(Sender: TObject);
begin
  AbrirLinea(mlNota, nil);
end;

procedure TfraCotizacion.btnNuevoTipoClick(Sender: TObject);
begin
  if TfrmItemCatalogo.Mostrar(Self, ctTiposTrabajo, 0) then
    FPresentador.RecargarTipos;
end;

procedure TfraCotizacion.Accion(Sender: TObject; const AClave: string);
var
  lLinea: TLineaDTO;
begin
  if dmMemoria.mtLineasCotizacion.IsEmpty then
    Exit;
  lLinea := FPresentador.Linea(dmMemoria.mtLineasCotizacionID.AsInteger);
  if lLinea = nil then
    Exit;
  if SameText(AClave, ACCIONES[alEditar].Clave) then
    AbrirLinea(mlEditar, lLinea)
  else if SameText(AClave, ACCIONES[alQuitar].Clave) then
    FPresentador.QuitarLinea(lLinea.ID);
end;

end.
