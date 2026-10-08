// ====================================================================
// FIGURAS QUE LATEN SEGUN EL BPM DE UN ARCHIVO CSV
// La figura 1 (roja) late segun los valores de la columna "bpm" del CSV.
// La figura 2 (azul) sigue con un BPM fijo, como referencia.
//
// Los cambios respecto a la version anterior estan marcados con:
//   // >>> NUEVO    (algo que no existia)
//   // >>> CAMBIO   (algo que ya existia pero se modifico)
//
// IMPORTANTE: en la carpeta "data" del sketch deben estar:
//   - sun.svg
//   - lizzz_BPM_20261002_190120.csv
// ====================================================================


// ---------------------- VARIABLES GLOBALES ----------------------

float a1 = 0.0;
float a2 = 0.0;

// >>> CAMBIO: ahora son float (con decimales) porque el CSV trae valores
// como 78.4. Antes eran int y no podian guardar decimales.
float bpm1 = 60;     // figura 1: se actualiza con el CSV mientras corre
float bpm2 = 60;     // figura 2: fija

float x1, y1, vx1, vy1;
float x2, y2, vx2, vy2;

PShape figura1;
PShape figura2;

// >>> NUEVO: variables para trabajar con el CSV
float[] datosBpm;              // aqui guardamos TODOS los valores de la columna bpm
float bpmMin, bpmMax;          // el BPM mas bajo y el mas alto del archivo
float segundosPorDato = 1.0;   // cuanto tiempo mostramos cada valor (1 = un dato por segundo)

// >>> NUEVO: para saber cuanto tiempo paso entre un cuadro y el anterior
int tAnterior = 0;


// ---------------------- SETUP (se ejecuta UNA vez) ----------------------
void setup() {
  size(640, 360);
  noStroke();
  shapeMode(CENTER);
  frameRate(60);
  colorMode(HSB, 360, 100, 100);

  figura1 = loadShape("sun.svg");
  figura2 = loadShape("sun.svg");

  // >>> NUEVO: cargar el CSV ---------------------------------------
  // "header" le dice a Processing que la primera fila tiene los nombres
  // de las columnas (tiempo, bpm) y no son datos.
  Table tabla = loadTable("lizzz_BPM_20261002_190120.csv", "header");

  // Cuantas filas de datos hay
  int n = tabla.getRowCount();

  // Creamos una lista (array) con espacio para n numeros
  datosBpm = new float[n];

  // Recorremos fila por fila y copiamos SOLO la columna "bpm".
  // La columna "tiempo" simplemente no la leemos.
  for (int i = 0; i < n; i++) {
    datosBpm[i] = tabla.getFloat(i, "bpm");
  }

  // min() y max() buscan el menor y el mayor valor de la lista
  bpmMin = min(datosBpm);
  bpmMax = max(datosBpm);

  // Mensaje en la consola para comprobar que se leyo bien
  println("Datos leidos: " + n + "  |  BPM minimo: " + bpmMin + "  |  BPM maximo: " + bpmMax);

  // Empezamos con el primer valor del archivo
  bpm1 = datosBpm[0];
  // ---------------------------------------------------------------

  // Posiciones iniciales
  x1 = width * 0.25;
  y1 = height * 0.5;
  x2 = width * 0.75;
  y2 = height * 0.5;

  // >>> CAMBIO: la velocidad de la figura 1 ya no se calcula aqui,
  // porque ahora cambia en cada cuadro (se calcula en draw()).
  // Solo indicamos la direccion inicial: derecha (+) y hacia abajo (+).
  vx1 = 1.0;
  vy1 = 1.0;

  // La figura 2 queda igual que antes (BPM fijo)
  vx2 = -map(bpm2, 60, 100, 1.0, 3.0);
  vy2 = map(bpm2, 60, 100, 0.8, 2.4);

  // >>> NUEVO: guardamos el momento en que termino el setup
  tAnterior = millis();
}


// ---------------------- DRAW (se repite 60 veces por segundo) ----------------------
void draw() {
  background(0, 0, 100);

  float t = millis() / 1000.0;   // segundos desde que inicio el programa

  // >>> NUEVO: dt = segundos que pasaron desde el cuadro anterior
  // (normalmente ~0.016 s, o sea 1/60)
  float dt = (millis() - tAnterior) / 1000.0;
  tAnterior = millis();

  // ---------- 0. LEER EL BPM ACTUAL DEL CSV ----------   >>> NUEVO
  // posicion = en que "numero de dato" vamos, con decimales.
  // Ejemplo: a los 2.5 segundos estamos a mitad de camino entre
  // el dato 2 y el dato 3.
  float posicion = t / segundosPorDato;

  // int(...) quita los decimales -> numero del dato actual
  // % datosBpm.length hace que, al llegar al final, VUELVA AL PRINCIPIO
  // (el simbolo % es el "resto de la division").
  int i = int(posicion) % datosBpm.length;
  int siguiente = (i + 1) % datosBpm.length;

  // fraccion = que tan avanzados estamos entre un dato y el siguiente (0 a 1)
  float fraccion = posicion - floor(posicion);

  // lerp(a, b, f) da un valor intermedio entre a y b.
  // Asi el BPM cambia SUAVEMENTE de un dato a otro y no da saltos bruscos.
  bpm1 = lerp(datosBpm[i], datosBpm[siguiente], fraccion);

  // ---------- 1. EL LATIDO (calcular el tamano) ----------
  // >>> CAMBIO en a1: antes era  a1 = TWO_PI * (bpm1 / 60.0) * t;
  // Eso funcionaba con un BPM fijo, pero si el BPM cambia, el angulo
  // "salta" de golpe y la figura se mueve a tirones.
  // Ahora el angulo se ACUMULA: en cada cuadro le sumamos un pedacito
  // (segun el BPM de ese momento y el tiempo transcurrido dt).
  a1 += TWO_PI * (bpm1 / 60.0) * dt;

  // La figura 2 no cambia de BPM, asi que su formula original sirve igual
  a2 = TWO_PI * (bpm2 / 60.0) * t;

  float s1 = map(cos(a1), -1, 1, 0.5, 2.5);
  float s2 = map(cos(a2), -1, 1, 0.5, 2.5);

  // ---------- 2. LA VELOCIDAD DE LA FIGURA 1 SEGUN SU BPM ----------   >>> NUEVO
  // Si el BPM es el mas bajo del archivo -> velocidad 1.0
  // Si el BPM es el mas alto del archivo -> velocidad 3.0
  // signo(vx1) conserva la direccion actual (+ derecha, - izquierda)
  // para que no "olvide" hacia donde iba.
  vx1 = signo(vx1) * map(bpm1, bpmMin, bpmMax, 1.0, 3.0);
  vy1 = signo(vy1) * map(bpm1, bpmMin, bpmMax, 0.8, 2.4);

  // ---------- 3. EL MOVIMIENTO ----------
  x1 += vx1;  y1 += vy1;
  x2 += vx2;  y2 += vy2;

  // ---------- 4. LOS REBOTES ----------
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

  // ---------- 5. EL COLOR ----------
  float tonoRojo = 0;
  float tonoAzul = 200;

  float sat1 = map(s1, 0.5, 2.5, 20, 100);
  float sat2 = map(s2, 0.5, 2.5, 20, 100);

  // ---------- 6. DIBUJAR LA FIGURA 1 ----------
  pushMatrix();
  translate(x1, y1);
  scale(s1);
  figura1.disableStyle();
  fill(tonoRojo, sat1, 100);
  shape(figura1, 0, 0, 50, 50);
  popMatrix();

  // ---------- 7. DIBUJAR LA FIGURA 2 ----------
  pushMatrix();
  translate(x2, y2);
  scale(s2);
  figura2.disableStyle();
  fill(tonoAzul, sat2, 100);
  shape(figura2, 0, 0, 50, 50);
  popMatrix();

  // ---------- 8. MOSTRAR EL BPM EN PANTALLA ----------   >>> NUEVO
  // Sirve para comprobar que los datos del CSV si estan cambiando.
  // nf(numero, 0, 1) muestra el numero con 1 decimal.
  fill(0, 0, 0);     // texto negro (en HSB: brillo 0)
  textSize(14);
  text("BPM figura 1 (CSV): " + nf(bpm1, 0, 1), 10, 20);
  text("BPM figura 2 (fijo): " + nf(bpm2, 0, 1), 10, 40);
}


// >>> NUEVO: funcion propia (la ponemos FUERA de setup() y draw())
// Devuelve 1 si el numero es positivo o cero, y -1 si es negativo.
// La usamos para saber hacia que lado se esta moviendo una figura.
float signo(float v) {
  if (v < 0) {
    return -1;
  } else {
    return 1;
  }
}
