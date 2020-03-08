//This effect sketch was created with reference to the 
//following websites:
//https://www.openprocessing.org/sketch/379481
//https://www.openprocessing.org/sketch/395389
//https://www.openprocessing.org/sketch/182404

class effects extends generalSketch {

  effects() {
    //set variables for position, velocity and colour
    loc = new PVector(random(-100,width), -10);
    vel = new PVector(0, random(4));
    m_hue = 75;
  }

  //drawing of snow fall effect
  void displaySnow() {
    stroke(360, 0, 100);
    strokeWeight(6);
    point(loc.x, loc.y, loc.z);
  }
  
  //drawing of leaves fall effect
  void displayLeaves(){
    noStroke();
    colorMode(HSB, 360, 100, 100);
    fill(m_hue, 50, 100);
    beginShape();
    vertex(loc.x,loc.y, loc.z);
    vertex(loc.x+5, loc.y+2, loc.z);
    vertex(loc.x+2, loc.y, loc.z);
    vertex(loc.x, loc.y+5, loc.z);
    vertex(loc.x-2, loc.y, loc.z);
    vertex(loc.x-5, loc.y+2, loc.z);
    endShape();
  }
     
  //Animation for both snow fall and leaves fall
  void animate(){
    loc.add(vel);
    float ang = atan2(loc.z, loc.x);
    ang-=0.01;
    loc.z++;
    loc.x = cos(ang)*sqrt(pow(loc.z, 2)+pow(loc.x,2));
  }

}