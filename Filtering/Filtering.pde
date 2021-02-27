//Please put on earpiece or headphones for a better
//experience.

/*Note: the sketch might not run as smoothly as it
 should if a computer or laptop with lower processing 
 power is used. For laptops make sure battery saver 
 is off before running the code.
 */

/*import sound library minim for sound
 manipulation and analysis
 */
import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.effects.*;

//Instances
Minim       minim;
AudioPlayer track1;
AudioPlayer track2;
Convolver lpf, hpf;
BeatListener listener;
BeatListener listener2;
BeatDetect detector;
BeatDetect detector2;

float ellipseSize;
color color1;
color color2;
color color3;

/*The set of ArrayLists that are used to store the 
 data of the music.
 */
ArrayList<Float> x1_list = new ArrayList<Float>();
ArrayList<Float> x2_list = new ArrayList<Float>();
ArrayList<Float> y1_list = new ArrayList<Float>();
ArrayList<Float> y2_list = new ArrayList<Float>();


void setup()
{
  size(512, 512);
  background(0);
  colorMode(HSB, 360, 100, 100);
  ellipseSize = 25;
  minim = new Minim(this);

  /*Load music files into the AudioPlayer instances.
   The music files 'bensound-erf.wav' is taken
   from 'Royalty Free Music from Bensound'.
   URL: https://www.bensound.com/royalty-free-music
   */
  track1 = minim.loadFile("bensound-erf.wav", 1024);
  track2 = minim.loadFile("bensound-erf.wav", 1024);
  //track1 = minim.loadFile("bensound-creativeminds.wav", 1024);
  //track2 = minim.loadFile("bensound-creativeminds.wav", 1024);
  //track1 = minim.loadFile("bensound-dubstep.wav", 1024);
  //track2 = minim.loadFile("bensound-dubstep.wav", 1024);
  //track1 = minim.loadFile("bensound-punky.wav", 1024);
  //track2 = minim.loadFile("bensound-punky.wav", 1024);
  //track1 = minim.loadFile("bensound-endlessmotion.wav", 1024);
  //track2 = minim.loadFile("bensound-endlessmotion.wav", 1024);

  /*Initialise instances to detect the beat in the 
   first track and the second track
   */
  detector = new BeatDetect(track1.bufferSize(), track1.sampleRate());
  detector.setSensitivity(400);
  listener = new BeatListener(detector, track1);
  detector2 = new BeatDetect(track2.bufferSize(), track2.sampleRate());
  detector2.setSensitivity(400);
  listener2 = new BeatListener(detector2, track2);

  /*Play both tracks together. If a computer with lower
   processing power is used, the playing of the 
   tracks may not synchronise.
   */
  track1.play();
  track2.play();

  /*Filter kernels, used for convolution of audio
   signals to apply low pass and high pass filters.
   Low pass filter is hardcoded while high pass filter
   can be derived from low pass filter.
   The technique of using filter kernels is done with
   reference to the example from the library 
   "LowPassConvolve".
   URL: https://github.com/ddf/Minim/tree/master/examples/Synthesis/LowPassConvolve
   */
  float[] lowPassKernel = new float[] {0.0, 0.1, 0.2, 0.3, 0.4, 0.3, 0.2, 0.1, 0.0};
  float[] highPassKernel = new float[lowPassKernel.length];

  /*Derive high pass filter from low pass filter with
   the  technique of 'Spectral Inversion'.
   Takes all sample in the kernel, invert the signs,
   and add 2 to the middle sample value of the kernel
   to create a kernel that detect greater difference
   in frequency between sampled values.
   */
  for (int i = 0; i< highPassKernel.length; i++ ) {
    if (lowPassKernel[i] != 0.0) {
      highPassKernel[i] = -lowPassKernel[i];
    }
  }
  highPassKernel[highPassKernel.length/2]+= 2.0;

  /*Create low and high pass filters with class
   Convolver and filter kernels.
   */
  lpf = new Convolver(lowPassKernel, track1.bufferSize());
  hpf = new Convolver(highPassKernel, track2.bufferSize());

  /*Apply low pass filter to track1, high pass filter
   to track2.
   */
  track2.addEffect(hpf);
  track1.addEffect(lpf);

  /*As track2 will sound softer after applying high
   pass filter, setting gain of 10db amplify the 
   sound to achieve balance between low pass filtered 
   and high pass filtered sound tracks.
   SetPan for tracks to equalise the filtered music.
   */
  track1.setPan(-0.5);
  track2.setPan(0.5);
  track2.setGain(10);
  
  displayInfo();
}

//To display the commands for the sketch.
void displayInfo() {
  println("Done by: Wong Dan Ning");
  println("UOL SRN: 17*****46\n");
  println("-------------------Commands-------------------");
  println("BACKSPACE\t: Restart");
  println("ENTER\t\t: Mute or Unmute");
  println("1, 2, or 3\t: Change colours of the animation");
}

/*Some basic commands that can be used on music player,
 such as pausing, muting, and rewind.
 Press 'Enter' to mute or unmute.
 Press 'Backspace' restart the song.
 */
void keyPressed() {
  if (key == BACKSPACE) {
    track1.rewind();
    track2.rewind();
  } else if (key == ENTER && !track1.isMuted() && !track2.isMuted()) {
    track1.mute();
    track2.mute();
  } else if (key == ENTER && track1.isMuted() && track2.isMuted()) {
    track1.unmute();
    track2.unmute();
  }
}

void draw() {
  fill(0,65);
  noStroke();
  rectMode(CORNER);
  rect(0, 0, width, height);

  /*Drawing a circle in the middle of the sketch
   that will change its size based on the beat 
   detected from the music.
   This part of the animation was inspired by the
   example from the Minim library
   "SoundEnergyBeatDetection".
   URL: http://code.compartmental.net/minim/beatdetect_field_sound_energy.html
   To change colour of the ellipse, simply press
   '1': red and orange colours for outer circle,
   cyan for the inner circle.
   '2': blue, cyan, and purple colours for outer 
   circle, 
   lime green for the inner circle.
   '3': green colour for the outer circle, 
   orange for the inner circle.
   By default the colour scheme for the circle is 
   the same as option 1.
   */
  pushMatrix();
  color1 = color(random(0, 54), 100, 100);
  color2 = color(random(170, 300), 100, 100);
  color3 = color(random(100, 160), 100, 80);
  ellipseMode(RADIUS);
  strokeWeight(5);
  if (key == '1') {
    stroke(color1);
  } else if (key == '2') {
    stroke(color2);
  } else if (key == '3') {
    stroke(color3);
  } else {
    stroke(color1);
  }
  ellipse(width/2, height/2, ellipseSize, ellipseSize);
  popMatrix();

  /*Drawing an ellipse in the middle with a complementary
   colour.  
   */
  pushMatrix();
  noStroke();
  color1 = color(181, 100, 100);
  color2 = color(77, 100, 100);
  color3 = color(62, 100, 100);
  if (key == '1') {
    fill(color1);
  } else if (key == '2') {
    fill(color2);
  } else if (key == '3')
    fill(color3);
  else {
    fill(color1);
  }
  ellipse(width/2, height/2, ellipseSize-15, ellipseSize-15);
  popMatrix();

  /*Uses BeatDetect objects to detect the beat in the music.
   It detect based on the frequencies of the song.
   The ellipse will then increase its size based on
   the amplitude of the frequencies in the song.
   */
  if (detector.isHat() || detector2.isHat()) {
    ellipseSize+=10;
  } else if (detector.isSnare() || detector2.isSnare()) {
    ellipseSize+=10;
  } else if (detector.isKick() || detector2.isKick()) {
    ellipseSize+=10;
  } else if (ellipseSize > 25) {
    ellipseSize -= 5;
  }


  /*The main part of data filtering. The amplitude and
   frequencies of the sound wave is mapped into a graph. 
   X-axis represents the samples, while the Y-axis 
   represents the amplitude of the samples. For both 
   sound tracks, the distance between the coordinates 
   of the graphs of sound tracks are analysed. The 
   larger the amplitude of frequencies, the shorter
   the distances between the coordinates. Only the 
   coordinates with distances that are less than or
   equals to height/25.6 = 20 are extracted.
   These data will then be mapped into an animation
   of rotating rectangles.
   */
  for ( int i = 0; i < track1.bufferSize() - 1; i++ )
  {  
    /*Coordinates for the graphs of sound tracks.
     (x1, y1) for track1, (x2, y2) for track2.*/
    float x1 = map(i, 0, track1.bufferSize(), 0, width);
    float x2 = map(i, 0, track2.bufferSize(), 0, width);
    float y1 = height/4 - track1.mix.get(i)*200;
    float y2 = height*3/4 - track2.mix.get(i)*300;

    /*The following codes are used to draw the graph 
     of the sound tracks. The codes were written with
     reference to the example in the following website:
     http://code.compartmental.net/minim/audioplayer_method_loop.html
     */
    //pushMatrix();
    //stroke(i/20+170, 100, 100);
    //strokeWeight(1);
    //line(x1, y1, x1, height/4-track1.mix.get(i+1));
    //line(x2, y2, x2, height*3/4-track2.mix.get(i+1));
    //popMatrix();

    /*Data filtering is applied here. If the distance 
     between two points (x1, y1) and (x2, y2) is less
     than or equals to height/25.6, store these 
     coordinates to the set of ArrayLists which were
     created earlier. These values will be used to
     animate rotating rectangles.
     Every execution will result in different
     coordinates stored in the ArrayLists, thus results
     in different rectangle animations. However, there
     is a possibility that no coordinates will be added
     when too many executions are run consecutively,
     which will result in no animations of rectangles.
     */
    if (dist(x1, y1, x2, y2) <= height/25.6) {
      x1_list.add(x1);
      y1_list.add(y1);
      x2_list.add(x2);
      y2_list.add(y2);
    }
  }

  /*The following is used to reset the ArrayLists so
   that the rectangles will be redrawn in different 
   sizes after the data in the ArrayLists exceed a
   certain amount.
   This will allow the sketch to draw rectangles
   when the sound tracks play high and sharp 
   amplitudes, thus create an effect of animation 
   synchronising with the sound tracks beat.
   Since the sizes of x1_list, x2_list, y1_list, and 
   y2_list are always the same, I used x1_list for 
   the condition to reset.
   */
  if (x1_list.size() > 8 ) {
    x1_list = new ArrayList<Float>();
    y1_list = new ArrayList<Float>();
    x2_list = new ArrayList<Float>();
    y2_list = new ArrayList<Float>();
  }


  /*Like what I mentioned above, setting the boolean
   condition for x1_list is equivalent to setting
   the boolean condition for all ArrayLists, thus
   only x1_list is checked here.
   If the ArrayLists are not empty, draw the rectangles
   with the values of the coordinates that are stored
   in the ArrayLists. 
   The x1 and y1 values will be the center of the
   rectangles, the x2 and y2 values will be the width
   and height of the rectangles respectively. 
   */
  if (!x1_list.isEmpty()) {
    for (int i = 0; i<x1_list.size(); i++ ) {
      pushMatrix();
      rectMode(CENTER);
      
      //A real number to rotate rectangles randomly.
      float degree = random(360);
      noFill();
      strokeWeight(4);
      color1 = color(random(160, 230), 100, 100);
      color2 = color(random(0, 100), 100, 100);
      color3 = color(random(250, 320), 100, 100);
      /*Colour changing of the rectangles by 
       pressing the following keys: 
       '1': cyan, blue, purple, pink colours
       '2': red, orange, yellow, green colours
       '3': purple, pink colours
       By default the colour of the animate
       is the colour scheme from the option 1.
       */
      if (key == '1') {
        stroke(color1);
      } else if (key == '2') {
        stroke(color2);
      } else if (key == '3')
        stroke(color3);
      else {
        stroke(color1);
      } 
      translate(width/2, height/2);
      rotate(degree);
      rect(x1_list.get(i)/width/2, y1_list.get(i)/height/2, x2_list.get(i), y2_list.get(i));
      popMatrix();
    }
  }
}
