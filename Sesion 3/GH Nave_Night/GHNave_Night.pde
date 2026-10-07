
// Posición de la nave (se actualiza cada frame según el mouse)
int px;
int py;

//Imagen de fondo
PImage fondo;

// Variable booleana para indicar si se muestra la imagen de fondo
boolean mostrarCielo = false;

void setup() {
  size(600, 350);
  fondo = loadImage("");
}

void draw() {
 
  if (mostrarCielo) {
    background(fondo);
  } else {
    background(202,240,248);
  }

  px = mouseX;
  py = mouseY;

  if (px < 110) {
    px = 110;
  }
  if (px > 550) {
    px = 550;
  }
  if (py < 60) {
    py = 60;
  }
  if (py > 280) {
    py = 280;
  }

  int vaporSize1 = 40;
  int vaporSize2 = 20;
  if (mousePressed) {
    vaporSize1 = 55;
    vaporSize2 = 30;
  }

  // Vapor
  stroke(170);
  fill(222,226,229);
  ellipse(px - 80, py + 10, vaporSize1, vaporSize1);
  ellipse(px - 100, py + 20, vaporSize2, vaporSize2);

  // Viajero
  fill(158,240,26);
  ellipse(px + 15, py - 35, 20, 20);

  // NAVE
  stroke(27, 38, 59);
  fill(27, 38, 59);
  ellipse(px, py, 150, 70);

  fill(206,212,218,1);
  ellipse(px, py - 30, 90, 70);

  fill(38, 59,56);
  ellipse(px, py + 5, 50, 20);
}

void mouseClicked(){
  if(mostrarCielo){
    mostrarCielo = false;  
  } else {
    mostrarCielo = true;
  }
}
