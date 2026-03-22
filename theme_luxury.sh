#!/bin/bash

# ============================================================
#   RzStore Luxury Theme — All In One Installer
#   Pterodactyl v1.12.x
#   Includes: Dark Theme + Sidebar Kiri + Logo RzStore
#   Version: 3.0.0
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
THEME_DIR="$PANEL_DIR/public/themes/rzstore"
VERSION="3.0.0"

info()    { echo -e "${CYAN}[INFO]${NC}  $1"; }
success() { echo -e "${GREEN}[OK]${NC}    $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }
step()    { echo -e "\n${PURPLE}━━━ $1 ━━━${NC}"; }

print_banner() {
    clear
    echo -e "${PURPLE}"
    echo "  ██████╗ ███████╗███████╗████████╗ ██████╗ ██████╗ ███████╗"
    echo "  ██╔══██╗╚══███╔╝██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝"
    echo "  ██████╔╝  ███╔╝ ███████╗   ██║   ██║   ██║██████╔╝█████╗  "
    echo "  ██╔══██╗ ███╔╝  ╚════██║   ██║   ██║   ██║██╔══██╗██╔══╝  "
    echo "  ██║  ██║███████╗███████║   ██║   ╚██████╔╝██║  ██║███████╗"
    echo "  ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝"
    echo -e "${NC}"
    echo -e "${CYAN}  ╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║  ${BOLD}RzStore Luxury Theme Installer v$VERSION${NC}${CYAN}          ║${NC}"
    echo -e "${CYAN}  ║  Dark Theme + Sidebar Kiri + Logo RzStore            ║${NC}"
    echo -e "${CYAN}  ║  Support: Pterodactyl v1.12.x                        ║${NC}"
    echo -e "${CYAN}  ╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "Script harus dijalankan sebagai root!"
        echo -e "  Jalankan: ${YELLOW}sudo bash theme_luxury.sh${NC}"
        exit 1
    fi
}

check_panel() {
    if [ ! -d "$PANEL_DIR" ]; then
        error "Pterodactyl tidak ditemukan di $PANEL_DIR"
        exit 1
    fi
    success "Panel ditemukan: $PANEL_DIR"
}

show_menu() {
    echo -e "${BOLD}Pilih aksi:${NC}"
    echo -e "  ${GREEN}[1]${NC} Install / Update RzStore Theme"
    echo -e "  ${YELLOW}[2]${NC} Uninstall — Kembali ke Tampilan Original"
    echo -e "  ${RED}[3]${NC} Keluar"
    echo ""
    read -rp "$(echo -e "${CYAN}Pilihan [1-3]: ${NC}")" CHOICE
}

do_backup() {
    step "Membuat Backup"
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_PATH="$BACKUP_DIR/$TIMESTAMP"
    mkdir -p "$BACKUP_PATH"
    local FILES=(
        "$PANEL_DIR/resources/views/templates/base/core.blade.php"
        "$PANEL_DIR/resources/views/templates/wrapper.blade.php"
        "$PANEL_DIR/resources/views/layouts/admin.blade.php"
        "$PANEL_DIR/resources/views/layouts/scripts.blade.php"
    )
    for f in "${FILES[@]}"; do
        [ -f "$f" ] && cp "$f" "$BACKUP_PATH/$(basename $f).bak" && \
            success "Backup: $(basename $f)"
    done
    [ -d "$THEME_DIR" ] && cp -r "$THEME_DIR" "$BACKUP_PATH/theme_old"
    echo "$BACKUP_PATH" > /tmp/rzstore_last_backup
    success "Backup disimpan di: $BACKUP_PATH"
}

generate_css() {
    cat > "$THEME_DIR/rzstore.css" << 'CSSEOF'
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Space+Grotesk:wght@400;500;600;700&display=swap');

:root {
  --rz-bg:         #0a0a0f;
  --rz-bg2:        #0d0d1a;
  --rz-bg3:        #13131f;
  --rz-bg4:        #1a1a2e;
  --rz-border:     #1e1e35;
  --rz-accent:     #8b5cf6;
  --rz-accent2:    #06b6d4;
  --rz-pink:       #ec4899;
  --rz-text:       #f1f0ff;
  --rz-muted:      #a09ec0;
  --rz-dim:        #5a5880;
  --rz-success:    #10b981;
  --rz-warning:    #f59e0b;
  --rz-danger:     #ef4444;
  --rz-radius:     12px;
  --rz-radius-lg:  16px;
  --rz-glow:       0 0 30px rgba(139,92,246,0.15);
  --rz-shadow:     0 4px 24px rgba(0,0,0,0.5);
  --rz-t:          all 0.25s cubic-bezier(0.4,0,0.2,1);
  --rz-sbw:        64px;
  --rz-sbw-open:   240px;
}

*,*::before,*::after { box-sizing: border-box; }
html,body {
  background: var(--rz-bg) !important;
  color: var(--rz-text) !important;
  font-family: 'Outfit',sans-serif !important;
  -webkit-font-smoothing: antialiased;
}
::-webkit-scrollbar { width:5px; height:5px; }
::-webkit-scrollbar-track { background:transparent; }
::-webkit-scrollbar-thumb { background:linear-gradient(180deg,var(--rz-accent),var(--rz-accent2)); border-radius:99px; }
::selection { background:rgba(139,92,246,0.3); }

body { padding-left:var(--rz-sbw) !important; transition:padding-left 0.3s ease !important; }
body.rz-open { padding-left:var(--rz-sbw-open) !important; }

body::before {
  content:''; position:fixed; top:0;
  left:var(--rz-sbw); right:0; height:2px;
  background:linear-gradient(90deg,var(--rz-accent),var(--rz-accent2),var(--rz-pink),var(--rz-accent));
  background-size:300% 100%;
  animation:rz-grad 4s linear infinite;
  z-index:9990; transition:left 0.3s ease;
}
body.rz-open::before { left:var(--rz-sbw-open); }
@keyframes rz-grad { 0%{background-position:0% 0} 100%{background-position:300% 0} }

/* SIDEBAR */
#rz-sidebar {
  position:fixed; top:0; left:0; height:100vh;
  width:var(--rz-sbw);
  background:linear-gradient(180deg,#0d0d1c 0%,#08080f 100%);
  border-right:1px solid var(--rz-border);
  z-index:9999;
  display:flex; flex-direction:column;
  transition:width 0.3s cubic-bezier(0.4,0,0.2,1);
  overflow:hidden;
  box-shadow:4px 0 32px rgba(0,0,0,0.6);
}
#rz-sidebar.rz-open { width:var(--rz-sbw-open); }

#rz-logo {
  height:70px; display:flex; align-items:center; justify-content:center;
  padding:0 14px; border-bottom:1px solid var(--rz-border);
  cursor:pointer; flex-shrink:0; gap:0;
  background:linear-gradient(135deg,rgba(139,92,246,0.07),rgba(6,182,212,0.03));
  transition:var(--rz-t); overflow:hidden; position:relative;
}
#rz-sidebar.rz-open #rz-logo { gap:12px; justify-content:flex-start; }
#rz-logo:hover { background:linear-gradient(135deg,rgba(139,92,246,0.13),rgba(6,182,212,0.07)); }

.rz-logo-svg {
  width:36px; height:36px; flex-shrink:0;
  filter:drop-shadow(0 0 8px rgba(139,92,246,0.6));
  animation:rz-pulse 3s ease-in-out infinite;
}
@keyframes rz-pulse {
  0%,100%{filter:drop-shadow(0 0 8px rgba(139,92,246,0.6));}
  50%{filter:drop-shadow(0 0 18px rgba(6,182,212,0.9));}
}
.rz-logo-text { overflow:hidden; max-width:0; opacity:0; transition:max-width 0.3s ease,opacity 0.3s ease; white-space:nowrap; }
#rz-sidebar.rz-open .rz-logo-text { max-width:160px; opacity:1; }
.rz-logo-name { font-family:'Space Grotesk',sans-serif; font-size:17px; font-weight:700; background:linear-gradient(135deg,#8b5cf6,#06b6d4); -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text; line-height:1.1; }
.rz-logo-sub { font-size:9px; color:var(--rz-dim); letter-spacing:0.14em; text-transform:uppercase; }
.rz-toggle { position:absolute; right:8px; top:50%; transform:translateY(-50%); width:20px; height:20px; display:flex; align-items:center; justify-content:center; opacity:0; transition:var(--rz-t); color:var(--rz-muted); }
#rz-logo:hover .rz-toggle { opacity:1; }
.rz-toggle svg { width:14px; height:14px; fill:currentColor; transition:transform 0.3s ease; }
#rz-sidebar.rz-open .rz-toggle svg { transform:rotate(180deg); }

#rz-nav { flex:1; overflow-y:auto; overflow-x:hidden; padding:8px 0; scrollbar-width:none; }
#rz-nav::-webkit-scrollbar { display:none; }

.rz-item {
  display:flex; align-items:center; width:100%; height:46px;
  padding:0 14px; gap:0; cursor:pointer;
  text-decoration:none !important; color:var(--rz-dim) !important;
  position:relative; transition:var(--rz-t); overflow:hidden;
}
#rz-sidebar.rz-open .rz-item { gap:14px; }
.rz-item::before { content:''; position:absolute; left:0; top:20%; bottom:20%; width:3px; background:linear-gradient(180deg,var(--rz-accent),var(--rz-accent2)); border-radius:0 3px 3px 0; opacity:0; transition:opacity 0.2s; }
.rz-item:hover { background:rgba(139,92,246,0.08) !important; color:var(--rz-text) !important; }
.rz-item:hover::before { opacity:1; }
.rz-item.rz-active { background:rgba(139,92,246,0.14) !important; color:var(--rz-text) !important; }
.rz-item.rz-active::before { opacity:1; }

.rz-icon { width:36px; height:36px; display:flex; align-items:center; justify-content:center; flex-shrink:0; border-radius:10px; transition:var(--rz-t); }
.rz-item:hover .rz-icon,.rz-item.rz-active .rz-icon { background:rgba(139,92,246,0.15); }
.rz-icon svg { width:17px; height:17px; fill:currentColor; }

.rz-label { font-family:'Outfit',sans-serif; font-size:13.5px; font-weight:500; white-space:nowrap; overflow:hidden; max-width:0; opacity:0; transition:max-width 0.3s ease,opacity 0.3s ease; }
#rz-sidebar.rz-open .rz-label { max-width:160px; opacity:1; }

.rz-tip { position:fixed; left:calc(var(--rz-sbw) + 10px); background:#0f0f1a; color:var(--rz-text); font-family:'Outfit',sans-serif; font-size:12px; font-weight:500; padding:6px 12px; border-radius:8px; white-space:nowrap; pointer-events:none; border:1px solid var(--rz-border); z-index:99999; display:none; box-shadow:var(--rz-shadow); }

.rz-divider { height:1px; background:var(--rz-border); margin:6px 12px; }

#rz-bottom { border-top:1px solid var(--rz-border); padding:8px 0; flex-shrink:0; }

/* PAGE CONTENT */
div[class*="bg-neutral-700"],
div[class*="bg-neutral-800"],
div[class*="bg-neutral-900"],
div[class*="ContentBox"],
.card,.box {
  background:var(--rz-bg3) !important;
  border:1px solid var(--rz-border) !important;
  border-radius:var(--rz-radius-lg) !important;
}

button,a[role="button"] {
  font-family:'Outfit',sans-serif !important;
  font-weight:600 !important;
  border-radius:var(--rz-radius) !important;
  transition:var(--rz-t) !important;
}

input,select,textarea {
  background:rgba(15,15,26,0.9) !important;
  border:1px solid var(--rz-border) !important;
  border-radius:var(--rz-radius) !important;
  color:var(--rz-text) !important;
  font-family:'Outfit',sans-serif !important;
}
input:focus,select:focus,textarea:focus {
  border-color:var(--rz-accent) !important;
  box-shadow:0 0 0 3px rgba(139,92,246,0.15) !important;
  outline:none !important;
}
input::placeholder { color:var(--rz-dim) !important; }

h1,h2,h3,h4,h5,h6 { font-family:'Outfit',sans-serif !important; color:var(--rz-text) !important; }
a { color:var(--rz-accent) !important; }
a:hover { color:var(--rz-accent2) !important; }

div[class*="ServerRow"] {
  background:var(--rz-bg3) !important;
  border:1px solid var(--rz-border) !important;
  border-radius:var(--rz-radius-lg) !important;
  transition:var(--rz-t) !important;
}
div[class*="ServerRow"]:hover {
  border-color:rgba(139,92,246,0.3) !important;
  transform:translateY(-1px) !important;
  box-shadow:var(--rz-glow) !important;
}
CSSEOF
    success "rzstore.css dibuat!"
}

generate_js() {
    cat > "$THEME_DIR/rzstore.js" << 'JSEOF'
(function(){
'use strict';
const OPEN_KEY='rz_sb';
const NAV=[
  {label:'Servers',href:'/',match:p=>p==='/'||p==='',icon:'<svg viewBox="0 0 24 24"><path d="M20 3H4v10c0 2.21 1.79 4 4 4h6c2.21 0 4-1.79 4-4v-3h2c1.11 0 2-.89 2-2V5c0-1.11-.89-2-2-2zm0 5h-2V5h2v3zM4 19h16v2H4z"/></svg>'},
  {label:'Account',href:'/account',match:p=>p==='/account',icon:'<svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>'},
  {type:'divider'},
  {label:'API Keys',href:'/account/api',match:p=>p.startsWith('/account/api'),icon:'<svg viewBox="0 0 24 24"><path d="M12.65 10C11.83 7.67 9.61 6 7 6c-3.31 0-6 2.69-6 6s2.69 6 6 6c2.61 0 4.83-1.67 5.65-4H17v4h4v-4h2v-4H12.65zM7 14c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z"/></svg>'},
  {label:'SSH Keys',href:'/account/ssh',match:p=>p.startsWith('/account/ssh'),icon:'<svg viewBox="0 0 24 24"><path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/></svg>'},
  {label:'Activity',href:'/account/activity',match:p=>p.startsWith('/account/activity'),icon:'<svg viewBox="0 0 24 24"><path d="M13.5 5.5c1.09 0 2-.9 2-2s-.91-2-2-2c-1.1 0-2 .9-2 2s.9 2 2 2zM9.8 8.9L7 23h2.1l1.8-8 2.1 2v6h2v-7.5l-2.1-2 .6-3C14.8 12 16.8 13 19 13v-2c-1.9 0-3.5-1-4.3-2.4l-1-1.6c-.4-.6-1-1-1.7-1-.3 0-.5.1-.8.1L6 8.3V13h2V9.6l1.8-.7"/></svg>'},
];

// Hide React topbar
function hideTopbar(){
  const check=()=>{
    // By position: fixed/sticky top bar
    document.querySelectorAll('body *').forEach(el=>{
      try{
        const s=window.getComputedStyle(el);
        const r=el.getBoundingClientRect();
        if((s.position==='fixed'||s.position==='sticky')
          && r.top<=2 && r.width>window.innerWidth*0.4
          && r.height>28 && r.height<90
          && el.id!=='rz-sidebar'){
          el.style.setProperty('display','none','important');
        }
      }catch(e){}
    });
    // By tag
    document.querySelectorAll('nav').forEach(el=>{
      if(el.id==='rz-sidebar'||el.closest('#rz-sidebar')) return;
      const r=el.getBoundingClientRect();
      if(r.top<=2&&r.width>200) el.style.setProperty('display','none','important');
    });
  };
  check();
  const obs=new MutationObserver(check);
  obs.observe(document.body,{childList:true,subtree:true});
  setTimeout(()=>obs.disconnect(),12000);
}

function buildSidebar(){
  if(document.getElementById('rz-sidebar')) return;
  const isOpen=localStorage.getItem(OPEN_KEY)==='true';
  const path=window.location.pathname;

  // Tooltip
  const tip=document.createElement('div');
  tip.className='rz-tip'; tip.id='rz-tip';
  document.body.appendChild(tip);

  const sb=document.createElement('div');
  sb.id='rz-sidebar';
  if(isOpen){sb.classList.add('rz-open');document.body.classList.add('rz-open');}

  sb.innerHTML=`
    <div id="rz-logo">
      <svg class="rz-logo-svg" viewBox="0 0 40 40" fill="none">
        <defs>
          <linearGradient id="rzg1" x1="0" y1="0" x2="40" y2="40" gradientUnits="userSpaceOnUse">
            <stop offset="0%" stop-color="#8b5cf6"/>
            <stop offset="100%" stop-color="#06b6d4"/>
          </linearGradient>
          <linearGradient id="rzg2" x1="0" y1="40" x2="40" y2="0" gradientUnits="userSpaceOnUse">
            <stop offset="0%" stop-color="#06b6d4"/>
            <stop offset="100%" stop-color="#ec4899"/>
          </linearGradient>
        </defs>
        <polygon points="20,1 39,20 20,39 1,20" fill="rgba(139,92,246,0.1)" stroke="url(#rzg1)" stroke-width="1.5"/>
        <polygon points="20,7 33,20 20,33 7,20" fill="rgba(139,92,246,0.07)"/>
        <text x="20" y="25" text-anchor="middle" font-family="Space Grotesk,sans-serif" font-size="12" font-weight="700" fill="url(#rzg2)" letter-spacing="-0.5">RZ</text>
        <circle cx="20" cy="1" r="2" fill="url(#rzg1)"/>
        <circle cx="39" cy="20" r="2" fill="url(#rzg1)"/>
        <circle cx="20" cy="39" r="2" fill="url(#rzg1)"/>
        <circle cx="1" cy="20" r="2" fill="url(#rzg1)"/>
      </svg>
      <div class="rz-logo-text">
        <div class="rz-logo-name">RzStore</div>
        <div class="rz-logo-sub">Game Panel</div>
      </div>
      <div class="rz-toggle">
        <svg viewBox="0 0 24 24"><path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6z"/></svg>
      </div>
    </div>
    <div id="rz-nav"></div>
    <div id="rz-bottom"></div>
  `;
  document.body.prepend(sb);
  document.getElementById('rz-logo').addEventListener('click',toggle);

  const nav=document.getElementById('rz-nav');
  NAV.forEach(item=>{
    if(item.type==='divider'){nav.insertAdjacentHTML('beforeend','<div class="rz-divider"></div>');return;}
    const a=document.createElement('a');
    a.href=item.href;
    a.className='rz-item'+(item.match(path)?' rz-active':'');
    a.innerHTML=`<div class="rz-icon">${item.icon}</div><span class="rz-label">${item.label}</span>`;
    a.addEventListener('mouseenter',e=>showTip(e,item.label));
    a.addEventListener('mouseleave',hideTip);
    nav.appendChild(a);
  });

  const bottom=document.getElementById('rz-bottom');
  const out=document.createElement('a');
  out.href='/auth/logout'; out.className='rz-item';
  out.style.cssText='color:rgba(239,68,68,0.65)!important;';
  out.innerHTML=`<div class="rz-icon"><svg viewBox="0 0 24 24" fill="currentColor"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg></div><span class="rz-label">Logout</span>`;
  out.addEventListener('mouseenter',e=>showTip(e,'Logout'));
  out.addEventListener('mouseleave',hideTip);
  bottom.appendChild(out);

  initParticles();
}

function toggle(){
  const sb=document.getElementById('rz-sidebar');if(!sb)return;
  const open=sb.classList.toggle('rz-open');
  document.body.classList.toggle('rz-open',open);
  localStorage.setItem(OPEN_KEY,open);
}

function showTip(e,text){
  const sb=document.getElementById('rz-sidebar');
  if(sb&&sb.classList.contains('rz-open'))return;
  const tip=document.getElementById('rz-tip');if(!tip)return;
  const r=e.currentTarget.getBoundingClientRect();
  tip.textContent=text;
  tip.style.top=(r.top+r.height/2-14)+'px';
  tip.style.display='block';
}
function hideTip(){const t=document.getElementById('rz-tip');if(t)t.style.display='none';}

function initParticles(){
  const c=document.createElement('canvas');
  c.style.cssText='position:fixed;inset:0;pointer-events:none;z-index:-1;opacity:0.18;';
  document.body.appendChild(c);
  const ctx=c.getContext('2d');
  let W=c.width=window.innerWidth,H=c.height=window.innerHeight;
  const CL=['#8b5cf6','#06b6d4','#ec4899'];
  const pts=Array.from({length:45},()=>({
    x:Math.random()*W,y:Math.random()*H,
    vx:(Math.random()-.5)*.25,vy:(Math.random()-.5)*.25,
    r:Math.random()*1.3+.4,c:CL[Math.floor(Math.random()*3)],a:Math.random()*.4+.15
  }));
  function draw(){
    ctx.clearRect(0,0,W,H);
    pts.forEach(p=>{
      p.x+=p.vx;p.y+=p.vy;
      if(p.x<0)p.x=W;if(p.x>W)p.x=0;
      if(p.y<0)p.y=H;if(p.y>H)p.y=0;
      ctx.beginPath();ctx.arc(p.x,p.y,p.r,0,Math.PI*2);
      ctx.fillStyle=p.c;ctx.globalAlpha=p.a;ctx.fill();
    });
    for(let i=0;i<pts.length;i++)for(let j=i+1;j<pts.length;j++){
      const dx=pts[i].x-pts[j].x,dy=pts[i].y-pts[j].y,d=Math.sqrt(dx*dx+dy*dy);
      if(d<90){ctx.beginPath();ctx.moveTo(pts[i].x,pts[i].y);ctx.lineTo(pts[j].x,pts[j].y);
        ctx.strokeStyle='#8b5cf6';ctx.globalAlpha=(1-d/90)*.07;ctx.lineWidth=.4;ctx.stroke();}
    }
    ctx.globalAlpha=1;requestAnimationFrame(draw);
  }
  draw();
  window.addEventListener('resize',()=>{W=c.width=window.innerWidth;H=c.height=window.innerHeight;});
}

function init(){
  buildSidebar();
  setTimeout(hideTopbar,500);
  setTimeout(hideTopbar,1200);
  setTimeout(hideTopbar,2500);
  console.log('%c✦ RzStore Theme v3.0.0','color:#8b5cf6;font-size:14px;font-weight:700;');
}

if(document.readyState==='loading') document.addEventListener('DOMContentLoaded',init);
else init();
})();
JSEOF
    success "rzstore.js dibuat!"
}

inject_blades() {
    step "Inject ke Blade Templates"
    local CSS='<!-- RZSTORE START --><link rel="preconnect" href="https://fonts.googleapis.com"><link rel="stylesheet" href="/themes/rzstore/rzstore.css?v=3.0.0"><!-- RZSTORE END -->'
    local JS='<!-- RZSTORE JS START --><script defer src="/themes/rzstore/rzstore.js?v=3.0.0"></script><!-- RZSTORE JS END -->'
    local FILES=(
        "$PANEL_DIR/resources/views/templates/base/core.blade.php"
        "$PANEL_DIR/resources/views/templates/wrapper.blade.php"
        "$PANEL_DIR/resources/views/layouts/admin.blade.php"
        "$PANEL_DIR/resources/views/layouts/scripts.blade.php"
    )
    for f in "${FILES[@]}"; do
        [ -f "$f" ] || continue
        sed -i '/<!-- RZSTORE START -->/,/<!-- RZSTORE END -->/d' "$f"
        sed -i '/<!-- RZSTORE JS START -->/,/<!-- RZSTORE JS END -->/d' "$f"
        sed -i '/<!-- LUXURY THEME/,/-->/d' "$f"
        sed -i '/sidebar\.css\|sidebar\.js\|luxury\.css\|luxury\.js\|rzstore\.css\|rzstore\.js/d' "$f"
        if grep -q "</head>" "$f"; then
            sed -i "s|</head>|$CSS\n</head>|" "$f"
        else
            echo -e "\n$CSS" >> "$f"
        fi
        if grep -q "</body>" "$f"; then
            sed -i "s|</body>|$JS\n</body>|" "$f"
        else
            echo -e "\n$JS" >> "$f"
        fi
        success "Injeksi: $(basename $f)"
    done
}

finish_install() {
    step "Permissions & Restart"
    chown -R www-data:www-data "$THEME_DIR" 2>/dev/null || \
    chown -R nginx:nginx "$THEME_DIR" 2>/dev/null || true
    chmod -R 755 "$THEME_DIR"
    cd "$PANEL_DIR"
    php artisan view:clear 2>/dev/null && success "Cache cleared!"
    php artisan config:clear 2>/dev/null
    systemctl restart php8.3-fpm 2>/dev/null || \
    systemctl restart php8.2-fpm 2>/dev/null || \
    systemctl restart php8.1-fpm 2>/dev/null || true
    systemctl restart nginx 2>/dev/null && success "Nginx restarted!"
}

do_uninstall() {
    print_banner
    step "Uninstall — Kembali ke Tampilan Original"
    local LAST=""
    [ -f /tmp/rzstore_last_backup ] && LAST=$(cat /tmp/rzstore_last_backup)
    [ -z "$LAST" ] && LAST=$(ls -td "$BACKUP_DIR"/*/ 2>/dev/null | head -1)
    if [ -n "$LAST" ] && [ -d "$LAST" ]; then
        info "Backup ditemukan: $LAST"
        read -rp "$(echo -e "${YELLOW}Restore dari backup? [y/N]: ${NC}")" CONFIRM
        if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
            for bak in "$LAST"/*.bak; do
                [ -f "$bak" ] || continue
                ORIG_NAME=$(basename "$bak" .bak)
                ORIG=$(find "$PANEL_DIR/resources/views" -name "$ORIG_NAME" 2>/dev/null | head -1)
                [ -n "$ORIG" ] && cp "$bak" "$ORIG" && success "Restored: $ORIG_NAME"
            done
        fi
    fi
    local FILES=(
        "$PANEL_DIR/resources/views/templates/base/core.blade.php"
        "$PANEL_DIR/resources/views/templates/wrapper.blade.php"
        "$PANEL_DIR/resources/views/layouts/admin.blade.php"
        "$PANEL_DIR/resources/views/layouts/scripts.blade.php"
    )
    for f in "${FILES[@]}"; do
        [ -f "$f" ] || continue
        sed -i '/<!-- RZSTORE START -->/,/<!-- RZSTORE END -->/d' "$f"
        sed -i '/<!-- RZSTORE JS START -->/,/<!-- RZSTORE JS END -->/d' "$f"
        sed -i '/<!-- LUXURY THEME/,/-->/d' "$f"
        sed -i '/sidebar\.css\|sidebar\.js\|luxury\.css\|luxury\.js\|rzstore\.css\|rzstore\.js/d' "$f"
        success "Cleaned: $(basename $f)"
    done
    [ -d "$THEME_DIR" ] && rm -rf "$THEME_DIR" && success "Folder tema dihapus!"
    [ -d "$PANEL_DIR/public/themes/luxury" ] && rm -rf "$PANEL_DIR/public/themes/luxury"
    finish_install
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✦  Tema di-uninstall! Panel kembali ke ori.     ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
}

do_install() {
    print_banner
    step "Memulai Instalasi RzStore Theme v$VERSION"
    check_panel
    do_backup
    step "Membuat Direktori"
    mkdir -p "$THEME_DIR" && success "Direktori: $THEME_DIR"
    step "Generate CSS"; generate_css
    step "Generate JS";  generate_js
    inject_blades
    finish_install
    echo ""
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   ✦  RzStore Theme v$VERSION berhasil diinstall!      ║${NC}"
    echo -e "${PURPLE}║                                                      ║${NC}"
    echo -e "${PURPLE}║  ▸ Dark luxury theme aktif                           ║${NC}"
    echo -e "${PURPLE}║  ▸ Sidebar kiri dengan logo RzStore                  ║${NC}"
    echo -e "${PURPLE}║  ▸ Klik logo untuk expand/collapse sidebar           ║${NC}"
    echo -e "${PURPLE}║  ▸ Hover icon untuk tooltip nama menu                ║${NC}"
    echo -e "${PURPLE}║  ▸ Particle background animasi                       ║${NC}"
    echo -e "${PURPLE}║                                                      ║${NC}"
    echo -e "${YELLOW}║  Tekan Ctrl+Shift+R untuk hard refresh!              ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════╝${NC}"
}

check_root
print_banner
show_menu

case "$CHOICE" in
    1) do_install ;;
    2) do_uninstall ;;
    3) echo -e "\n${CYAN}Keluar!${NC}"; exit 0 ;;
    *) error "Pilihan tidak valid!"; exit 1 ;;
esac
