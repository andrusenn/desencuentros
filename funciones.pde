void getScreen() {
  loadPixels();
  video_out.loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    video_out.pixels[i] = pixels[i];
  }
  video_out.updatePixels();
}
void keyEvents(PApplet papplet) {
  switch(papplet.key) {
  case '1':
    PANTALLA = P_NEGRO;
    break;
  case '2':
    PANTALLA = P_LARGOS;
    break;
  case '3':
    PANTALLA = P_CLIMAX;
    break;
  case '4':
    PANTALLA = P_SOLO;
    break;
  case '5':
    PANTALLA = P_FINAL;
    break;
  case '6':
    PANTALLA = P_TITULOS;
    break;
  }
  // -----------------
  if (papplet.key == 'r') {
    reloj = true;
  }
  if (papplet.key == 's') {
    reloj = false;
    reloj_init = millis();
  }
  if (papplet.keyCode == 112) {
    controles.setVisible(true);
  }
}
void recorteAutomatico(float _d, float _t) {
  if ( n_fotograma >= fotogramas ) {
    n_fotograma = 0;// resetea el contador
    fotogramas = int( random( 20, 60 ) );// asigna un nuevo maximo
    if (video != null ) {
      if ( _d < 20) {
        videos.add( new Video( video, rx, ry, MULTIPLY ) );
      } else

        if ( _d >= 20 && _d < 50 ) {
          videos.add( new Video( video, rx, ry, ADD ) );
        } else {
          videos.add( new Video( video, rx, ry, BLEND ) );
        }
      output = new PImage();// resetea la variable
      video = new ArrayList<PImage>();//resetea array de imagenes

      rw = int( random(50, 300) );
      rh = int( random(50, 300) );
      rx = int(random(width-rw));
      ry = int( random( height-rh ) );
    }
  } else {
    video.add( videos_.get("5climax").get(rx, ry, rw, rh) );
    n_fotograma++;
  }
}

void getGlitch(PImage _i, int numb) {

  rev.loadPixels();
  // Carga bufer
  bi = (BufferedImage)_i.getNative();
  ByteArrayOutputStream baos = new ByteArrayOutputStream();
  try {
    ImageIO.write(bi, "jpg", baos);
    byte[] bytes = baos.toByteArray();
    for (int i = 0; i < numb; i++) {
      //bytes[int(random(bytes.length))] = byte(random(-128, 128));
      bytes[int(random(bytes.length))] = byte(0);
    }
    bi2 = ImageIO.read(new ByteArrayInputStream(bytes));
    // Put the pixels into the video PImage
    bi2.getRGB(0, 0, rev.width, rev.height, rev.pixels, 0, rev.width);
  }
  catch(Exception e) {
    //
  }
  rev.updatePixels();
}
void distort(PImage _img, int _a) {
  loadPixels();
  float rr = random(20, 300);
  int m = int(map(rr, 0, _img.width, 0, _a));
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int i = x + y * width;
      //if (y>100 && y < height-100 && x > 100 && x < width-100) {
      int n = int(m*noise(rr*0.005, y*0.05));
      //int tx = x + n;
      int nx = int(x+n);
      if ( nx > _img.width) {
        //nx = nx - _img.width;
      }
      set(nx, y, pixels[i]);
    }
  }
}
void bn() {
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int i = x + y * width;
      pixels[i] = color(brightness(pixels[i]));
    }
  }
  updatePixels();
}
void doNoise() {
  loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    pixels[i] = color(random(255));
  }
  updatePixels();
}

class VideoFrame {
  PImage[] video = new PImage[0];
  int frame = 0;
  VideoFrame(PImage[] _imgs) {
    video = _imgs;
  }
  public void render() {
    if (((frameCount + 2) / 2) % int(random(video.length)+2) == 0) {
      frame = int(random(video.length));
    } else {
      frame++;
      frame = frame % video.length;
    }
    //image(video[frame], 0, 0);
  }
  public PImage getFrame() {
    return video[frame];
  }
}
PImage[] loadImages( String _folder ) {
  PImage[] _imgs = new PImage[0];
  File folder = new File(_folder);
  File[] lista_jpg = folder.listFiles();
  String[] filenames = folder.list();
  for (int i = 0; i < filenames.length; i++) {
    // para que solo cargue jpgs
    String path = lista_jpg[i].getAbsolutePath();
    //if (path.toLowerCase().endsWith(".jpeg") || path.toLowerCase().endsWith(".jpg") || path.toLowerCase().endsWith(".png"))
    ///{   
    PImage img = loadImage(_folder+"/"+filenames[i], "jpg");
    _imgs = (PImage[])append(_imgs, img);
    //}
  }
  return _imgs;
}
class Video {
  ArrayList<PImage> video;
  int x, y;
  int TIPO = 0;
  Video( ArrayList<PImage> _v, int _rx, int _ry ) {
    x = _rx;
    y = _ry;
    video = _v;
    TIPO = ADD;
  }
  Video( ArrayList<PImage> _v, int _rx, int _ry, int _t ) {
    x = _rx;
    y = _ry;
    video = _v;
    TIPO = _t;
  }
  PImage getFrame() {
    int frame = int( frameCount %  video.size() );
    PImage img = (PImage) video.get( frame );
    return img;
  }
  void viewMovie() {
    int frame = int( frameCount %  video.size() );
    image(video.get( frame ), x, y);
  }
  int getVideoSize() {
    return video.size();
  }
}