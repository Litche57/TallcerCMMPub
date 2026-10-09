//
//  PARTICIPANTE 1  |  Corazon que late (con audio de fondo)
// 
class Participante1 extends Celda {

  // ---------- Variables propias ----------
  float a = 0.0;                 // angulo del latido
  float s = 0.0;                 // escala del corazon
  PShape figura;
  SoundFile musicaFondo, otrofondo;

  int tAnterior = 0;             // para medir el tiempo entre cuadros
  // El original sumaba 0.04 por cuadro a 70 fps. Lo convertimos a
  // "radianes por segundo" para que el ritmo sea el mismo en la galeria
  // (que corre a 60 fps) y se mantenga sincronizado con el audio.
  float velocidadAngular = 0.04 * 70;

  Participante1() {
    super("Participante 1");     // <-- escribe aqui tu nombre
  }

  // Equivale al setup() original
  void iniciar() {
    g.background(255);
    g.shapeMode(CENTER);

    figura = loadShape("heart.svg");
    figura.disableStyle();       // ignora los colores del SVG; usamos nuestro fill()

    // Solo se CARGAN aqui; se reproducen en sonar(true)
    musicaFondo = new SoundFile(app, "heartbeat.mp3");
    otrofondo   = new SoundFile(app, "rainfalling.mp3");

    tAnterior = millis();
  }

  // Equivale al draw() original
  void dibujar() {
    float dt = (millis() - tAnterior) / 1000.0;
    tAnterior = millis();

    a += velocidadAngular * dt;
    s = cos(a) * 2;

    g.pushMatrix();
    g.translate(w / 2.0, h / 2.0);   // centro de la celda (antes: width/2, height/2)
    g.scale(s);
    g.stroke(255);
    g.fill(255, 3, 66);              // #FF0342 en RGB
    g.shape(figura, 0, 0, 80, 80);
    g.popMatrix();

    // print("\n a=", a, "s=" + s);  // desactivado: llenaria la consola a 60 fps
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
}
