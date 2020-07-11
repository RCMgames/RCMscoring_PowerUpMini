class refPWindow extends PApplet {
  refPWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void settings() {
    size(1920, 700);
  }

  void setup() {
    background(255);
  }

  void draw() {
    background(255);
    String[] bmsg={"score", "switchOwnTime", "scaleOwnTime", "ownershipScore", "penaltyScore"};
    String[] bval={str(int(blueScore)), str(int(blueSwitchOwnershipTime)), str(int(blueScaleOwnershipTime)), str(int(blueOwnershipScore)), str(int(bluePenaltyScore))};
    String[] rmsg={"score", "switchOwnTime", "scaleOwnTime", "ownershipScore", "penaltyScore"};
    String[] rval={str(int(redScore)), str(int(redSwitchOwnershipTime)), str(int(redScaleOwnershipTime)), str(int(redOwnershipScore)), str(int(redPenaltyScore))};
    if (blueSide==Left) {
      dispData(color(0, 0, 100), bmsg, bval, 0, 0, width*.2, height, 35);
      dispData(color(100, 0, 0), rmsg, rval, width*.8, 0, width*.2, height, 35);
    } else {
      dispData(color(0, 0, 100), bmsg, bval, width*.8, 0, width*.2, height, 35);
      dispData(color(100, 0, 0), rmsg, rval, 0, 0, width*.2, height, 35);
    }
  }

  void mousePressed() {
  }

  void dispData(color c, String[] msg, String[] val, float x, float y, float w, float h, float ts) {
    pushStyle();
    textSize(ts);
    stroke(255);
    strokeWeight(1);
    fill(c);
    rect(x, y, w, h-1);
    fill(255);
    for (int i=0; i<msg.length; i++) {
      text(msg[i], x+5, (i+1)*h/(msg.length+1)+y, w*.95, 2*h/(msg.length+1));
      text(": "+val[i], x+5+constrain(textWidth(msg[i]+": "), 0, w*.95), (i+1)*h/(msg.length+1)+y, w- textWidth(": "+msg[i]), 2*h/(msg.length+1));
    }
    popStyle();
  }
}
