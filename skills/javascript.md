# Interactive JavaScript Components

All components are vanilla JavaScript — no libraries, no frameworks, no npm.

## Carousel / Slider with Touch Support

```html
<div class="carousel" id="carousel">
  <div class="carousel-track" id="track">
    <div class="slide">Slide 1 content</div>
    <div class="slide">Slide 2 content</div>
    <div class="slide">Slide 3 content</div>
  </div>
  <div class="carousel-dots" id="dots"></div>
</div>

<style>
.carousel { position: relative; overflow: hidden; }
.carousel-track { display: flex; transition: transform 0.5s ease; }
.slide { min-width: 100%; }
.carousel-dots { display: flex; justify-content: center; gap: 8px; margin-top: 16px; }
.dot {
  width: 10px; height: 10px; border-radius: 50%;
  background: #333; border: none; cursor: pointer;
}
.dot.active { background: #6c5ce7; }
</style>

<script>
const track = document.getElementById('track');
const slides = track.children;
const dots = document.getElementById('dots');
let current = 0;

// Create dots
[...slides].forEach((_, i) => {
  const dot = document.createElement('button');
  dot.className = 'dot' + (i === 0 ? ' active' : '');
  dot.onclick = () => goTo(i);
  dots.appendChild(dot);
});

function goTo(index) {
  current = index;
  track.style.transform = `translateX(-${index * 100}%)`;
  dots.querySelectorAll('.dot').forEach((d, i) =>
    d.classList.toggle('active', i === index)
  );
}

// Touch/swipe
let startX;
track.addEventListener('touchstart', e => startX = e.touches[0].clientX);
track.addEventListener('touchend', e => {
  const diff = startX - e.changedTouches[0].clientX;
  if (Math.abs(diff) > 50) {
    if (diff > 0 && current < slides.length - 1) goTo(current + 1);
    if (diff < 0 && current > 0) goTo(current - 1);
  }
});

// Auto-advance
setInterval(() => goTo((current + 1) % slides.length), 5000);
</script>
```

## Lightbox Modal

```html
<button onclick="openModal('myModal')">Open</button>

<div class="modal-overlay" id="myModal" onclick="if(event.target===this)closeModal('myModal')">
  <div class="modal-content">
    <button class="modal-close" onclick="closeModal('myModal')">&times;</button>
    <h3>Modal Title</h3>
    <p>Modal content here.</p>
  </div>
</div>

<style>
.modal-overlay {
  display: none; position: fixed; inset: 0; z-index: 10000;
  background: rgba(0,0,0,0.9);
  align-items: center; justify-content: center;
}
.modal-overlay.active { display: flex; }
.modal-content {
  background: #111; border-radius: 16px; padding: 40px;
  max-width: 500px; width: 90%; position: relative;
  border: 1px solid rgba(255,255,255,0.1);
}
.modal-close {
  position: absolute; top: 16px; right: 16px;
  background: none; border: none; color: #888; font-size: 1.5rem; cursor: pointer;
}
</style>

<script>
function openModal(id) { document.getElementById(id).classList.add('active'); }
function closeModal(id) { document.getElementById(id).classList.remove('active'); }

// Close on Escape key
document.addEventListener('keydown', e => {
  if (e.key === 'Escape') {
    document.querySelectorAll('.modal-overlay.active').forEach(m => m.classList.remove('active'));
  }
});
</script>
```

## Image Lightbox (Click to Expand)

```html
<img src="photo.jpg" alt="Photo" class="lightbox-trigger" onclick="showImage(this.src)">

<div class="image-lightbox" id="imageLightbox" onclick="this.classList.remove('active')">
  <img id="lightboxImg" src="" alt="">
</div>

<style>
.lightbox-trigger { cursor: pointer; transition: transform 0.3s; }
.lightbox-trigger:hover { transform: scale(1.02); }
.image-lightbox {
  display: none; position: fixed; inset: 0; z-index: 10000;
  background: rgba(0,0,0,0.95);
  align-items: center; justify-content: center; cursor: pointer;
}
.image-lightbox.active { display: flex; }
.image-lightbox img {
  max-width: 90vw; max-height: 90vh; border-radius: 8px;
  object-fit: contain;
}
</style>

<script>
function showImage(src) {
  document.getElementById('lightboxImg').src = src;
  document.getElementById('imageLightbox').classList.add('active');
}
</script>
```

## Platform Picker Popup

```html
<button onclick="openModal('platformPicker')">Watch Live</button>

<div class="modal-overlay" id="platformPicker" onclick="if(event.target===this)closeModal('platformPicker')">
  <div class="modal-content" style="text-align:center;">
    <button class="modal-close" onclick="closeModal('platformPicker')">&times;</button>
    <h3 style="margin-bottom:24px;">Choose Your Platform</h3>
    <div style="display:flex; flex-direction:column; gap:12px;">
      <a href="https://youtube.com/@channel" target="_blank" class="platform-btn" style="background:#FF0000;">
        YouTube
      </a>
      <a href="https://facebook.com/page/live" target="_blank" class="platform-btn" style="background:#1877F2;">
        Facebook
      </a>
      <a href="https://instagram.com/account" target="_blank" class="platform-btn" style="background:linear-gradient(45deg,#f09433,#e6683c,#dc2743,#cc2366,#bc1888);">
        Instagram
      </a>
    </div>
  </div>
</div>

<style>
.platform-btn {
  display: block; padding: 14px 24px; border-radius: 8px;
  color: #fff; font-weight: 600; font-size: 1rem;
  text-decoration: none; transition: transform 0.2s, opacity 0.2s;
}
.platform-btn:hover { transform: scale(1.03); opacity: 0.9; }
</style>
```

## Smooth Scroll Navigation

```javascript
// Smooth scroll to anchor links
document.querySelectorAll('a[href^="#"]').forEach(link => {
  link.addEventListener('click', e => {
    e.preventDefault();
    const target = document.querySelector(link.getAttribute('href'));
    if (target) {
      target.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  });
});
```

## Password Gate

```javascript
// Simple client-side gate (NOT secure — just a deterrent)
(function() {
  if (sessionStorage.getItem('access') === 'granted') return;
  
  const gate = document.createElement('div');
  gate.innerHTML = `
    <div style="position:fixed;inset:0;z-index:99999;background:#050505;display:flex;align-items:center;justify-content:center;">
      <div style="text-align:center;max-width:400px;padding:40px;">
        <h2 style="color:#fff;margin-bottom:16px;">Access Required</h2>
        <input type="password" id="gatePass" placeholder="Enter password"
          style="padding:12px;width:100%;border-radius:8px;border:1px solid #333;background:#111;color:#fff;margin-bottom:12px;">
        <button onclick="checkPass()" style="padding:12px 32px;background:#6c5ce7;color:#fff;border:none;border-radius:8px;cursor:pointer;">
          Enter
        </button>
      </div>
    </div>
  `;
  document.body.appendChild(gate);
  
  window.checkPass = function() {
    if (document.getElementById('gatePass').value === 'yourpassword') {
      sessionStorage.setItem('access', 'granted');
      gate.remove();
    } else {
      alert('Incorrect password');
    }
  };
})();
```

## Mobile Hamburger Menu

```html
<nav>
  <div class="logo">Brand</div>
  <button class="hamburger" onclick="this.classList.toggle('active');document.getElementById('mobileNav').classList.toggle('open');">
    <span></span><span></span><span></span>
  </button>
  <div class="mobile-nav" id="mobileNav">
    <a href="#services">Services</a>
    <a href="#pricing">Pricing</a>
    <a href="#contact">Contact</a>
  </div>
</nav>

<style>
.hamburger {
  display: none; background: none; border: none; cursor: pointer;
  flex-direction: column; gap: 5px; padding: 5px;
}
.hamburger span {
  display: block; width: 24px; height: 2px; background: #fff;
  transition: all 0.3s;
}
.hamburger.active span:nth-child(1) { transform: rotate(45deg) translate(5px, 5px); }
.hamburger.active span:nth-child(2) { opacity: 0; }
.hamburger.active span:nth-child(3) { transform: rotate(-45deg) translate(5px, -5px); }

.mobile-nav {
  display: none; position: fixed; top: 60px; left: 0; right: 0;
  background: #0a0a0a; padding: 20px;
  flex-direction: column; gap: 16px;
  border-bottom: 1px solid rgba(255,255,255,0.05);
}
.mobile-nav.open { display: flex; }
.mobile-nav a { color: #fff; font-size: 1.1rem; padding: 8px 0; }

@media (max-width: 768px) {
  .hamburger { display: flex; }
  .nav-links { display: none; }
}
</style>
```

## News Ticker / Scrolling Text

```html
<div class="ticker-wrapper">
  <div class="ticker-content">
    <span>Breaking News: Something important happened</span>
    <span>Update: Another piece of news</span>
    <span>Alert: Third item scrolling by</span>
  </div>
</div>

<style>
.ticker-wrapper {
  overflow: hidden; background: #111;
  padding: 10px 0; border-top: 1px solid rgba(108,92,231,0.3);
}
.ticker-content {
  display: flex; gap: 60px; white-space: nowrap;
  animation: scroll 30s linear infinite;
}
.ticker-content span { color: #ccc; font-size: 0.85rem; }
@keyframes scroll {
  0% { transform: translateX(100%); }
  100% { transform: translateX(-100%); }
}
</style>
```
