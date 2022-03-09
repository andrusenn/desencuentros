/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.
 
 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
 // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

synchronized public void controles_draw(PApplet appc, GWinData data) { //_CODE_:controles:893619:
  appc.background(50);
  appc.image(video_out, 0, 0, 400, 300);
  appc.noFill();
  appc.strokeWeight(2);
  appc.stroke(120);
  appc.rect( 0, 0, 400, 300);

  // info ------------------------
  appc.textSize(12);
  appc.textAlign(LEFT, CENTER);
  appc.fill(0, 100);
  appc.noStroke();
  appc.rect(0, 300-20, 400, 20);
  appc.fill(255);
  try {
    appc.text(cur_video_title + " | t: " + cur_video.time(), 5, 300-12);
  }
  catch(Exception e) {
    //
  }
  // -----------------------------
  // Reloj -----------------------
  // info ------------------------
  try {
    // Comenzar
    appc.textSize(20);
    appc.textAlign(CENTER, CENTER);
    if (reloj) {
      appc.fill(255, 0, 0);
      if (appc.frameCount % 15 < 7) {
        appc.text("INICIADO", 600, 50);
      }
    } else {
      appc.fill(255);
      appc.text("R para iniciar", 600, 50);
    }
    // Reloj
    appc.textSize(90);
    appc.textAlign(CENTER, CENTER);
    appc.fill(255);
    String rm = reloj_min<10?"0"+reloj_min:""+reloj_min;
    String rs = reloj_seg<10?"0"+reloj_seg:""+reloj_seg;
    appc.text(rm + ":" + rs, 600, 150);

    // Info teclas
    appc.textSize(25);
    appc.textAlign(LEFT, CENTER);
    appc.fill(255);
    for (int i = 0; i < E.length; i++) {
      appc.fill(255);
      if (i+1 == PANTALLA) {
        appc.fill(255, 0, 0);
      }
      appc.text(E[i], 15, 350 + i * 30);
    }
  }
  catch(Exception e) {
    //
  }
  // -----------------------------
} //_CODE_:controles:893619:

synchronized public void controles_key(PApplet appc, GWinData data, KeyEvent kevent) { //_CODE_:controles:988776:
  if ( kevent.getAction() == KeyEvent.RELEASE ) {
    keyEvents(appc);
  }
} //_CODE_:controles:656912:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI() {
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  surface.setTitle("Desencuentros");
  controles = GWindow.getWindow(this, "Controles", 100, 100, 800, 600, JAVA2D);
  controles.noLoop();
  controles.addDrawHandler(this, "controles_draw");
  controles.addKeyHandler(this, "controles_key");
  controles.loop();
}

// Variable declarations 
// autogenerated do not edit
GWindow controles;