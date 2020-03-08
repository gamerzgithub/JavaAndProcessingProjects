//Super class of all sketches
class generalSketch{
  
  // Member variables -------------------------------
  int    m_lineLength;       // turtle line length
  int    m_x;                // initial x position
  int    m_y;                // initial y position
  float  m_branchAngle;      // turtle rotation at branch
  float  m_initOrientation;  // initial orientation
  String m_initiator;        // initial state string (axiom)
  String m_state;            // current state string
  float  m_scaleFactor;      // branch scale factor
  String m_F_rule;           // F-rule substitution
  String m_H_rule;           // H-rule substitution
  String m_f_rule;           // f-rule substitution
  int    m_numIterations;    // number of times to substitute
  
  //Other variables added for this sketch -----------
  int    m_z;                //initial z position for 3D animation
  float  m_hue;              //hue colour
  //variables for effects class
  PVector loc;               //location vector
  PVector vel;               //velocity vector
   
  
  // Getter methods -------------------------------
  // get the current state of the L-system
  String getState() {
    return m_state;
  }
  
    // Implementation of L-system functionality -------------------
  // Turtle command definitions for each character in our alphabet
  void turtle(char c) {
    switch(c) {
    case 'F': // drop through to next case
    case 'H':
      line(0, 0, m_lineLength, 0);
      translate(m_lineLength, 0);
      break;
    case 'f':
      translate(m_lineLength, 0);
      break;
    case 's':
      scale(m_scaleFactor);
      break;
    case '-':
      rotate(-m_branchAngle);
      break;
    case '+':
      rotate(m_branchAngle);
      break;
    case '[':
      pushMatrix();
      break;
    case ']':
      popMatrix();
      break;
    default:
      println("Bad character: " + c);
      exit();
    }
  }
    // apply substitution rules to string s and return the resulting string
  String substitute(String s) {
    String newState = new String();
    for (int j=0; j < s.length(); j++) {
      switch (s.charAt(j)) {
      case 'F':
        newState += m_F_rule;
        break;
      case 'H':
        newState += m_H_rule;
        break;
      case 'f':
        newState += m_f_rule;
        break;
      default:
        newState += s.charAt(j);
      }
    }
    return newState;
  }
  
  // Calculate the final state of the string according to the initiator,
  // rules and number of iterations
  void calculateState() {

    // begin with the initiator
    m_state = m_initiator;

    // and apply the specified number of iterations of substitutions
    for (int k=0; k < m_numIterations; k++) {
      m_state = substitute(m_state);
    }
  }
}