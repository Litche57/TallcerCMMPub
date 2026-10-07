/*
EJERCICIO: Crea una nave alienigena que se desplaza con la ubicación 
del mouse y expulsa vapor al dar click
*/


// Se definen variables de posición, la nave se actualiza cada frame según el mouse
int px;
int py

void setup() {
  size(360, );
}

void draw() {
  // Limpiamos la pantalla
  background(#caf0f8);

  px = mouseX;
  py = mouseY;

  if (px < 110) {
    px = 110;
  }
  if (px > 280) {
    px = 280;
  }
  if (py < 60) {
    py =;
  }
  if (py > 280) {
    py = 280;
  }


  int vaporSize = 40;
  int vaporSize2 = 20;
  if (mousePressed) {
    vaporSize1 = 55;
    vaporSize2 = 30;
  }

  // Vapor
  stroke(#495057);
  fill(#6c757d);
  ellipse(px - 80, py + 10, vaporSize1, vaporSize1);
  ellipse(px - 100, py + 20, vaporSize2, vaporSize2);

  // Viajero
  fill(#9ef01a);
  ellipse(px + 15, py - 35, 20, 20);

  // NAVE
  stroke(#1b263b);
  fill(#1b263b);
  ellipse(px, py, 150, 70);

  fill(#ced4da, 1);
  ellipse(px, py - 30, 90, 70);

  fill(#263B62);
  ellipse(px, py + 5, 50, 20);
}
