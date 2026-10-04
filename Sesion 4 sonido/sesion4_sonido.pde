// ============================================================
// SESIÓN 4 · Sonido
// Objetivo: que cada latido haga sonar una nota. El rango de BPM
// decide qué tan grave/aguda es y con qué "timbre" suena.
// Requiere la biblioteca Sound de Processing.
// ============================================================

import processing.sound.*;   // carga la biblioteca de sonido

float bpm = 72;
float ultimoLatido = 0;
float angulo = 0;
float brillo = 0;            // se enciende en cada latido y se apaga solo

// --- INSTRUMENTOS ---
// Una "onda" es un generador de sonido.
SinOsc ondaSuave;            // sonido redondo y dulce
TriOsc ondaBrillante;        // sonido más brillante
// Una "envolvente" hace que el sonido nazca y se apague rápido,
// como un golpecito, en vez de sonar sin parar.
Env envolventeSuave;
Env envolventeBrillante;

// Escala pentatónica: 5 notas que siempre suenan bien juntas.
// Son distancias (en semitonos) desde la nota base: Do, Re, Mi, Sol, La.
int[] escala = {0, 2, 4, 7, 9};

void setup() {
  size(800, 600);
  colorMode(HSB, 360, 100, 100, 100);
  textAlign(CENTER);

  // Creamos los instrumentos. "this" significa "este programa".
  ondaSuave = new SinOsc(this);
  ondaBrillante = new TriOsc(this);
  envolventeSuave = new Env(this);
  envolventeBrillante = new Env(this);
}

void draw() {
  bpm = map(mouseX, 0, width, 60, 180);

  // --- RANGO (como en la sesión 3, pero ahora también decide el sonido) ---
  int rango;          // número de rango: 0 a 4
  float tono;
  int octava;         // 0 = grave, 1 = medio, 2 = agudo
  if (bpm < 60) {
    rango = 0; tono = 240; octava = 0;
  } else if (bpm < 80) {
    rango = 1; tono = 190; octava = 1;
  } else if (bpm < 100) {
    rango = 2; tono = 90;  octava = 1;
  } else if (bpm < 130) {
    rango = 3; tono = 40;  octava = 2;
  } else {
    rango = 4; tono = 0;   octava = 2;
  }

  // --- EL LATIDO ---
  float intervalo = 60000.0 / bpm;
  if (millis() - ultimoLatido >= intervalo) {
    ultimoLatido = ultimoLatido + intervalo;
    brillo = 100;                          // ¡destello!

    // === AQUÍ SUENA LA NOTA ===
    // 1) Elegimos una nota. 48 es el Do grave; sumamos 12 por cada octava
    //    y una nota al azar de la escala pentatónica.
    int nota = 48 + 12 * octava + escala[int(random(5))];

    // 2) Convertimos la nota (número MIDI) en frecuencia (Hz).
    float frecuencia = 440 * pow(2, (nota - 69) / 12.0);

    // 3) Según el rango elegimos el instrumento.
    //    play(frecuencia, volumen) prepara el sonido;
    //    envolvente.play(...) lo dispara como un golpecito.
    if (rango <= 1) {
      ondaSuave.play(frecuencia, 0.5);
      envolventeSuave.play(ondaSuave, 0.01, 0.02, 0.5, 0.4);
    } else {
      ondaBrillante.play(frecuencia, 0.3);
      envolventeBrillante.play(ondaBrillante, 0.005, 0.02, 0.5, 0.25);
    }
  }

  float fase = constrain((millis() - ultimoLatido) / intervalo, 0, 1);
  float radio = 50 + 70 * pow(1 - fase, 3);
  brillo = brillo * 0.92;                  // el destello se apaga poco a poco

  angulo = angulo + map(bpm, 40, 180, 0.008, 0.05);
  float x = width / 2 + 250 * cos(angulo);
  float y = height / 2 + 150 * sin(angulo * 1.5);

  // --- DIBUJAR ---
  noStroke();
  fill(0, 0, 5, 20);
  rect(0, 0, width, height);

  fill(tono, 80 - brillo * 0.5, 70 + brillo * 0.3);
  ellipse(x, y, radio * 2, radio * 2);

  fill(0, 0, 100);
  textSize(28);
  text(int(bpm) + " BPM", width / 2, 50);
}

// ------------------------------------------------------------
// PUNTOS DE EXPERIMENTACIÓN
//  1. La escala: {0, 2, 4, 7, 9} → prueba {0, 3, 5, 7, 10} (otra pentatónica,
//     más "bluesera") o {0, 2, 4, 5, 7, 9, 11} (¡escala completa!, y cambia random(5) por random(7)).
//  2. La nota base: 48 → prueba 36 (muy grave) o 60.
//  3. La duración del eco: el último número de envolvente.play(...) (0.4) → prueba 0.05 y 1.5.
//  4. El volumen: 0.5 → prueba 0.1 y 0.9.
//  5. El umbral de timbre: if (rango <= 1) → prueba rango <= 3.
// ------------------------------------------------------------
