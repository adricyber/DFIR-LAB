#!/usr/bin/env bash
set -Eeuo pipefail
[[ $EUID -eq 0 ]] || { echo "Uso: sudo bash install_lab.sh"; exit 1; }
USER_NAME="${SUDO_USER:-$USER}"
USER_HOME="$(getent passwd "$USER_NAME" | cut -d: -f6)"
ROOT=/opt/dfir-lab
DESKTOP="$USER_HOME/Desktop/DFIR-LAB"
BIN="$ROOT/bin"
VENV="$ROOT/venv"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[1/7] Hora de Caracas + NTP"
timedatectl set-timezone America/Caracas
timedatectl set-ntp true || true

echo "[2/7] Dependencias mínimas"
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
 ca-certificates curl wget git jq unzip p7zip-full file tree ripgrep sqlite3 tmux rsync \
 python3 python3-venv python3-pip python3-dev build-essential libmagic1 \
 libimage-exiftool-perl yara sleuthkit testdisk foremost \
 tshark wireshark tcpdump zeek tor proxychains4 wireguard-tools docker.io docker-compose-v2

echo "[3/7] Workspace"
mkdir -p "$DESKTOP"/{01_DISK_FORENSICS,02_MEMORY_FORENSICS,03_TIMELINE_DFIR,04_ENDPOINT_IR,05_NETWORK_FORENSICS,06_MALWARE_ANALYSIS,07_WEB_SECURITY,08_MOBILE_SECURITY,09_ACCESS_SIMULATION,10_EVIDENCE,11_CASES,12_REPORTS,13_DOCUMENTATION}
mkdir -p "$DESKTOP"/{samples,pcaps,memdumps,disk-images,exports}
mkdir -p "$ROOT"/{bin,downloads}

echo "[4/7] Python DFIR"
python3 -m venv "$VENV"
"$VENV/bin/pip" install --upgrade pip wheel setuptools
"$VENV/bin/pip" install volatility3 plaso floss
ln -sf "$VENV/bin/vol" "$BIN/vol"
ln -sf "$VENV/bin/log2timeline.py" "$BIN/log2timeline.py"
ln -sf "$VENV/bin/psort.py" "$BIN/psort.py"
ln -sf "$VENV/bin/floss" "$BIN/floss"

echo "[5/7] mitmproxy aislado"
python3 -m venv "$ROOT/mitmproxy-venv"
"$ROOT/mitmproxy-venv/bin/pip" install --upgrade pip
"$ROOT/mitmproxy-venv/bin/pip" install mitmproxy
ln -sf "$ROOT/mitmproxy-venv/bin/mitmproxy" "$BIN/mitmproxy"
ln -sf "$ROOT/mitmproxy-venv/bin/mitmdump" "$BIN/mitmdump"

install_release() {
 local repo="$1" regex="$2" name="$3"
 local url
 url="$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" | jq -r --arg r "$regex" '.assets[] | select(.name|test($r)) | .browser_download_url' | head -n1)"
 [[ -n "$url" && "$url" != "null" ]] || return 0
 curl -fL --retry 3 "$url" -o "$ROOT/downloads/$name"
 echo "$url" > "$ROOT/downloads/$name.url"
}

echo "[6/7] Binarios DFIR"
install_release Velocidex/velociraptor 'linux-amd64$' velociraptor
[[ -f "$ROOT/downloads/velociraptor" ]] && install -m 0755 "$ROOT/downloads/velociraptor" "$BIN/velociraptor"

install_release Yamato-Security/hayabusa 'linux-x64.*\.(zip|tar\.gz)$' hayabusa.pkg
if [[ -f "$ROOT/downloads/hayabusa.pkg" ]]; then
 mkdir -p "$ROOT/downloads/hayabusa"
 case "$(cat "$ROOT/downloads/hayabusa.pkg.url")" in
  *.zip) unzip -oq "$ROOT/downloads/hayabusa.pkg" -d "$ROOT/downloads/hayabusa" ;;
  *) tar -xf "$ROOT/downloads/hayabusa.pkg" -C "$ROOT/downloads/hayabusa" ;;
 esac
 H="$(find "$ROOT/downloads/hayabusa" -type f -name hayabusa -print -quit || true)"
 [[ -n "$H" ]] && install -m 0755 "$H" "$BIN/hayabusa"
fi

install_release ffuf/ffuf 'linux_amd64.*\.tar\.gz$' ffuf.tar.gz
if [[ -f "$ROOT/downloads/ffuf.tar.gz" ]]; then
 mkdir -p "$ROOT/downloads/ffuf"
 tar -xzf "$ROOT/downloads/ffuf.tar.gz" -C "$ROOT/downloads/ffuf"
 F="$(find "$ROOT/downloads/ffuf" -type f -name ffuf -print -quit || true)"
 [[ -n "$F" ]] && install -m 0755 "$F" "$BIN/ffuf"
fi


install_release zaproxy/zaproxy '_Linux\\.tar\\.gz (no levanta servicios automáticamente)"
systemctl enable docker
cat > "$ROOT/docker-compose.yml" <<'YAML'
services:
  mobsf:
    image: opensecurity/mobile-security-framework-mobsf:latest
    container_name: dfir-mobsf
    ports: ["127.0.0.1:8000:8000"]
    restart: unless-stopped
  timesketch:
    image: ghcr.io/google/timesketch/timesketch:latest
    container_name: dfir-timesketch
    ports: ["127.0.0.1:5000:5000"]
    restart: unless-stopped
YAML

rsync -a "$SCRIPT_DIR/desktop/" "$DESKTOP/"
mkdir -p "$DESKTOP/13_DOCUMENTATION"
install -m 0644 "$SCRIPT_DIR/assets/DFIR-LAB-wallpaper.svg" "$DESKTOP/13_DOCUMENTATION/DFIR-LAB-wallpaper.svg"
if command -v gsettings >/dev/null 2>&1 && [[ -n "${XDG_CURRENT_DESKTOP:-}" ]]; then
  sudo -u "$USER_NAME" gsettings set org.gnome.desktop.background picture-uri "file://$DESKTOP/13_DOCUMENTATION/DFIR-LAB-wallpaper.svg" 2>/dev/null || true
  sudo -u "$USER_NAME" gsettings set org.gnome.desktop.background picture-uri-dark "file://$DESKTOP/13_DOCUMENTATION/DFIR-LAB-wallpaper.svg" 2>/dev/null || true
fi
rsync -a "$SCRIPT_DIR/docs/" "$DESKTOP/13_DOCUMENTATION/"

cat > "$DESKTOP/10_EVIDENCE/hash_evidence.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
T="${1:?Uso: hash_evidence.sh <archivo|directorio>}"
if [[ -f "$T" ]]; then sha256sum "$T"; sha512sum "$T"
elif [[ -d "$T" ]]; then find "$T" -type f -print0 | sort -z | xargs -0 sha256sum
else echo "No existe: $T" >&2; exit 1; fi
EOF
chmod +x "$DESKTOP/10_EVIDENCE/hash_evidence.sh"

cat > "$DESKTOP/13_DOCUMENTATION/ENVIRONMENT.md" <<EOF
# Environment
Usuario: $USER_NAME
Workspace: $DESKTOP
Timezone: $(timedatectl show -p Timezone --value)
Tools: $BIN
Python DFIR: $VENV
EOF

chown -R "$USER_NAME:$USER_NAME" "$DESKTOP"
echo "DFIR-LAB listo en $DESKTOP"
 zap.tar.gz
if [[ -f "$ROOT/downloads/zap.tar.gz" ]]; then
 mkdir -p "$ROOT/zap"
 tar -xzf "$ROOT/downloads/zap.tar.gz" --strip-components=1 -C "$ROOT/zap"
 [[ -x "$ROOT/zap/zap.sh" ]] && ln -sf "$ROOT/zap/zap.sh" "$BIN/zap.sh"
fi

install_release projectdiscovery/nuclei 'nuclei_.*_linux_amd64\\.zip (no levanta servicios automáticamente)"
systemctl enable docker
cat > "$ROOT/docker-compose.yml" <<'YAML'
services:
  mobsf:
    image: opensecurity/mobile-security-framework-mobsf:latest
    container_name: dfir-mobsf
    ports: ["127.0.0.1:8000:8000"]
    restart: unless-stopped
  timesketch:
    image: ghcr.io/google/timesketch/timesketch:latest
    container_name: dfir-timesketch
    ports: ["127.0.0.1:5000:5000"]
    restart: unless-stopped
YAML

rsync -a "$SCRIPT_DIR/desktop/" "$DESKTOP/"
rsync -a "$SCRIPT_DIR/docs/" "$DESKTOP/13_DOCUMENTATION/"

cat > "$DESKTOP/10_EVIDENCE/hash_evidence.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
T="${1:?Uso: hash_evidence.sh <archivo|directorio>}"
if [[ -f "$T" ]]; then sha256sum "$T"; sha512sum "$T"
elif [[ -d "$T" ]]; then find "$T" -type f -print0 | sort -z | xargs -0 sha256sum
else echo "No existe: $T" >&2; exit 1; fi
EOF
chmod +x "$DESKTOP/10_EVIDENCE/hash_evidence.sh"

cat > "$DESKTOP/13_DOCUMENTATION/ENVIRONMENT.md" <<EOF
# Environment
Usuario: $USER_NAME
Workspace: $DESKTOP
Timezone: $(timedatectl show -p Timezone --value)
Tools: $BIN
Python DFIR: $VENV
EOF

chown -R "$USER_NAME:$USER_NAME" "$DESKTOP"
echo "DFIR-LAB listo en $DESKTOP"
 nuclei.zip
if [[ -f "$ROOT/downloads/nuclei.zip" ]]; then
 mkdir -p "$ROOT/downloads/nuclei"
 unzip -oq "$ROOT/downloads/nuclei.zip" -d "$ROOT/downloads/nuclei"
 N="$(find "$ROOT/downloads/nuclei" -type f -name nuclei -print -quit || true)"
 [[ -n "$N" ]] && install -m 0755 "$N" "$BIN/nuclei"
fi

echo "[7/7] ZAP/Nuclei + Docker preparado (no levanta servicios automáticamente)"
systemctl enable docker
cat > "$ROOT/docker-compose.yml" <<'YAML'
services:
  mobsf:
    image: opensecurity/mobile-security-framework-mobsf:latest
    container_name: dfir-mobsf
    ports: ["127.0.0.1:8000:8000"]
    restart: unless-stopped
  timesketch:
    image: ghcr.io/google/timesketch/timesketch:latest
    container_name: dfir-timesketch
    ports: ["127.0.0.1:5000:5000"]
    restart: unless-stopped
YAML

rsync -a "$SCRIPT_DIR/desktop/" "$DESKTOP/"
rsync -a "$SCRIPT_DIR/docs/" "$DESKTOP/13_DOCUMENTATION/"

cat > "$DESKTOP/10_EVIDENCE/hash_evidence.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
T="${1:?Uso: hash_evidence.sh <archivo|directorio>}"
if [[ -f "$T" ]]; then sha256sum "$T"; sha512sum "$T"
elif [[ -d "$T" ]]; then find "$T" -type f -print0 | sort -z | xargs -0 sha256sum
else echo "No existe: $T" >&2; exit 1; fi
EOF
chmod +x "$DESKTOP/10_EVIDENCE/hash_evidence.sh"

cat > "$DESKTOP/13_DOCUMENTATION/ENVIRONMENT.md" <<EOF
# Environment
Usuario: $USER_NAME
Workspace: $DESKTOP
Timezone: $(timedatectl show -p Timezone --value)
Tools: $BIN
Python DFIR: $VENV
EOF

chown -R "$USER_NAME:$USER_NAME" "$DESKTOP"
echo "DFIR-LAB listo en $DESKTOP"
