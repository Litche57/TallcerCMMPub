import processing.sound.*;

// Tres ondas para una sola "voz": fundamental + quinta + octava
TriOsc fundamental;
TriOsc quinta;
SinOsc octava;
Env envolvente;

int[] pentatonica = {0, 2, 4, 7, 9};   // Do, Re, Mi, Sol, La

void setup() {
  size(400, 200);
  fundamental = new TriOsc(this);
  quinta = new TriOsc(this);
  octava = new SinOsc(this);
  envolvente = new Env(this);
}

void draw() {
  background(0);
  // el mouse simula el BPM de 60 a 100
  float bpm = map(mouseX, 0, width, 60, 100);
  fill(255);
  text(int(bpm) + " BPM", 20, 30);
}

void keyPressed() {
  float bpm = map(mouseX, 0, width, 60, 100);

  // --- 1. ARMONÍA: BPM -> escalón de la pentatónica ---
  int escalon = int(map(bpm, 60, 100, 0, 5));
  escalon = constrain(escalon, 0, 4);
  int nota = 60 + pentatonica[escalon];
  float f = 440 * pow(2, (nota - 69) / 12.0);

  // --- 2. TIMBRE: 3 ondas en intervalos consonantes ---
  fundamental.play(f, 0.4);                  // la nota tal cual
  quinta.play(f * 1.5, 0.15);                // una quinta arriba, más bajito
  octava.play(f * 2.0, 0.2);                 // una octava arriba, más bajito

  // una sola envolvente moldea las tres si suenan juntas y con el mismo ritmo
  envolvente.play(fundamental, 0.01, 0.1, 0.4, 0.6);
}
