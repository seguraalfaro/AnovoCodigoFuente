unit Anovo.Forms.AjusteCotizacion;

// Ventana del ajuste de la cotizacion: descuento o recargo con su motivo
// y una vista previa del total.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.TitleBarCtrls, Vcl.WinXCtrls, Vcl.Mask, Vcl.DBCtrls,
  rDBComponents,
  VclPlano.BotonWin,
  Anovo.Forms.Edicion,
  Anovo.Vistas.Intf.Cotizacion,
  Anovo.Vistas.Intf.Registro,
  Anovo.Presentadores.Cotizacion;

type
  TfrmAjusteCotizacion = class(TfrmEdicion, IVistaAjuste)
    pnlCampos: TPanel;
    lblCostoRot: TLabel;
    lblAjusteRot: TLabel;
    lblIvaRot: TLabel;
    lblTotalRot: TLabel;
    lblCosto: TLabel;
    lblAjuste: TLabel;
    lblIva: TLabel;
    lblTotal: TLabel;
    lblAyuda: TLabel;
    rbDescuento: TRadioButton;
    rbRecargo: TRadioButton;
    edPorcentaje: TrDBEdit;
    edMotivo: TrDBEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure CambioAjuste(Sender: TObject);
  private
    FPresentador: TPresentadorAjusteCotizacion;
    FGuardado: Boolean;
    function Porcentaje: Currency;
    procedure MostrarVistaPrevia(const AAjuste, AIva, ATotal: Currency);
    procedure Guardado(const AId: Integer);
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    class function Mostrar(AOwner: TComponent; const ACotizacionId: Integer;
      const ACosto, APorcentajeIva, APorcentajeActual: Currency;
      const AMotivoActual: string): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Api.Cotizaciones,
  Anovo.Datos.Memoria,
  Anovo.Formato,
  Anovo.Textos;

class function TfrmAjusteCotizacion.Mostrar(AOwner: TComponent;
  const ACotizacionId: Integer; const ACosto, APorcentajeIva,
  APorcentajeActual: Currency; const AMotivoActual: string): Boolean;
var
  lForma: TfrmAjusteCotizacion;
begin
  lForma := TfrmAjusteCotizacion.Create(AOwner);
  try
    lForma.FPresentador.Iniciar(ACotizacionId, ACosto, APorcentajeIva);
    lForma.lblCosto.Caption := TFormato.Colones(ACosto);
    if APorcentajeIva = 0 then
      lForma.lblIvaRot.Caption := SIvaExonerado
    else
      lForma.lblIvaRot.Caption := Format(SIvaPorcentaje,
        [TFormato.Porcentaje(APorcentajeIva)]);
    lForma.rbDescuento.Checked := APorcentajeActual < 0;
    lForma.rbRecargo.Checked := APorcentajeActual >= 0;
    dmMemoria.mtAjustePORCENTAJE.AsCurrency := Abs(APorcentajeActual);
    dmMemoria.mtAjusteMOTIVO.AsString := AMotivoActual;
    lForma.CambioAjuste(nil);
    lForma.ShowModal;
    Result := lForma.FGuardado;
  finally
    lForma.Free;
  end;
end;

procedure TfrmAjusteCotizacion.FormCreate(Sender: TObject);
begin
  FGuardado := False;
  lblTitulo.Caption := SAjusteTitulo;
  lblAyuda.Caption := SAjusteAyuda;
  btnGuardar.Caption := SBotonAplicarAjuste;
  FPresentador := TPresentadorAjusteCotizacion.Create(Self,
    TApiCotizaciones.Create);
  dmMemoria.Preparar(dmMemoria.mtAjuste);
end;

procedure TfrmAjusteCotizacion.FormDestroy(Sender: TObject);
begin
  FPresentador.Free;
  dmMemoria.mtAjuste.Close;
end;

function TfrmAjusteCotizacion.ControlesEdicion: TArray<TControl>;
begin
  Result := [pnlCampos];
end;

function TfrmAjusteCotizacion.Porcentaje: Currency;
begin
  Result := Abs(StrToCurrDef(edPorcentaje.Text, 0));
end;

procedure TfrmAjusteCotizacion.CambioAjuste(Sender: TObject);
begin
  if FPresentador = nil then
    Exit;
  FPresentador.Previsualizar(Porcentaje, rbDescuento.Checked);
end;

procedure TfrmAjusteCotizacion.MostrarVistaPrevia(const AAjuste, AIva,
  ATotal: Currency);
begin
  if rbDescuento.Checked then
    lblAjusteRot.Caption := Format(SDescuento,
      [TFormato.Porcentaje(Porcentaje)])
  else
    lblAjusteRot.Caption := Format(SRecargo, [TFormato.Porcentaje(Porcentaje)]);
  lblAjuste.Caption := TFormato.Colones(AAjuste);
  lblIva.Caption := TFormato.Colones(AIva);
  lblTotal.Caption := TFormato.Colones(ATotal);
end;

procedure TfrmAjusteCotizacion.btnGuardarClick(Sender: TObject);
begin
  dmMemoria.Confirmar(dmMemoria.mtAjuste);
  FPresentador.Aplicar(Abs(dmMemoria.mtAjustePORCENTAJE.AsCurrency),
    rbDescuento.Checked, dmMemoria.mtAjusteMOTIVO.AsString);
end;

procedure TfrmAjusteCotizacion.Guardado(const AId: Integer);
begin
  FGuardado := True;
  ModalResult := mrOk;
end;

end.
