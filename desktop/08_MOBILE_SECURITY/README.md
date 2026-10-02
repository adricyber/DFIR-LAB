# 08 Mobile Security

MobSF analiza APK/IPA de prueba.

Flujo: hash -> static analysis -> permisos/componentes/secretos -> dynamic analysis en dispositivo/emulador de laboratorio -> tráfico -> correlación.


## Android Studio + Android Emulator

**Android Studio** incluye el **Android Emulator**, que permite crear dispositivos Android virtuales para ejecutar y probar aplicaciones sin utilizar un teléfono físico. Se utilizará como complemento de MobSF para pruebas dinámicas y para comprobar aplicaciones web desde una interfaz móvil.

### Usos en DFIR-LAB

1. **Pruebas de APK**
   - Instalar APKs de laboratorio.
   - Observar permisos y comportamiento.
   - Ejecutar la aplicación.
   - Recopilar logs y evidencias.
   - Complementar el análisis estático de MobSF.

2. **Pruebas de aplicaciones web desde interfaz móvil**
   - Abrir la web desde Chrome u otro navegador dentro del Android virtual.
   - Probar diferentes tamaños de pantalla y versiones de Android.
   - Validar login, navegación y flujos móviles.
   - Observar JavaScript, recursos y comportamiento de la aplicación.
   - Interceptar tráfico del laboratorio con mitmproxy/ZAP cuando corresponda.

### Requisitos

Android Studio + Emulator requiere más recursos que las herramientas CLI. La documentación oficial indica como mínimo 16 GB de RAM para Studio + Emulator y virtualización Intel VT-x o AMD-V habilitada. Se recomiendan 32 GB de RAM y SSD para un entorno cómodo.

### Instalación

Descarga oficial:

https://developer.android.com/studio

En Ubuntu 64-bit, Android Developers documenta la instalación mediante el paquete oficial de Linux y el Setup Wizard. Después del primer inicio:

1. Completar el **Setup Wizard**.
2. Abrir **SDK Manager**.
3. Instalar Android SDK Platform y una o más System Images.
4. Abrir **Device Manager**.
5. Crear un dispositivo virtual, por ejemplo un Pixel.
6. Seleccionar la versión de Android/API que se quiera probar.
7. Iniciar el emulador.

### Instalar un APK

Con el emulador iniciado:

```bash
adb devices
adb install ./aplicacion-laboratorio.apk
```

También se puede arrastrar el APK a la ventana del emulador cuando la versión configurada lo permita.

### Flujo recomendado

```text
APK
 ↓
SHA-256
 ↓
MobSF — análisis estático
 ↓
Android Emulator
 ↓
Ejecución controlada
 ↓
ADB / Logcat
 ↓
mitmproxy / ZAP
 ↓
PCAP / Logs
 ↓
Correlación DFIR
 ↓
Reporte
```

### Seguridad del entorno

Utilizar únicamente APKs propios, de laboratorio o expresamente autorizados. Para aplicaciones bancarias, utilizar versiones de prueba/sandbox y datos ficticios.

El emulador forma parte del entorno controlado de validación; no debe utilizarse para acceder a cuentas reales o datos reales del banco.
