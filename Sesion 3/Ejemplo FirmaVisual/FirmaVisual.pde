// Figuras que se expanden y contraen, se desplazan y cambian de color según BPM

float a1 = 0.0;
float a2 = 0.0;

int bpm1 = 100;
int bpm2 = 60;

// Posición y velocidad de cada figura
float x1, y1, vx1, vy1;
float x2, y2, vx2, vy2;

PShape figura1;
PShape figura2;

void setup() {
  size(640, 360);
  noStroke();
  shapeMode(CENTER);
  frameRate(60);
  colorMode(HSB, 360, 100, 100);

  figura1 = loadShape("sun.svg");
  figura2 = loadShape("sun.svg");

  // Posiciones iniciales
  x1 = width * 0.25;
  y1 = height * 0.5;
  x2 = width * 0.75;
  y2 = height * 0.5;

  // Velocidades proporcionales al BPM
  vx1 = map(bpm1, 60, 100, 1.0, 3.0);
  vy1 = map(bpm1, 60, 100, 0.8, 2.4);
  vx2 = -map(bpm2, 60, 100, 1.0, 3.0);
  vy2 = map(bpm2, 60, 100, 0.8, 2.4);
}

void draw() {
  background(0, 0, 100);   
  // Cada figura late a su propio BPM:
  // frecuencia (pulsos por segundo) = bpm / 60
  // ángulo = 2*PI * frecuencia * tiempo
  float t = millis() / 1000.0;
  a1 = TWO_PI * (bpm1 / 60.0) * t;
  a2 = TWO_PI * (bpm2 / 60.0) * t;

  // Escala oscilando entre 0.5 y 2.5
  float s1 = map(cos(a1), -1, 1, 0.5, 2.5);
  float s2 = map(cos(a2), -1, 1, 0.5, 2.5);

  // Movimiento por todo el lienzo (rebotan en los bordes)
  x1 += vx1;  y1 += vy1;
  x2 += vx2;  y2 += vy2;

  float m1 = 25 * s1;  // margen según tamaño actual
  float m2 = 25 * s2;

  if (x1 < m1 || x1 > width - m1)  vx1 *= -1;
  if (y1 < m1 || y1 > height - m1) vy1 *= -1;
  if (x2 < m2 || x2 > width - m2)  vx2 *= -1;
  if (y2 < m2 || y2 > height - m2) vy2 *= -1;

  x1 = constrain(x1, m1, width - m1);
  y1 = constrain(y1, m1, height - m1);
  x2 = constrain(x2, m2, width - m2);
  y2 = constrain(y2, m2, height - m2);

    // Color en HSB: tono fijo, la saturación depende del tamaño

  float tonoRojo = 0;     // figura 1 (bpm1): rojo
  float tonoAzul = 200;   // figura 2 (bpm2): azul

  float sat1 = map(s1, 0.5, 2.5, 20, 100);
  float sat2 = map(s2, 0.5, 2.5, 20, 100);

  // Figura 1: rojo suave -> rojo intenso
  pushMatrix();
  translate(x1, y1);
  scale(s1);
  figura1.disableStyle();
  fill(tonoRojo, sat1, 100);
  shape(figura1, 0, 0, 50, 50);
  popMatrix();

  // Figura 2: azul suave -> azul intenso
  pushMatrix();
  translate(x2, y2);
  scale(s2);
  figura2.disableStyle();
  fill(tonoAzul, sat2, 100);
  shape(figura2, 0, 0, 50, 50);
  popMatrix();
}
