//Name    : Wong Dan Ning //<>//
//UOL SRN : 17*****46
//Part A
/*
 BEFORE YOU START:
 Please ensure the PeasyCam and ControlP5 libraries are installed 
 in Processing before running the sketch.
 
 NOTE: 
 The sketch is done in Processing version 3.5.4
 
 REFERENCE:
 http://www.sojamo.de/libraries/controlP5/
 https://processing.org/tutorials/pshader/
 http://setosa.io/ev/image-kernels/
 https://lodev.org/cgtutor/filtering.html
 http://math.hws.edu/graphicsbook/source/webgl/texture-transform.html
 https://search.creativecommons.org/photos/d2292f45-0531-4f92-8ecf-f3c268bd8efe
 https://rvdesign.myportfolio.com/001-free-textures
 https://rvdesign.myportfolio.com/003-free-textures
 (From the excellent example coursework 2 of 2018-2019)
 Brigjaj, J. D. (2019) CO3355 Advanced Graphics coursework 2 Partb, BSc Computing and Information System, University of London, Unpublished.
 https://github.com/jdf/peasycam/blob/master/src/peasy/PeasyCam.java
 https://github.com/processing/processing/blob/master/core/src/processing/opengl/PGraphics3D.java
 */
import peasy.*;
PeasyCam cam;

import controlP5.*;
import processing.opengl.*;

ControlP5 conp5;
Button image1;
Button image2;
Button image3;
Button effect1;
Button effect2;
Button effect3;
Slider slider;
CheckBox rotation;
CheckBox texAnimation;

PShape shape;
int lvl;
int num;
float speed;
float angle;
float intensity;
float animation;
float frame;
boolean rotate;
boolean animate;

String instructions;
PFont font;
PFont buttonFont;

PShader shader;
PImage[] images;
PGraphics3D pg3D;
boolean pushlights;

void setup() {

  size(1024, 768, P3D);

  cam = new PeasyCam(this, width/2, height/2, 0, 300);
  cam.setMaximumDistance(1000);

  conp5 = new ControlP5(this);
  conp5.setAutoDraw(false);

  font       = createFont("Calibri Light", 20);
  buttonFont = createFont("Arial Narrow", 15);
  textFont(font);
  textLeading(23);

  lvl        = 1;
  speed      = 0;
  intensity  = 1;
  angle      = 0;
  animation  = 1.0;
  frame      = 1.0;
  num        = 0;
  frameRate(60);

  //GUI buttons
  image1 = new Button(conp5, "image1");
  image1.setCaptionLabel("Image 1")
    .setPosition(width/6, 68+24)
    .setSize(70, 20)
    .setValue(0)
    .getCaptionLabel()
    .setFont(buttonFont);

  image2 = new Button(conp5, "image2");
  image2.setCaptionLabel("Image 2")
    .setPosition(width/6+75, 68+24)
    .setSize(70, 20)
    .setValue(1)
    .getCaptionLabel()
    .setFont(buttonFont);        
  image3 = new Button(conp5, "image3");
  image3.setCaptionLabel("Image 3")
    .setPosition(width/6+75+75, 68+24)
    .setSize(70, 20)
    .setValue(2)
    .getCaptionLabel()
    .setFont(buttonFont);  

  effect1 = new Button(conp5, "effect1");
  effect1.setCaptionLabel("Original")
    .setPosition(width/6, 92+24)
    .setSize(70, 20)
    .getCaptionLabel()
    .setFont(buttonFont);
  effect2 = new Button(conp5, "effect2");
  effect2.setCaptionLabel("Emboss")
    .setPosition(width/6+75, 92+24)
    .setSize(70, 20)
    .getCaptionLabel()
    .setFont(buttonFont);         
  effect3 = new Button(conp5, "effect3");
  effect3.setCaptionLabel("Sharpen")
    .setPosition(width/6+75+75, 92+24)
    .setSize(70, 20)
    .getCaptionLabel()
    .setFont(buttonFont);

  /*
   Effect parameter for adjustment. The same parameter
   can be applied to both effects.
   */
  slider = new Slider(conp5, "intensity");
  slider.setCaptionLabel("")
    .setPosition(width/6, 116+24)
    .setSize(220, 20)
    .setRange(-20, 20);

  //Allow user to activate or deactivate rotation of object
  rotation = new CheckBox(conp5, "checkBox");
  rotation.setItemsPerRow(1)
    .addItem("Rotation", 0)
    .setPosition(width/6, 140+24)
    .setSize(50, 20)
    .setColorActive(color(31, 255, 249))
    .hideLabels()
    .activateAll();

  texAnimation = new CheckBox(conp5, "texture animation");
  texAnimation.setItemsPerRow(1)
    .addItem("texture", 0)
    .setPosition(width/6, 164+24)
    .setSize(50, 20)
    .setColorActive(color(31, 255, 249))
    .hideLabels()
    .activateAll();


  //Display instructions
  String studentInfo = "Name\t\t: Wong Dan Ning\n" + "UOL SRN\t: 17*****46\n";
  instructions = "Press UP arrow key to increase level, press DOWN arrow key to decrease level.\n";
  instructions += "Alternatively, press '1' to '9' for the corresponding level value, press '0' for level 10.\n";
  instructions += "Press 'x' to deactivate camera navigation, 'c' to activate camera navigation. Drag the mouse cursor to rotate the view angle.";
  instructions += "\nUse the mouse wheel to zoom in or out. Double click on the mouse to return the sketch to original position.";
  println(studentInfo+"---------------------------------CONTROLS---------------------------------\n"+instructions);
  instructions += "\nChoose texture      :";
  instructions += "\nChoose effect        :";
  instructions += "\nAdjust intensity      :";
  instructions += "\nRotation                 :";
  instructions += "\nTexture Animation :";
  

  //Load textures
  images = new PImage[3];
  images[0] = loadImage("abstractTexture.jpg");
  images[1] = loadImage("rustTexture.jpg");
  images[2] = loadImage("oakTexture.jpg");

  //Initialise shader
  shader = loadShader("texFragShaderA.glsl", "texVertShaderA.glsl");
  shader.set("tex", images[0]);

  shape  = createIcosahedron(lvl);
}

void draw() {
  background(0);
  lights();

  pushMatrix();
  translate(width/2, height/2);
  rotation();
  scale(100);
  shape(shape);
  //Setting effect parameter
  shader.set("intensity", intensity);
  //Animate texture with frame count
  animate();
  shader(shader);
  popMatrix();

  displayGUI();
}

void displayGUI() {
  beginHUD();
  conp5.draw();
  fill(255);
  text(instructions, 5, 15);
  endHUD();
}


/*
 beingHUD() and endHUD() methods are adapted from PeasyCam.
 'g' is a public PGraphics renderer that is associated to
 the PApplet of this sketch.
 These methods are important to ensure the instructions text and
 controlP5 controllers are drawn separately from the 3D object.
 */
void beginHUD() {
  g.hint(DISABLE_DEPTH_TEST);
  g.pushMatrix();
  g.resetMatrix();
  pg3D = (PGraphics3D)g;
  pushlights = pg3D.lights;
  pg3D.lights = false;
  pg3D.pushProjection();
  g.ortho(0, width, -height, 0);
}

void endHUD() {
  pg3D = (PGraphics3D)g;
  pg3D.popProjection();
  pg3D.lights = pushlights;
  g.popMatrix();
  g.hint(ENABLE_DEPTH_TEST);
}

void keyPressed() {
  switch(keyCode) {
    /*
     * Increase level
     * When level is set to a high value the sketch might crash,
     * thus maximum level is capped at 10.
     */
  case UP: 
    if (lvl < 10) {
      lvl++;
    } else if (lvl >= 10) {
      lvl = 10;
    }
    println("level: "+ lvl);     
    println("number of vertices: " + (12+10*(pow(4, lvl-1) - 1)));
    println("frame rate: " + frameRate);
    println("frame time: " + 1/frameRate+ "\n");
    break;
    /*
     * Decrease level 
     * Negative and 0 int levels will no have an effect on the shape,
     * thus the minimum level is capped at 1.
     */
  case DOWN:           
    if (lvl > 1) {
      lvl--;
    } else if (lvl <= 1) {
      lvl = 1;
    }
    println("level: "+ lvl);     
    println("number of vertices: " + (12+10*(pow(4, lvl-1) - 1)));
    println("frame rate: " + frameRate);
    println("frame time: " + 1/frameRate+ "\n");
    break;
    /*
     * Number 0 to 9, mapped to corresponding level value, except that
     * number 0 is mapped to level 10.
     */
  case '1':
    lvl = 1;
    println("level: "+ lvl);     
    println("number of vertices: " + (12+10*(pow(4, lvl-1) - 1)));
    println("frame rate: " + frameRate);
    println("frame time: " + 1/frameRate+ "\n");
    break;
  case '2': 
    lvl = 2;
    println("level: "+ lvl);     
    println("number of vertices: " + (12+10*(pow(4, lvl-1) - 1)));
    println("frame rate: " + frameRate);
    println("frame time: " + 1/frameRate+ "\n");
    break;
  case '3':
    lvl = 3;
    println("level: "+ lvl);     
    println("number of vertices: " + (12+10*(pow(4, lvl-1) - 1)));
    println("frame rate: " + frameRate);
    println("frame time: " + 1/frameRate+ "\n");
    break;
  case '4':
    lvl = 4;
    println("level: "+ lvl);     
    println("number of vertices: " + (12+10*(pow(4, lvl-1) - 1)));
    println("frame rate: " + frameRate);
    println("frame time: " + 1/frameRate+ "\n");
    break;
  case '5':
    lvl = 5;
    println("level: "+ lvl);     
    println("number of vertices: " + (12+10*(pow(4, lvl-1) - 1)));
    println("frame rate: " + frameRate);
    println("frame time: " + 1/frameRate+ "\n");
    break;
  case '6':
    lvl = 6;
    println("level: "+ lvl);     
    println("number of vertices: " + (12+10*(pow(4, lvl-1) - 1)));
    println("frame rate: " + frameRate);
    println("frame time: " + 1/frameRate+ "\n");
    break;
  case '7':
    lvl = 7;
    println("level: "+ lvl);     
    println("number of vertices: " + (12+10*(pow(4, lvl-1) - 1)));
    println("frame rate: " + frameRate);
    println("frame time: " + 1/frameRate+ "\n");
    break;
  case '8':
    lvl = 8;
    println("level: "+ lvl);     
    println("number of vertices: " + (12+10*(pow(4, lvl-1) - 1)));
    println("frame rate: " + frameRate);
    println("frame time: " + 1/frameRate+ "\n");
    break;
  case '9': 
    lvl = 9;
    println("level: "+ lvl);     
    println("number of vertices: " + (12+10*(pow(4, lvl-1) - 1)));
    println("frame rate: " + frameRate);
    println("frame time: " + 1/frameRate+ "\n");
    break;
  case '0':
    lvl = 10;
    println("level: "+ lvl);     
    println("number of vertices: " + (12+10*(pow(4, lvl-1) - 1)));
    println("frame rate: " + frameRate);
    println("frame time: " + 1/frameRate+ "\n");
    break;
  }
  //Turn on or off camera navigation
  cameraNavigation();
  shape = createIcosahedron(lvl);
}


void mousePressed() {
  //Image texture selection
  if (image1.isPressed()) {
    //Image taken from https://search.creativecommons.org/photos/d2292f45-0531-4f92-8ecf-f3c268bd8efe
    shader.set("tex", images[0]);
    println("Abstract Texture");
  } else if (image2.isPressed()) {
    //Image taken from https://rvdesign.myportfolio.com/003-free-textures
    shader.set("tex", images[1]);
    println("Rust Texture");
  } else if (image3.isPressed()) {
    //Image taken from https://rvdesign.myportfolio.com/001-free-textures
    shader.set("tex", images[2]);
    println("Oak Texture");
  }
  //Image post-processing effect selection
  if (effect1.isPressed()) {
    //Original effect
    shader.set("num1", 0.0);
    shader.set("num2", 0.0);
    shader.set("num3", 0.0);
    shader.set("num4", 0.0);
    shader.set("num5", 1.0);
    shader.set("num6", 0.0);
    shader.set("num7", 0.0);
    shader.set("num8", 0.0);
    shader.set("num9", 0.0);
    println("Original Effect");
  } else if (effect2.isPressed()) {
    //Emboss effect
    shader.set("num1", -1.0);
    shader.set("num2", -1.0);
    shader.set("num3", 0.0);
    shader.set("num4", -1.0);
    shader.set("num5", 0.0);
    shader.set("num6", 1.0);
    shader.set("num7", 0.0);
    shader.set("num8", 1.0);
    shader.set("num9", 1.0);
    println("Emboss Effect");
  } else if (effect3.isPressed()) {
    //Sharpen effect
    shader.set("num1", -1.0);
    shader.set("num2", -1.0);
    shader.set("num3", -1.0);
    shader.set("num4", -1.0);
    shader.set("num5", 9.0);
    shader.set("num6", -1.0);
    shader.set("num7", -1.0);
    shader.set("num8", -1.0);
    shader.set("num9", -1.0);
    println("Sharpen Effect");
  }
  shape = createIcosahedron(lvl);
}

//Activation of rotation
void rotation() {
  rotate = rotation.getState(0);
  if (rotate) {
    rotateY(speed);
    speed+=0.02;
  } else {
    angle = speed;
    rotateY(angle);
  }
}

//Animate texture with frame count
void animate() {
  animate = texAnimation.getState(0);
  frame=abs(sin(num/80.0));
  if (animate) {
    num++;
  }
  animation = frame;
  shader.set("animation", animation);
}

//Camera navigation
void cameraNavigation() {
  if (key == 'c' || key == 'C') {
    cam.setActive(true);
    println("Camera On");
  } else if (key == 'x' || key =='X') {
    cam.setActive(false);
    println("Camera Off");
  }
}
