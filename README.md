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

## Componentes

- Disk: Sleuth Kit, Autopsy, TestDisk/PhotoRec, ExifTool.
- Memory: Volatility 3.
- Timeline: Plaso y Timesketch.
- Endpoint: Velociraptor y Hayabusa.
- Network: Wireshark/tshark, Zeek y Arkime.
- Malware: YARA y FLOSS.
- Web: OWASP ZAP, mitmproxy, ffuf y Nuclei.
- Mobile: MobSF.
- Access simulation: Tor, WireGuard y proxychains4.

## Entregables

Arquitectura, inventario, casos de prueba, matriz de controles, procedimiento, informes, evidencias, plan de mejoras y metodología/checklist de certificación.

> Uso exclusivamente autorizado. Los escenarios de evasión, automatización, TOR/VPN/proxy y manipulación de tráfico deben ejecutarse solamente contra infraestructura de laboratorio o activos expresamente aprobados.
