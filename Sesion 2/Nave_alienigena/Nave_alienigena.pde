/*
EJERCICIO 1: Crea unanave alienigena que expulsa vapor
*/

int x = 180;

void setup(){
  size(360, 320);
}

void draw(){

  // Limpiamos la pantalla
  background(#caf0f8);

  // Vapor
  stroke(#495057);
  fill(#6c757d);
  ellipse(x-80, 160, 40, 40);
  ellipse(x-100, 170, 20, 20);
  
  // Viajero
  fill(#9ef01a);
  ellipse(x+15,115,20,20);

  // NAVE
  stroke(#1b263b);
  fill(#1b263b);
  ellipse(x, 150, 150, 70);

  fill(#ced4da,1);
  ellipse(x, 120, 90, 70);
  
  fill(#263B62);
  ellipse(x,155,50,20);

}
