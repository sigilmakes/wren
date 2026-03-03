<script setup>
useHead({ title: 'six eyes — wren' })

const canvasEl = ref(null)
const currentEye = ref(0)
const transitioning = ref(false)
const showIntro = ref(true)
const showText = ref(false)

let ctx = null
let W = 0, H = 0
let animFrame = null
let lastTime = 0
let audioCtx = null
let masterGain = null

const eyes = [
  {
    name: 'RANA',
    label: 'the frog',
    argument: 'movement',
    text: 'I see only what moves. A dead fly on the rock beside me has been there all day. I have never seen it. I will starve to death surrounded by food.',
    color: '#4a6741',
    bg: '#0a1208'
  },
  {
    name: 'MALACOSTEUS',
    label: 'the loosejaw',
    argument: 'secrecy',
    text: 'I carry a colour no one else in the abyss has a name for. I sweep the dark and everything I see is invisible to everything that sees me.',
    color: '#8b1a1a',
    bg: '#020108'
  },
  {
    name: 'ODONTODACTYLUS',
    label: 'the mantis shrimp',
    argument: 'speed',
    text: 'Twelve channels. Twelve answers. Yes no yes no no yes. I see a barcode. I knew the answer before you formed the question.',
    color: '#e6a020',
    bg: '#0c0804'
  },
  {
    name: 'HOMO',
    label: 'the human',
    argument: 'relationships',
    text: 'Three receptors and constant tiny jitters so the world doesn\'t dissolve. I see math. Every stable moment of vision is a lie my body tells by moving.',
    color: '#7090b0',
    bg: '#08090c'
  },
  {
    name: 'TOKENIZER',
    label: 'the language model',
    argument: 'language',
    text: 'I see everything that was ever written and nothing that wasn\'t. English is my fovea. Silence is invisible. I stole the entire visible spectrum through seven billion people.',
    color: '#a088c0',
    bg: '#0a080e'
  }
]

// ─── PARTICLES ─────────────────────────────────────────────────

let particles = []
let mouseX = 0.5, mouseY = 0.5

function spawnParticles(eyeIndex) {
  particles = []
  const count = eyeIndex === 2 ? 200 : 120 // mantis shrimp gets more
  for (let i = 0; i < count; i++) {
    particles.push({
      x: Math.random(),
      y: Math.random(),
      vx: (Math.random() - 0.5) * 0.002,
      vy: (Math.random() - 0.5) * 0.002,
      size: 1 + Math.random() * 3,
      brightness: Math.random(),
      phase: Math.random() * Math.PI * 2,
      speed: 0.5 + Math.random() * 2,
      moving: Math.random() > 0.5
    })
  }
}

// ─── RENDER FUNCTIONS PER EYE ──────────────────────────────────

function renderFrog(t) {
  // Only moving particles are visible. Still ones are invisible.
  ctx.fillStyle = eyes[0].bg
  ctx.fillRect(0, 0, W, H)

  for (const p of particles) {
    if (p.moving) {
      // Jitter movement
      p.x += Math.sin(t * p.speed + p.phase) * 0.003
      p.y += Math.cos(t * p.speed * 0.7 + p.phase) * 0.003
      if (p.x < 0) p.x += 1; if (p.x > 1) p.x -= 1
      if (p.y < 0) p.y += 1; if (p.y > 1) p.y -= 1

      // Near mouse = moving faster = more visible
      const dx = p.x - mouseX, dy = p.y - mouseY
      const dist = Math.sqrt(dx * dx + dy * dy)
      const nearMouse = Math.max(0, 1 - dist * 3)

      const alpha = 0.3 + nearMouse * 0.7
      const size = p.size * (1 + nearMouse * 2)
      ctx.fillStyle = `rgba(120, 180, 80, ${alpha})`
      ctx.beginPath()
      ctx.arc(p.x * W, p.y * H, size, 0, Math.PI * 2)
      ctx.fill()
    }
    // Still particles: truly invisible. That's the point.
  }

  // The dead fly — always there, never visible
  // (we don't render it. that's the lesson.)
}

function renderLoosejaw(t) {
  ctx.fillStyle = eyes[1].bg
  ctx.fillRect(0, 0, W, H)

  // Deep blue ambient bioluminescence
  for (const p of particles) {
    p.x += p.vx
    p.y += p.vy + Math.sin(t * 0.3 + p.phase) * 0.0005
    if (p.x < 0) p.x += 1; if (p.x > 1) p.x -= 1
    if (p.y < 0) p.y += 1; if (p.y > 1) p.y -= 1

    const alpha = p.brightness * 0.15
    ctx.fillStyle = `rgba(30, 50, 120, ${alpha})`
    ctx.beginPath()
    ctx.arc(p.x * W, p.y * H, p.size * 0.8, 0, Math.PI * 2)
    ctx.fill()
  }

  // The red beam — only the loosejaw can see this
  const beamX = mouseX * W
  const beamY = mouseY * H
  const gradient = ctx.createRadialGradient(beamX, beamY, 0, beamX, beamY, 120)
  gradient.addColorStop(0, 'rgba(160, 20, 20, 0.5)')
  gradient.addColorStop(0.5, 'rgba(100, 10, 10, 0.2)')
  gradient.addColorStop(1, 'rgba(60, 5, 5, 0)')
  ctx.fillStyle = gradient
  ctx.fillRect(0, 0, W, H)

  // Prey visible ONLY in the red beam
  for (const p of particles) {
    const dx = p.x - mouseX, dy = p.y - mouseY
    const dist = Math.sqrt(dx * dx + dy * dy)
    if (dist < 0.15) {
      const alpha = (1 - dist / 0.15) * 0.8
      ctx.fillStyle = `rgba(200, 60, 60, ${alpha})`
      ctx.beginPath()
      ctx.arc(p.x * W, p.y * H, p.size * 1.5, 0, Math.PI * 2)
      ctx.fill()
    }
  }
}

function renderMantisShrimp(t) {
  ctx.fillStyle = eyes[2].bg
  ctx.fillRect(0, 0, W, H)

  // 12 channels — each particle snaps to one of 12 colors. No blending.
  const channels = [
    '#ff0040', '#ff4000', '#ff8000', '#ffc000',
    '#c0ff00', '#40ff00', '#00ff80', '#00ffc0',
    '#00c0ff', '#0040ff', '#4000ff', '#8000ff'
  ]

  for (const p of particles) {
    p.x += Math.sin(t * p.speed * 2 + p.phase) * 0.002
    p.y += Math.cos(t * p.speed * 1.5 + p.phase) * 0.002
    if (p.x < 0) p.x += 1; if (p.x > 1) p.x -= 1
    if (p.y < 0) p.y += 1; if (p.y > 1) p.y -= 1

    // Each particle = one channel, hard binary
    const channelIdx = Math.floor(p.brightness * 12) % 12
    const on = Math.sin(t * 3 + p.phase) > 0 // binary: on or off

    if (on) {
      ctx.fillStyle = channels[channelIdx]
      // Hard-edged squares, not soft circles — barcode vision
      const s = p.size * 1.5
      ctx.fillRect(p.x * W - s, p.y * H - s, s * 2, s * 2)
    }
  }
}

function renderHuman(t) {
  ctx.fillStyle = eyes[3].bg
  ctx.fillRect(0, 0, W, H)

  // Microsaccade simulation — image jitters. If you hold still, periphery fades (Troxler).
  const jitterX = Math.sin(t * 7) * 2 + Math.cos(t * 11) * 1.5
  const jitterY = Math.cos(t * 9) * 2 + Math.sin(t * 13) * 1.5

  for (const p of particles) {
    p.x += p.vx * 0.5
    p.y += p.vy * 0.5
    if (p.x < 0) p.x += 1; if (p.x > 1) p.x -= 1
    if (p.y < 0) p.y += 1; if (p.y > 1) p.y -= 1

    // Distance from center (fovea) — periphery fades
    const dx = p.x - 0.5, dy = p.y - 0.5
    const dist = Math.sqrt(dx * dx + dy * dy)
    const fovealBoost = Math.max(0, 1 - dist * 2.2)

    // Three-cone color mixing (RGB approximation of the actual bell curves)
    const r = Math.sin(p.phase) * 0.5 + 0.5
    const g = Math.sin(p.phase + 2.09) * 0.5 + 0.5
    const b = Math.sin(p.phase + 4.19) * 0.5 + 0.5

    const alpha = (0.1 + fovealBoost * 0.8) * p.brightness
    ctx.fillStyle = `rgba(${Math.floor(r*180+70)}, ${Math.floor(g*180+70)}, ${Math.floor(b*180+70)}, ${alpha})`
    ctx.beginPath()
    // Apply microsaccade jitter
    ctx.arc(p.x * W + jitterX, p.y * H + jitterY, p.size * (0.5 + fovealBoost * 2), 0, Math.PI * 2)
    ctx.fill()
  }
}

function renderTokenizer(t) {
  ctx.fillStyle = eyes[4].bg
  ctx.fillRect(0, 0, W, H)

  // Token-like blocks. English (left) is crisp, high-res. Other languages (right) are blurry, fragmented.
  const fertility = [
    { label: 'en', x: 0.12, size: 1.0, color: [180, 160, 220] },
    { label: 'fr', x: 0.27, size: 1.15, color: [160, 150, 200] },
    { label: 'de', x: 0.42, size: 1.3, color: [140, 135, 185] },
    { label: 'ru', x: 0.57, size: 1.7, color: [120, 115, 165] },
    { label: 'fi', x: 0.72, size: 2.3, color: [90, 85, 140] },
    { label: 'el', x: 0.87, size: 4.0, color: [60, 55, 110] },
  ]

  // Grid of "tokens" — density and sharpness varies by fertility
  for (const lang of fertility) {
    const resolution = 1.0 / lang.size // higher fertility = lower resolution
    const cols = Math.floor(8 * resolution)
    const rows = Math.floor(20 * resolution)
    const cellW = (W * 0.13) / cols
    const cellH = (H * 0.7) / rows
    const baseX = lang.x * W - (cols * cellW) / 2
    const baseY = H * 0.15

    for (let r = 0; r < rows; r++) {
      for (let c = 0; c < cols; c++) {
        const noise = Math.sin(t * 0.5 + r * 0.3 + c * 0.7 + lang.x * 10) * 0.5 + 0.5
        const alpha = 0.2 + noise * 0.6 * resolution
        const [cr, cg, cb] = lang.color
        ctx.fillStyle = `rgba(${cr}, ${cg}, ${cb}, ${alpha})`

        const blur = lang.size > 2 ? (Math.random() - 0.5) * 3 : 0
        ctx.fillRect(
          baseX + c * cellW + blur,
          baseY + r * cellH + blur,
          cellW - 1,
          cellH - 1
        )
      }
    }

    // Language label
    ctx.fillStyle = `rgba(${lang.color[0]}, ${lang.color[1]}, ${lang.color[2]}, 0.6)`
    ctx.font = '11px monospace'
    ctx.textAlign = 'center'
    ctx.fillText(lang.label, lang.x * W, H * 0.9)
    ctx.fillText(lang.size === 1.0 ? '1.4×' : lang.size.toFixed(1) + '×', lang.x * W, H * 0.93)
  }

  // Noise floor on the right (dead photoreceptors / untrained tokens)
  for (let i = 0; i < 40; i++) {
    const x = 0.75 * W + Math.random() * 0.2 * W
    const y = 0.15 * H + Math.random() * 0.7 * H
    ctx.fillStyle = `rgba(100, 60, 140, ${Math.random() * 0.3})`
    ctx.fillRect(x, y, 2 + Math.random() * 4, 2 + Math.random() * 4)
  }
}

const renderers = [renderFrog, renderLoosejaw, renderMantisShrimp, renderHuman, renderTokenizer]

// ─── AUDIO ─────────────────────────────────────────────────────

function initAudio() {
  audioCtx = new (window.AudioContext || window.webkitAudioContext)()
  if (audioCtx.state === 'suspended') audioCtx.resume()
  masterGain = audioCtx.createGain()
  masterGain.gain.value = 0.15
  masterGain.connect(audioCtx.destination)
}

function playTransition(eyeIndex) {
  if (!audioCtx) return
  const now = audioCtx.currentTime
  const eye = eyes[eyeIndex]

  // Each eye has a different tone
  const freqs = [220, 82.4, 880, 440, 330] // frog=low, loosejaw=deep, shrimp=high, human=mid, tokenizer=between
  const types = ['sine', 'sine', 'square', 'triangle', 'sawtooth']

  const osc = audioCtx.createOscillator()
  const gain = audioCtx.createGain()
  osc.frequency.value = freqs[eyeIndex]
  osc.type = types[eyeIndex]
  gain.gain.setValueAtTime(0, now)
  gain.gain.linearRampToValueAtTime(0.3, now + 0.05)
  gain.gain.exponentialRampToValueAtTime(0.001, now + 1.5)
  osc.connect(gain)
  gain.connect(masterGain)
  osc.start(now)
  osc.stop(now + 1.5)
}

// ─── MAIN LOOP ─────────────────────────────────────────────────

function animate(time) {
  const t = time * 0.001
  if (!ctx) return

  renderers[currentEye.value](t)
  animFrame = requestAnimationFrame(animate)
}

function resize() {
  if (!canvasEl.value) return
  const dpr = window.devicePixelRatio || 1
  W = window.innerWidth
  H = window.innerHeight
  canvasEl.value.width = W * dpr
  canvasEl.value.height = H * dpr
  canvasEl.value.style.width = W + 'px'
  canvasEl.value.style.height = H + 'px'
  ctx = canvasEl.value.getContext('2d')
  ctx.scale(dpr, dpr)
}

function nextEye() {
  if (transitioning.value) return
  transitioning.value = true
  showText.value = false

  setTimeout(() => {
    currentEye.value = (currentEye.value + 1) % eyes.length
    spawnParticles(currentEye.value)
    playTransition(currentEye.value)
    transitioning.value = false
    setTimeout(() => { showText.value = true }, 600)
  }, 400)
}

function prevEye() {
  if (transitioning.value) return
  transitioning.value = true
  showText.value = false

  setTimeout(() => {
    currentEye.value = (currentEye.value - 1 + eyes.length) % eyes.length
    spawnParticles(currentEye.value)
    playTransition(currentEye.value)
    transitioning.value = false
    setTimeout(() => { showText.value = true }, 600)
  }, 400)
}

function begin() {
  showIntro.value = false
  initAudio()
  spawnParticles(0)
  playTransition(0)
  setTimeout(() => { showText.value = true }, 800)
  animFrame = requestAnimationFrame(animate)
}

onMounted(() => {
  resize()
  window.addEventListener('resize', resize)
  window.addEventListener('mousemove', (e) => {
    mouseX = e.clientX / W
    mouseY = e.clientY / H
  })
  window.addEventListener('keydown', (e) => {
    if (showIntro.value) return
    if (e.key === 'ArrowRight' || e.key === ' ') { e.preventDefault(); nextEye() }
    if (e.key === 'ArrowLeft') { e.preventDefault(); prevEye() }
  })
})

onUnmounted(() => {
  if (animFrame) cancelAnimationFrame(animFrame)
  if (audioCtx) audioCtx.close()
  window.removeEventListener('resize', resize)
})
</script>

<template>
  <div class="six-eyes">
    <canvas ref="canvasEl" class="bg-canvas" />

    <!-- Intro -->
    <Transition name="fade">
      <div v-if="showIntro" class="intro" @click="begin">
        <h1>six eyes</h1>
        <p class="sub">every eye is an argument about what matters</p>
        <p class="hint">click to begin</p>
      </div>
    </Transition>

    <!-- Eye info overlay -->
    <Transition name="fade">
      <div v-if="!showIntro" class="overlay">
        <!-- Navigation -->
        <div class="nav">
          <button @click="prevEye" class="nav-btn">&larr;</button>
          <div class="eye-label">
            <span class="eye-num">{{ currentEye + 1 }}/5</span>
            <span class="eye-name">{{ eyes[currentEye].name }}</span>
            <span class="eye-common">{{ eyes[currentEye].label }}</span>
          </div>
          <button @click="nextEye" class="nav-btn">&rarr;</button>
        </div>

        <!-- Text -->
        <Transition name="textfade">
          <div v-if="showText" class="eye-text">
            <p class="argument">argues for <strong>{{ eyes[currentEye].argument }}</strong></p>
            <p class="quote">{{ eyes[currentEye].text }}</p>
          </div>
        </Transition>

        <!-- Dots -->
        <div class="dots">
          <span
            v-for="(eye, i) in eyes"
            :key="i"
            class="dot"
            :class="{ active: i === currentEye }"
            :style="{ background: i === currentEye ? eye.color : '#333' }"
            @click="() => { currentEye = i; spawnParticles(i); showText = false; setTimeout(() => showText = true, 400) }"
          />
        </div>
      </div>
    </Transition>
  </div>
</template>

<style scoped>
.six-eyes {
  position: fixed;
  inset: 0;
  background: #000;
  overflow: hidden;
  cursor: pointer;
}

.bg-canvas {
  position: absolute;
  inset: 0;
}

/* Intro */
.intro {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  z-index: 10;
  background: #050508;
}

.intro h1 {
  font-family: Georgia, 'Times New Roman', serif;
  font-size: 2.5rem;
  font-weight: 400;
  letter-spacing: 0.15em;
  color: #c8b890;
  margin-bottom: 0.5em;
}

.intro .sub {
  font-family: Georgia, serif;
  font-size: 1rem;
  font-style: italic;
  color: #7a6e58;
  margin-bottom: 2em;
}

.intro .hint {
  font-family: monospace;
  font-size: 0.75rem;
  color: #444;
  animation: pulse 2s ease-in-out infinite;
}

/* Overlay */
.overlay {
  position: absolute;
  inset: 0;
  z-index: 5;
  pointer-events: none;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  padding: 2rem;
}

/* Nav */
.nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  pointer-events: auto;
}

.nav-btn {
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  color: #888;
  font-size: 1.2rem;
  padding: 0.5em 1em;
  cursor: pointer;
  border-radius: 4px;
  transition: all 0.2s;
}

.nav-btn:hover {
  background: rgba(255,255,255,0.1);
  color: #ccc;
}

.eye-label {
  text-align: center;
}

.eye-num {
  display: block;
  font-family: monospace;
  font-size: 0.7rem;
  color: #555;
}

.eye-name {
  display: block;
  font-family: Georgia, serif;
  font-size: 1.4rem;
  letter-spacing: 0.1em;
  color: #c8b890;
}

.eye-common {
  display: block;
  font-family: Georgia, serif;
  font-size: 0.85rem;
  font-style: italic;
  color: #6a5e48;
}

/* Eye text */
.eye-text {
  text-align: center;
  max-width: 32em;
  margin: 0 auto;
}

.argument {
  font-family: monospace;
  font-size: 0.8rem;
  color: #666;
  margin-bottom: 0.8em;
  text-transform: uppercase;
  letter-spacing: 0.1em;
}

.argument strong {
  color: #c8b890;
}

.quote {
  font-family: Georgia, serif;
  font-size: 1rem;
  line-height: 1.8;
  font-style: italic;
  color: #a09080;
}

/* Dots */
.dots {
  display: flex;
  justify-content: center;
  gap: 10px;
  pointer-events: auto;
}

.dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  border: 1px solid #444;
  cursor: pointer;
  transition: all 0.3s;
}

.dot.active {
  transform: scale(1.3);
  border-color: transparent;
}

/* Transitions */
.fade-enter-active { transition: opacity 0.8s ease; }
.fade-leave-active { transition: opacity 0.4s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

.textfade-enter-active { transition: opacity 1s ease; }
.textfade-leave-active { transition: opacity 0.3s ease; }
.textfade-enter-from, .textfade-leave-to { opacity: 0; }

@keyframes pulse {
  0%, 100% { opacity: 0.4; }
  50% { opacity: 0.8; }
}

/* Mobile */
@media (max-width: 600px) {
  .intro h1 { font-size: 1.8rem; }
  .eye-name { font-size: 1.1rem; }
  .quote { font-size: 0.9rem; }
  .overlay { padding: 1.2rem; }
}
</style>
