unit Anovo.Forms.Servidor;

// Ventana del servidor: log, base, cache de permisos, actividad
// y errores.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls,
  MVCFramework.Server.Intf;

type
  TfrmServidor = class(TForm)
    pnlEncabezado: TPanel;
    lblTitulo: TLabel;
    lblEstado: TLabel;
    btnIniciar: TButton;
    btnDetener: TButton;
    lblBase: TLabel;
    lblVersion: TLabel;
    pnlContadores: TPanel;
    lblServidas: TLabel;
    lblErrores: TLabel;
    lblCache: TLabel;
    btnInvalidar: TButton;
    pgc: TPageControl;
    tabRegistro: TTabSheet;
    memRegistro: TMemo;
    tabActividad: TTabSheet;
    lvActividad: TListView;
    tabErrores: TTabSheet;
    lvErrores: TListView;
    tmrRefresco: TTimer;
    tmrVigencias: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnIniciarClick(Sender: TObject);
    procedure btnDetenerClick(Sender: TObject);
    procedure btnInvalidarClick(Sender: TObject);
    procedure tmrRefrescoTimer(Sender: TObject);
    procedure tmrVigenciasTimer(Sender: TObject);
  private
    FServidor: IMVCServer;
    FDesde: TDateTime;
    FYaArranco: Boolean;
    procedure MostrarEstado;
    procedure RelevarPrecios;
    procedure MostrarCabecera;
    procedure RefrescarContadores;
    procedure RefrescarListas;
    function EstaEscuchando: Boolean;
  end;

var
  frmServidor: TfrmServidor;

implementation

{$R *.dfm}

uses
  System.DateUtils,
  LoggerPro,
  LoggerPro.VCLMemoAppender,
  MVCFramework.Container,
  MVCFramework.Logger,
  MVCFramework.Commons,
  Anovo.Bootstrap,
  Anovo.Servidor,
  Anovo.Middleware.Actividad,
  Anovo.Services.Vigencias,
  Anovo.Services.Intf.Permisos;

const
  REFRESCO_MS = 1000;

  LINEAS_LOG = 500;

  VIGENCIAS_MS = 60 * 60 * 1000;

procedure TfrmServidor.FormCreate(Sender: TObject);
begin
  Caption := 'Servidor Anovo';
  FServidor := nil;
  FDesde := 0;
  FYaArranco := False;

  Boot(TVCLMemoLogAppender.Create(memRegistro, LINEAS_LOG) as ILogAppender,
    False);

  PrepararServicios;

  MostrarCabecera;
  MostrarEstado;
  tmrRefresco.Interval := REFRESCO_MS;
  tmrRefresco.Enabled := True;
end;

procedure TfrmServidor.FormShow(Sender: TObject);
begin
  if FYaArranco then
    Exit;
  FYaArranco := True;
  btnIniciarClick(nil);
end;

procedure TfrmServidor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tmrRefresco.Enabled := False;
  tmrVigencias.Enabled := False;
  if EstaEscuchando then
  begin
    LogI('Cerrando el servidor desde la ventana.');
    FServidor.Stop;
    FServidor := nil;
  end;
end;

function TfrmServidor.EstaEscuchando: Boolean;
begin
  Result := FServidor <> nil;
end;

procedure TfrmServidor.MostrarCabecera;
begin
  lblBase.Caption := 'Base: ' + BaseConfigurada + '   Usuario: ' +
    UsuarioDeBase;
  lblVersion.Caption := 'DelphiMVCFramework ' + DMVCFRAMEWORK_VERSION;
end;

procedure TfrmServidor.MostrarEstado;
begin
  if EstaEscuchando then
  begin
    lblEstado.Caption := 'Escuchando en https://localhost:' +
      PuertoConfigurado.ToString;
    lblEstado.Font.Color := clGreen;
  end
  else
  begin
    lblEstado.Caption := 'Detenido';
    lblEstado.Font.Color := clMaroon;
  end;
  btnIniciar.Enabled := not EstaEscuchando;
  btnDetener.Enabled := EstaEscuchando;
end;

procedure TfrmServidor.btnIniciarClick(Sender: TObject);
begin
  if EstaEscuchando then
    Exit;

  Screen.Cursor := crAppStart;
  try
    try
      FServidor := CrearServidor;

      RelevarPrecios;

      FServidor.Listen(PuertoConfigurado);
      tmrVigencias.Interval := VIGENCIAS_MS;
      tmrVigencias.Enabled := True;
      FDesde := Now;
      TActividad.Limpiar;
      LogI('Servidor levantado desde la ventana en el puerto ' +
        PuertoConfigurado.ToString);
    except
      on E: Exception do
      begin
        FServidor := nil;
        LogE('No se pudo levantar: ' + E.ClassName + ': ' + E.Message);
        MessageDlg('No se pudo levantar el servidor.' + sLineBreak +
          sLineBreak + E.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
    Screen.Cursor := crDefault;
    MostrarEstado;
  end;
end;

procedure TfrmServidor.btnDetenerClick(Sender: TObject);
begin
  if not EstaEscuchando then
    Exit;

  tmrVigencias.Enabled := False;
  FServidor.Stop;
  FServidor := nil;
  FDesde := 0;
  LogI('Servidor detenido desde la ventana.');
  MostrarEstado;
end;

procedure TfrmServidor.btnInvalidarClick(Sender: TObject);
var
  lCache: IPermisoCache;
begin
  lCache := NewServiceContainerResolver.Resolve(TypeInfo(IPermisoCache))
    as IPermisoCache;
  lCache.Invalidar;
  LogI('Cache de permisos invalidada desde la ventana.');
  RefrescarContadores;
end;

procedure TfrmServidor.RelevarPrecios;
begin
  try
    AplicarVigencias;
  except
    on E: Exception do
      LogE('No se pudieron relevar los precios programados: ' + E.ClassName +
        ': ' + E.Message);
  end;
end;

procedure TfrmServidor.tmrVigenciasTimer(Sender: TObject);
begin
  RelevarPrecios;
end;

procedure TfrmServidor.tmrRefrescoTimer(Sender: TObject);
begin
  RefrescarContadores;
  RefrescarListas;
end;

procedure TfrmServidor.RefrescarContadores;
var
  lCache: IPermisoCache;
  lMinutos: Int64;
begin
  lblServidas.Caption := 'Peticiones: ' + TActividad.Servidas.ToString;
  lblErrores.Caption := 'Errores: ' + TActividad.Errores.ToString;

  if FDesde > 0 then
  begin
    lMinutos := MinutesBetween(Now, FDesde);
    lblTitulo.Caption := 'Servidor Anovo   ' + FormatDateTime('hh:nn', FDesde)
      + '   (' + lMinutos.ToString + ' min)';
  end
  else
    lblTitulo.Caption := 'Servidor Anovo';

  try
    lCache := NewServiceContainerResolver.Resolve(TypeInfo(IPermisoCache))
      as IPermisoCache;
    if lCache.Cargada then
      lblCache.Caption := 'Permisos: en cache'
    else
      lblCache.Caption := 'Permisos: sin cargar';
  except
    lblCache.Caption := 'Permisos: sin cargar';
  end;
end;

procedure TfrmServidor.RefrescarListas;
var
  lFilas: TArray<TRegistroActividad>;
  lFila: TRegistroActividad;
  lItem: TListItem;

  procedure Agregar(const ALista: TListView; const AFila: TRegistroActividad);
  begin
    lItem := ALista.Items.Add;
    lItem.Caption := FormatDateTime('hh:nn:ss', AFila.Hora);
    if AFila.UsuarioId = 0 then
      lItem.SubItems.Add('-')
    else
      lItem.SubItems.Add(AFila.UsuarioId.ToString);
    lItem.SubItems.Add(AFila.Verbo);
    lItem.SubItems.Add(AFila.Ruta);
    lItem.SubItems.Add(AFila.Estado.ToString);
    lItem.SubItems.Add(AFila.Milisegundos.ToString);
  end;

begin
  if not(pgc.ActivePage = tabActividad) and not(pgc.ActivePage = tabErrores)
  then
    Exit;

  lFilas := TActividad.Ultimas;

  if pgc.ActivePage = tabActividad then
  begin
    lvActividad.Items.BeginUpdate;
    try
      lvActividad.Items.Clear;
      for lFila in lFilas do
        Agregar(lvActividad, lFila);
    finally
      lvActividad.Items.EndUpdate;
    end;
    Exit;
  end;

  lvErrores.Items.BeginUpdate;
  try
    lvErrores.Items.Clear;
    for lFila in lFilas do
      if lFila.Estado >= 400 then
        Agregar(lvErrores, lFila);
  finally
    lvErrores.Items.EndUpdate;
  end;
end;

end.
