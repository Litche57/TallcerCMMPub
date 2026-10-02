float a=0.0;
float s=0.0;
float x1,y1;
PShape figura;

void setup(){
  size(400,200);
  background(255);

  shapeMode(CENTER);
  frameRate(60);
  figura = loadShape("sun.svg");
  
  //Posición inicial
  x1 = width * 0.25;
  y1 = height * 0.5;

}

void draw(){
  a = a + 0.04;
  s = cos(a)*2;
  
  translate(width/2, height/2);
  scale(s);
  figura.disableStyle();
  stroke(255);
  fill(250, 50, 100);
  shape(figura, 0, 0, 50, 50);

}
