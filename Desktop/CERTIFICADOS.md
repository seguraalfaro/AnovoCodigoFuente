# Certificado del servidor en la aplicación de escritorio

Cómo lograr que la aplicación de escritorio se conecte por HTTPS al servidor de Anovo, que
usa un certificado emitido por una **autoridad certificadora (CA) propia**, y por qué la
solución es la que es.

**Estado:** solución aplicada y **confirmada** el 16/09/2026 en `Src/Api/Anovo.Api.Base.pas`:
el login desde la aplicación de escritorio funciona contra el servidor.

---

## Paso a paso en un equipo cliente

### 1. Instalar la CA del servidor en Windows

La aplicación usa el cliente HTTP de Delphi, que confía en el almacén de certificados de
**Windows**. Importar la CA en Firefox no sirve: Firefox tiene su propio almacén.

Se instala **la CA** (`rootCA.crt`), no el certificado del servidor (`localhost.crt`). En el
almacén del usuario no hace falta ser administrador:

```bash
certutil -user -addstore Root "ruta\a\rootCA.crt"
```

Windows pide confirmar que se confía en ella.

### 2. Comprobar que Windows confía en el servidor

Con el servidor en marcha, usando el `curl` de Windows (el de `C:\Windows\System32`, que usa
el mismo motor de certificados que la aplicación):

```bash
C:\Windows\System32\curl.exe --ssl-no-revoke https://localhost:443/api/swagger.json
```

Tiene que responder con el documento. **El `--ssl-no-revoke` es imprescindible**: sin él,
`curl` exige consultar la revocación del certificado, y la CA propia no la publica. La
aplicación no hace esa consulta, así que sin la opción la prueba falla por un motivo que no
afecta a la aplicación.

### 3. La URL tiene que coincidir con el certificado

El certificado del servidor cubre `localhost` y `127.0.0.1`. La URL del archivo `.ini` junto
al ejecutable debe usar uno de esos nombres:

```ini
[Servidor]
Url=https://localhost:443
```

Para otro equipo de la red hay que reemitir el certificado con el nombre o la IP del
servidor. La CA se reutiliza: los equipos que ya confían en ella no reinstalan nada.

### 4. El validador del cliente

Ya está en `Anovo.Api.Base`. Sin él, la conexión se rechaza **aunque los pasos 1 a 3 estén
bien**. Se explica abajo.

---

## Por qué hace falta el validador

Con la CA instalada y `curl` respondiendo bien, la aplicación seguía rechazando la conexión.
La causa está en la combinación de Delphi 10.4 con el cliente REST del framework:

1. **WinHTTP, en Delphi 10.4, llama al validador también cuando el certificado es válido.**
   En `System.Net.HttpClient.Win.pas`, al enviar la petición, si hay un validador asignado
   se le consulta con `SecureFailureReasons` vacío y `aAccepted` en `True`, solo para
   ofrecer una validación adicional.

2. **El cliente REST de DMVCFramework siempre asigna su propio validador**, y responde
   `aAccepted := MVCRESTClientAcceptInvalidCertificates`, que vale `False`. Su comentario
   supone que solo lo llaman cuando el certificado ya falló; en 10.4 con WinHTTP no es así.
   Resultado: rechaza **todo** HTTPS, incluso con certificados válidos.

La solución es dar un validador propio que acepte **solo lo que Windows ya dio por bueno**:

```pascal
aAccepted := (aSender is THTTPClient) and
  (THTTPClient(aSender).SecureFailureReasons = []);
```

No afloja la seguridad: si Windows rechaza el certificado —CA desconocida, nombre que no
coincide, fecha vencida—, `SecureFailureReasons` trae el motivo y se sigue rechazando.

---

## Lo que NO hay que hacer

**Aceptar cualquier certificado** (`Accepted := True`), como hace el ejemplo `ssl_client` del
framework. Le entrega el token y la clave a cualquiera que se ponga en medio de la conexión.

**Poner `MVCRESTClientAcceptInvalidCertificates := True`.** Es lo mismo, pero para todas las
conexiones de la aplicación.

**Diagnosticar con `certutil -verify`.** Revisa la revocación siempre, y la aplicación no.
Da un error que la aplicación nunca tiene, y lleva a buscar la solución en el sitio
equivocado. Ver la nota de revisión.

---

## Nota de revisión: cómo se llegó a la solución

La solución no fue la primera que se intentó. Se deja constancia de lo revisado, porque los
caminos descartados son justo los que alguien volvería a probar.

**Documentación y ejemplos del framework consultados:**

- `CERTIFICATES_TUTORIAL.MD` del repositorio de DMVCFramework: resuelve la confianza
  instalando la CA en el almacén de Windows. Necesario, pero no suficiente.
- Ejemplo `ssl_client`: usa `SetValidateServerCertificateProc` con `Accepted := True`. Confirma
  que hace falta un validador propio, pero su versión acepta cualquier certificado. Viene de
  cuando el validador interno del framework aceptaba todo por defecto.
- Ejemplo `ssl_server`: configura Indy con SSLv3, TLS 1.0 y TLS 1.1, protocolos obsoletos. No
  sirve de modelo; el servidor de Anovo usa TaurusTLS.

**Código fuente revisado:**

- `MVCFramework.RESTClient.pas`: el validador interno que rechaza por defecto, y el `Execute`
  que envuelve todo error de red en `EMVCRESTClientHttpException`.
- `System.Net.HttpClient.pas` y `System.Net.HttpClient.Win.pas` de la RTL de Delphi 10.4: en
  qué momentos se llama al validador, qué contiene `SecureFailureReasons`, y que la RTL
  **nunca activa** la revisión de revocación de WinHTTP.

**Caminos descartados, en orden:**

| Hipótesis | Qué se hizo | Por qué se descartó |
| --- | --- | --- |
| CA duplicada con el mismo nombre en el almacén | Se listaron las CA instaladas | Hay dos, pero Windows elige la correcta por el identificador de clave (`CERT_TRUST_HAS_KEY_MATCH_ISSUER`) |
| Falta la lista de revocación | Se generó una CRL con OpenSSL y se instaló | Windows no la consulta sin punto de distribución en el certificado |
| Falta el punto de distribución | Se reemitió el certificado con URL `http://` y luego `file://` | Windows exige descargarla por HTTP; se restauró el certificado original |
| Tolerar solo el fallo de revocación en el validador | `aAccepted := Reasons = [CertRevFailed]` | La aplicación nunca tuvo ese fallo: el diagnóstico venía de `certutil`, que sí revisa revocación |

**El error de método.** Se diagnosticó con `certutil -verify`, que revisa revocación, y se
asumió que la aplicación hacía lo mismo. Lo que resolvió el caso fue medir con una
herramienta que se comporta como la aplicación —`curl` de Windows con `--ssl-no-revoke`— y
leer en la RTL cuándo se llama al validador.

---

## Producción

Si el servidor se publica mediante un túnel de Cloudflare, los clientes reciben el
certificado público de Cloudflare y la CA propia solo queda entre el túnel y el servidor.
El validador sigue siendo necesario por el comportamiento descrito arriba, que no depende
de qué certificado sea.
