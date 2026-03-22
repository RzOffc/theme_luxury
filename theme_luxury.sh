#!/bin/bash

# ============================================================
#   Pterodactyl Luxury Theme Installer
#   Gabungan: Enigma + PyroFish + Billing Style
#   Support: v1.12.x
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
VERSION="1.0.1"

# ── Auto detect blade file ──
detect_blade() {
    local CANDIDATES=(
        "$PANEL_DIR/resources/views/templates/base/core.blade.php"
        "$PANEL_DIR/resources/views/templates/wrapper.blade.php"
        "$PANEL_DIR/resources/views/layouts/master.blade.php"
        "$PANEL_DIR/resources/views/layouts/scripts.blade.php"
    )
    for f in "${CANDIDATES[@]}"; do
        if [ -f "$f" ]; then
            echo "$f"
            return
        fi
    done
    echo ""
}

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
    echo -e "${CYAN}  ║   ${BOLD}Pterodactyl Luxury Theme Installer v$VERSION${NC}${CYAN}   ║${NC}"
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
        echo -e "  Jalankan: ${YELLOW}sudo bash theme_luxury.sh${NC}"
        exit 1
    fi
}

check_panel() {
    if [ ! -d "$PANEL_DIR" ]; then
        error "Pterodactyl Panel tidak ditemukan di $PANEL_DIR"
        exit 1
    fi

    BLADE_FILE=$(detect_blade)
    if [ -z "$BLADE_FILE" ]; then
        error "Tidak dapat menemukan file blade template!"
        error "Coba jalankan: find $PANEL_DIR/resources/views -name '*.blade.php' | head -5"
        exit 1
    fi

    success "Blade template ditemukan: $BLADE_FILE"
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

    if [ -f "$BLADE_FILE" ]; then
        cp "$BLADE_FILE" "$BACKUP_PATH/blade.bak"
        success "Backup blade → $BACKUP_PATH/blade.bak"
    fi

    if [ -d "$THEME_DIR" ]; then
        cp -r "$THEME_DIR" "$BACKUP_PATH/theme_old"
        success "Backup tema lama → $BACKUP_PATH/theme_old"
    fi

    echo "$BACKUP_PATH" > /tmp/ptero_last_backup
    echo "$BLADE_FILE" > /tmp/ptero_blade_path
    success "Backup selesai!"
}

# ============================================================
# GENERATE CSS
# ============================================================
generate_css() {
    cat > "$CSS_FILE" << 'CSSEOF'
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=Space+Grotesk:wght@400;500;600&display=swap');

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

*, *::before, *::after { box-sizing: border-box; }

html, body {
  background: var(--luxury-bg-primary) !important;
  color: var(--luxury-text-primary) !important;
  font-family: 'Outfit', sans-serif !important;
  font-size: 15px;
  line-height: 1.6;
  -webkit-font-smoothing: antialiased;
}

::-webkit-scrollbar { width: 6px; height: 6px; }
::-webkit-scrollbar-track { background: var(--luxury-bg-primary); }
::-webkit-scrollbar-thumb {
  background: linear-gradient(180deg, var(--luxury-accent), var(--luxury-accent-2));
  border-radius: 99px;
}

/* SIDEBAR */
.sidebar, nav.sidebar, #app aside {
  background: linear-gradient(180deg, #0d0d1a 0%, #0a0a12 100%) !important;
  border-right: 1px solid var(--luxury-border) !important;
  box-shadow: 4px 0 30px rgba(0,0,0,0.4) !important;
}

.sidebar a, .sidebar li a {
  color: var(--luxury-text-secondary) !important;
  font-weight: 500 !important;
  font-size: 13.5px !important;
  border-radius: var(--luxury-radius) !important;
  margin: 2px 8px !important;
  padding: 10px 14px !important;
  transition: var(--luxury-transition) !important;
  position: relative; overflow: hidden;
  display: block;
}

.sidebar a::before {
  content: '';
  position: absolute; left: 0; top: 20%; bottom: 20%;
  width: 3px;
  background: linear-gradient(180deg, var(--luxury-accent), var(--luxury-accent-2));
  border-radius: 0 4px 4px 0;
  opacity: 0; transition: var(--luxury-transition);
}

.sidebar a:hover { background: rgba(139,92,246,0.1) !important; color: var(--luxury-text-primary) !important; }
.sidebar a:hover::before { opacity: 1; }
.sidebar a.active {
  background: linear-gradient(135deg, rgba(139,92,246,0.2), rgba(6,182,212,0.1)) !important;
  color: var(--luxury-text-primary) !important;
}
.sidebar a.active::before { opacity: 1; }

/* TOPBAR */
header, .topbar, nav {
  background: rgba(10,10,15,0.9) !important;
  border-bottom: 1px solid var(--luxury-border) !important;
  backdrop-filter: blur(20px) !important;
}

/* CARDS */
.card, .box, .panel, .bg-white, .bg-neutral-50,
[class*="ContentBox"], [class*="content-box"] {
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

/* BUTTONS */
button, .btn {
  font-family: 'Outfit', sans-serif !important;
  font-weight: 600 !important;
  border-radius: var(--luxury-radius) !important;
  transition: var(--luxury-transition) !important;
  position: relative; overflow: hidden;
}

.btn-primary, button[type="submit"] {
  background: linear-gradient(135deg, var(--luxury-accent), #7c3aed) !important;
  border: none !important; color: #fff !important;
  box-shadow: 0 4px 15px rgba(139,92,246,0.4) !important;
}
.btn-primary:hover, button[type="submit"]:hover {
  box-shadow: 0 6px 25px rgba(139,92,246,0.6) !important;
  transform: translateY(-1px) !important;
}
.btn-success {
  background: linear-gradient(135deg, var(--luxury-success), #059669) !important;
  border: none !important;
}
.btn-danger {
  background: linear-gradient(135deg, var(--luxury-danger), #dc2626) !important;
  border: none !important;
}
.btn-secondary, .btn-default {
  background: transparent !important;
  border: 1px solid var(--luxury-border) !important;
  color: var(--luxury-text-secondary) !important;
}
.btn-secondary:hover { border-color: var(--luxury-accent) !important; color: var(--luxury-accent) !important; }

/* INPUTS */
input, select, textarea {
  background: rgba(15,15,26,0.8) !important;
  border: 1px solid var(--luxury-border) !important;
  border-radius: var(--luxury-radius) !important;
  color: var(--luxury-text-primary) !important;
  font-family: 'Outfit', sans-serif !important;
  transition: var(--luxury-transition) !important;
  padding: 10px 14px !important;
}
input:focus, select:focus, textarea:focus {
  border-color: var(--luxury-accent) !important;
  box-shadow: 0 0 0 3px rgba(139,92,246,0.15) !important;
  outline: none !important;
}
input::placeholder, textarea::placeholder { color: var(--luxury-text-muted) !important; }

label, .label {
  color: var(--luxury-text-secondary) !important;
  font-size: 13px !important; font-weight: 500 !important;
  letter-spacing: 0.03em !important;
}

/* TABLES */
thead tr th {
  background: rgba(139,92,246,0.08) !important;
  color: var(--luxury-text-secondary) !important;
  font-size: 11px !important; font-weight: 600 !important;
  letter-spacing: 0.08em !important; text-transform: uppercase !important;
  border-bottom: 1px solid var(--luxury-border) !important;
  padding: 12px 16px !important;
}
tbody tr { background: var(--luxury-bg-card) !important; transition: var(--luxury-transition) !important; }
tbody tr:hover { background: var(--luxury-bg-hover) !important; }
tbody tr td {
  border-bottom: 1px solid var(--luxury-border) !important;
  padding: 13px 16px !important;
  color: var(--luxury-text-primary) !important;
  font-size: 14px !important;
}

/* BADGES */
.badge { font-size: 11px !important; font-weight: 600 !important; padding: 4px 10px !important; border-radius: 6px !important; }
.badge-success { background: rgba(16,185,129,0.12) !important; color: var(--luxury-success) !important; border: 1px solid rgba(16,185,129,0.2) !important; }
.badge-danger  { background: rgba(239,68,68,0.12) !important;  color: var(--luxury-danger) !important;  border: 1px solid rgba(239,68,68,0.2) !important; }
.badge-warning { background: rgba(245,158,11,0.12) !important; color: var(--luxury-warning) !important; border: 1px solid rgba(245,158,11,0.2) !important; }
.badge-info    { background: rgba(6,182,212,0.12) !important;  color: var(--luxury-info) !important;    border: 1px solid rgba(6,182,212,0.2) !important; }

/* MODAL */
.modal, [class*="Modal"] {
  background: var(--luxury-bg-secondary) !important;
  border: 1px solid var(--luxury-border) !important;
  border-radius: var(--luxury-radius-lg) !important;
  box-shadow: 0 25px 80px rgba(0,0,0,0.7) !important;
}
.modal-backdrop { background: rgba(0,0,0,0.75) !important; backdrop-filter: blur(8px) !important; }

/* PROGRESS BAR */
.progress { background: rgba(255,255,255,0.05) !important; border-radius: 99px !important; height: 6px !important; }
.progress-bar {
  background: linear-gradient(90deg, var(--luxury-accent), var(--luxury-accent-2)) !important;
  border-radius: 99px !important;
  box-shadow: 0 0 10px rgba(139,92,246,0.5) !important;
}

/* SERVER ROWS */
[class*="ServerRow"], [class*="server-card"] {
  background: var(--luxury-bg-card) !important;
  border: 1px solid var(--luxury-border) !important;
  border-radius: var(--luxury-radius-lg) !important;
  transition: var(--luxury-transition) !important;
  position: relative; overflow: hidden;
}
[class*="ServerRow"]::before {
  content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px;
  background: linear-gradient(90deg, var(--luxury-accent), var(--luxury-accent-2));
  opacity: 0; transition: var(--luxury-transition);
}
[class*="ServerRow"]:hover { border-color: var(--luxury-border-glow) !important; transform: translateY(-2px) !important; }
[class*="ServerRow"]:hover::before { opacity: 1; }

/* ALERTS */
.alert { border-radius: var(--luxury-radius) !important; border: none !important; border-left: 3px solid !important; }
.alert-success { background: rgba(16,185,129,0.08) !important; border-color: var(--luxury-success) !important; }
.alert-danger  { background: rgba(239,68,68,0.08)  !important; border-color: var(--luxury-danger)  !important; }
.alert-warning { background: rgba(245,158,11,0.08) !important; border-color: var(--luxury-warning) !important; }
.alert-info    { background: rgba(6,182,212,0.08)  !important; border-color: var(--luxury-info)    !important; }

/* CONSOLE */
.terminal, [class*="Console"] {
  background: #050508 !important;
  border-radius: var(--luxury-radius) !important;
  border: 1px solid var(--luxury-border) !important;
  font-family: 'JetBrains Mono', 'Fira Code', monospace !important;
}

/* TYPOGRAPHY */
h1,h2,h3,h4,h5,h6 { font-family: 'Outfit', sans-serif !important; color: var(--luxury-text-primary) !important; font-weight: 600 !important; }
a { color: var(--luxury-accent) !important; text-decoration: none !important; transition: var(--luxury-transition) !important; }
a:hover { color: var(--luxury-accent-2) !important; }
.text-muted { color: var(--luxury-text-secondary) !important; }

hr { border: none !important; height: 1px !important; background: linear-gradient(90deg, transparent, var(--luxury-border), transparent) !important; }

::selection { background: rgba(139,92,246,0.3); color: var(--luxury-text-primary); }

@keyframes fadeInUp { from { opacity:0; transform:translateY(16px); } to { opacity:1; transform:translateY(0); } }
.card, .box, [class*="ContentBox"] { animation: fadeInUp 0.35s ease both; }
CSSEOF
}

# ============================================================
# GENERATE JS
# ============================================================
generate_js() {
    cat > "$JS_FILE" << 'JSEOF'
(function () {
  'use strict';

  function initParticles() {
    const canvas = document.createElement('canvas');
    canvas.id = 'luxury-particles';
    canvas.style.cssText = 'position:fixed;top:0;left:0;width:100%;height:100%;pointer-events:none;z-index:-1;opacity:0.3;';
    document.body.prepend(canvas);
    const ctx = canvas.getContext('2d');
    let W = canvas.width = window.innerWidth;
    let H = canvas.height = window.innerHeight;
    const COLORS = ['#8b5cf6','#06b6d4','#ec4899'];
    const pts = Array.from({length:50},()=>({
      x:Math.random()*W, y:Math.random()*H,
      vx:(Math.random()-.5)*.3, vy:(Math.random()-.5)*.3,
      r:Math.random()*1.5+.5, c:COLORS[Math.floor(Math.random()*3)], a:Math.random()*.4+.15
    }));
    function draw(){
      ctx.clearRect(0,0,W,H);
      pts.forEach(p=>{
        p.x+=p.vx; p.y+=p.vy;
        if(p.x<0)p.x=W; if(p.x>W)p.x=0;
        if(p.y<0)p.y=H; if(p.y>H)p.y=0;
        ctx.beginPath(); ctx.arc(p.x,p.y,p.r,0,Math.PI*2);
        ctx.fillStyle=p.c; ctx.globalAlpha=p.a; ctx.fill();
      });
      for(let i=0;i<pts.length;i++) for(let j=i+1;j<pts.length;j++){
        const dx=pts[i].x-pts[j].x,dy=pts[i].y-pts[j].y,d=Math.sqrt(dx*dx+dy*dy);
        if(d<100){ctx.beginPath();ctx.moveTo(pts[i].x,pts[i].y);ctx.lineTo(pts[j].x,pts[j].y);
          ctx.strokeStyle='#8b5cf6';ctx.globalAlpha=(1-d/100)*.1;ctx.lineWidth=.5;ctx.stroke();}
      }
      ctx.globalAlpha=1; requestAnimationFrame(draw);
    }
    draw();
    window.addEventListener('resize',()=>{W=canvas.width=window.innerWidth;H=canvas.height=window.innerHeight;});
  }

  function applyGradientBrand() {
    document.querySelectorAll('.logo,.brand,.navbar-brand,[class*="logo"]').forEach(el=>{
      el.style.background='linear-gradient(135deg,#8b5cf6,#06b6d4)';
      el.style.webkitBackgroundClip='text';
      el.style.webkitTextFillColor='transparent';
      el.style.backgroundClip='text';
      el.style.fontWeight='700';
    });
  }

  function initRipple() {
    document.addEventListener('click',function(e){
      const btn=e.target.closest('button,.btn');
      if(!btn)return;
      const ripple=document.createElement('span');
      const rect=btn.getBoundingClientRect();
      const size=Math.max(rect.width,rect.height);
      ripple.style.cssText=`position:absolute;width:${size}px;height:${size}px;left:${e.clientX-rect.left-size/2}px;top:${e.clientY-rect.top-size/2}px;background:rgba(255,255,255,0.15);border-radius:50%;transform:scale(0);animation:lux-ripple .5s ease-out forwards;pointer-events:none;z-index:999;`;
      if(!btn.style.position||btn.style.position==='static') btn.style.position='relative';
      btn.style.overflow='hidden'; btn.appendChild(ripple);
      ripple.addEventListener('animationend',()=>ripple.remove());
    });
    const s=document.createElement('style');
    s.textContent='@keyframes lux-ripple{to{transform:scale(2.5);opacity:0;}}';
    document.head.appendChild(s);
  }

  function initFadeIn() {
    const obs=new IntersectionObserver((entries)=>{
      entries.forEach(e=>{
        if(e.isIntersecting){e.target.style.opacity='1';e.target.style.transform='translateY(0)';obs.unobserve(e.target);}
      });
    },{threshold:0.08});
    document.querySelectorAll('.card,.box,[class*="ContentBox"],[class*="ServerRow"]').forEach(el=>{
      el.style.opacity='0';el.style.transform='translateY(12px)';
      el.style.transition='opacity .4s ease,transform .4s ease';obs.observe(el);
    });
  }

  function injectClock() {
    const topbar=document.querySelector('header,nav,.topbar');
    if(!topbar)return;
    const clock=document.createElement('div');
    clock.style.cssText='font-family:"Space Grotesk",sans-serif;font-size:13px;color:#a09ec0;letter-spacing:.05em;margin-left:auto;padding-right:20px;display:flex;align-items:center;gap:6px;';
    const dot=document.createElement('span');
    dot.style.cssText='width:6px;height:6px;border-radius:50%;background:#10b981;display:inline-block;animation:clk 2s infinite;';
    const s=document.createElement('style');
    s.textContent='@keyframes clk{0%,100%{opacity:1}50%{opacity:.4}}';
    document.head.appendChild(s);
    const time=document.createElement('span');
    const upd=()=>{time.textContent=new Date().toLocaleTimeString('id-ID',{hour:'2-digit',minute:'2-digit',second:'2-digit'});};
    upd(); setInterval(upd,1000);
    clock.appendChild(dot); clock.appendChild(time); topbar.appendChild(clock);
  }

  function init() {
    initParticles(); applyGradientBrand(); initRipple(); initFadeIn(); injectClock();
    console.log('%c✦ Luxury Theme v1.0.1 Active','color:#8b5cf6;font-size:14px;font-weight:700;');
  }

  if(document.readyState==='loading') document.addEventListener('DOMContentLoaded',init);
  else init();
})();
JSEOF
}

# ============================================================
# INJECT KE BLADE
# ============================================================
inject_blade() {
    step "Menginjeksi Tema ke Blade Template"
    info "Target: $BLADE_FILE"

    # Hapus injeksi lama jika ada
    if grep -q "LUXURY THEME" "$BLADE_FILE"; then
        warn "Injeksi lama ditemukan, menghapus..."
        sed -i '/<!-- LUXURY THEME START -->/,/<!-- LUXURY THEME END -->/d' "$BLADE_FILE"
        sed -i '/<!-- LUXURY THEME JS START -->/,/<!-- LUXURY THEME JS END -->/d' "$BLADE_FILE"
    fi

    # Cek apakah ada </head> di file
    if grep -q "</head>" "$BLADE_FILE"; then
        sed -i "s|</head>|<!-- LUXURY THEME START -->\n    <link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">\n    <link rel=\"stylesheet\" href=\"/themes/luxury/luxury.css?v=$VERSION\">\n<!-- LUXURY THEME END -->\n</head>|" "$BLADE_FILE"
        success "CSS diinjeksi sebelum </head>"
    else
        warn "</head> tidak ditemukan, menambahkan di akhir file..."
        echo -e "\n<!-- LUXURY THEME START -->\n<link rel=\"stylesheet\" href=\"/themes/luxury/luxury.css?v=$VERSION\">\n<!-- LUXURY THEME END -->" >> "$BLADE_FILE"
    fi

    # Inject JS sebelum </body>
    if grep -q "</body>" "$BLADE_FILE"; then
        sed -i "s|</body>|<!-- LUXURY THEME JS START -->\n    <script defer src=\"/themes/luxury/luxury.js?v=$VERSION\"></script>\n<!-- LUXURY THEME JS END -->\n</body>|" "$BLADE_FILE"
        success "JS diinjeksi sebelum </body>"
    else
        warn "</body> tidak ditemukan, menambahkan di akhir file..."
        echo -e "\n<!-- LUXURY THEME JS START -->\n<script defer src=\"/themes/luxury/luxury.js?v=$VERSION\"></script>\n<!-- LUXURY THEME JS END -->" >> "$BLADE_FILE"
    fi

    success "Injeksi selesai!"
}

# ============================================================
# PERMISSIONS
# ============================================================
set_permissions() {
    step "Setting Permissions"
    chown -R www-data:www-data "$THEME_DIR" 2>/dev/null || \
    chown -R nginx:nginx "$THEME_DIR" 2>/dev/null || true
    chmod -R 755 "$THEME_DIR"
    success "Permissions OK!"
}

# ============================================================
# RESTART PANEL
# ============================================================
restart_panel() {
    step "Clear Cache & Restart Panel"
    cd "$PANEL_DIR" || exit
    php artisan view:clear 2>/dev/null && success "View cache cleared!" || warn "Gagal clear view cache"
    php artisan config:clear 2>/dev/null && success "Config cache cleared!" || warn "Gagal clear config cache"
    systemctl restart php8.3-fpm 2>/dev/null || \
    systemctl restart php8.2-fpm 2>/dev/null || \
    systemctl restart php8.1-fpm 2>/dev/null || \
    systemctl restart php-fpm 2>/dev/null || \
    warn "Restart PHP-FPM manual jika perlu"
    systemctl restart nginx 2>/dev/null && success "Nginx restarted!" || warn "Gagal restart nginx"
}

# ============================================================
# INSTALL
# ============================================================
do_install() {
    print_banner
    step "Memulai Instalasi Luxury Theme"
    check_panel
    do_backup

    step "Membuat Direktori Tema"
    mkdir -p "$THEME_DIR"
    success "Direktori: $THEME_DIR"

    step "Generate CSS"
    generate_css
    success "luxury.css dibuat!"

    step "Generate JavaScript"
    generate_js
    success "luxury.js dibuat!"

    inject_blade
    set_permissions
    restart_panel

    echo ""
    echo -e "${PURPLE}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   ✦  Luxury Theme berhasil diinstall!  ✦         ║${NC}"
    echo -e "${PURPLE}║   Blade : $(basename $BLADE_FILE)                      ║${NC}"
    echo -e "${PURPLE}║   Versi : $VERSION                                  ║${NC}"
    echo -e "${YELLOW}║   Refresh browser Ctrl+Shift+R untuk melihat     ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════╝${NC}"
}

# ============================================================
# UNINSTALL
# ============================================================
do_uninstall() {
    print_banner
    step "Uninstall / Rollback Tema"
    check_panel

    LAST_BACKUP=""
    [ -f /tmp/ptero_last_backup ] && LAST_BACKUP=$(cat /tmp/ptero_last_backup)
    [ -z "$LAST_BACKUP" ] && LAST_BACKUP=$(ls -td "$BACKUP_DIR"/*/ 2>/dev/null | head -1)

    if [ -n "$LAST_BACKUP" ] && [ -d "$LAST_BACKUP" ]; then
        info "Backup ditemukan: $LAST_BACKUP"
        read -rp "$(echo -e "${YELLOW}Rollback ke backup ini? [y/N]: ${NC}")" CONFIRM
        if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
            [ -f "$LAST_BACKUP/blade.bak" ] && cp "$LAST_BACKUP/blade.bak" "$BLADE_FILE" && success "Blade dirollback!"
        fi
    fi

    # Hapus injeksi
    if grep -q "LUXURY THEME" "$BLADE_FILE" 2>/dev/null; then
        sed -i '/<!-- LUXURY THEME START -->/,/<!-- LUXURY THEME END -->/d' "$BLADE_FILE"
        sed -i '/<!-- LUXURY THEME JS START -->/,/<!-- LUXURY THEME JS END -->/d' "$BLADE_FILE"
        success "Injeksi tema dihapus!"
    fi

    [ -d "$THEME_DIR" ] && rm -rf "$THEME_DIR" && success "Folder tema dihapus!"

    restart_panel
    success "Tema berhasil di-uninstall!"
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
    3) echo -e "\n${CYAN}Keluar!${NC}\n"; exit 0 ;;
    *) error "Pilihan tidak valid!"; exit 1 ;;
esac
