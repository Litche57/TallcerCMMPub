import processing.sound.*;

// Figuras que se expanden y contraen, se desplazan, cambian de color
// y suenan con notas pentatónicas al ritmo de su latido

float a1 = 0.0;
float a2 = 0.0;

int bpm1 = 100;
int bpm2 = 60;

float x1, y1, vx1, vy1;
float x2, y2, vx2, vy2;

PShape figura1;
PShape figura2;

// Escala pentatónica mayor: Do, Re, Mi, Sol, La
int[] pentatonica = {0, 2, 4, 7, 9};

Voz voz1;   // figura 1 (bpm1): registro agudo
Voz voz2;   // figura 2 (bpm2): registro grave

int ultimoLatido1 = -1;
int ultimoLatido2 = -1;

// Una "voz": tres osciladores, cada uno con su envolvente
class Voz {
  TriOsc fundamental;
  TriOsc quinta;
  SinOsc octava;
  Env envF, envQ, envO;
  int base;       // nota MIDI de la tónica de la voz
  int grado;      // posición actual dentro de la escala (0 a 9 = dos octavas)

  Voz(PApplet p, int baseMidi, int gradoInicial) {
    fundamental = new TriOsc(p);
    quinta = new TriOsc(p);
    octava = new SinOsc(p);
    envF = new Env(p);
    envQ = new Env(p);
    envO = new Env(p);
    base = baseMidi;
    grado = gradoInicial;
  }

  void tocar(float bpm) {
    // La melodía camina por la escala con saltos pequeños (suena fluida)
    grado = constrain(grado + int(random(-2, 3)), 0, 9);
    int nota = base + 12 * (grado / 5) + pentatonica[grado % 5];
    float f = midiAFrecuencia(nota);

    fundamental.freq(f);
    quinta.freq(f * 1.5);    // quinta justa
    octava.freq(f * 2.0);    // octava

    // La envolvente depende de la duración del latido:
    // BPM alto -> ataque rápido y nota corta; BPM bajo -> ataque suave y nota larga
    float duracion = 60.0 / bpm;
    float ataque   = map(bpm, 60, 100, 0.08, 0.015);
    float sostener = duracion * 0.15;
    float soltar   = duracion * 0.9;

    envF.play(fundamental, ataque, sostener, 0.30, soltar);
    envQ.play(quinta,      ataque, sostener, 0.12, soltar);
    envO.play(octava,      ataque, sostener, 0.08, soltar);
  }
}

float midiAFrecuencia(int nota) {
  return 440.0 * pow(2, (nota - 69) / 12.0);
}

void setup() {
  size(640, 360);
  noStroke();
  shapeMode(CENTER);
  frameRate(160);
  colorMode(HSB, 360, 100, 100);

  figura1 = loadShape("sun.svg");
  figura2 = loadShape("sun.svg");

  x1 = width * 0.25;
  y1 = height * 0.5;
  x2 = width * 0.75;
  y2 = height * 0.5;

  vx1 = map(bpm1, 60, 100, 1.0, 3.0);
  vy1 = map(bpm1, 60, 100, 0.8, 2.4);
  vx2 = -map(bpm2, 60, 100, 1.0, 3.0);
  vy2 = map(bpm2, 60, 100, 0.8, 2.4);

  // Figura 1 en Do5 (MIDI 72), figura 2 en Do3 (MIDI 48)
  voz1 = new Voz(this, 72, 2);
  voz2 = new Voz(this, 48, 0);
}

void draw() {
  background(0, 0, 100);   // blanco en HSB

  float t = millis() / 1000.0;
  a1 = TWO_PI * (bpm1 / 60.0) * t;
  a2 = TWO_PI * (bpm2 / 60.0) * t;

  // --- Sonido: una nota por cada latido completo ---
  int latido1 = floor(a1 / TWO_PI);
  int latido2 = floor(a2 / TWO_PI);

  if (latido1 != ultimoLatido1) {
    voz1.tocar(bpm1);
    ultimoLatido1 = latido1;
  }
  if (latido2 != ultimoLatido2) {
    voz2.tocar(bpm2);
    ultimoLatido2 = latido2;
  }

  // --- Escala ---
  float s1 = map(cos(a1), -1, 1, 0.5, 2.5);
  float s2 = map(cos(a2), -1, 1, 0.5, 2.5);

  // --- Movimiento ---
  x1 += vx1;  y1 += vy1;
  x2 += vx2;  y2 += vy2;

  float m1 = 25 * s1;
  float m2 = 25 * s2;

  if (x1 < m1 || x1 > width - m1)  vx1 *= -1;
  if (y1 < m1 || y1 > height - m1) vy1 *= -1;
  if (x2 < m2 || x2 > width - m2)  vx2 *= -1;
  if (y2 < m2 || y2 > height - m2) vy2 *= -1;

  x1 = constrain(x1, m1, width - m1);
  y1 = constrain(y1, m1, height - m1);
  x2 = constrain(x2, m2, width - m2);
  y2 = constrain(y2, m2, height - m2);

  // --- Color: tono fijo, saturación según el tamaño ---
  float sat1 = map(s1, 0.5, 2.5, 20, 100);
  float sat2 = map(s2, 0.5, 2.5, 20, 100);

  pushMatrix();
  translate(x1, y1);
  scale(s1);
  figura1.disableStyle();
  fill(0, sat1, 100);        // rojo
  shape(figura1, 0, 0, 50, 50);
  popMatrix();

  pushMatrix();
  translate(x2, y2);
  scale(s2);
  figura2.disableStyle();
  fill(220, sat2, 100);      // azul
  shape(figura2, 0, 0, 50, 50);
  popMatrix();
}
