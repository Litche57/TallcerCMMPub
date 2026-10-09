// ====================================================================
//  GALERIA DE CREACIONES 
//  Lienzo 1800 x 1000  |  5 columnas x 3 filas  |  celda 360 x 333
//
//  Requiere la biblioteca Sound:
//    Sketch > Import Library > Add Library... > "Sound" (Processing Foundation)
//
//  Teclas:
//    z  -> ampliar / reducir la celda bajo el raton
//    m  -> silenciar / activar el sonido
//    r  -> reintentar las celdas que dieron error
// ====================================================================
import processing.sound.*;

final int COLS = 5, FILAS = 3, N = 15;
final int CW = 360, CH = 333;          // tamano estandar de cada celda

PApplet sketch;                        // referencia al sketch para los Participantes
Celda[] celdas = new Celda[N];
String[] errorCreacion = new String[N];

int activa = -1;                       // celda bajo el raton (suena)
int zoom = -1;                         // celda ampliada (-1 = ninguna)
boolean silencio = false;
float zs = 1, zox = 0, zoy = 0;        // escala y desplazamiento del zoom

void setup() {
  size(1800, 1000);
  frameRate(60);
  sketch = this;
  textFont(createFont("SansSerif", 12));

  for (int i = 0; i < N; i++) construir(i);
}

void draw() {
  background(0);
  calcularZoom();
  calcularActiva();

  if (zoom >= 0) dibujarZoom();
  else dibujarCuadricula();

  surface.setTitle("Galeria  |  " + nf(frameRate, 0, 1) + " fps");
}

// ------------------------------------------------------------ construccion segura
// Si el constructor de un Participante falla, solo esa celda queda marcada.
// Si todavia no hay clase para esa celda, queda gris (sin error).
void construir(int i) {
  try {
    Celda c = crearParticipante(i);
    if (c == null) {                     // celda sin entregar
      celdas[i] = null;
      errorCreacion[i] = null;
      return;
    }
    c.arrancar();
    celdas[i] = c;
    errorCreacion[i] = null;
  } catch (Exception e) {
    celdas[i] = null;
    errorCreacion[i] = "constructor: " + e;
    println("ERROR creando Participante" + nf(i + 1, 2) + ": " + e);
  }
}

// Aqui se registra cada Participante. Agrega un "case" por cada clase nueva.
Celda crearParticipante(int i) {
  switch (i) {
    case 0: return new Participante1();
    case 1: return new Participante2();
    case 2: return new Participante3();
    case 3: return new Participante4();
    case 4: return new Participante5();
    case 5: return new Participante6();
    case 6: return new Participante7();
    case 7: return new Participante8();
    case 8: return new Participante9();
    case 9: return new Participante10();
    // ... hasta case 14: return new Participante15();
  }
  return null;
}

// ------------------------------------------------------------ dibujo
void dibujarCuadricula() {
  for (int i = 0; i < N; i++) {
    int x = (i % COLS) * CW;
    int y = (i / COLS) * CH;
    dibujarCelda(i, x, y, CW, CH);
  }
}

void dibujarZoom() {
  dibujarCelda(zoom, zox, zoy, CW * zs, CH * zs);
}

void dibujarCelda(int i, float x, float y, float tw, float th) {
  Celda c = celdas[i];
  String etiqueta = "Participante " + nf(i + 1, 2);
  String msg = errorCreacion[i];

  if (c != null) {
    c.actualizar();
    image(c.g, x, y, tw, th);
    etiqueta = nf(i + 1, 2) + "  " + c.autor;
    msg = c.error;
  } else {
    noStroke();
    fill(25);
    rect(x, y, tw, th);
  }

  if (msg != null) {                       // pantalla de error
    noStroke();
    fill(130, 0, 0, 200);
    rect(x, y, tw, th);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    text("ERROR\n" + msg, x + 10, y + 10, tw - 20, th - 20);
  }

  noFill();                                // marco
  stroke(i == activa ? color(255, 200, 0) : color(70));
  strokeWeight(i == activa ? 2 : 1);
  rect(x, y, tw, th);
  strokeWeight(1);

  noStroke();                              // etiqueta
  fill(0, 150);
  rect(x + 1, y + 1, 170, 18);
  fill(255);
  textAlign(LEFT, CENTER);
  textSize(11);
  text(etiqueta, x + 6, y + 10);
}

// ------------------------------------------------------------ raton y sonido
void calcularZoom() {
  zs = min((float) width / CW, (float) height / CH);
  zox = (width - CW * zs) / 2;
  zoy = (height - CH * zs) / 2;
}

void calcularActiva() {
  int nueva = -1;
  float lx = -1, ly = -1;

  if (zoom >= 0) {
    float ax = (mouseX - zox) / zs;
    float ay = (mouseY - zoy) / zs;
    if (ax >= 0 && ax < CW && ay >= 0 && ay < CH) {
      nueva = zoom;
      lx = ax;
      ly = ay;
    }
  } else if (mouseX >= 0 && mouseY >= 0 && mouseX < COLS * CW && mouseY < FILAS * CH) {
    nueva = (mouseY / CH) * COLS + (mouseX / CW);
    lx = mouseX - (nueva % COLS) * CW;
    ly = mouseY - (nueva / COLS) * CH;
  }

  for (int i = 0; i < N; i++) {            // todos "sin raton" por defecto
    if (celdas[i] == null) continue;
    celdas[i].mx = -1;
    celdas[i].my = -1;
    celdas[i].presionado = false;
  }
  if (nueva >= 0 && celdas[nueva] != null) {
    celdas[nueva].mx = lx;
    celdas[nueva].my = ly;
    celdas[nueva].presionado = mousePressed;
  }

  if (nueva != activa) {
    if (activa >= 0 && celdas[activa] != null) celdas[activa].cambiarSonido(false);
    if (nueva >= 0 && celdas[nueva] != null && !silencio) celdas[nueva].cambiarSonido(true);
    activa = nueva;
  }
}

void keyPressed() {
  if (key == 'z' || key == 'Z') {
    if (zoom >= 0) zoom = -1;
    else if (activa >= 0) zoom = activa;
  }
  if (key == 'm' || key == 'M') {
    silencio = !silencio;
    if (activa >= 0 && celdas[activa] != null) celdas[activa].cambiarSonido(!silencio);
  }
  if (key == 'r' || key == 'R') {
    for (int i = 0; i < N; i++) {
      boolean fallo = (celdas[i] == null) || (celdas[i].error != null);
      if (fallo) construir(i);
    }
  }
}
