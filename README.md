# Sistema de cotizaciones de Anovo

Trabajo Final de Graduación (TFG) del Bachillerato en Ingeniería Informática de la Universidad Estatal a Distancia (UNED), modalidad Proyecto, II semestre 2026.

**Desarrollo de un sistema multiplataforma de gestión de cotizaciones para optimizar el proceso comercial de Anovo**

Autor: Marcos Vinicio Segura Alfaro · Empresa patrocinadora: Anovo MS SA

> **Uso restringido.** Este repositorio no es de código abierto. Su contenido es propiedad de Anovo MS SA y solo puede consultarse con fines académicos. Las condiciones están en [LICENCIA.md](LICENCIA.md).

## Qué contiene

El sistema reemplaza el proceso manual de cotización de Anovo. Tiene tres partes:

1. **Aplicación móvil Android:** el asesor registra en la visita las solicitudes del cliente, con croquis, fotografías y firma. Funciona sin conexión y sincroniza al volver a tenerla.
2. **Servidor REST:** centraliza los datos en la base Firebird y aplica los permisos de cada perfil.
3. **Aplicación de escritorio Windows:** en la oficina se administran los catálogos, se arman y aprueban las cotizaciones y se consultan los reportes.

| Carpeta | Contenido |
|---|---|
| `AppMovil/` | Aplicación Android (B4A, SQLite) |
| `Backend/` | Servidor REST (Delphi 10.4, DelphiMVCFramework 3.5) |
| `Desktop/` | Aplicación de escritorio (Delphi 10.4, VCL) |
| `Db/` | Esquema, migraciones y datos de prueba de Firebird 4.0 |
| `Tests/` | Pruebas del servidor (DUnitX) |
| `Instalador/` | Script de Inno Setup de los instaladores |
| `Compilaciones/` | Servidor y escritorio ya compilados, en 32 y 64 bits, con configuración de demostración |
| `Instaladores/` | Instalador del servidor con la base en cero y el de la aplicación de escritorio |
| `Manual/` | Manual de usuario en PDF |
| `Video/` | Vídeo de presentación del sistema |

## Instalación básica

**Requisitos:** Windows 10 u 11 (se recomienda de 64 bits), permisos de administrador y el puerto HTTPS libre (443 por defecto).

### 1. Servidor

1. Descargue y ejecute como administrador `Instaladores/Anovo-Servidor-1.0.0-base-en-cero.exe`.
2. En **Servidor de Anovo**, deje el nombre del equipo y el puerto 443, o escriba otro puerto libre (por ejemplo 8443).
3. En **Base de datos**, escriba una clave para el administrador de Firebird (SYSDBA) y guárdela: hace falta para respaldar y restaurar la base. Si Firebird ya está instalado, escriba la clave que tiene.
4. En **Cotizaciones**, deje 1 como primer número, o escriba el número con que debe seguir la numeración.
5. Al terminar, marque **Abrir el servidor ahora**. La primera vez, como la base no tiene cuentas, el servidor pide los datos para crear el administrador.

El instalador se encarga de Firebird 4.0.6, de la base, del certificado HTTPS, de las claves y de la regla del firewall. También programa el servidor para que arranque con Windows.

### 2. Aplicación de escritorio

1. Con el servidor encendido, ejecute como administrador `Instaladores/Anovo-Escritorio-1.0.0.exe`, en el mismo equipo o en otro de la red.
2. Escriba el mismo nombre de servidor y puerto del paso anterior. El instalador trae el certificado del servidor y lo instala en Windows.
3. Abra **Anovo** desde el escritorio o el menú Inicio y entre con el administrador creado en el servidor.

### 3. Primeros pasos

Con el administrador se crean las cuentas de las demás personas usuarias y se revisan los catálogos. Después ya se pueden registrar clientes, solicitudes y cotizaciones. La base viene sin cuentas ni clientes: solo trae los roles, los permisos y los catálogos.

### Sin instalar

Para correr las compilaciones directamente, sin los instaladores, los pasos están en [Compilaciones/LEEME.txt](Compilaciones/LEEME.txt).

## Manual de usuario

El uso de cada pantalla, de la aplicación móvil y de la de escritorio, se explica en el [manual de usuario](Manual/Manual%20de%20usuario%20-%20Sistema%20de%20cotizaciones%20Anovo.pdf).

## Licencia

Todos los derechos reservados. Consulte [LICENCIA.md](LICENCIA.md).
