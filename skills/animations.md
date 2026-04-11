# CSS & JavaScript Animations

## CSS Animations

### Loading Screen
```css
.loader {
  position: fixed; inset: 0; z-index: 9999;
  background: #050505;
  display: flex; align-items: center; justify-content: center;
  transition: opacity 0.5s, visibility 0.5s;
}
.loader.hidden { opacity: 0; visibility: hidden; pointer-events: none; }

/* Animated gradient bar */
.loader-bar {
  width: 200px; height: 3px; background: #1a1a1a;
  border-radius: 3px; overflow: hidden;
}
.loader-bar::after {
  content: ''; display: block; width: 40%; height: 100%;
  background: linear-gradient(90deg, #6c5ce7, #00cec9);
  animation: load 1s ease-in-out infinite;
}
@keyframes load {
  0% { transform: translateX(-100%); }
  100% { transform: translateX(350%); }
}
```

```javascript
// Hide after page loads
window.addEventListener('load', () => {
  setTimeout(() => document.getElementById('loader').classList.add('hidden'), 800);
});
```

### Scroll Reveal (Fade Up)
```css
.reveal {
  opacity: 0;
  transform: translateY(30px);
  transition: opacity 0.6s ease, transform 0.6s ease;
}
.reveal.visible {
  opacity: 1;
  transform: translateY(0);
}
```

```javascript
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
    }
  });
}, { threshold: 0.1 });

document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
```

### Staggered Reveal (cards appear one by one)
```css
.reveal-stagger {
  opacity: 0;
  transform: translateY(30px);
  transition: opacity 0.6s ease, transform 0.6s ease;
}
.reveal-stagger.visible { opacity: 1; transform: translateY(0); }
/* Stagger delay per card */
.reveal-stagger:nth-child(1) { transition-delay: 0s; }
.reveal-stagger:nth-child(2) { transition-delay: 0.1s; }
.reveal-stagger:nth-child(3) { transition-delay: 0.2s; }
.reveal-stagger:nth-child(4) { transition-delay: 0.3s; }
```

### Pulse / Breathing Effect
```css
@keyframes pulse {
  0%, 100% { transform: scale(1); opacity: 1; }
  50% { transform: scale(1.05); opacity: 0.8; }
}
.pulse { animation: pulse 2s ease-in-out infinite; }
```

### Gradient Border Animation
```css
.gradient-border {
  position: relative;
  background: #111;
  border-radius: 16px;
  padding: 40px;
}
.gradient-border::before {
  content: '';
  position: absolute; inset: -1px;
  border-radius: 17px;
  background: linear-gradient(135deg, #6c5ce7, #00cec9, #6c5ce7);
  background-size: 300% 300%;
  z-index: -1;
  animation: borderRotate 3s ease infinite;
}
@keyframes borderRotate {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}
```

### Typewriter Effect
```css
.typewriter {
  overflow: hidden;
  white-space: nowrap;
  border-right: 2px solid #6c5ce7;
  animation: typing 3s steps(30) forwards, blink 0.7s step-end infinite;
  width: 0;
}
@keyframes typing { to { width: 100%; } }
@keyframes blink { 50% { border-color: transparent; } }
```

### Floating / Levitate
```css
@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}
.float { animation: float 3s ease-in-out infinite; }
```

### Smooth Hover Transitions
```css
/* Card hover — always use these together */
.card {
  transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
}
.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 0 30px rgba(108, 92, 231, 0.1);
  border-color: rgba(108, 92, 231, 0.3);
}

/* Button hover */
.btn {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 30px rgba(108, 92, 231, 0.3);
}

/* Link hover */
a { transition: color 0.3s ease; }
```

## JavaScript Animations

### Cursor Glow Effect
```html
<div class="cursor-glow" id="glow"></div>

<style>
.cursor-glow {
  position: fixed;
  width: 400px; height: 400px;
  background: radial-gradient(circle, rgba(108,92,231,0.08), transparent 70%);
  border-radius: 50%;
  pointer-events: none;
  z-index: 0;
  transform: translate(-50%, -50%);
  transition: left 0.3s ease, top 0.3s ease;
}
@media (max-width: 768px) { .cursor-glow { display: none; } }
</style>

<script>
const glow = document.getElementById('glow');
if (window.innerWidth > 768) {
  document.addEventListener('mousemove', e => {
    glow.style.left = e.clientX + 'px';
    glow.style.top = e.clientY + 'px';
  });
}
</script>
```

### Animated Counter (Count Up)
```javascript
function animateCount(element, target, duration = 2000) {
  const start = performance.now();
  function update(now) {
    const progress = Math.min((now - start) / duration, 1);
    element.textContent = Math.floor(progress * target);
    if (progress < 1) requestAnimationFrame(update);
    else element.textContent = target;
  }
  requestAnimationFrame(update);
}

// Trigger when element scrolls into view
const observer = new IntersectionObserver((entries) => {
  entries.forEach(e => {
    if (e.isIntersecting) {
      animateCount(e.target, parseInt(e.target.dataset.target));
      observer.unobserve(e.target);
    }
  });
}, { threshold: 0.5 });
document.querySelectorAll('[data-target]').forEach(el => observer.observe(el));
```

### Live Countdown / Count-up Timer
```javascript
function updateTimer() {
  const start = new Date('2026-01-15T00:00:00Z'); // event date
  const now = new Date();
  const diff = now - start; // for count-up (swap for countdown)
  const days = Math.floor(diff / 86400000);
  const hours = Math.floor((diff % 86400000) / 3600000);
  const mins = Math.floor((diff % 3600000) / 60000);
  document.getElementById('timer').textContent = `${days}d ${hours}h ${mins}m`;
}
updateTimer();
setInterval(updateTimer, 60000);
```

### Parallax Scroll Effect
```javascript
window.addEventListener('scroll', () => {
  const scrolled = window.pageYOffset;
  document.querySelector('.parallax-bg').style.transform =
    `translateY(${scrolled * 0.5}px)`;
});
```

## Performance Tips

1. **Use `transform` and `opacity` for animations** — they don't trigger layout reflows
2. **Never animate `width`, `height`, `top`, `left`** — use `transform: translate/scale` instead
3. **Use `will-change: transform`** sparingly on elements that will animate
4. **Disable animations on mobile** when they add lag — use `@media (max-width: 768px)` to remove
5. **Use `IntersectionObserver`** instead of scroll event listeners for reveal effects
6. **Keep animations under 0.5s** for UI interactions, 2-3s for decorative effects
