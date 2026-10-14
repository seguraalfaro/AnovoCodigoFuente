B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Ubicacion actual del telefono con el LocationManager de Android (red y satelite), sin Google Play.
' Pedir espera hasta el tiempo dado; sin permiso, sin senal o sin proveedor devuelve Ok en False.
Sub Class_Globals
	Private nativo As JavaObject
End Sub

Public Sub Initialize
	nativo = Me
End Sub

Public Sub Pedir (EsperaMs As Int) As ResumableSub
	Dim ctx As JavaObject
	ctx.InitializeContext
	nativo.RunMethod("pedir", Array(ctx, EsperaMs))
	Wait For Ubicacion_Resultado (Exito As Boolean, Lat As Double, Lon As Double, Margen As Double)
	Dim r As UbicacionGps
	r.Initialize
	r.Ok = Exito
	r.Latitud = Lat
	r.Longitud = Lon
	r.Precision = Margen
	Return r
End Sub

#If JAVA
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

private static final long VIGENCIA_MS = 120000;

public void pedir(Context ctx, int esperaMs) {
	final LocationManager lm = (LocationManager) ctx.getSystemService(Context.LOCATION_SERVICE);
	if (lm == null) {
		fallo();
		return;
	}
	Location mejor = null;
	for (String proveedor : new String[] {LocationManager.GPS_PROVIDER, LocationManager.NETWORK_PROVIDER}) {
		try {
			Location l = lm.getLastKnownLocation(proveedor);
			if (l != null && System.currentTimeMillis() - l.getTime() < VIGENCIA_MS
				&& (mejor == null || l.getAccuracy() < mejor.getAccuracy()))
				mejor = l;
		} catch (Exception e) {
		}
	}
	if (mejor != null) {
		avisar(mejor);
		return;
	}
	final boolean[] listo = {false};
	final LocationListener oyente = new LocationListener() {
		@Override
		public void onLocationChanged(Location l) {
			if (listo[0]) return;
			listo[0] = true;
			lm.removeUpdates(this);
			avisar(l);
		}

		@Override
		public void onStatusChanged(String proveedor, int estado, Bundle extras) {
		}

		@Override
		public void onProviderEnabled(String proveedor) {
		}

		@Override
		public void onProviderDisabled(String proveedor) {
		}
	};
	boolean pedido = false;
	try {
		if (lm.isProviderEnabled(LocationManager.NETWORK_PROVIDER)) {
			lm.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0, 0, oyente, Looper.getMainLooper());
			pedido = true;
		}
		if (lm.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
			lm.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, oyente, Looper.getMainLooper());
			pedido = true;
		}
	} catch (Exception e) {
		pedido = false;
	}
	if (!pedido) {
		fallo();
		return;
	}
	new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
		@Override
		public void run() {
			if (listo[0]) return;
			listo[0] = true;
			lm.removeUpdates(oyente);
			fallo();
		}
	}, esperaMs);
}

private void avisar(Location l) {
	ba.raiseEventFromUI(null, "ubicacion_resultado", true, l.getLatitude(), l.getLongitude(), (double) l.getAccuracy());
}

private void fallo() {
	ba.raiseEventFromUI(null, "ubicacion_resultado", false, 0d, 0d, 0d);
}
#End If
