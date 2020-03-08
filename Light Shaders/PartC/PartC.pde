
import peasy.*;
import controlP5.*;

ControlP5 conP5;
Button copper;
Button cyanRubber;
Button pearl;
Knob knob;

PShape object;

PShader shader;
String s;

PVector[] copperVect = new PVector[4];
PVector[] cyanRubberVect = new PVector[4];
PVector[] pearlVect = new PVector[4];

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
  PFont title = createFont("H2hdrM", 25, true);
 
  //Instantiate ControlP5
  conP5 = new ControlP5(this);
  conP5.setAutoDraw(false);
 
  //Initialise spotlight positions 
  lightXPos = 100;
  lightZPos = 400;
  lightDirAngle = 0;
  scale = 1000;
  lightXDir = 0;
  lightZDir = 0;
  dirX = 0.01; 
  dirZ = 0.01;
  col = 255;
  cutOffAngle = 45;
  concentration = 1.5;
  
  //Initialise materials parameters
  /*array[0] - ambient
    array[1] - diffuse
    array[2] - specular
    array[3] - shininess, metalness, roughness*/
  //Copper
  copperVect[0] = new PVector(0.19125, 0.0735, 0.0225);
  copperVect[1] = new PVector(0.7038, 0.27048, 0.0828);
  copperVect[2] = new PVector(0.256777, 0.137622, 0.086014);
  copperVect[3] = new PVector(12.8, 0.7, 1.5);
  //Cyan rubber
  cyanRubberVect[0] = new PVector(0.0, 0.05, 0.05);
  cyanRubberVect[1] = new PVector(0.4, 0.5, 0.5);
  cyanRubberVect[2] = new PVector(0.04, 0.7, 0.7);
  cyanRubberVect[3] = new PVector(10.0, 0.0, 4.0);
  //Pearl
  pearlVect[0] = new PVector( 0.25, 0.20725, 0.20725);
  pearlVect[1] = new PVector(1.0, 0.829, 0.829);
  pearlVect[2] = new PVector(0.296648, 0.296648, 0.296648);
  pearlVect[3] = new PVector(11.264, 0.0, 2.0);
  
  //Instantiate PeasyCam for camera navigation
  cam = new PeasyCam(this, width/2, height/2, 0, 790);
  cam.setMaximumDistance(1000);
  cam.setActive(false);
  conP5.addTextlabel("cameraInstruction")
    .setText("Press 'c' to activate camera navigation\nPress 'v' to deactivate camera navigation")
    .setPosition(20, 160)
    .setFont(pfont);
    
  //Instantiate default shader
  shader =  loadShader("cook_torrance_shading_frag.glsl", "cook_torrance_shading_vert.glsl");

  //Instantiate buttons for different materials
  copper = new Button(conP5, "copper");
  copper.setCaptionLabel("Copper")
    .setPosition(width*3/4, 50)
    .setSize(120, 30)
    .getCaptionLabel()
    .setFont(pfont)
    .toUpperCase(false);    
  cyanRubber = new Button(conP5, "cyanRubber");
  cyanRubber.setCaptionLabel("Cyan Rubber")
    .setPosition(width*3/4, 90)
    .setSize(120, 30)
    .getCaptionLabel()
    .setFont(pfont)
    .toUpperCase(false);
  pearl = new Button(conP5, "pearl");
  pearl.setCaptionLabel("Pearl")
    .setPosition(width*3/4, 130)
    .setSize(120,30)
    .getCaptionLabel()
    .setFont(pfont)
    .toUpperCase(false);
  conP5.addLabel("shaderLabel")
    .setText("Choose Material")
    .setPosition(width*3/4, 20)
    .setFont(pfont);
  conP5.addLabel("Cook Torrance Shading Model")
     .setPosition(20, 20)
     .setFont(title)
     ;

  //Instantiate object
  //object = createShape(SPHERE, 70);
  object = loadShape("minicooper.obj");
//  object = loadShape("shuttle.obj");
  
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
  spotLight(col, col, col, lightXPos, 0, lightZPos, lightXDir, 1, lightZDir, radians(60), 100); 
  spotLight(col, col, col, lightXPos+500, 0, -lightZPos, lightXDir, 1, lightZDir, radians(60), 100);
  directionChange(); 
  
  
  //Draw object in the centre of the sketch
  pushMatrix();
  translate(width/2, height/2+100, 0);
  scale(3);
  rotateX(PI/2);
  rotateZ(PI);
  shape(object);
  popMatrix();

  //Map material vectors to buttons 
  if (copper.isPressed()) {
    shader.set("ambReflect", copperVect[0]);
    shader.set("diffReflect", copperVect[1]);
    shader.set("specReflect", copperVect[2]);
    //sh - shininess, m - roughness
    shader.set("sh", copperVect[3].x);
    shader.set("metalness", copperVect[3].y);
    shader.set("m", copperVect[3].z);
  } 
  else if (cyanRubber.isPressed()) {
    shader.set("ambReflect", cyanRubberVect[0]);
    shader.set("diffReflect", cyanRubberVect[1]);
    shader.set("specReflect", cyanRubberVect[2]);
    shader.set("sh", cyanRubberVect[3].x);
    shader.set("metalness", cyanRubberVect[3].y);
    shader.set("m", cyanRubberVect[3].z);
  }
  else if(pearl.isPressed()){
    shader.set("ambReflect", pearlVect[0]);
    shader.set("diffReflect", pearlVect[1]);
    shader.set("specReflect", pearlVect[2]);
    shader.set("sh", pearlVect[3].x);
    shader.set("metalness", pearlVect[3].y);
    shader.set("m", pearlVect[3].z);
  } 
  shader(shader);

  //Manually draw GUI controls
  gui();  
}

void directionChange() {
  //Change direction of light in x-axis
  lightXDir += dirX;
  if (lightXDir <= -1 || lightXDir >= 1) {
    dirX = -dirX;
  }
  //Change direction of light in z-axis
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
