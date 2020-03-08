PShape primitiveObj;

float objParameters;
float rx1, ry1; 
int SpeedX1, SpeedY1;
float posX1, posY1;

PShape complexObj;
float rx2, ry2;
int SpeedX2, SpeedY2;
float posX2, posY2;

import controlP5.*;
ControlP5 conP5;
CheckBox checkboxPrimitiveObj;
CheckBox checkboxComplexObj;
Button gouraud;
Button phong;

import peasy.*;
PeasyCam cam;

PShader shader;
String s;

void setup() {
  size(1000, 600, P3D);
  smooth();
      
  objParameters = 100;
  primitiveObj = createShape(SPHERE, objParameters);
  rx1 = 0;     
  ry1 = 0;     
  SpeedX1 = 1; 
  SpeedY1 = 1; 
  posX1 = 0;   
  posY1 = 0;  

  complexObj = loadShape("minicooper.obj");
  rx2 = 0;     
  ry2 = 0;     
  SpeedX2 = 1; 
  SpeedY2 = 1; 
  posX2 = 0;   
  posY2 = 0;  

  PFont pfont = createFont("Arial Narrow", 15, true);

  conP5 = new ControlP5(this);
  conP5.setAutoDraw(false);

  checkboxPrimitiveObj = conP5.addCheckBox("Rotation of Primitive Object")
    .setPosition(100, 400)
    .setSize(50, 50)
    .setItemsPerRow(3)
    .setSpacingColumn(195)
    .addItem("Rotate X1", 0)
    .addItem("Rotate Y1", 1)
    .setFont(pfont)
    ;

  checkboxComplexObj = conP5.addCheckBox("Rotation of Complex Object")
    .setPosition(600, 400)
    .setSize(50, 50)
    .setItemsPerRow(3)
    .setSpacingColumn(195)
    .addItem("Rotate X2", 3)
    .addItem("Rotate Y2", 4)
    .setFont(pfont)
    ;
  
  conP5.addSlider("SpeedX1")
    .setPosition(100, 460)
    .setRange(-20, 20)
    .setSize(295, 20)
    .getCaptionLabel()
    .setFont(pfont)
    .toUpperCase(false);
  conP5.addSlider("SpeedY1")
    .setPosition(100, 490)
    .setRange(-20, 20)
    .setSize(295, 20)
    .getCaptionLabel()
    .setFont(pfont)
    .toUpperCase(false)
    ;
  conP5.addSlider("SpeedX2")
    .setPosition(600, 460)
    .setRange(-20, 20)
    .setSize(295, 20)
    .getCaptionLabel()
    .setFont(pfont)
    .toUpperCase(false);
  conP5.addSlider("SpeedY2")
    .setPosition(600, 490)
    .setRange(-20, 20)
    .setSize(295, 20)
    .getCaptionLabel()
    .setFont(pfont)
    .toUpperCase(false)
    ;
    
  cam = new PeasyCam(this, width/2, height/2, 0, 520);
  cam.setMaximumDistance(5000);
  
  shader = loadShader("gouraud_shading_frag.glsl", "gouraud_shading_vert.glsl");
  s = "Choose Shader";

  gouraud = new Button(conP5, "gouraud");
  gouraud.setValue(0)
    .setCaptionLabel("Gouraud Shader")
    .setPosition(475, 420)
    .setSize(100, 30)
    .getCaptionLabel()
    .setFont(pfont)
    .toUpperCase(false);    
  phong = new Button(conP5, "phong");
  phong.setValue(0)
    .setCaptionLabel("Phong Shader")
    .setPosition(475, 460)
    .setSize(100, 30)
    .getCaptionLabel()
    .setFont(pfont)
    .toUpperCase(false);
  conP5.addLabel("shaderLabel")
    .setText("Choose Shader")
    .setPosition(477, 390)
    .setFont(pfont);
}

void draw() {
  background(0);
  
  //Implement point light
  pointLight(200, 200, 200, mouseX, mouseY, 400);

  //Map shader to buttons 
  if (gouraud.isPressed()) {
    shader = loadShader("gouraud_shading_frag.glsl", "gouraud_shading_vert.glsl");
  } else if (phong.isPressed()) {
    shader = loadShader("phong_shading_frag.glsl", "phong_shading_vert.glsl");
  }

  //Drawing primitive object
  pushMatrix();
  primitiveObj.setStroke(0);
  primitiveObj.setFill(color(255));
  translate(300, 250, 0); 
  //Rotation of Primitive Object at X-Axis
  if (checkboxPrimitiveObj.getArrayValue()[0]==1) {
    rotateX(radians(rx1%360));
    rx1+=SpeedX1;
  } else {
    posX1 = rx1%360;
    rotateX(radians(posX1));
  }
  //Rotation of Primitive Object at Y-Axis
  if (checkboxPrimitiveObj.getArrayValue()[1]==1) {
    rotateY(radians(ry1%360));
    ry1+=SpeedY1;
  } else {
    posY1 = ry1%360;
    rotateY(radians(posY1));
  } 
  //Display Primitive Obj
  shape(primitiveObj);
  popMatrix();

  //Drawing Complex Object
  pushMatrix();
  complexObj.setFill(color(255));
  complexObj.setStroke(0);
  translate(750, 250, 0);
  scale(1.5);
  //Rotation of Complex Object in X-Axis
  if (checkboxComplexObj.getArrayValue()[0]==1) {
    rotateX(radians(rx2%360));
    rx2+=SpeedX2;
  } else { 
    posX2 = rx2%360;
    rotateX(radians(posX2));
  }
  //Rotation of Complex Object in Y-Axis
  if (checkboxComplexObj.getArrayValue()[1]==1) {
    rotateY(radians(ry2%360));
    ry2+=SpeedY2;
  } else {
    posY2 = ry2%360;
    rotateY(radians(posY2));
  }
  //Display Complex Object
  shape(complexObj);
  popMatrix();

  //Apply Shader
  shader(shader);

  gui();
}


/*Manually draw GUI so that rotation of PeasyCam does not affect
 or move the GUI controls.
 */
void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  conP5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

/*
REFERENCES:
 ControlP5 Library Reference
 http://www.sojamo.de/libraries/controlP5/
 http://www.sojamo.de/libraries/controlP5/examples/controllers/ControlP5checkBox/ControlP5checkBox.pde
 http://www.sojamo.de/libraries/controlP5/examples/controllers/ControlP5slider/ControlP5slider.pde
 http://www.sojamo.de/libraries/controlP5/examples/controllers/ControlP5textlabel/ControlP5Textlabel.pde
 http://www.sojamo.de/libraries/controlP5/examples/controllers/ControlP5button/ControlP5button.pde
 http://www.sojamo.de/libraries/controlP5/examples/extra/ControlP5withPeasyCam/ControlP5withPeasyCam.pde
 
 Processing References
 https://processing.org/reference/pointLight_.html
 https://processing.org/reference/PShape.html
 https://processing.org/reference/PShader.html
 
 Subject Guide References
 Chapter 4 
 Shader Programming - pg 54 to pg 59
 Chapter 5
 Lighting - pg 64 to pg 65
 Shading - pg 67 to pg 70
 
 Other Material References
 Minicooper Object "minicooper.obj" taken from https://people.sc.fsu.edu/~jburkardt/data/obj/obj.html
 Interactive Computer Graphics - A Top-Down Approach With Shader-Based OpenGL 6th Edition
 
 */
