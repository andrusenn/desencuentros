final int P_NEGRO = 1;
final int P_LARGOS = 2;
final int P_CLIMAX = 3;
final int P_SOLO = 4;
final int P_FINAL = 5;
final int P_TITULOS = 6;
int PANTALLA = P_NEGRO;
// -------------------------------
boolean video_det_playing = false;
void p_largos() {
  if (!video_det_playing) {
    // 
    resetVideos();
    videos_.get("escena8").stop();
    cur_video = videos_.get("escena8");
    cur_video_title = "escena8";
    videos_.get("escena8").play();
    video_det_playing = true;
  }
  if (videos_.get("escena8").available()) {
    background(0);
    videos_.get("escena8").read();
    image(videos_.get("escena8"), 0, 0);
    if ( videos_.get("escena8").time()>= videos_.get("escena8").duration()-0.4) {
      PANTALLA = P_CLIMAX;
    }
  }
}
// CLIMAX -------------------------------
boolean video_cli_playing = false;
void p_climax() {
  if (!video_cli_playing) {
    // 
    resetVideos();
    videos_.get("5climax").stop();
    cur_video = videos_.get("5climax");
    cur_video_title = "5climax";
    videos_.get("5climax").play();
    video_cli_playing = true;

    rw = int( random(50, 300) );
    rh = int( random(50, 300) );
    rx = int(random(width-rw));
    ry = int( random( height-rh ) );
  }
  if (videos_.get("5climax").available()) {
    background(0);
    videos_.get("5climax").read();
    image(videos_.get("5climax"), 0, 0);
    if (videos_.get("5climax").time() < 100) {
      for ( Video v : videos ) {
        PImage f = v.getFrame();
        blend( f, 0, 0, width, height, v.x, v.y, f.width, f.height, v.TIPO);
      }
      recorteAutomatico(videos_.get("5climax").time(), videos_.get("5climax").duration());
      if ( videos.size() > 90 ) {
        videos.remove(0);
      }
    } else {
      videos = new ArrayList<Video>();
      image(videos_.get("5climax"), 0, 0);
    }
    if ( videos_.get("5climax").time() >= videos_.get("5climax").duration()-0.4) {
      PANTALLA = P_SOLO;
    }
  }
}
// SOLO -------------------------------
boolean video_solo_playing = false;
void p_solo() {
  if (!video_solo_playing) {
    // 
    resetVideos();
    videos_.get("solo").stop();
    cur_video = videos_.get("solo");
    cur_video_title = "solo";
    videos_.get("solo").play();
    video_solo_playing = true;
  }
  if (videos_.get("solo").available()) {
    background(0);
    videos_.get("solo").read();
    image(videos_.get("solo"), 0, 0);
    if (controles.keyPressed || keyPressed) {
      int r = int(random(30, 50));
      // ---------------------------
      if (frameCount % r < r * 0.3) {
        asound.setPan(random(-1.0, 1.0));
        asound.play(random(asound.duration()));
      }
      // ---------------------------
      if (controles.keyCode==UP || keyCode==UP) {
        getGlitch(videos_.get("solo"), int(random(0, 10)));
        image(rev, 0, 0);
      }
      if (controles.keyCode==LEFT || keyCode==LEFT) {

        distort(videos_.get("solo"), int(random(1000)));
        bn();
        //image(rev, 0, 0);
      }
      if (controles.keyCode==RIGHT || keyCode==RIGHT) {
        doNoise();
      }
      if (controles.keyCode==DOWN || keyCode==DOWN) {
        getGlitch(videos_.get("solo"), int(random(500, 1000)));
        image(rev, 0, 0);
      }
    }
    if ( videos_.get("solo").time()>= videos_.get("solo").duration()-0.4) {
      asound.pause();
      PANTALLA = P_FINAL;
    }
  } else {   
    asound.pause();
  }
}
// -------------------------------
boolean video_fin_playing = false;
void p_final() {
  if (!video_fin_playing) {
    // 
    resetVideos();
    cur_video = videos_.get("soundscape");
    cur_video_title = "soundscape";
    videos_.get("soundscape").play();
    video_fin_playing = true;
  }
  if (videos_.get("soundscape").available()) {
    background(0);
    videos_.get("soundscape").read();
    image(videos_.get("soundscape"), 0, 0);

    if ( videos_.get("soundscape").time()>= videos_.get("soundscape").duration()-0.4) {
      PANTALLA = P_TITULOS;
    }
  }
}
// -------------------------------
boolean video_tit_playing = false;
void p_titulos() {
  if (!video_tit_playing) {
    // 
    resetVideos();
    video_tit_playing = true;
  }
  image(titulos, 0, 0);
}