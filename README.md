# DFIR-LAB — Digital Forensics & Security Validation Laboratory

Laboratorio Ubuntu para **DFIR, análisis forense digital y validación controlada de controles de seguridad** de canales web, móviles y de acceso digital.

## Objetivo

Validar de forma reproducible WAF, F5 BIG-IP, Cisco FMC/FTD, antifraude, autenticación y monitoreo/SIEM frente a escenarios autorizados de TOR, VPN, proxy, cabeceras HTTP, automatización, emulación de dispositivos y otros vectores de riesgo.

## Instalación

```bash
git clone https://github.com/adricyber/DFIR-LAB.git
cd DFIR-LAB
sudo bash install_lab.sh
```

El instalador configura `America/Caracas`, NTP, dependencias y herramientas, y crea el workspace en el Escritorio. No modifica BECA-AntiPhishing ni elimina paquetes arbitrarios del sistema.

## Escritorio

```
DFIR-LAB/
├── 01_DISK_FORENSICS/
├── 02_MEMORY_FORENSICS/
├── 03_TIMELINE_DFIR/
├── 04_ENDPOINT_IR/
├── 05_NETWORK_FORENSICS/
├── 06_MALWARE_ANALYSIS/
├── 07_WEB_SECURITY/
├── 08_MOBILE_SECURITY/
├── 09_ACCESS_SIMULATION/
├── 10_EVIDENCE/
├── 11_CASES/
├── 12_REPORTS/
└── 13_DOCUMENTATION/
```

## Herramientas del laboratorio

La siguiente tabla resume **qué hace cada herramienta principal que instala o prepara DFIR-LAB**, para qué se utiliza dentro del laboratorio y cómo se ejecuta.

| Área | Herramienta | ¿Qué hace? | Uso dentro de DFIR-LAB | Acceso |
|---|---|---|---|---|
| **Disk Forensics** | **Sleuth Kit** | Analiza imágenes de disco y sistemas de archivos sin modificar la evidencia original. | Investigación de discos, particiones, archivos borrados, metadatos y artefactos. | CLI |
| **Disk Forensics** | **TestDisk** | Recupera particiones y ayuda a diagnosticar problemas de discos. | Recuperación controlada de particiones y análisis de medios. | CLI |
| **Disk Forensics** | **PhotoRec** | Recupera archivos mediante file carving. | Recuperación de archivos cuando no existe información suficiente del sistema de archivos. | CLI |
| **Disk Forensics** | **Foremost** | Realiza recuperación de archivos mediante file carving. | Recuperación complementaria de archivos desde imágenes o medios. | CLI |
| **Disk Forensics** | **ExifTool** | Lee y analiza metadatos de archivos, especialmente imágenes y documentos. | Investigación de metadatos y validación de evidencias. | CLI |
| **Memory Forensics** | **Volatility 3** | Analiza dumps de memoria RAM. | Procesos, conexiones, DLL, handles, malware y otros artefactos de memoria. | CLI / Python |
| **Timeline DFIR** | **Plaso / log2timeline** | Extrae artefactos temporales y construye super timelines. | Correlación temporal de eventos provenientes de múltiples fuentes. | CLI |
| **Timeline DFIR** | **psort** | Procesa, filtra y exporta timelines generadas por Plaso. | Preparación de timelines para análisis y reportes. | CLI |
| **Timeline DFIR** | **Timesketch** | Plataforma para explorar y correlacionar timelines de investigación. | Análisis visual y colaborativo de líneas de tiempo. | Docker / Web |
| **Endpoint IR** | **Velociraptor** | Plataforma de visibilidad, adquisición y respuesta sobre endpoints mediante VQL. | Triage, recolección de artefactos y respuesta a incidentes. | CLI / Web |
| **Endpoint IR** | **Hayabusa** | Analiza Windows Event Logs usando reglas Sigma y genera resultados orientados a threat hunting. | Investigación de EVTX, detección y creación de timelines. | CLI |
| **Network Forensics** | **Wireshark** | Analizador gráfico de tráfico de red y protocolos. | Investigación detallada de PCAP y sesiones de red. | GUI |
| **Network Forensics** | **TShark** | Versión CLI de Wireshark. | Automatización y análisis de PCAP desde terminal. | CLI |
| **Network Forensics** | **Tcpdump** | Captura y filtra tráfico de red. | Capturas controladas y adquisición de evidencia de red. | CLI |
| **Network Forensics** | **Zeek** | Genera telemetría de red a partir del tráfico observado. | HTTP, DNS, TLS, conexiones, archivos y otros logs de red. | CLI |
| **Malware Analysis** | **YARA** | Identifica archivos mediante reglas basadas en patrones. | Detección y clasificación de muestras y artefactos sospechosos. | CLI |
| **Malware Analysis** | **FLOSS** | Extrae strings estáticas y ofuscadas de ejecutables. | Análisis inicial de malware y descubrimiento de URLs, comandos y cadenas ocultas. | CLI |
| **Web Security** | **OWASP ZAP** | Proxy de seguridad para analizar aplicaciones web. | Validación controlada de aplicaciones web y controles WAF. | GUI / CLI |
| **Web Security** | **mitmproxy** | Proxy HTTP/HTTPS interactivo y programable. | Inspección y modificación controlada de tráfico HTTP/HTTPS. | CLI / Web |
| **Web Security** | **ffuf** | Herramienta de fuzzing y descubrimiento de recursos web. | Enumeración controlada de rutas, parámetros y endpoints autorizados. | CLI |
| **Web Security** | **Nuclei** | Motor de escaneo basado en templates. | Validaciones repetibles de seguridad sobre objetivos autorizados. | CLI |
| **Mobile Security** | **MobSF** | Framework para análisis de seguridad de aplicaciones móviles. | Análisis estático y dinámico de APK/IPA de laboratorio. | Docker / Web |
| **Access Simulation** | **Tor** | Red de anonimización que permite generar tráfico desde una salida Tor. | Validación autorizada de controles frente a tráfico de origen Tor. | Servicio |
| **Access Simulation** | **WireGuard** | VPN moderna basada en túneles cifrados. | Simulación de accesos desde redes/VPN controladas. | CLI |
| **Access Simulation** | **proxychains4** | Fuerza aplicaciones compatibles a utilizar proxies configurados. | Pruebas controladas de aplicaciones detrás de un proxy. | CLI |
| **Platform** | **Docker** | Ejecuta servicios y herramientas aisladas mediante contenedores. | Hospedar MobSF y Timesketch sin instalar todas sus dependencias directamente en Ubuntu. | Servicio |
| **Evidence** | **hash_evidence.sh** | Genera hashes SHA-256 y SHA-512 de evidencias. | Verificación de integridad y trazabilidad de archivos de investigación. | Script |

### Servicios Docker preparados

DFIR-LAB prepara dos servicios que **no se inician automáticamente** para evitar consumo innecesario de recursos:

| Servicio | Puerto local | Función |
|---|---:|---|
| **MobSF** | `8000` | Análisis de seguridad de aplicaciones móviles |
| **Timesketch** | `5000` | Análisis y correlación de timelines DFIR |

Para iniciarlos:

```bash
cd /opt/dfir-lab
sudo docker compose up -d
```

Comprobar:

```bash
sudo docker compose ps
```

Detener:

```bash
sudo docker compose down
```

### Herramientas base del sistema

El instalador también incorpora utilidades de soporte:

| Herramienta | Función |
|---|---|
| **Git** | Clonar y actualizar el repositorio |
| **curl / wget** | Descarga y comunicación HTTP/HTTPS |
| **jq** | Procesamiento de JSON desde terminal |
| **unzip / 7zip** | Extracción de archivos comprimidos |
| **file / libmagic** | Identificación del tipo real de archivo |
| **tree** | Visualización de estructuras de directorios |
| **ripgrep** | Búsqueda rápida dentro de archivos |
| **sqlite3** | Consulta de bases de datos SQLite |
| **tmux** | Sesiones persistentes de terminal |
| **rsync** | Copia y sincronización de archivos |
| **Python 3 + venv + pip** | Ejecución y aislamiento de herramientas Python |
| **build-essential / python3-dev** | Dependencias para compilar determinados paquetes |
| **ca-certificates** | Validación de certificados TLS |
| **Docker Compose** | Administración de servicios del laboratorio |

### Herramientas complementarias no instaladas automáticamente

**Autopsy** y **Arkime** están documentados como herramientas complementarias, pero no se presentan como instaladas automáticamente por `install_lab.sh`. Esto mantiene el sistema base más limpio y evita instalar componentes pesados cuando no sean necesarios.

## Entregables

Arquitectura, inventario, casos de prueba, matriz de controles, procedimiento, informes, evidencias, plan de mejoras y metodología/checklist de certificación.

> Uso exclusivamente autorizado. Los escenarios de evasión, automatización, TOR/VPN/proxy y manipulación de tráfico deben ejecutarse solamente contra infraestructura de laboratorio o activos expresamente aprobados.
