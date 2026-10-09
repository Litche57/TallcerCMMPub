// ====================================================================
//  Celda.pde  -  Clase base de todos los alumnos
// ====================================================================
abstract class Celda {
  PApplet app;           // el sketch (necesario para SinOsc, SoundFile, etc.)
  PGraphics g;           // lienzo propio del alumno
  int w, h;              // tamano de la celda (360 x 333)
  String autor;

  float mx = -1, my = -1;        // raton LOCAL (-1 = fuera de la celda)
  boolean presionado = false;

  String error = null;           // mensaje si el codigo del alumno fallo

  Celda(String autor) {
    this.autor = autor;
    this.app = sketch;
    this.w = CW;
    this.h = CH;
    this.g = createGraphics(w, h);
  }

  // ---- Lo que implementa cada alumno ----
  void iniciar() {}                  // equivale a setup()
  abstract void dibujar();           // equivale a draw()
  void sonar(boolean activo) {}      // true = enciende, false = apaga

  // ---- Lo usa el director (ejecucion protegida) ----
  void arrancar() {
    g.beginDraw();
    try {
      iniciar();
    } catch (Exception e) {
      fallar("iniciar", e);
    }
    g.endDraw();
  }

  void actualizar() {
    if (error != null) return;
    g.beginDraw();
    try {
      dibujar();
    } catch (Exception e) {
      fallar("dibujar", e);
    }
    g.endDraw();
  }

  void cambiarSonido(boolean activo) {
    if (error != null) return;
    try {
      sonar(activo);
    } catch (Exception e) {
      fallar("sonar", e);
    }
  }

  void fallar(String donde, Exception e) {
    error = donde + ": " + e;
    println("ERROR en " + autor + " (" + donde + "): " + e);
  }
}
