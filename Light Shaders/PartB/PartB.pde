//Part B

import peasy.*;
import controlP5.*;

//ControlP5 objects
ControlP5 conP5;
Button gouraud;
Button phong;
Knob knob;

//3D Object
PShape object;

//Shader object
PShader shader;

//PeasyCam object
PeasyCam cam;

//Light Parameters
/*Assuming spotlights are fixed at the top, the direction of spotlight
 will change along x-axis and z-axis.
 */
float lightXPos;
float lightZPos;
float lightDirAngle;
float scale;
float lightXDir;
float lightZDir;
float dirX;
float dirZ;
float cutOffAngle;
float concentration;
boolean spotlight;
float col;

void setup() {

  size(600, 900, P3D);
  //Instantiate font for labels
  PFont pfont = createFont("Arial Narrow", 20, true);
 
  //Instantiate ControlP5
  conP5 = new ControlP5(this);
  conP5.setAutoDraw(false);
 
  //Initialise spotlight positions 
  lightXPos = 200;
  lightZPos = 200;
  lightDirAngle = 0;
  scale = 600;
  lightXDir = 0;
  lightZDir = -1;
  dirX = 0.01; 
  dirZ = 0.01;
  col = 255;
  cutOffAngle = 45;
  concentration = 10;
  
  //Instantiate PeasyCam for camera navigation
  cam = new PeasyCam(this, width/2, height/2, 0, 790);
  cam.setMaximumDistance(1000);
  cam.setActive(false);
  conP5.addTextlabel("cameraInstruction")
    .setText("Press 'c' to activate camera navigation\nPress 'v' to deactivate camera navigation")
    .setPosition(20, 160)
    .setFont(pfont);
    
  //Instantiate default shader
  shader =  loadShader("gouraud_shading_frag_B.glsl", "gouraud_shading_vert_B.glsl");

  //Instantiate buttons for shaders
  gouraud = new Button(conP5, "gouraud");
  gouraud.setCaptionLabel("Gouraud Shader")
    .setPosition(20, 50)
    .setSize(120, 30)
    .getCaptionLabel()
    .setFont(pfont)
    .toUpperCase(false);    
  phong = new Button(conP5, "phong");
  phong.setCaptionLabel("Phong Shader")
    .setPosition(20, 90)
    .setSize(120, 30)
    .getCaptionLabel()
    .setFont(pfont)
    .toUpperCase(false);
  conP5.addLabel("shaderLabel")
    .setText("Choose Shader")
    .setPosition(20, 20)
    .setFont(pfont);

  //Instantiate toggle for On/Off spotlight function;
  conP5.addToggle("spotlight")
    .setLabel("Spotlight switch")
    .setPosition(380, 110)
    .setSize(60, 30)
    .setValue(true)
    .getCaptionLabel()
    .setFont(pfont)
    .toUpperCase(false)
    .getStyle().marginTop = -65;
    
  //Instantiate knob to control cutoff angle
  knob = new Knob(conP5, "cutOffAngle");
  knob.setCaptionLabel("Cutoff Angle")
    .setPosition(210, 50)
    .setFont(pfont)
    .setRadius(50)
    .setRange(0, 90)
    .setViewStyle(knob.ELLIPSE)
    .getCaptionLabel() 
    .toUpperCase(false)
    .getStyle().marginTop = -130;

  //Instantiate slider to control concentration
  conP5.addSlider("concentration")
    .setLabel("Concentration")
    .setRange(1, 100)
    .setPosition(380, 50)
    .setSize(200, 30)
    .setFont(pfont)
    .getCaptionLabel()
    .toUpperCase(false)
    .getStyle()
    .marginTop = -33;
  conP5.getController("concentration")
    .getCaptionLabel()
    .getStyle()
    .marginLeft = -200;


  //Instantiate object
  //object = createShape(SPHERE, 70);
  object = loadShape("minicooper.obj");
  object.setStroke(0);
}

void draw() {
  
  //Apply camera activation and deactivation
  if (keyPressed){
    if (key == 'c' || key =='C'){
      cam.setActive(true);
    }else if (key == 'v' || key =='V'){
      cam.setActive(false);
    }
  }
  background(0);
  smooth();
  
  //Apply spotlight activation and deactivation
  if (spotlight == true) {
    spotLight(col, col, col, lightXPos, 0, lightZPos, lightXDir, 1, lightZDir, radians(cutOffAngle*2-90), concentration); 
    spotLight(col, col, col, lightXPos+400, 0, -lightZPos, lightXDir, 1, lightZDir, radians(cutOffAngle*2-90), concentration);
  }
  directionChange(); 
 

  //Draw object in the centre of the sketch
  pushMatrix();
  translate(width/2, height/2+100, 0);
  scale(3);
  rotateX(PI/2);
  rotateZ(PI);
  shape(object);
  popMatrix();

  //Map shader to buttons 
  if (gouraud.isPressed()) {
    shader = loadShader("gouraud_shading_frag_B.glsl", "gouraud_shading_vert_B.glsl");
  } else if (phong.isPressed()) {
    shader = loadShader("phong_shading_frag_B.glsl", "phong_shading_vert_B.glsl");
  } 

  //Apply shader
  shader(shader);

  //Manually draw GUI controls
  gui();  
}

void directionChange() {
  //Changing the direction of spotlight in x-axis
  lightXDir += dirX;
  if (lightXDir <= -1 || lightXDir >= 1) {
    dirX = -dirX;
  }
  //Changing the direction of spotlight in z-axis
  lightZDir += dirZ;
  if (lightZDir  <= -1 || lightZDir >= 1) {
    dirZ = -dirZ;
  }
  /*It is assumed that the spotlight will light up from the top, so the 
  y coordinate is not changed and the spotlight will shine in positive
  y direction.*/
}

/*Manually draw GUI so that rotation of PeasyCam does not affect
 or move the GUI controls.
 */
void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();  

  pushMatrix();
  rect(0, 0, width, 220);
  fill(100,100);
  popMatrix();

  conP5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

//Status of camera activation to be printed in console
void keyPressed(){
   if (key == 'c' || key =='C'){
      println("camera on");
   }else if (key == 'v' || key =='V'){
      println("camera off");
   } 
}

/*REFERENCES
http://www.sojamo.de/libraries/controlP5/
http://www.sojamo.de/libraries/controlP5/examples/controllers/ControlP5button/ControlP5button.pde
http://www.sojamo.de/libraries/controlP5/examples/controllers/ControlP5knob/ControlP5knob.pde
http://www.sojamo.de/libraries/controlP5/examples/controllers/ControlP5textlabel/ControlP5Textlabel.pde
http://www.sojamo.de/libraries/controlP5/examples/controllers/ControlP5slider/ControlP5slider.pde
http://mrfeinberg.com/peasycam/
https://processing.org/reference/PShape.html
https://processing.org/tutorials/pshader/
*/
