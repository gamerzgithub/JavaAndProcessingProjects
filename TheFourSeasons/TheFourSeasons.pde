//CO1112 CW2
//NAME: WONG DAN NING
//Part 5
//Below is the extended version of the 
//'Lsystem sketch' given in the question, 
//for Part 1, 2 and 3.
//Unused codes and other question instructions 
//are commented out or deleted.

//Declare objects as global variables
ArrayList<Tree> trees;
ArrayList<Bushes> bushes;
ArrayList<RTree> rTrees;
ArrayList<RBushes> rBushes;
ArrayList<effects> EFFECTS;
int s = 2;//speed

void setup() {
  size(600, 600, P3D);
  background(0);
  
  //Used for positions of the trees and bushes drawn.
  int x = 250;
  int y = 200;
  int z = 50;
  //setting up initial sketch of trees and bushes on the left.
  Tree tree1 = new Tree(int(random(2, 4)), x, y, z);
  z+=100;
  y+=100;
  x-=10;
  Bushes bushes1 = new Bushes(int(random(5, 8)), x, y, z);
  z+=100;
  y+=100;
  x-=10;
  Tree tree2 = new Tree(int(random(2, 4)), x, y, z);
  z+=100;
  y+=100;
  x-=10;
  Bushes bushes2 = new Bushes(int(random(5, 8)), x, y, z);
  z+=100;
  y+=100;
  x-=10;
  Tree tree3 = new Tree(int(random(2, 4)), x, y, z);
  z+=100;
  y+=100;
  x-=10;
  Bushes bushes3 = new Bushes(int(random(5, 8)), x, y, z);

  //x, y, z variables for trees and bushes on the right side.
  x = 350;
  y = 200;
  z = 50;
  //setting up sketches of trees and bushes on the right.
  RTree rTree1 = new RTree(int(random(2, 4)), x, y, z);
  z+=100;
  y+=100;
  x+=10;
  RBushes rBushes1 = new RBushes(int(random(5, 8)), x, y, z);
  z+=100;
  y+=100;
  x+=10;
  RTree rTree2 = new RTree(int(random(2, 4)), x, y, z);
  z+=100;
  y+=100;
  x+=10;
  RBushes rBushes2 = new RBushes(int(random(5, 8)), x, y, z);
  z+=100;
  y+=100;
  x+=10;
  RTree rTree3 = new RTree(int(random(5, 8)), x, y, z);
  z+=100;
  y+=100;
  x+=10;
  RBushes rBushes3 = new RBushes(int(random(5, 8)), x, y, z);

  //Create trees and bushes array
  trees = new ArrayList<Tree>();
  trees.add(tree1);
  trees.add(tree2);
  trees.add(tree3);
  rTrees = new ArrayList<RTree>();
  rTrees.add(rTree1);
  rTrees.add(rTree2);
  rTrees.add(rTree3);
  bushes = new ArrayList<Bushes>();
  bushes.add(bushes1);
  bushes.add(bushes2);
  bushes.add(bushes3);
  rBushes = new ArrayList<RBushes>();
  rBushes.add(rBushes1);
  rBushes.add(rBushes2);
  rBushes.add(rBushes3);
  
  //Create array for effects of Autumn and Winter
  EFFECTS = new ArrayList<effects>();
}

// Any drawing should be done here!
void draw() {
  background(0);
  
  //drawing of trees on the left side
  for (Tree tree : trees) {
    tree.draw();
    tree.m_z+=2*s;
    tree.m_y+=s;
    tree.m_x-=s/5;
    //animation of trees moving
    if (tree.m_z > 600) {
      tree.m_z=50;
      tree.m_y=200;
      tree.m_x=250;
    }
    
    
    //animation of colour of trees
    //Spring
    if (tree.m_hue >= 290.0) {
      tree.m_hue += 0.215;
      if (tree.m_hue > 360.0)
        tree.m_hue = 140.0;
    }
    //Summer and Autumn
    else if (tree.m_hue <= 140.0) {
      tree.m_hue -= 0.205;
      if (tree.m_hue <= 10.0)
        tree.m_hue = 180.0;
    }
    //Winter
    else if (tree.m_hue >= 180.0)
      tree.m_hue += 0.37;
  }


  //drawing trees on the right side
  for (RTree rTrees : rTrees) {
    rTrees.draw();
    rTrees.m_z+=2*s;
    rTrees.m_y+=s;
    rTrees.m_x+=s/5;
    //animation of trees moving
    if (rTrees.m_z >600) {
      rTrees.m_z=50;
      rTrees.m_y=200;
      rTrees.m_x=350;
    }
    //animation for colours of trees
    //Spring
    if (rTrees.m_hue >= 290.0) {
      rTrees.m_hue += 0.215;
      if (rTrees.m_hue > 360.0)
        rTrees.m_hue = 140.0;
    }
    //Summer and Autumn
    else if (rTrees.m_hue <= 140.0) {
      rTrees.m_hue -= 0.205;
      if (rTrees.m_hue <= 10.0)
        rTrees.m_hue = 180.0;
    } 
    //Winter
    else if (rTrees.m_hue >= 180.0)
      rTrees.m_hue += 0.37;
  }


  //drawing of bushes on the left side
  for (Bushes bushes : bushes) {
    bushes.draw();
    bushes.m_z+=2*s;
    bushes.m_y+=s;
    bushes.m_x-=s/5;
    //animation for bushes moving
    if (bushes.m_z > 600) {
      bushes.m_z=50;
      bushes.m_y=200;
      bushes.m_x=250;
    }
    //animation for colours of bushes
    //Spring and Summer
    if (bushes.m_hue >= 80.0 && bushes.m_hue < 180.0) {
      bushes.m_hue+=0.109;
      if (bushes.m_hue > 150.0 && bushes.m_hue < 180.0)
        bushes.m_hue = 75;
    }
    //Autumn
    else if (bushes.m_hue <=75.0) {
      bushes.m_hue-=0.205;
      if (bushes.m_hue < 10)
        bushes.m_hue = 240.0;
    } 
    //Winter
    else if (bushes.m_hue <= 240.0) {
      bushes.m_hue-=0.2015;
      if (bushes.m_hue < 180)
        bushes.m_hue = 80.0;
    }
  }


  //drawing of bushes on the right side
  for (RBushes rBushes : rBushes) {
    rBushes.draw();
    rBushes.m_z+=2*s;
    rBushes.m_y+=s;
    rBushes.m_x+=s/5;
    //animation of bushes moving
    if (rBushes.m_z > 600) {
      rBushes.m_z=50;
      rBushes.m_y=200;
      rBushes.m_x=350;
    }
    //Spring and Summer
    if (rBushes.m_hue >= 80.0 && rBushes.m_hue < 180.0) {
      rBushes.m_hue+=0.109;
      if (rBushes.m_hue > 150.0 && rBushes.m_hue < 180.0)
        rBushes.m_hue = 75;
    } 
    //Autumn
    else if (rBushes.m_hue <=75.0) {
      rBushes.m_hue-=0.205;
      
      //Leaves fall effect
      for (effects e: EFFECTS){
        e.displayLeaves();
        e.m_hue=rBushes.m_hue;
        e.animate();
      }
      EFFECTS.add(new effects());
        
      if (rBushes.m_hue < 10)
        rBushes.m_hue = 240.0;
    } 
    //Winter
    else if (rBushes.m_hue <= 240.0) {
      rBushes.m_hue-=0.2015;
      
      //Snow fall effect
      for (effects e : EFFECTS) {
        e.displaySnow();
        e.animate();
      }
      EFFECTS.add(new effects());
      
      if (rBushes.m_hue < 180)
        rBushes.m_hue = 80.0;
    }
  }
}
