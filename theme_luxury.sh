#!/bin/bash

# ============================================================
#   Pterodactyl Luxury Theme Installer
#   Gabungan: Enigma + PyroFish + Billing Style
#   Support: v1.12.x
#   By: Custom Script Generator
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

PANEL_DIR="/var/www/pterodactyl"
BACKUP_DIR="/var/www/pterodactyl-theme-backup"
THEME_DIR="$PANEL_DIR/public/themes/luxury"
CSS_FILE="$PANEL_DIR/public/themes/luxury/luxury.css"
JS_FILE="$PANEL_DIR/public/themes/luxury/luxury.js"
BLADE_FILE="$PANEL_DIR/resources/views/layouts/master.blade.php"
VERSION="1.0.0"

# ============================================================
# BANNER
# ============================================================
print_banner() {
    clear
    echo -e "${PURPLE}"
    echo "  ██╗     ██╗   ██╗██╗  ██╗██╗   ██╗██████╗ ██╗   ██╗"
    echo "  ██║     ██║   ██║╚██╗██╔╝██║   ██║██╔══██╗╚██╗ ██╔╝"
    echo "  ██║     ██║   ██║ ╚███╔╝ ██║   ██║██████╔╝ ╚████╔╝ "
    echo "  ██║     ██║   ██║ ██╔██╗ ██║   ██║██╔══██╗  ╚██╔╝  "
    echo "  ███████╗╚██████╔╝██╔╝ ██╗╚██████╔╝██║  ██║   ██║   "
    echo "  ╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝  "
    echo -e "${NC}"
    echo -e "${CYAN}  ╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║   ${BOLD}Pterodactyl Luxury Theme Installer v$VERSION${NC}${CYAN}    ║${NC}"
    echo -e "${CYAN}  ║   Enigma + PyroFish + Billing Fusion Theme       ║${NC}"
    echo -e "${CYAN}  ║   Support: Pterodactyl v1.12.x                   ║${NC}"
    echo -e "${CYAN}  ╚══════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ============================================================
# HELPERS
# ============================================================
info()    { echo -e "${CYAN}[INFO]${NC}  $1"; }
success() { echo -e "${GREEN}[OK]${NC}    $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }
step()    { echo -e "\n${PURPLE}━━━ $1 ━━━${NC}"; }

check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "Script ini harus dijalankan sebagai root!"
        echo -e "  Jalankan: ${YELLOW}sudo bash pterodactyl-theme-installer.sh${NC}"
        exit 1
    fi
}

check_panel() {
    if [ ! -d "$PANEL_DIR" ]; then
        error "Pterodactyl Panel tidak ditemukan di $PANEL_DIR"
        error "Pastikan panel sudah terinstall dengan benar."
        exit 1
    fi
    if [ ! -f "$BLADE_FILE" ]; then
        error "File master.blade.php tidak ditemukan!"
        error "Path: $BLADE_FILE"
        exit 1
    fi
}

# ============================================================
# MENU UTAMA
# ============================================================
show_menu() {
    echo -e "${BOLD}Pilih aksi:${NC}"
    echo -e "  ${GREEN}[1]${NC} Install / Update Luxury Theme"
    echo -e "  ${YELLOW}[2]${NC} Uninstall / Rollback Tema"
    echo -e "  ${RED}[3]${NC} Keluar"
    echo ""
    read -rp "$(echo -e "${CYAN}Pilihan [1-3]: ${NC}")" CHOICE
}

# ============================================================
# BACKUP
# ============================================================
do_backup() {
    step "Membuat Backup"
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_PATH="$BACKUP_DIR/$TIMESTAMP"

    mkdir -p "$BACKUP_PATH"

    # Backup blade master
    if [ -f "$BLADE_FILE" ]; then
        cp "$BLADE_FILE" "$BACKUP_PATH/master.blade.php.bak"
        success "Backup master.blade.php → $BACKUP_PATH"
    fi

    # Backup tema lama jika ada
    if [ -d "$THEME_DIR" ]; then
        cp -r "$THEME_DIR" "$BACKUP_PATH/theme_old"
        success "Backup tema lama → $BACKUP_PATH/theme_old"
    fi

    # Simpan path backup terbaru
    echo "$BACKUP_PATH" > /tmp/ptero_last_backup

    success "Backup selesai! Disimpan di: $BACKUP_PATH"
}

# ============================================================
# GENERATE CSS LUXURY THEME
# ============================================================
generate_css() {
    cat > "$CSS_FILE" << 'CSSEOF'
/* ============================================================
   LUXURY THEME - Enigma + PyroFish + Billing Fusion
   Pterodactyl Panel v1.12.x
   ============================================================ */

@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=Space+Grotesk:wght@400;500;600&display=swap');

/* ── ROOT VARIABLES ── */
:root {
  --luxury-bg-primary:    #0a0a0f;
  --luxury-bg-secondary:  #0f0f1a;
  --luxury-bg-card:       #13131f;
  --luxury-bg-hover:      #1a1a2e;
  --luxury-border:        #1e1e35;
  --luxury-border-glow:   rgba(139, 92, 246, 0.25);

  --luxury-accent:        #8b5cf6;
  --luxury-accent-2:      #06b6d4;
  --luxury-accent-gold:   #f59e0b;
  --luxury-accent-pink:   #ec4899;

  --luxury-text-primary:  #f1f0ff;
  --luxury-text-secondary:#a09ec0;
  --luxury-text-muted:    #5a5880;

  --luxury-success:       #10b981;
  --luxury-warning:       #f59e0b;
  --luxury-danger:        #ef4444;
  --luxury-info:          #06b6d4;

  --luxury-radius:        12px;
  --luxury-radius-lg:     18px;
  --luxury-shadow:        0 4px 24px rgba(0,0,0,0.5);
  --luxury-shadow-glow:   0 0 30px rgba(139, 92, 246, 0.15);
  --luxury-transition:    all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

/* ── GLOBAL RESET ── */
*, *::before, *::after { box-sizing: border-box; }

html, body {
  background: var(--luxury-bg-primary) !important;
  color: var(--luxury-text-primary) !important;
  font-family: 'Outfit', sans-serif !important;
  font-size: 15px;
  line-height: 1.6;
  -webkit-font-smoothing: antialiased;
}

/* Subtle noise texture overlay */
body::before {
  content: '';
  position: fixed;
  inset: 0;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.03'/%3E%3C/svg%3E");
  pointer-events: none;
  z-index: 0;
  opacity: 0.4;
}

/* ── SCROLLBAR ── */
::-webkit-scrollbar { width: 6px; height: 6px; }
::-webkit-scrollbar-track { background: var(--luxury-bg-primary); }
::-webkit-scrollbar-thumb {
  background: linear-gradient(180deg, var(--luxury-accent), var(--luxury-accent-2));
  border-radius: 99px;
}

/* ── SIDEBAR / NAVIGATION ── */
.sidebar, nav.sidebar, #app aside, .navigation-bar {
  background: linear-gradient(180deg, #0d0d1a 0%, #0a0a12 100%) !important;
  border-right: 1px solid var(--luxury-border) !important;
  box-shadow: 4px 0 30px rgba(0,0,0,0.4) !important;
  backdrop-filter: blur(20px);
}

/* Sidebar logo area */
.sidebar .logo, .sidebar-logo, nav .brand {
  padding: 24px 20px !important;
  border-bottom: 1px solid var(--luxury-border) !important;
  background: linear-gradient(135deg, rgba(139,92,246,0.08), rgba(6,182,212,0.05)) !important;
}

/* Sidebar nav items */
.sidebar a, .sidebar li a, nav a.nav-item {
  color: var(--luxury-text-secondary) !important;
  font-weight: 500 !important;
  font-size: 13.5px !important;
  letter-spacing: 0.01em;
  border-radius: var(--luxury-radius) !important;
  margin: 2px 8px !important;
  padding: 10px 14px !important;
  transition: var(--luxury-transition) !important;
  position: relative;
  overflow: hidden;
}

.sidebar a::before, nav a.nav-item::before {
  content: '';
  position: absolute;
  left: 0; top: 20%; bottom: 20%;
  width: 3px;
  background: linear-gradient(180deg, var(--luxury-accent), var(--luxury-accent-2));
  border-radius: 0 4px 4px 0;
  opacity: 0;
  transition: var(--luxury-transition);
}

.sidebar a:hover, nav a.nav-item:hover {
  background: rgba(139,92,246,0.1) !important;
  color: var(--luxury-text-primary) !important;
}

.sidebar a:hover::before, nav a.nav-item:hover::before { opacity: 1; }

.sidebar a.active, nav a.nav-item.active {
  background: linear-gradient(135deg, rgba(139,92,246,0.2), rgba(6,182,212,0.1)) !important;
  color: var(--luxury-text-primary) !important;
  box-shadow: inset 0 1px 0 rgba(255,255,255,0.05) !important;
}

.sidebar a.active::before, nav a.nav-item.active::before { opacity: 1; }

/* ── TOPBAR / HEADER ── */
.topbar, header.topbar, .app-bar {
  background: rgba(10,10,15,0.85) !important;
  border-bottom: 1px solid var(--luxury-border) !important;
  backdrop-filter: blur(20px) !important;
  -webkit-backdrop-filter: blur(20px) !important;
}

/* ── CARDS & PANELS ── */
.card, .box, .panel, .content-box,
[class*="ContentBox"], [class*="content-box"],
.bg-white, .bg-neutral-50, .bg-neutral-100 {
  background: var(--luxury-bg-card) !important;
  border: 1px solid var(--luxury-border) !important;
  border-radius: var(--luxury-radius-lg) !important;
  box-shadow: var(--luxury-shadow) !important;
  transition: var(--luxury-transition) !important;
}

.card:hover, .box:hover {
  border-color: var(--luxury-border-glow) !important;
  box-shadow: var(--luxury-shadow), var(--luxury-shadow-glow) !important;
  transform: translateY(-1px);
}

/* ── BUTTONS ── */
button, .btn, [class*="Button"] {
  font-family: 'Outfit', sans-serif !important;
  font-weight: 600 !important;
  letter-spacing: 0.02em !important;
  border-radius: var(--luxury-radius) !important;
  transition: var(--luxury-transition) !important;
  position: relative;
  overflow: hidden;
}

/* Primary button */
.btn-primary, button[type="submit"], .btn.is-primary,
[class*="Button--primary"] {
  background: linear-gradient(135deg, var(--luxury-accent), #7c3aed) !important;
  border: none !important;
  color: #fff !important;
  box-shadow: 0 4px 15px rgba(139,92,246,0.4) !important;
}

.btn-primary:hover, button[type="submit"]:hover {
  background: linear-gradient(135deg, #9d74f7, var(--luxury-accent)) !important;
  box-shadow: 0 6px 25px rgba(139,92,246,0.6) !important;
  transform: translateY(-1px) !important;
}

/* Success button */
.btn-success, [class*="Button--success"] {
  background: linear-gradient(135deg, var(--luxury-success), #059669) !important;
  border: none !important;
  box-shadow: 0 4px 15px rgba(16,185,129,0.3) !important;
}

/* Danger button */
.btn-danger, [class*="Button--danger"] {
  background: linear-gradient(135deg, var(--luxury-danger), #dc2626) !important;
  border: none !important;
  box-shadow: 0 4px 15px rgba(239,68,68,0.3) !important;
}

/* Secondary/ghost */
.btn-secondary, .btn-default, [class*="Button--secondary"] {
  background: transparent !important;
  border: 1px solid var(--luxury-border) !important;
  color: var(--luxury-text-secondary) !important;
}

.btn-secondary:hover {
  border-color: var(--luxury-accent) !important;
  color: var(--luxury-accent) !important;
}

/* Button shine effect */
button::after, .btn::after {
  content: '';
  position: absolute;
  top: -50%; left: -60%;
  width: 40%; height: 200%;
  background: rgba(255,255,255,0.08);
  transform: skewX(-20deg);
  transition: left 0.4s ease;
  pointer-events: none;
}
button:hover::after, .btn:hover::after { left: 130%; }

/* ── FORMS & INPUTS ── */
input, select, textarea,
[class*="Input"], [class*="input"] {
  background: rgba(15,15,26,0.8) !important;
  border: 1px solid var(--luxury-border) !important;
  border-radius: var(--luxury-radius) !important;
  color: var(--luxury-text-primary) !important;
  font-family: 'Outfit', sans-serif !important;
  font-size: 14px !important;
  transition: var(--luxury-transition) !important;
  padding: 10px 14px !important;
}

input:focus, select:focus, textarea:focus {
  border-color: var(--luxury-accent) !important;
  box-shadow: 0 0 0 3px rgba(139,92,246,0.15), 0 0 15px rgba(139,92,246,0.1) !important;
  outline: none !important;
  background: rgba(15,15,26,1) !important;
}

input::placeholder, textarea::placeholder {
  color: var(--luxury-text-muted) !important;
}

label, .label {
  color: var(--luxury-text-secondary) !important;
  font-size: 13px !important;
  font-weight: 500 !important;
  letter-spacing: 0.03em !important;
  text-transform: uppercase !important;
  margin-bottom: 6px !important;
}

/* ── TABLES ── */
table {
  border-collapse: separate !important;
  border-spacing: 0 4px !important;
  width: 100%;
}

thead tr th {
  background: rgba(139,92,246,0.08) !important;
  color: var(--luxury-text-secondary) !important;
  font-size: 11px !important;
  font-weight: 600 !important;
  letter-spacing: 0.08em !important;
  text-transform: uppercase !important;
  border-bottom: 1px solid var(--luxury-border) !important;
  padding: 12px 16px !important;
}

tbody tr {
  background: var(--luxury-bg-card) !important;
  border-radius: var(--luxury-radius) !important;
  transition: var(--luxury-transition) !important;
}

tbody tr:hover {
  background: var(--luxury-bg-hover) !important;
  box-shadow: 0 2px 12px rgba(139,92,246,0.1) !important;
}

tbody tr td {
  border-top: 1px solid transparent !important;
  border-bottom: 1px solid var(--luxury-border) !important;
  padding: 13px 16px !important;
  color: var(--luxury-text-primary) !important;
  font-size: 14px !important;
}

/* ── BADGES & STATUS ── */
.badge, [class*="Badge"], .tag {
  font-family: 'Space Grotesk', sans-serif !important;
  font-size: 11px !important;
  font-weight: 600 !important;
  letter-spacing: 0.04em !important;
  padding: 4px 10px !important;
  border-radius: 6px !important;
}

.badge-success, .badge-green, [class*="--success"] {
  background: rgba(16,185,129,0.12) !important;
  color: var(--luxury-success) !important;
  border: 1px solid rgba(16,185,129,0.2) !important;
}

.badge-danger, .badge-red, [class*="--danger"] {
  background: rgba(239,68,68,0.12) !important;
  color: var(--luxury-danger) !important;
  border: 1px solid rgba(239,68,68,0.2) !important;
}

.badge-warning, .badge-yellow, [class*="--warning"] {
  background: rgba(245,158,11,0.12) !important;
  color: var(--luxury-warning) !important;
  border: 1px solid rgba(245,158,11,0.2) !important;
}

.badge-info, .badge-blue, [class*="--info"] {
  background: rgba(6,182,212,0.12) !important;
  color: var(--luxury-accent-2) !important;
  border: 1px solid rgba(6,182,212,0.2) !important;
}

/* ── ALERTS ── */
.alert, [class*="Alert"] {
  border-radius: var(--luxury-radius) !important;
  border: none !important;
  border-left: 3px solid !important;
  backdrop-filter: blur(10px) !important;
}

.alert-success { background: rgba(16,185,129,0.08) !important; border-color: var(--luxury-success) !important; }
.alert-danger   { background: rgba(239,68,68,0.08)  !important; border-color: var(--luxury-danger)  !important; }
.alert-warning  { background: rgba(245,158,11,0.08) !important; border-color: var(--luxury-warning) !important; }
.alert-info     { background: rgba(6,182,212,0.08)  !important; border-color: var(--luxury-info)    !important; }

/* ── SERVER CARDS (Dashboard) ── */
[class*="ServerRow"], [class*="server-card"], .server-item {
  background: var(--luxury-bg-card) !important;
  border: 1px solid var(--luxury-border) !important;
  border-radius: var(--luxury-radius-lg) !important;
  transition: var(--luxury-transition) !important;
  position: relative;
  overflow: hidden;
}

[class*="ServerRow"]::before, .server-item::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 2px;
  background: linear-gradient(90deg, var(--luxury-accent), var(--luxury-accent-2));
  opacity: 0;
  transition: var(--luxury-transition);
}

[class*="ServerRow"]:hover, .server-item:hover {
  border-color: var(--luxury-border-glow) !important;
  box-shadow: var(--luxury-shadow-glow) !important;
  transform: translateY(-2px) !important;
}

[class*="ServerRow"]:hover::before, .server-item:hover::before { opacity: 1; }

/* ── STATS / RESOURCE BARS ── */
.progress, [class*="ProgressBar"], progress {
  background: rgba(255,255,255,0.05) !important;
  border-radius: 99px !important;
  height: 6px !important;
  overflow: hidden !important;
}

.progress-bar, [class*="ProgressBar__fill"] {
  background: linear-gradient(90deg, var(--luxury-accent), var(--luxury-accent-2)) !important;
  border-radius: 99px !important;
  box-shadow: 0 0 10px rgba(139,92,246,0.5) !important;
  transition: width 0.6s cubic-bezier(0.4, 0, 0.2, 1) !important;
}

/* ── MODAL / DIALOG ── */
.modal, [class*="Modal"], .dialog {
  background: var(--luxury-bg-secondary) !important;
  border: 1px solid var(--luxury-border) !important;
  border-radius: var(--luxury-radius-lg) !important;
  box-shadow: 0 25px 80px rgba(0,0,0,0.7), var(--luxury-shadow-glow) !important;
}

.modal-header, [class*="Modal__header"] {
  border-bottom: 1px solid var(--luxury-border) !important;
  padding: 20px 24px !important;
}

.modal-backdrop, .modal-overlay {
  background: rgba(0,0,0,0.75) !important;
  backdrop-filter: blur(8px) !important;
}

/* ── CONSOLE / TERMINAL ── */
.terminal, [class*="Console"], .xterm {
  background: #050508 !important;
  border-radius: var(--luxury-radius) !important;
  border: 1px solid var(--luxury-border) !important;
  font-family: 'JetBrains Mono', 'Fira Code', 'Cascadia Code', monospace !important;
  font-size: 13px !important;
}

/* ── TOOLTIPS ── */
[class*="Tooltip"], .tooltip .tooltip-inner {
  background: rgba(20,20,35,0.95) !important;
  border: 1px solid var(--luxury-border) !important;
  border-radius: 8px !important;
  color: var(--luxury-text-primary) !important;
  font-size: 12px !important;
  backdrop-filter: blur(12px) !important;
}

/* ── CODE ── */
code, pre {
  background: rgba(15,15,26,0.9) !important;
  border: 1px solid var(--luxury-border) !important;
  border-radius: 8px !important;
  color: var(--luxury-accent) !important;
  font-family: 'JetBrains Mono', monospace !important;
  font-size: 13px !important;
}

/* ── BILLING SECTION STYLES ── */
.billing-card, .invoice-card, .plan-card {
  background: var(--luxury-bg-card) !important;
  border: 1px solid var(--luxury-border) !important;
  border-radius: var(--luxury-radius-lg) !important;
  transition: var(--luxury-transition) !important;
}

.billing-card.featured, .plan-card.recommended {
  border-color: var(--luxury-accent) !important;
  box-shadow: 0 0 40px rgba(139,92,246,0.2) !important;
  position: relative;
}

.billing-card.featured::before {
  content: '★ POPULAR';
  position: absolute;
  top: -1px; right: 20px;
  background: linear-gradient(135deg, var(--luxury-accent), var(--luxury-accent-2));
  color: white;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.08em;
  padding: 4px 12px;
  border-radius: 0 0 8px 8px;
}

/* ── PAGE LOADING BAR ── */
#nprogress .bar {
  background: linear-gradient(90deg, var(--luxury-accent), var(--luxury-accent-2)) !important;
  height: 3px !important;
  box-shadow: 0 0 15px rgba(139,92,246,0.8) !important;
}

/* ── HEADINGS & TYPOGRAPHY ── */
h1, h2, h3, h4, h5, h6 {
  font-family: 'Outfit', sans-serif !important;
  color: var(--luxury-text-primary) !important;
  font-weight: 600 !important;
}

p, span, li, td, th { color: var(--luxury-text-primary); }

a {
  color: var(--luxury-accent) !important;
  text-decoration: none !important;
  transition: var(--luxury-transition) !important;
}
a:hover { color: var(--luxury-accent-2) !important; }

/* Muted text */
.text-muted, .text-neutral-400, .text-neutral-500 {
  color: var(--luxury-text-secondary) !important;
}

/* ── GRADIENT TEXT UTILITY ── */
.gradient-text {
  background: linear-gradient(135deg, var(--luxury-accent), var(--luxury-accent-2));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* ── PAGE TITLE AREA ── */
.page-header, .content-header, [class*="PageHeader"] {
  padding: 24px 0 !important;
  border-bottom: 1px solid var(--luxury-border) !important;
  margin-bottom: 24px !important;
}

/* ── GLOW DIVIDER ── */
hr, .divider {
  border: none !important;
  height: 1px !important;
  background: linear-gradient(90deg, transparent, var(--luxury-border), transparent) !important;
  margin: 20px 0 !important;
}

/* ── SKELETON LOADER ── */
[class*="Skeleton"], .skeleton {
  background: linear-gradient(90deg, var(--luxury-bg-card) 25%, var(--luxury-bg-hover) 50%, var(--luxury-bg-card) 75%) !important;
  background-size: 200% 100% !important;
  animation: skeleton-shimmer 1.5s infinite !important;
  border-radius: var(--luxury-radius) !important;
}

@keyframes skeleton-shimmer {
  0%   { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}

/* ── SELECTION ── */
::selection {
  background: rgba(139,92,246,0.3);
  color: var(--luxury-text-primary);
}

/* ── ANIMATIONS ── */
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(16px); }
  to   { opacity: 1; transform: translateY(0); }
}

@keyframes glow-pulse {
  0%, 100% { box-shadow: 0 0 20px rgba(139,92,246,0.2); }
  50%       { box-shadow: 0 0 40px rgba(139,92,246,0.4); }
}

.card, .box, [class*="ContentBox"] {
  animation: fadeInUp 0.35s ease both;
}

/* ── RESPONSIVE ── */
@media (max-width: 768px) {
  .sidebar { width: 260px !important; }
  .card, .box { border-radius: var(--luxury-radius) !important; }
}
CSSEOF
}

# ============================================================
# GENERATE JAVASCRIPT
# ============================================================
generate_js() {
    cat > "$JS_FILE" << 'JSEOF'
/**
 * Luxury Theme JS — Pterodactyl Panel
 * Particle background + UI enhancements
 */
(function () {
  'use strict';

  // ── Particle Background ──
  function initParticles() {
    const canvas = document.createElement('canvas');
    canvas.id = 'luxury-particles';
    canvas.style.cssText = `
      position: fixed; top: 0; left: 0;
      width: 100%; height: 100%;
      pointer-events: none; z-index: -1;
      opacity: 0.35;
    `;
    document.body.prepend(canvas);

    const ctx = canvas.getContext('2d');
    let W = canvas.width = window.innerWidth;
    let H = canvas.height = window.innerHeight;

    const COLORS = ['#8b5cf6', '#06b6d4', '#ec4899', '#f59e0b'];
    const particles = Array.from({ length: 55 }, () => ({
      x: Math.random() * W,
      y: Math.random() * H,
      r: Math.random() * 1.5 + 0.5,
      vx: (Math.random() - 0.5) * 0.3,
      vy: (Math.random() - 0.5) * 0.3,
      color: COLORS[Math.floor(Math.random() * COLORS.length)],
      alpha: Math.random() * 0.5 + 0.2,
    }));

    function draw() {
      ctx.clearRect(0, 0, W, H);
      particles.forEach(p => {
        p.x += p.vx; p.y += p.vy;
        if (p.x < 0) p.x = W; if (p.x > W) p.x = 0;
        if (p.y < 0) p.y = H; if (p.y > H) p.y = 0;
        ctx.beginPath();
        ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
        ctx.fillStyle = p.color;
        ctx.globalAlpha = p.alpha;
        ctx.fill();
      });

      // Lines between nearby particles
      ctx.globalAlpha = 1;
      for (let i = 0; i < particles.length; i++) {
        for (let j = i + 1; j < particles.length; j++) {
          const dx = particles[i].x - particles[j].x;
          const dy = particles[i].y - particles[j].y;
          const dist = Math.sqrt(dx * dx + dy * dy);
          if (dist < 100) {
            ctx.beginPath();
            ctx.moveTo(particles[i].x, particles[i].y);
            ctx.lineTo(particles[j].x, particles[j].y);
            ctx.strokeStyle = '#8b5cf6';
            ctx.globalAlpha = (1 - dist / 100) * 0.12;
            ctx.lineWidth = 0.5;
            ctx.stroke();
            ctx.globalAlpha = 1;
          }
        }
      }
      requestAnimationFrame(draw);
    }

    draw();
    window.addEventListener('resize', () => {
      W = canvas.width = window.innerWidth;
      H = canvas.height = window.innerHeight;
    });
  }

  // ── Gradient Text on Logo/Brand ──
  function applyGradientBrand() {
    const selectors = ['.logo', '.brand', 'nav .site-name', '.navbar-brand'];
    selectors.forEach(sel => {
      document.querySelectorAll(sel).forEach(el => {
        el.style.background = 'linear-gradient(135deg, #8b5cf6, #06b6d4)';
        el.style.webkitBackgroundClip = 'text';
        el.style.webkitTextFillColor = 'transparent';
        el.style.backgroundClip = 'text';
        el.style.fontWeight = '700';
      });
    });
  }

  // ── Button Ripple Effect ──
  function initRipple() {
    document.addEventListener('click', function (e) {
      const btn = e.target.closest('button, .btn, a.btn');
      if (!btn) return;
      const ripple = document.createElement('span');
      const rect = btn.getBoundingClientRect();
      const size = Math.max(rect.width, rect.height);
      ripple.style.cssText = `
        position: absolute;
        width: ${size}px; height: ${size}px;
        left: ${e.clientX - rect.left - size / 2}px;
        top: ${e.clientY - rect.top - size / 2}px;
        background: rgba(255,255,255,0.15);
        border-radius: 50%;
        transform: scale(0);
        animation: luxury-ripple 0.5s ease-out forwards;
        pointer-events: none; z-index: 999;
      `;
      if (!btn.style.position || btn.style.position === 'static') {
        btn.style.position = 'relative';
      }
      btn.style.overflow = 'hidden';
      btn.appendChild(ripple);
      ripple.addEventListener('animationend', () => ripple.remove());
    });

    const style = document.createElement('style');
    style.textContent = `@keyframes luxury-ripple {
      to { transform: scale(2.5); opacity: 0; }
    }`;
    document.head.appendChild(style);
  }

  // ── Fade-in on Scroll ──
  function initFadeIn() {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateY(0)';
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.08 });

    document.querySelectorAll('.card, .box, [class*="ContentBox"], [class*="ServerRow"]').forEach(el => {
      el.style.opacity = '0';
      el.style.transform = 'translateY(12px)';
      el.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
      observer.observe(el);
    });
  }

  // ── Tooltip Enhancement ──
  function enhanceTooltips() {
    document.querySelectorAll('[title]').forEach(el => {
      const title = el.getAttribute('title');
      if (!title) return;
      el.removeAttribute('title');
      el.setAttribute('data-luxury-tip', title);
      el.addEventListener('mouseenter', function (e) {
        const tip = document.createElement('div');
        tip.className = 'luxury-tooltip';
        tip.textContent = title;
        tip.style.cssText = `
          position: fixed;
          background: rgba(20,20,35,0.97);
          color: #f1f0ff;
          padding: 6px 12px;
          border-radius: 8px;
          font-size: 12px;
          font-family: 'Outfit', sans-serif;
          border: 1px solid #1e1e35;
          pointer-events: none;
          z-index: 9999;
          box-shadow: 0 8px 24px rgba(0,0,0,0.5);
          white-space: nowrap;
          transform: translateY(-6px);
          opacity: 0;
          transition: all 0.18s ease;
        `;
        document.body.appendChild(tip);
        setTimeout(() => { tip.style.opacity = '1'; tip.style.transform = 'translateY(-2px)'; }, 10);

        const move = (ev) => {
          tip.style.left = ev.clientX + 14 + 'px';
          tip.style.top = ev.clientY - 36 + 'px';
        };
        document.addEventListener('mousemove', move);
        el.addEventListener('mouseleave', () => {
          tip.style.opacity = '0';
          setTimeout(() => tip.remove(), 200);
          document.removeEventListener('mousemove', move);
        }, { once: true });
      });
    });
  }

  // ── Clock in Topbar ──
  function injectClock() {
    const topbar = document.querySelector('.topbar, header.topbar, nav header, .app-bar');
    if (!topbar) return;
    const clock = document.createElement('div');
    clock.id = 'luxury-clock';
    clock.style.cssText = `
      font-family: 'Space Grotesk', sans-serif;
      font-size: 13px;
      color: #a09ec0;
      letter-spacing: 0.05em;
      margin-left: auto;
      padding-right: 20px;
      display: flex;
      align-items: center;
      gap: 6px;
    `;
    const dot = document.createElement('span');
    dot.style.cssText = `
      width: 6px; height: 6px;
      border-radius: 50%;
      background: #10b981;
      display: inline-block;
      animation: clock-pulse 2s infinite;
    `;
    const style = document.createElement('style');
    style.textContent = `@keyframes clock-pulse {
      0%,100%{opacity:1} 50%{opacity:0.4}
    }`;
    document.head.appendChild(style);
    clock.appendChild(dot);

    const timeSpan = document.createElement('span');
    clock.appendChild(timeSpan);

    const update = () => {
      const now = new Date();
      timeSpan.textContent = now.toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
    };
    update();
    setInterval(update, 1000);
    topbar.appendChild(clock);
  }

  // ── INIT ──
  function init() {
    initParticles();
    applyGradientBrand();
    initRipple();
    initFadeIn();
    enhanceTooltips();
    injectClock();
    console.log('%c✦ Luxury Theme Active', 'color:#8b5cf6;font-size:14px;font-weight:700;');
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
JSEOF
}

# ============================================================
# INJECT KE BLADE TEMPLATE
# ============================================================
inject_blade() {
    step "Menginjeksi Tema ke Blade Template"

    # Cek apakah sudah terinjeksi sebelumnya
    if grep -q "luxury-theme" "$BLADE_FILE"; then
        warn "Tema sudah terinjeksi sebelumnya. Menimpa..."
        # Hapus injeksi lama
        sed -i '/<!-- LUXURY THEME START -->/,/<!-- LUXURY THEME END -->/d' "$BLADE_FILE"
    fi

    # Inject sebelum </head>
    INJECT_CSS='<!-- LUXURY THEME START -->\n    <link rel="preconnect" href="https://fonts.googleapis.com">\n    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>\n    <link rel="stylesheet" href="/themes/luxury/luxury.css?v='"$VERSION"'">\n<!-- LUXURY THEME END -->'

    INJECT_JS='<!-- LUXURY THEME JS START -->\n    <script defer src="/themes/luxury/luxury.js?v='"$VERSION"'"></script>\n<!-- LUXURY THEME JS END -->'

    # Inject CSS sebelum </head>
    sed -i "s|</head>|$INJECT_CSS\n</head>|" "$BLADE_FILE"

    # Inject JS sebelum </body>
    sed -i "s|</body>|$INJECT_JS\n</body>|" "$BLADE_FILE"

    success "Injeksi CSS & JS berhasil!"
}

# ============================================================
# SET PERMISSIONS
# ============================================================
set_permissions() {
    step "Setting Permissions"
    chown -R www-data:www-data "$THEME_DIR" 2>/dev/null || \
    chown -R nginx:nginx "$THEME_DIR" 2>/dev/null || true
    chmod -R 755 "$THEME_DIR"
    success "Permissions diatur!"
}

# ============================================================
# CLEAR CACHE & RESTART
# ============================================================
restart_panel() {
    step "Clear Cache & Restart Panel"
    cd "$PANEL_DIR" || exit

    info "Clear view cache..."
    php artisan view:clear 2>/dev/null && success "View cache cleared!" || warn "Gagal clear view cache"

    info "Clear config cache..."
    php artisan config:clear 2>/dev/null && success "Config cache cleared!" || warn "Gagal clear config cache"

    info "Restart PHP-FPM..."
    systemctl restart php8.1-fpm 2>/dev/null || \
    systemctl restart php8.2-fpm 2>/dev/null || \
    systemctl restart php-fpm 2>/dev/null || \
    warn "Tidak bisa restart PHP-FPM, restart manual jika perlu."

    info "Restart Nginx..."
    systemctl restart nginx 2>/dev/null && success "Nginx restarted!" || warn "Gagal restart nginx"

    success "Panel berhasil di-restart!"
}

# ============================================================
# INSTALL TEMA
# ============================================================
do_install() {
    print_banner
    step "Memulai Instalasi Luxury Theme"
    check_panel

    do_backup

    step "Membuat Direktori Tema"
    mkdir -p "$THEME_DIR"
    success "Direktori dibuat: $THEME_DIR"

    step "Membuat File CSS"
    generate_css
    success "luxury.css berhasil dibuat!"

    step "Membuat File JavaScript"
    generate_js
    success "luxury.js berhasil dibuat!"

    inject_blade
    set_permissions
    restart_panel

    echo ""
    echo -e "${PURPLE}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                                                  ║${NC}"
    echo -e "${GREEN}║   ✦  Luxury Theme berhasil diinstall!  ✦         ║${NC}"
    echo -e "${PURPLE}║                                                  ║${NC}"
    echo -e "${PURPLE}║   Tema   : Enigma + PyroFish + Billing Fusion    ║${NC}"
    echo -e "${PURPLE}║   Versi  : $VERSION                                ║${NC}"
    echo -e "${PURPLE}║   Backup : $(cat /tmp/ptero_last_backup 2>/dev/null || echo 'N/A')   ║${NC}"
    echo -e "${PURPLE}║                                                  ║${NC}"
    echo -e "${YELLOW}║   Refresh browser (Ctrl+Shift+R) untuk melihat  ║${NC}"
    echo -e "${YELLOW}║   perubahan tema!                                ║${NC}"
    echo -e "${PURPLE}║                                                  ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════╝${NC}"
}

# ============================================================
# UNINSTALL / ROLLBACK
# ============================================================
do_uninstall() {
    print_banner
    step "Uninstall / Rollback Tema"
    check_panel

    # Cari backup terbaru
    if [ -f /tmp/ptero_last_backup ]; then
        LAST_BACKUP=$(cat /tmp/ptero_last_backup)
    else
        LAST_BACKUP=$(ls -td "$BACKUP_DIR"/*/ 2>/dev/null | head -1)
    fi

    if [ -z "$LAST_BACKUP" ] || [ ! -d "$LAST_BACKUP" ]; then
        warn "Tidak ada backup ditemukan. Menghapus injeksi tema saja..."
    else
        info "Backup ditemukan: $LAST_BACKUP"
        echo -e "${YELLOW}Rollback ke backup ini? [y/N]: ${NC}"
        read -r CONFIRM
        if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
            if [ -f "$LAST_BACKUP/master.blade.php.bak" ]; then
                cp "$LAST_BACKUP/master.blade.php.bak" "$BLADE_FILE"
                success "master.blade.php dirollback!"
            fi
        fi
    fi

    # Hapus injeksi dari blade (jika rollback tidak dilakukan atau backup tidak ada)
    if grep -q "LUXURY THEME" "$BLADE_FILE"; then
        sed -i '/<!-- LUXURY THEME START -->/,/<!-- LUXURY THEME END -->/d' "$BLADE_FILE"
        sed -i '/<!-- LUXURY THEME JS START -->/,/<!-- LUXURY THEME JS END -->/d' "$BLADE_FILE"
        success "Injeksi tema dihapus dari blade!"
    fi

    # Hapus folder tema
    if [ -d "$THEME_DIR" ]; then
        rm -rf "$THEME_DIR"
        success "Folder tema dihapus!"
    fi

    restart_panel

    echo ""
    success "Tema berhasil di-uninstall! Panel kembali ke tampilan default."
}

# ============================================================
# MAIN
# ============================================================
check_root
print_banner
show_menu

case "$CHOICE" in
    1) do_install ;;
    2) do_uninstall ;;
    3) echo -e "\n${CYAN}Keluar. Sampai jumpa!${NC}\n"; exit 0 ;;
    *) error "Pilihan tidak valid."; exit 1 ;;
esac
