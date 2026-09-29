//Introducción a formas básicas en Processing
void setup(){ //Definimos el tamaño de nuestro canvas
  size(800,600);
  background(255);
}
void draw(){ //Inicializamos el bloque de instrucciones para dibujar en el canvas
  //Iniciamos dibujando un punto en el canvas, se especifica la coordenada x,y
  point(50,150);
 
  //Para dibujar una línea se tienen las siguientes propiedades line(x1,y1,x2,y2); es decir line(punto A, punto B).
  line(80,150,80,255);
 
  //Para un rectángulo se especifican las siguientes propiedades (x,y, ancho y alto)
  rect(100,155, 50,50);
  
  //Para dibujar una ellipse se especifica de la siguiente manera: ellipse(x,y,ancho,alto)
  ellipse(200,180,50,50);

  triangle(250, 200, 350,200, 300, 150); 
}
