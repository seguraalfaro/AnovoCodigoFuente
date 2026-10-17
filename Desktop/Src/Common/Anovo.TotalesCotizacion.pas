unit Anovo.TotalesCotizacion;

// Textos del desglose de una cotizacion (subtotales, ajuste, IVA y total)
// para las pantallas que lo muestran, sin VCL.

interface

uses
  Anovo.DTOs.Cotizaciones;

type
  TTotalesCotizacion = record
    Materiales: string;
    ManoObra: string;
    Maquina: string;
    Costo: string;
    AjusteRotulo: string;
    Ajuste: string;
    MotivoAjuste: string;
    IvaRotulo: string;
    Iva: string;
    Total: string;
    class function De(const ACotizacion: TCotizacionDTO)
      : TTotalesCotizacion; static;
  end;

implementation

uses
  System.SysUtils,
  Anovo.Formato,
  Anovo.Textos;

class function TTotalesCotizacion.De(const ACotizacion: TCotizacionDTO)
  : TTotalesCotizacion;
begin
  Result.Materiales :=
    TFormato.Colones(ACotizacion.SubtotalMateriales.ValueOrDefault);
  Result.ManoObra :=
    TFormato.Colones(ACotizacion.SubtotalManoObra.ValueOrDefault);
  Result.Maquina :=
    TFormato.Colones(ACotizacion.SubtotalMaquina.ValueOrDefault);
  Result.Costo := TFormato.Colones(ACotizacion.CostoTotal.ValueOrDefault);
  Result.Ajuste := TFormato.Colones(ACotizacion.CostoTotal.ValueOrDefault *
    ACotizacion.PorcentajeAjuste / 100);
  if ACotizacion.PorcentajeAjuste = 0 then
    Result.AjusteRotulo := SSinAjuste
  else
    Result.AjusteRotulo := Format(SAjustePorcentaje,
      [TFormato.Porcentaje(ACotizacion.PorcentajeAjuste)]);
  Result.MotivoAjuste := ACotizacion.MotivoAjuste.ValueOrDefault;
  if ACotizacion.PorcentajeIva = 0 then
    Result.IvaRotulo := SIvaExonerado
  else
    Result.IvaRotulo := Format(SIvaPorcentaje,
      [TFormato.Porcentaje(ACotizacion.PorcentajeIva)]);
  Result.Iva := TFormato.Colones(ACotizacion.MontoImpuesto.ValueOrDefault);
  Result.Total := TFormato.Colones(ACotizacion.MontoTotal.ValueOrDefault);
end;

end.
