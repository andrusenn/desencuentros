public class ASound {
  float freq = 440.f;
  private Sample sample;
  private Glide glide_gain;
  private Glide glide_gain_verb;
  private Glide glide_pan;
  private Gain gain;
  private Gain gain_verb;
  private Panner panner;
  private SamplePlayer player;

  // FX
  private Reverb reverb;
  private Compressor compressor;
  private AudioContext context;
  private ASoundSystem ss;

  public ASound(ASoundSystem _ss, String _path_sample) {
    try {
      sample = new Sample(_path_sample);
    } 
    catch (Exception e) {
      //
    }
    ss = _ss;
    context = ss.getContext();
    player = new SamplePlayer(context, sample);
    player.setKillOnEnd(false);
    //sample = player.getSample();

    // FX Reverb
    reverb = new Reverb(context, 2);
    reverb.setSize(0.3f);
    reverb.setDamping(0.1f);

    // FX Compress
    compressor = new Compressor(context, 1);
    compressor.setAttack(99999); // the attack is how long it takes for
    // compression to ramp up, once the
    // threshold is crossed
    compressor.setDecay(0);
    compressor.setRatio(0.0f);
    compressor.setThreshold(1.0f);

    glide_gain = new Glide(context, 0.8f, 20);
    gain = new Gain(context, 1, glide_gain);

    glide_gain_verb = new Glide(context, 0.8f, 20);
    gain_verb = new Gain(context, 2, glide_gain_verb);

    glide_pan = new Glide(context, 0.0f, 20);

    panner = new Panner(context, glide_pan);
    // Compress
    compressor.addInput(player);
    // 2 Gain DRY / WET
    // Manejo por separado
    gain.addInput(compressor);
    gain_verb.addInput(compressor);
    reverb.addInput(gain_verb);
    panner.addInput(gain);
    // Add to System
    ss.addInput(panner);
  }

  public void reverb() {
    // Reset input / prevent various inputs
    // panner.removeAllConnections(reverb);
    ss.addInput(reverb);
  }
  public void noReverb() {
    ss.removeInput(reverb);
  }
  public void setPan(float _pan) {
    glide_pan.setValue(_pan);
  }
  public void setVol(float _vol) {
    glide_gain.setValue(_vol);
  }
  public void mixReverb(float _dry, float _wet) {
    glide_gain_verb.setValue(_wet);
    glide_gain.setValue(_dry);
  }
  public float duration() {
    return (float)sample.getLength();
  }  
  public Sample getSample() {
    return sample;
  }
  public void play() {
    player.start(0.0f);
  }
  public void play(float _to) {
    player.start(_to);
  }
  public void pause() {
    player.pause(true);
  }
  public Reverb getFXReverb() {
    return reverb;
  }
  public Compressor getFXCompressor() {
    return compressor;
  }
}

public class ASoundSystem {
  private AudioContext context;
  private Gain gain;
  private Glide glid_gain;
  private Compressor compressor;
  private HashMap<String, Float> properties;

  public ASoundSystem() {
    context = new AudioContext();
    glid_gain = new Glide(context, 0.9f, 20);
    gain = new Gain(context, 2, glid_gain);
    properties = new HashMap<String, Float>();
    // FX Compress
    properties.put("FXCompress-attack", 99999.0f);
    properties.put("FXCompress-decay", 0.0f);
    properties.put("FXCompress-ratio", 0.0f);
    properties.put("FXCompress-threshold", 1.0f);
    compressor = new Compressor(context, 2);
    updateProp();
  }

  public void setProp(String _prop, float _val) {
    properties.put(_prop, new Float(_val));
    updateProp();
  }

  private void updateProp() {
    compressor.setAttack(properties.get("FXCompress-attack"));
    compressor.setDecay(properties.get("FXCompress-decay"));
    compressor.setRatio(properties.get("FXCompress-ratio"));
    compressor.setThreshold(properties.get("FXCompress-threshold"));
  }

  public Compressor getFXCompressor() {
    return compressor;
  }

  public AudioContext getContext() {
    return context;
  }

  protected void addInput(Panner _p) {
    gain.addInput(_p);
  }

  protected void addInput(Reverb _p) {
    gain.addInput(_p);
  }

  protected void removeInput(Panner _p) {
    gain.removeAllConnections(_p);
  }

  protected void removeInput(Reverb _p) {
    gain.removeAllConnections(_p);
  }

  public void start() {
    compressor.addInput(gain);
    context.out.addInput(compressor);
    context.start();
  }
}