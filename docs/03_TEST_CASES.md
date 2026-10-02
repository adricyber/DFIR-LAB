# Casos de prueba

| ID | Escenario | Control |
|---|---|---|
| WEB-001 | baseline legítimo | WAF/antifraude |
| WEB-002 | cabeceras anómalas | WAF/F5 |
| WEB-003 | automatización controlada | WAF/antifraude |
| WEB-004 | enumeración autorizada | WAF/F5 |
| WEB-005 | origen VPN | antifraude |
| WEB-006 | origen proxy | antifraude |
| WEB-007 | origen TOR | antifraude |
| WEB-008 | User-Agent alterado | WAF/antifraude |
| WEB-009 | emulación de dispositivo | antifraude |
| MOB-001 | APK de prueba | MobSF |
| NET-001 | PCAP conocido | Zeek/Wireshark |
| DFIR-001 | imagen de disco | TSK/Autopsy |
| DFIR-002 | memory dump | Volatility |
| WIN-001 | EVTX | Hayabusa |
| IR-001 | endpoint controlado | Velociraptor |

Cada caso: autorización, precondiciones, pasos, esperado, observado, evidencia y criterio.
