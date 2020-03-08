//Create with reference to the original class 'Tree',
//with different Lsystem rules implemented.

class Bushes extends generalSketch{

  // Constructor -------------------------------
  // (d = line length, x & y = start position of drawing)
  Bushes(int d, int x, int y, int z) {
    m_lineLength = d;
    m_x = x;
    m_y = y; 
    m_z = z;
    m_hue = 80.0;
    m_branchAngle = radians(25);
    m_initOrientation = -HALF_PI;
    m_scaleFactor = 0.9;
    m_initiator = "F";
    //F and H rules were modified with reference to
    //L-system rules from the following website:
    //http://www.kevs3d.co.uk/dev/lsystems/
    m_F_rule = "f-[f[F]+fF]+H[f+HF]-F";
    m_H_rule = "HH";
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
    stroke(m_hue, 50, 80);
    
    translate(m_x, m_y, m_z);        // initial position
    rotate(m_initOrientation);  // initial rotation

    for (int i=0; i < m_state.length(); i++) {
      turtle(m_state.charAt(i));
    }

    popStyle();
    popMatrix();
  }


}