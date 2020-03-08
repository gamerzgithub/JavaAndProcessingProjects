/*Variable midPoint is used again for the left and right 
 *slanted lines.
 */
float angle = 0.0;
float midPoint = 250;
float scalar = 200;

//Declare variables for the middle line of the Big Peace sign.
/*Mid y initialised to 250 (The first small peace sign appears
 *in the middle of the line)
 */
float yMidLine = 250;

/*Declare array variables that will be used for the positions
 *that the small peace sign can appear to form left and right
 *slanted lines.
 */
/*Creating only 10 sets of x and y coordinates of small peace signs 
 *in an array on the left and right slanted lines.
 */
float setLx [] = new float[10];
float setLy [] = new float[10];
float setRx [] = new float[10];
float setRy [] = new float[10];

/*reference for drawing smaller peace signs, the basic code 
for each small peace sign in each part.*/
/*
void drawSmallPeaceSigns(){
  stroke(random(255), random(255), random(255));
  strokeWeight(2);
  ellipse(x, y, 30, 30);
  line(x, y-15, x, y+15);
  line(x, y, x-13, y+7.5);
  line(x, y, x+13, y+7.5);
}*/


void setup(){
  size(500,500);
  background(0);
  //Colour mode is changed to HSB mode, Hue, Saturation, and Brightness
  colorMode(HSB, 255);
}  

void draw(){
 /*First 3 lines of code generates a fading effect, but generates random fading speed
  *each time the method is called.
  */
 fill(0, random(0, 20));
 noStroke();
 rect(0, 0, width, height); 
 /*The rest of the methods to draw the big peace sign using many small peace signs.
  *Drawing of big peace sign is split into 4 parts, the circle, middle line, left
  *slanted line, and right slanted line.
  */
 drawBigCircle();
 drawMidLine();
 LeftLineArray(0, setLx, setLy);
 drawLeftSlantedLine();
 RightLineArray(0, setRx, setRy);
 drawRightSlantedLine();
 frameRate(30);  
}

//Drawing of the circle.
void drawBigCircle(){
  float x = midPoint + cos(angle)*scalar;
  float y = midPoint + sin(angle)*scalar;
  stroke(random(255), 200, 255);
  strokeWeight(2);
  ellipse(x, y, 30, 30);
  line(x, y-15, x, y+15);
  line(x, y, x-13, y+7.5);
  line(x, y, x+13, y+7.5);
  angle += random(-4.0, 4.0);
}

//Drawing of the middle line.
void drawMidLine(){
  stroke(random(255), 200, 255);
  strokeWeight(2);
  ellipse(midPoint, yMidLine, 30, 30);
  line(midPoint, yMidLine-15, midPoint, yMidLine+15);
  line(midPoint, yMidLine, midPoint-13, yMidLine+7.5);
  line(midPoint, yMidLine, midPoint+13, yMidLine+7.5);
  yMidLine = random(50, 450);
}

/*Creating an array of x and y coordinate sets for the small peace sign,
 *to specify which positions that smaller peace sign can take to form the Left
 *Slanted Line.
 */
void LeftLineArray(int i, float setLx[], float setLy[] ){
  for(i=0; i<setLx.length; i++){
    float Lx = midPoint - i*15.6;
    float Ly = midPoint + i*15.8;
    setLx[i] = Lx;
    setLy[i] = Ly;
  }
}

//Drawing of Left Slanted Line
void drawLeftSlantedLine(){
  int num1 = int(random(setLx.length));
  stroke(random(255), 200, 255);
  strokeWeight(2);
  ellipse(setLx[num1], setLy[num1], 30, 30);
  line(setLx[num1], setLy[num1]-15, setLx[num1], setLy[num1]+15);
  line(setLx[num1], setLy[num1], setLx[num1]-13, setLy[num1]+7.5);
  line(setLx[num1], setLy[num1], setLx[num1]+13, setLy[num1]+7.5);
}

/*Creating an array of x and y coordinate sets for the small peace sign,
 *to specify which positions that smaller peace sign can take to form the Right
 *Slanted Line.
 */
void RightLineArray(int j, float setRx[], float setRy[]){ 
 for(j=0; j<setRx.length; j++){
  float Rx = midPoint + j*15.7;
  float Ry = midPoint + j*15.8;
  setRx[j] = Rx;
  setRy[j] = Ry;
 }
}

//Drawing of Right Slanted Line
void drawRightSlantedLine(){
  int num2 = int(random(setRx.length));
  stroke(random(255), 200, 255);
  strokeWeight(2);
  ellipse(setRx[num2], setRy[num2], 30, 30);
  line(setRx[num2], setRy[num2]-15, setRx[num2], setRy[num2]+15);
  line(setRx[num2], setRy[num2], setRx[num2]-13, setRy[num2]+7.5);
  line(setRx[num2], setRy[num2], setRx[num2]+13, setRy[num2]+7.5);
}
  
