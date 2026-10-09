// ====================================================================
//  PARTICIPANTE 3 (Sandra)  |  Figuras que laten segun el BPM de un CSV
//  Archivos necesarios en la carpeta "data" de la galeria:
//    horse-svgrepo-com.svg, dog-svgrepo-com.svg,
//    heart-love-like-favourite-follow-svgrepo-com.svg,
//    Sinte clase bpm.mp3, mightuser-gentle-ocean-waves-1-300837.mp3,
//    Sandra_BPM_20261005_175505.csv
// ====================================================================
class Participante3 extends Celda {

  // ---------- Variables propias ----------
  float a1 = 0.0, a2 = 0.0, a3 = 0.0;          // angulos del latido
  float bpm1 = 60, bpm2 = 60, bpm3 = 60;       // BPM de cada figura (vienen del CSV)

  float x1, y1, vx1, vy1;
  float x2, y2, vx2, vy2;
  float x3, y3, vx3, vy3;

  PShape figura1, figura2, figura3;
  SoundFile musicaFondo, otrofondo;

  float[] datosBpm;              // columna "bpm" del CSV
  float bpmMin, bpmMax;
  float segundosPorDato = 1.0;
  int tAnterior = 0;

  Participante3() {
    super("Sandra");
  }

  // Equivale al setup() original
  void iniciar() {
    g.noStroke();
    g.shapeMode(CENTER);
    g.colorMode(HSB, 330, 68, 95);

    figura1 = loadShape("horse-svgrepo-com.svg");
    figura2 = loadShape("dog-svgrepo-com.svg");
    figura3 = loadShape("heart-love-like-favourite-follow-svgrepo-com.svg");

    // Solo se CARGAN aqui; se reproducen en sonar(true)
    musicaFondo = new SoundFile(app, "Sinte clase bpm.mp3");
    otrofondo   = new SoundFile(app, "mightuser-gentle-ocean-waves-1-300837.mp3");

    // ---- CARGAR LA TABLA DE BPMS ----
    Table tabla = loadTable("Sandra_BPM_20261005_175505.csv", "header");
    int n = tabla.getRowCount();
    datosBpm = new float[n];
    for (int i = 0; i < n; i++) {
      datosBpm[i] = tabla.getFloat(i, "bpm");
    }
    bpmMin = min(datosBpm);
    bpmMax = max(datosBpm);
    println("Sandra -> datos leidos: " + n + " | BPM min: " + bpmMin + " | BPM max: " + bpmMax);

    bpm1 = datosBpm[0];
    bpm2 = datosBpm[0];
    bpm3 = datosBpm[0];

    // ---- Posiciones iniciales (w y h en lugar de width y height) ----
    x1 = w * 0.25;  y1 = h * 0.5;
    x2 = w * 0.75;  y2 = h * 0.5;
    x3 = w * 0.5;   y3 = h * 0.25;

    // ---- Velocidades iniciales ----
    vx1 = 1.0;   vy1 = 1.0;
    vx2 = -1.0;  vy2 = 1.0;
    vx3 = -1.0;  vy3 = 1.0;

    tAnterior = millis();
  }

  // Equivale al draw() original
  void dibujar() {
    g.background(0, 0, 100);

    float t = millis() / 1000.0;
    float dt = (millis() - tAnterior) / 1000.0;
    tAnterior = millis();

    // ---------- 0. LEER EL BPM ACTUAL DEL CSV ----------
    float posicion = t / segundosPorDato;
    int i = int(posicion) % datosBpm.length;
    int siguiente = (i + 1) % datosBpm.length;
    float fraccion = posicion - floor(posicion);
    float bpmActual = lerp(datosBpm[i], datosBpm[siguiente], fraccion);

    bpm1 = bpmActual;
    bpm2 = bpmActual;
    bpm3 = bpmActual;

    // ---------- 1. EL LATIDO ----------
    a1 += TWO_PI * (bpm1 / 60.0) * dt;
    a2 += TWO_PI * (bpm2 / 60.0) * dt;
    a3 += TWO_PI * (bpm3 / 60.0) * dt;

    float s1 = map(cos(a1), -1, 1, 0.5, 2.5);
    float s2 = map(cos(a2), -1, 1, 0.5, 2.5);
    float s3 = map(cos(a3), -1, 1, 0.5, 2.5);

    // ---------- 2. VELOCIDADES SEGUN EL BPM ----------
    vx1 = signo(vx1) * map(bpm1, bpmMin, bpmMax, 1.0, 3.0);
    vy1 = signo(vy1) * map(bpm1, bpmMin, bpmMax, 0.8, 2.4);
    vx2 = signo(vx2) * map(bpm2, bpmMin, bpmMax, 1.0, 3.0);
    vy2 = signo(vy2) * map(bpm2, bpmMin, bpmMax, 0.8, 2.4);
    vx3 = signo(vx3) * map(bpm3, bpmMin, bpmMax, 1.0, 3.0);
    vy3 = signo(vy3) * map(bpm3, bpmMin, bpmMax, 0.8, 2.4);

    // ---------- 3. MOVIMIENTO ----------
    x1 += vx1;  y1 += vy1;
    x2 += vx2;  y2 += vy2;
    x3 += vx3;  y3 += vy3;

    // ---------- 4. REBOTES ----------
    float m1 = 25 * s1;
    float m2 = 25 * s2;
    float m3 = 25 * s3;

    if (x1 < m1 || x1 > w - m1)  vx1 *= -1;
    if (y1 < m1 || y1 > h - m1)  vy1 *= -1;
    if (x2 < m2 || x2 > w - m2)  vx2 *= -1;
    if (y2 < m2 || y2 > h - m2)  vy2 *= -1;
    if (x3 < m3 || x3 > w - m3)  vx3 *= -1;
    if (y3 < m3 || y3 > h - m3)  vy3 *= -1;

    x1 = constrain(x1, m1, w - m1);
    y1 = constrain(y1, m1, h - m1);
    x2 = constrain(x2, m2, w - m2);
    y2 = constrain(y2, m2, h - m2);
    x3 = constrain(x3, m3, w - m3);
    y3 = constrain(y3, m3, h - m3);

    // ---------- 5. COLOR ----------
    float tonoRojo = 0;     // figura 1
    float tonoAzul = 200;   // figuras 2 y 3

    float sat1 = map(s1, 0.5, 2.5, 20, 100);
    float sat2 = map(s2, 0.5, 2.5, 20, 100);
    float sat3 = map(s3, 0.5, 2.5, 20, 100);

    // ---------- 6. FIGURA 1 ----------
    g.pushMatrix();
    g.translate(x1, y1);
    g.scale(s1);
    g.fill(tonoRojo, sat1, 100);
    g.shape(figura1, 30, 30, 50, 50);
    g.popMatrix();

    // ---------- 7. FIGURA 2 ----------
    g.pushMatrix();
    g.translate(x2, y2);
    g.scale(s2);
    g.fill(tonoAzul, sat2, 100);
    g.shape(figura2, 0, 0, 50, 50);
    g.popMatrix();

    // ---------- 8. FIGURA 3 ----------
    g.pushMatrix();
    g.translate(x3, y3);
    g.scale(s3);
    g.fill(tonoAzul, sat3, 100);
    g.shape(figura3, 0, 0, 50, 50);
    g.popMatrix();

    // ---------- 9. TEXTOS ----------
    g.fill(0, 0, 0);
    g.textSize(18);
    g.text("BPM actual (latidos): " + nf(bpmActual, 0, 1), 230, 25);
    g.textAlign(RIGHT, CENTER);
    g.text(autor, 93, 10);          // autor = "Sandra" (definido en el constructor)
  }

  // El audio solo suena cuando el raton esta sobre esta celda
  void sonar(boolean activo) {
    if (activo) {
      musicaFondo.loop();
      musicaFondo.amp(0.1);
      otrofondo.loop();
      otrofondo.amp(0.02);
    } else {
      musicaFondo.stop();
      otrofondo.stop();
    }
  }

  // Funcion auxiliar: 1 si es positivo o cero, -1 si es negativo
  float signo(float v) {
    if (v < 0) {
      return -1;
    } else {
      return 1;
    }
  }
}
