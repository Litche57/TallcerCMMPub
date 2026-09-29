//Atributos de formas y primitivas geométricas
void setup(){ //Definimos el tamaño de nuestro canvas
  size(800,600);
  background(255);//Fondo de canvas, el valor 255 representa el color blanco
}
void draw(){ //Inicializamos el bloque de instrucciones para dibujar en el canvas
  //Iniciamos dibujando un punto en el canvas, se especifica la coordenada x,y
  stroke(0); //Color de contorno 0 representa el color negro
  strokeWeight(5); //Grosor de contorno
  point(50,150);
 

  //Para dibujar una línea se tienen las siguientes propiedades line(x1,y1,x2,y2); es decir, line(punto A, punto B).
  strokeWeight(1); //Grosor de contorno 
  stroke(0); //Se define el color de contorno en negro. ¡¡IMPORTANTE!! Las líneas de código se ejecutan en orden secuencial, por lo tanto, desde aquí, todas las siguientes formas tendrán este grosor y color de contorno
  line(80,150,80,255);
 

  //Para un rectángulo se especifican las siguientes propiedades (x,y, ancho y alto)
  fill(255,0,0); //Color de relleno de rectángulo en formato RGB (Red, Green, Blue), el primer valor 255 representa el valor máximo de intensidad del rojo
  rect(100,155, 50,50);
  
  //Para dibujar una elipse se especifica de la siguiente manera: ellipse(x,y,ancho,alto)
  fill(0,255,0); //Color de relleno de elipse en formato RGB (Red, Green, Blue), el segundo valor 255 representa el valor máximo de intensidad del verde
  ellipse(200,180,50,50);
    
  fill(0,0,255);
  triangle(250, 200, 350,200, 300, 150); //Color de relleno de triángulo en formato RGB (Red, Green, Blue), el tercer valor 255 representa el valor máximo de intensidad del azul
}
