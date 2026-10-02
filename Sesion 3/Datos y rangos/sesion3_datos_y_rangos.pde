// ============================================================
// SESIÓN 3 · Datos y rangos
// Objetivo: convertir un dato (el BPM) en color, tamaño y velocidad,
// usando map() y if / else.
// CÓMO USARLO: mueve el mouse de izquierda a derecha para cambiar el BPM.
// ============================================================

float bpm = 72;
float ultimoLatido = 0;
float angulo = 0;          // ángulo del movimiento circular

void setup() {
  size(800, 600);
  // El cuarto número (100) permite usar transparencia en fill().
  colorMode(HSB, 360, 100, 100, 100);
  textAlign(CENTER);
}

void draw() {
  // --- 1. EL DATO ---
  // map(valor, minOrigen, maxOrigen, minDestino, maxDestino)
  // Convierte la posición del mouse (0 a width) en un BPM entre 40 y 180.
  bpm = map(mouseX, 0, width, 60, 180);

  // --- 2. EL RANGO ---
  // if / else if / else: el programa elige UNA opción según el valor del BPM.
  String nombreRango;
  float tono;
  if (bpm < 60) {
    nombreRango = "Reposo profundo";
    tono = 240;                       // azul
  } else if (bpm < 80) {
    nombreRango = "Calma";
    tono = 190;                       // turquesa
  } else if (bpm < 100) {
    nombreRango = "Activo";
    tono = 90;                        // verde
  } else if (bpm < 130) {
    nombreRango = "Agitado";
    tono = 40;                        // naranja
  } else {
    nombreRango = "Intenso";
    tono = 0;                         // rojo
  }

  // --- 3. OTRAS PROPIEDADES A PARTIR DEL BPM ---
  float velocidad = map(bpm, 40, 180, 0.008, 0.05);   // más BPM = más rápido
  float alturaLatido = map(bpm, 40, 180, 30, 90);     // más BPM = latido más fuerte
  float radioBase = 50;

  // --- 4. EL LATIDO (igual que en la sesión 2) ---
  float intervalo = 60000.0 / bpm;
  if (millis() - ultimoLatido >= intervalo) {
    ultimoLatido = ultimoLatido + intervalo;
  }
  float fase = constrain((millis() - ultimoLatido) / intervalo, 0, 1);
  float radio = radioBase + alturaLatido * pow(1 - fase, 3);

  // --- 5. EL MOVIMIENTO ---
  // cos() y sin() juntos dibujan un círculo (o una elipse).
  angulo = angulo + velocidad;
  float x = width / 2 + 250 * cos(angulo);
  float y = height / 2 + 150 * sin(angulo * 1.5);

  // --- 6. DIBUJAR ---
  // Un rectángulo casi transparente en vez de background():
  // deja una estela de los cuadros anteriores.
  noStroke();
  fill(0, 0, 5, 20);
  rect(0, 0, width, height);

  fill(tono, 80, 100);
  ellipse(x, y, radio * 2, radio * 2);

  fill(0, 0, 100);
  textSize(28);
  text(int(bpm) + " BPM  ·  " + nombreRango, width / 2, 50);
}

// ------------------------------------------------------------
// PUNTOS DE EXPERIMENTACIÓN
//  1. Los tonos de cada rango: cambia 240, 190, 90, 40, 0 por otros
//     números entre 0 y 360.
//  2. Los límites de los rangos: cambia 60, 80, 100, 130.
//  3. La estela: fill(0, 0, 5, 20) → prueba 3 (estela larga) o 80 (casi sin estela).
//  4. El movimiento: 250 y 150 son el ancho y el alto de la trayectoria.
//  5. map(bpm, 40, 180, 0.008, 0.05) → cambia 0.05 por 0.2. ¿Qué pasa?
// ------------------------------------------------------------
