// FIGURAS QUE LATEN SEGUN SU BPM
// Dos soles que:
//   - se agrandan y se encogen (como un latido)
//   - se mueven por la pantalla y rebotan en los bordes
//   - cambian de color (de suave a intenso) segun su tamaño
// Cada sol tiene su propio BPM (pulsos por minuto): uno va mas rápido
// que el otro.
//
// IMPORTANTE: el archivo "sun.svg" debe estar en la carpeta "data"


// <---------------------- VARIABLES GLOBALES ---------------------->

// Angulos de cada figura. Con ellos calculamos el latido usando cos().
// Empiezan en 0 y se recalculan en cada frame dentro de draw().
float a1 = 0.0;
float a2 = 0.0;

// BPM = "beats per minute" = latidos por minuto.
// La figura 1 late a 100 BPM (más rápido) y la figura 2 a 60 BPM (más lento).
int bpm1 = 100;
int bpm2 = 60;

// Posición (x, y) y velocidad (vx, vy) de cada figura.
// x1, y1 = donde esta la figura 1
// vx1, vy1 = cuantos pixeles se mueve la figura 1 en cada frame
float x1, y1, vx1, vy1;
float x2, y2, vx2, vy2;

// PShape es el tipo de variable que guarda una imagen vectorial (SVG).
PShape figura1;
PShape figura2;

// <---------------------- SETUP (se ejecuta UNA vez) ---------------------->
void setup() {
  size(640, 360);        // tamano de la ventana: 640 de ancho x 360 de alto
  noStroke();            // las figuras se dibujan sin borde
  shapeMode(CENTER);     // las figuras se dibujan desde su CENTRO (no desde la esquina)
  frameRate(60);         // intentamos dibujar 60 frames por segundo

  // Cambiamos el modo de color a HSB:
  //   H (Hue/tono): de 0 a 360   -> el color (0 = rojo, 200 = azul)
  //   S (Saturation): de 0 a 100 -> que tan intenso es (0 = gris/blanco)
  //   B (Brightness): de 0 a 100 -> que tan claro es (0 = negro)
  colorMode(HSB, 360, 100, 100);

  // Cargamos el dibujo del sol desde la carpeta "data".
  // Se carga dos veces para tener dos figuras independientes.
  figura1 = loadShape("sun.svg");
  figura2 = loadShape("sun.svg");

  // ---- Posiciones iniciales ----
  // width = ancho de la ventana, height = alto de la ventana
  x1 = width * 0.25;     // figura 1: a un cuarto del ancho (lado izquierdo)
  y1 = height * 0.5;     // a la mitad del alto (centrada verticalmente)
  x2 = width * 0.75;     // figura 2: a tres cuartos del ancho (lado derecho)
  y2 = height * 0.5;

  // ---- Velocidades segun el BPM ----
  // map(valor, minOrigen, maxOrigen, minDestino, maxDestino)
  // convierte un numero de un rango a otro rango.
  // Aqui: si el BPM es 60 -> velocidad 1.0, y si es 100 -> velocidad 3.0.
  // Resultado: a mayor BPM, la figura se mueve mas rapido.
  vx1 = map(bpm1, 60, 100, 1.0, 3.0);
  vy1 = map(bpm1, 60, 100, 0.8, 2.4);

  // El signo menos (-) hace que la figura 2 empiece moviendose
  // hacia la IZQUIERDA (la figura 1 empieza hacia la derecha).
  vx2 = -map(bpm2, 60, 100, 1.0, 3.0);
  vy2 = map(bpm2, 60, 100, 0.8, 2.4);
}


// <---------------------- DRAW (se repite 60 veces por segundo) ---------------------->
void draw() {
  // Pintamos el fondo en cada cuadro para borrar el dibujo anterior.
  // En HSB, (0, 0, 100) es BLANCO (sin tono, sin saturacion, maximo brillo).
  background(0, 0, 100);

  // ---------- 1. El latido (calcular el tamaño) ----------
  // Cada figura late a su propio BPM:
  //   frecuencia (pulsos por segundo) = bpm / 60
  //   angulo = 2*PI * frecuencia * tiempo
  // Una vuelta completa del angulo (2*PI) equivale a UN latido.

  // millis() devuelve los milisegundos desde que inicio el programa.
  // Lo dividimos entre 1000 para tenerlo en segundos.
  float t = millis() / 1000.0;

  // TWO_PI es 2*PI (una vuelta completa de un círculo).
  // Dividimos entre 60.0 (con decimal) para que la division no se redondee.
  a1 = TWO_PI * (bpm1 / 60.0) * t;
  a2 = TWO_PI * (bpm2 / 60.0) * t;

  // cos() va y viene entre -1 y 1 (como una ola).
  // Con map() lo convertimos a un rango de escala entre 0.5 y 2.5:
  //   cos = -1  ->  escala 0.5 (la figura esta chiquita, a la mitad)
  //   cos =  1  ->  escala 2.5 (la figura esta grande, 2.5 veces su tamaño)
  float s1 = map(cos(a1), -1, 1, 0.5, 2.5);
  float s2 = map(cos(a2), -1, 1, 0.5, 2.5);

  // ---------- 2. EL MOVIMIENTO ----------
  // Sumamos la velocidad a la posición: asi la figura avanza en cada frame.
  // (x1 += vx1 es lo mismo que x1 = x1 + vx1)
  x1 += vx1;  y1 += vy1;
  x2 += vx2;  y2 += vy2;

  // ---------- 3. LOS REBOTES ----------
  // El margen es la distancia desde el centro de la figura hasta su borde.
  // Dibujamos las figuras de 50 px de ancho, asi que su mitad es 25.
  // Como la figura cambia de tamano, el margen también: 25 * escala.
  float m1 = 25 * s1;
  float m2 = 25 * s2;

  // Si la figura toca el borde izquierdo (x < margen) o el derecho
  // (x > ancho - margen), invertimos su velocidad horizontal:
  // multiplicar por -1 cambia de derecha a izquierda (o al revés).
  // El simbolo || significa "o".
  if (x1 < m1 || x1 > width - m1)  vx1 *= -1;
  if (y1 < m1 || y1 > height - m1) vy1 *= -1;   // lo mismo arriba y abajo
  if (x2 < m2 || x2 > width - m2)  vx2 *= -1;
  if (y2 < m2 || y2 > height - m2) vy2 *= -1;

  // constrain(valor, minimo, maximo) obliga al valor a quedarse dentro
  // de ese rango. Asi evitamos que, al crecer, la figura se quede
  // "atorada" fuera de la ventana.
  x1 = constrain(x1, m1, width - m1);
  y1 = constrain(y1, m1, height - m1);
  x2 = constrain(x2, m2, width - m2);
  y2 = constrain(y2, m2, height - m2);

  // <---------- 4. EL COLOR ---------->
  // Color en HSB: el tono (H) es fijo para cada figura y la saturacion (S)
  // depende del tamano: cuanto mas grande, mas intenso el color.

  float tonoRojo = 0;     // figura 1 (bpm1): rojo
  float tonoAzul = 200;   // figura 2 (bpm2): azul

  // Escala 0.5 (chiquita) -> saturacion 20 (color palido)
  // Escala 2.5 (grande)   -> saturacion 100 (color fuerte)
  float sat1 = map(s1, 0.5, 2.5, 20, 100);
  float sat2 = map(s2, 0.5, 2.5, 20, 100);

  // <---------- 5. DIBUJAR LA FIGURA 1 ---------->
  // pushMatrix() guarda la posición/escala actual del "lápiz".
  // Todo lo que hagamos hasta popMatrix() solo afecta a esta figura
  // y no a la otra.
  pushMatrix();
  translate(x1, y1);     // movemos el origen (0,0) al lugar donde esta la figura
  scale(s1);             // agrandamos o encogemos todo lo que se dibuje despues
  figura1.disableStyle();          // ignoramos los colores propios del SVG
                                   // para poder usar nuestro fill()
  fill(tonoRojo, sat1, 100);       // rojo suave -> rojo intenso (segun el tamano)
  shape(figura1, 0, 0, 50, 50);    // dibujamos en (0,0) con 50x50 px
                                   // (ya movimos el origen con translate)
  popMatrix();           // volvemos a la posicion/escala que guardamos

  // ---------- 6. DIBUJAR LA FIGURA 2 ----------
  // Es exactamente lo mismo que la figura 1, pero con sus propios valores.
  pushMatrix();
  translate(x2, y2);
  scale(s2);
  figura2.disableStyle();
  fill(tonoAzul, sat2, 100);       // azul suave -> azul intenso
  shape(figura2, 0, 0, 50, 50);
  popMatrix();
}
