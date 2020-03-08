//Sketch for trees on the right hand side.

class RTree extends generalSketch{

  // Constructor -------------------------------
  // (d = line length, x & y = start position of drawing)
  RTree(int d, int x, int y, int z) {
    m_lineLength = d;
    m_x = x;
    m_y = y; 
    m_z = z;
    m_hue = 290.0;
    //Angle changed to 25 degree.
    m_branchAngle = radians(25);
    m_initOrientation = -HALF_PI;
    m_scaleFactor = 0.9;
    m_initiator = "F";
    //F rule is modified.
    m_F_rule = "F[-F-+F]F[+F-+F]F";
    m_H_rule = "";
    m_f_rule = "";
    m_numIterations = 4;

    calculateState();
  }

  // Drawing -------------------------------
  void draw() {
    pushMatrix();
    pushStyle();
   
    //Implementation of colours
    colorMode(HSB, 360, 100, 100);
    strokeWeight(1);
    stroke(m_hue, 50, 100);
    
    translate(m_x, m_y, m_z);        
    rotate(m_initOrientation);  // initial rotation

    for (int i=0; i < m_state.length(); i++) {
      turtle(m_state.charAt(i));
    }

    popStyle();
    popMatrix();
  }

}