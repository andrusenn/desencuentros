import beads.*;
import org.jaudiolibs.beads.*;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import javax.imageio.ImageIO;
import java.io.ByteArrayInputStream;
import java.util.Map;
import processing.video.*;
import g4p_controls.*;

PApplet main_papplet;

PImage video_out;
PImage titulos;
HashMap<String, Movie> videos_;
Movie cur_video;
String cur_video_title = "";
PGraphics recortes;
ArrayList<Video> videos;
ArrayList<PImage> video;
int n_fotograma = 0;
int rw, rx, ry, rh;
PImage output;
int vposY = 0;
int fotogramas = 15;

// FX -------------
// ByteCorrupt --------
BufferedImage bi;
BufferedImage bi2;
PImage rev;

// Audio ---------
ASound asound;
ASoundSystem ssystem;
// Reloj
int reloj_init = 0;
int reloj_time = 0;
boolean reloj = false;
int reloj_min = 0;
int reloj_seg = 0;

void setup() {
  noCursor();
  frameRate(60);
  colorMode(HSB);

  ssystem = new ASoundSystem();
  ssystem.start();
  try {
    String s = sketchPath("") + "/" + "data/videos/solo.mp3";
    asound = new ASound(ssystem, s);
    asound.pause();
    /*Sample s2 = new Sample(sketchPath("") + "/" + "data/drum2.wav");
     asound2 = new ASound(ssystem, s2);
     asound2.reverb();
     asound2.mixReverb(0.9, 0.5);
     asound.pause();*/
  }
  catch(Exception e) {
  }
  titulos = loadImage("videos/titulos.png");
  main_papplet = this;
  videos = new ArrayList<Video>();
  video = new ArrayList<PImage>();
  output = createImage( width, height, RGB );
  rev = createImage( width, height, RGB );
  size(800, 600);
  video_out = createImage(width, height, RGB);
  videos_ = new HashMap<String, Movie>();
  videos_.put("escena8", new Movie(this, "videos/10silencio.mp4"));
  videos_.put("5climax", new Movie(this, "videos/5climax.mp4"));
  videos_.put("soundscape", new Movie(this, "videos/paisaje.mp4"));
  videos_.put("solo", new Movie(this, "videos/solo.mp4"));
  createGUI();
  customGUI();
}
void resetVideos() {
  background(0);
  videos_.get("escena8").stop();
  videos_.get("soundscape").stop();
  videos_.get("5climax").stop();
  videos_.get("solo").stop();
  video_det_playing = false;
  video_cli_playing = false;
  cur_video_title = "";
  video_solo_playing = false;
  video_fin_playing = false;
  video_tit_playing = false;
  video = new ArrayList<PImage>();
  videos = new ArrayList<Video>();
}
void draw() {
  switch(PANTALLA) {
  case P_NEGRO:
    background(0);
    resetVideos();
    break;
  case P_LARGOS:
    p_largos();
    break;
  case P_CLIMAX:
    p_climax();
    break;
  case P_SOLO:
    p_solo();
    break;
  case P_FINAL:
    p_final();
    break;
  case P_TITULOS:
    p_titulos();
    break;
  }

  //video_out.copy(get(), 0, 0, width, height, 0, 0, 400, 300);
  thread("getScreen");
  //println(frameRate);
  if (reloj) {
    reloj_time = ( millis() - reloj_init ) / 1000;
    reloj_min = reloj_time / 60;
    reloj_seg = reloj_time % 60;
  } else {
    reloj_init = millis();
  }
}
void keyReleased() {

  keyEvents(this);
}