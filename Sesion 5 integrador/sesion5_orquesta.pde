// ============================================================
// SESIÓN 5 · La orquesta
// Objetivo: reunir los latidos de TODAS las personas en una sola obra.
// Cada persona es una "voz": una figura que late, se mueve y suena
// según su BPM. Los BPM se leen del archivo data/bpms.csv
//
// TECLAS
//   R          → vuelve a leer bpms.csv (para sumar a alguien sin cerrar el programa)
//   ↑ / ↓      → sube o baja el volumen general
//
// IMPORTANTE: para proyectar, cambia size(1280, 720) por fullScreen()
// (solo se puede usar una de las dos) o usa Sketch > Presentar.
// ============================================================

import processing.sound.*;

// ----- AJUSTES GENERALES (¡aquí está casi todo para experimentar!) -----
float volumenGeneral = 0.6;                    // 0 = silencio, 1 = máximo
int[] escala = {0, 2, 4, 7, 9};                // notas pentatónicas: Do Re Mi Sol La
float[] tonos = {240, 190, 90, 40, 0};         // color de cada rango (azul → rojo)
int[] octavas = {0, 1, 1, 2, 2};               // qué tan agudo suena cada rango
String[] nombresRango = {"Reposo profundo", "Calma", "Activo", "Agitado", "Intenso"};

Voz[] voces;          // aquí guardamos a todos los participantes
Sound salida;         // controla el volumen general de la computadora

void setup() {
  size(1280, 720);    // para proyección: fullScreen();
  colorMode(HSB, 360, 100, 100, 100);
  salida = new Sound(this);
  salida.volume(0.1);
  cargarOrquesta();
}

void draw() {
  // Fondo casi negro y semitransparente: deja estelas suaves.
  noStroke();
  fill(0, 0, 4, 25);
  rect(0, 0, width, height);

  // Cada voz se actualiza (¿toca latir?) y se dibuja.
  for (int i = 0; i < voces.length; i = i + 1) {
    voces[i].actualizar();
    voces[i].dibujar();
  }

  // Leyenda de rangos, discreta, arriba a la derecha
  noStroke();
  textSize(12);
  for (int r = 0; r < 5; r = r + 1) {
    fill(tonos[r], 80, 100);
    ellipse(width - 135, 16 + r * 18, 10, 10);
    fill(0, 0, 70);
    textAlign(RIGHT, CENTER);
    text(nombresRango[r], width - 10, 16 + r * 18);
  }

  // Letrero de ayuda, discreto, abajo a la izquierda
  fill(0, 0, 50);
  textAlign(LEFT, BOTTOM);
  text("R: recargar BPM   ↑↓: volumen   voces: " + voces.length, 10, height - 6);
}

// Lee el archivo CSV y crea una voz por cada fila.
void cargarOrquesta() {
  // Si ya había voces, las callamos antes de crear las nuevas.
  if (voces != null) {
    for (int i = 0; i < voces.length; i = i + 1) {
      voces[i].callar();
    }
  }

  Table tabla = loadTable("bpms.csv", "header");
  if (tabla == null) {
    println("No encuentro data/bpms.csv. Revisa que exista la carpeta data.");
    voces = new Voz[0];
    return;
  }

  int cantidad = tabla.getRowCount();
  voces = new Voz[cantidad];

  // Repartimos las figuras en una cuadrícula que llene la pantalla.
  int columnas = ceil(sqrt(cantidad * width / float(height)));
  int filas = ceil(cantidad / float(columnas));
  float anchoCelda = width / float(columnas);
  float altoCelda = height / float(filas);

  for (int i = 0; i < cantidad; i = i + 1) {
    TableRow fila = tabla.getRow(i);
    String nombre = fila.getString("nombre");
    float bpm = fila.getFloat("bpm");

    int columna = i % columnas;          // % = "resto de dividir"
    int renglon = i / columnas;
    float x = (columna + 0.5) * anchoCelda;
    float y = (renglon + 0.5) * altoCelda;

    voces[i] = new Voz(this, nombre, bpm, x, y, min(anchoCelda, altoCelda), i, cantidad);
  }
}

// Devuelve el número de rango (0 a 4) que corresponde a un BPM.
int rangoDeBpm(float latidos) {
  if (latidos < 60) {
    return 0;
  } else if (latidos < 80) {
    return 1;
  } else if (latidos < 100) {
    return 2;
  } else if (latidos < 130) {
    return 3;
  } else {
    return 4;
  }
}

// Se ejecuta sola cuando presionas una tecla.
void keyPressed() {
  if (key == 'r' || key == 'R') {
    cargarOrquesta();
  }
  if (keyCode == UP) {
    volumenGeneral = min(1, volumenGeneral + 0.05);
    ajustarVolumen();
  }
  if (keyCode == DOWN) {
    volumenGeneral = max(0, volumenGeneral - 0.05);
    ajustarVolumen();
  }
}

// El volumen de cada voz depende de cuántas voces hay.
void ajustarVolumen() {
  for (int i = 0; i < voces.length; i = i + 1) {
    voces[i].volumen = volumenGeneral / sqrt(voces.length);
  }
}


// ============================================================
// CLASE VOZ
// Una clase es un "molde": describe cómo es y qué hace una voz.
// Con ese molde creamos una voz distinta por cada participante.
// ============================================================
class Voz {
  // ----- Lo que SABE cada voz (sus variables) -----
  String nombre;
  float bpm;
  int rango;               // 0 a 4
  float x, y;              // centro de su espacio en pantalla
  float tamCelda;          // tamaño de su espacio
  float radioBase;         // tamaño de la figura en reposo
  float angulo;            // para su movimiento
  float ultimoLatido;      // momento (ms) de su último latido
  int grado;               // qué nota de la escala toca esta voz
  float volumen;
  TriOsc onda;             // su instrumento
  Env envolvente;          // su "golpecito" de sonido

  // ----- Constructor: se ejecuta al crear una voz nueva -----
  Voz(PApplet programa, String nombre_, float bpm_, float x_, float y_, float tam_, int numero, int total) {
    nombre = nombre_;
    bpm = constrain(bpm_, 40, 200);
    rango = rangoDeBpm(bpm);
    x = x_;
    y = y_;
    tamCelda = tam_;
    radioBase = tamCelda * 0.18;
    angulo = random(TWO_PI);
    grado = numero % 5;
    volumen = volumenGeneral / sqrt(total);

    // Cada voz empieza en un momento distinto de su latido,
    // para que no suenen todas al mismo tiempo.
    ultimoLatido = millis() - random(60000.0 / bpm);

    onda = new TriOsc(programa);
    envolvente = new Env(programa);
  }

  // ----- Lo que HACE cada voz (sus funciones) -----

  // ¿Toca latir? ¿Cuánto me he movido?
  void actualizar() {
    float intervalo = 60000.0 / bpm;
    if (millis() - ultimoLatido >= intervalo) {
      ultimoLatido = ultimoLatido + intervalo;
      // Si el programa se quedó "dormido" un momento, nos re-sincronizamos.
      if (millis() - ultimoLatido >= intervalo) {
        ultimoLatido = millis();
      }
      sonar();
    }
    angulo = angulo + map(bpm, 40, 180, 0.005, 0.03);
  }

  // Toca su nota: la altura depende de su rango y de su lugar en la escala.
  void sonar() {
    int nota = 48 + 12 * octavas[rango] + escala[grado];
    float frecuencia = 440 * pow(2, (nota - 69) / 12.0);
    onda.play(frecuencia, volumen);
    envolvente.play(onda, 0.005, 0.02, 0.5, 0.3);
  }

  // Dibuja su figura: una onda que se expande y un círculo que late.
  void dibujar() {
    float intervalo = 60000.0 / bpm;
    float fase = constrain((millis() - ultimoLatido) / intervalo, 0, 1);
    float tono = tonos[rango];

    // Posición: gira despacito alrededor del centro de su espacio.
    float amplitud = tamCelda * 0.10;
    float cx = x + amplitud * cos(angulo);
    float cy = y + amplitud * sin(angulo * 1.3);

    // Onda expansiva: crece y se desvanece entre latido y latido.
    float radioOnda = radioBase + fase * tamCelda * 0.25;
    noFill();
    stroke(tono, 60, 100, (1 - fase) * 70);
    strokeWeight(3);
    ellipse(cx, cy, radioOnda * 2, radioOnda * 2);

    // Cuerpo: grande al latir, se encoge después.
    float radio = radioBase + radioBase * 0.9 * pow(1 - fase, 3);
    noStroke();
    fill(tono, 80, 100, 90);
    ellipse(cx, cy, radio * 2, radio * 2);

    // Nombre y BPM
    fill(0, 0, 100, 80);
    textAlign(CENTER, CENTER);
    textSize(max(12, tamCelda * 0.09));
    text(nombre + " · " + int(bpm), x, y + tamCelda * 0.40);
  }

  // Apaga el instrumento (se usa al recargar la lista).
  void callar() {
    onda.stop();
  }
}
