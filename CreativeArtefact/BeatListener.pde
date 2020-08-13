/*Taken from the Minim library example 
 'FrequencyEnergyBeatDetection'.
 URL: http://code.compartmental.net/minim/beatdetect_field_freq_energy.html,
 This class implements AudioListener to call the
 'detect' method on each buffer, and it is needed 
 for the detection of beat with 'isSnare()', 
 'isHat()', and 'isKick()' method.
 */
class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer audio;

  //Constructor
  BeatListener(BeatDetect beat, AudioPlayer audio)
  {
    this.audio = audio;
    this.audio.addListener(this);
    this.beat = beat;
  }


  void samples(float[] samples)
  {
    /*the 'detect' method analyse the samples of the
     song.
     'mix' takes in the mix of left and right channels
     of the source audio.
     */
    beat.detect(audio.mix);
  }

  void samples(float[] samplesLeft, float[] samplesRight)
  {
    beat.detect(audio.mix);
  }
}
