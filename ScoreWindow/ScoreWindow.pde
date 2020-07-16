refPWindow refWin;
import processing.serial.*;
Serial myPort;
static final int Near=1;
static final int Far=-1;
static final int Center=0;
static final int Left=-1;
static final int Right=1;

String filename="C:/Users/Joshua/Google Drive/JoshuaFiles/Current/Projects/rcmgames/RCMgames/competition scoring/mini powerup/test/rcmscores.txt";
String serialPort="COM5";

int blueSide=Right;////
int LswitchBlue=Far;////
int scaleBlue=Far;////
int RswitchBlue=Far;////

int LswitchPos=0;
int scalePos=0;
int RswitchPos=0;
int LswitchPosA=0;
int scalePosA=0;
int RswitchPosA=0;

float redScore=0;
float blueScore=0;

int redRP=0;
int blueRP=0;

float redSwitchOwnershipTime=0;
float redScaleOwnershipTime=0;
float blueScaleOwnershipTime=0;
float blueSwitchOwnershipTime=0;

float redOwnershipPercent=0;
float blueOwnershipPercent=0;

float redOwnershipScore=0;
float blueOwnershipScore=0;

float redPenaltyScore=0;
float bluePenaltyScore=0;

int redClimbs=0;
int blueClimbs=0;

int state=-1;

float matchTime=0;
int totalMatchTime=5*60;/////
int matchStartMillis=0;
int endgameTime=30;////
int autoTime=15;////

float switchPointsPerSecondStart=1;////
float switchPointsPerSecondEnd=2;////
float scalePointsPerSecondStart=1;////
float scalePointsPerSecondEnd=2;////

float switchForOwnership=1;////
float scaleForOwnership=0;////

float climbPoints=90;////
float foulValue=15;////
float techFoulValue=100;////
float ownershipRPPercent=90;////

boolean nextState=false;
long millisLastCalculatedScore=0;
long redFoulMillis=0;
long blueFoulMillis=0;
long redTechFoulMillis=0;
long blueTechFoulMillis=0;
long lastMillisArduinoComms=0;

Integer leftSwitchOverride=null;
Integer scaleOverride=null;
Integer rightSwitchOverride=null;

int maxClimbs=2;////


void settings() {
  size(1920, 300);
}  

void setup() {
  refWin=new refPWindow();
  frameRate(100);
  myPort=new Serial(this, serialPort, 250000);
}

void serialEvent(Serial p) {
  lastMillisArduinoComms=millis();
  int in=p.read();
  LswitchPosA=0;
  scalePosA=0;
  RswitchPosA=0;
  if (((byte)in & 0x01)==1) LswitchPosA+=Far;
  if (((byte)in>>1 & 0x01)==1) LswitchPosA+=Near;
  if (((byte)in>>2 & 0x01)==1) scalePosA+=Far;
  if (((byte)in>>3 & 0x01)==1) scalePosA+=Near;
  if (((byte)in>>4 & 0x01)==1) RswitchPosA+=Far;
  if (((byte)in>>5 & 0x01)==1) RswitchPosA+=Near;
}

void draw() {
  LswitchPos=LswitchPosA;
  scalePos=scalePosA;
  RswitchPos=RswitchPosA;
  if (leftSwitchOverride!=null) {
    LswitchPos=leftSwitchOverride;
  }
  if (scaleOverride!=null) {
    scalePos=scaleOverride;
  }
  if (rightSwitchOverride!=null) {
    RswitchPos=rightSwitchOverride;
  }

  if (state<0) {
    redScore=0;
    blueScore=0;
    redSwitchOwnershipTime=0;
    redScaleOwnershipTime=0;
    blueScaleOwnershipTime=0;
    blueSwitchOwnershipTime=0;
    redOwnershipScore=0;
    blueOwnershipScore=0;
    redPenaltyScore=0;
    bluePenaltyScore=0;
    redClimbs=0;
    blueClimbs=0;
    redOwnershipPercent=0;
    blueOwnershipPercent=0;
    redRP=0;
    blueRP=0;
    matchStartMillis=millis();
  }
  if (state==-1) {
    background(#999999);
    textSize(20);
    fill(0);
    text("pre match", width/2, height/2);
  }

  if (state==2) {
    noStroke();
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    textSize(height/3);
    if (int(redScore)>int(blueScore)) {
      fill(255, 0, 0);
      rect(width/2, height/2, width/3, height);
      fill(0);
      text("RED Wins", width/2, height/2);
    }
    if (int(redScore)<int(blueScore)) {
      fill(0, 0, 255);
      rect(width/2, height/2, width/3, height);
      fill(0);
      text("BLUE Wins", width/2, height/2);
    }
    if (int(redScore)==int(blueScore)) {
      fill(255, 255, 0);
      rect(width/2, height/2, width/3, height);
      fill(0);
      text("TIE", width/2, height/2);
    }
    fill(0, 0, 255);
    String[] blueL={"points", "ownership points", "RPs", "climbs", "switch ownership %", "switch own time", "scale own time", "penalties"};
    String[] blueD={str(int(blueScore)), str(int(redOwnershipScore)), str(blueRP), str(blueClimbs), str(int(blueOwnershipPercent))+((blueOwnershipPercent>ownershipRPPercent)?"  (RP)":""), str(int(blueSwitchOwnershipTime)), str(int(blueScaleOwnershipTime)), str(bluePenaltyScore)};
    if (blueSide==Left) {
      dispData(color(0, 0, 100), blueL, blueD, 0, 0, width/3, height, 25);
    } else {
      dispData(color(0, 0, 100), blueL, blueD, width*2/3, 0, width/3, height, 35);
    }
    String[] redL={"points", "ownership points", "RPs", "climbs", "switch ownership %", "switch own time", "scale own time", "penalties"};
    String[] redD={str(int(redScore)), str(int(redOwnershipScore)), str(redRP), str(redClimbs), str(int(redOwnershipPercent))+((redOwnershipPercent>ownershipRPPercent)?"  (RP)":""), str(int(redSwitchOwnershipTime)), str(int(redScaleOwnershipTime)), str(redPenaltyScore)};
    if (blueSide==Left) {
      dispData(color(100, 0, 0), redL, redD, width*2/3, 0, width/3, height, 25);
    } else {
      dispData(color(100, 0, 0), redL, redD, 0, 0, width/3, height, 35);
    }
  }

  if (state==0) {
    background(#E5B102);
    matchTime=totalMatchTime-(millis()-matchStartMillis)/1000.0;

    float switchPointsPerSecond=map(matchTime, totalMatchTime, 0, switchPointsPerSecondStart, switchPointsPerSecondEnd);
    float scalePointsPerSecond=map(matchTime, totalMatchTime, 0, scalePointsPerSecondStart, scalePointsPerSecondEnd);
    float interval=(millis()-millisLastCalculatedScore)/1000.0;
    millisLastCalculatedScore=millis();
    if (redSwitch()) {
      redOwnershipScore+=switchPointsPerSecond*interval;
      redSwitchOwnershipTime+=interval;
    }

    if (redScale()) {
      redOwnershipScore+=scalePointsPerSecond*interval;
      redScaleOwnershipTime+=interval;
    }

    if (blueSwitch()) {
      blueOwnershipScore+=switchPointsPerSecond*interval;
      blueSwitchOwnershipTime+=interval;
    }

    if (blueScale()) {
      blueOwnershipScore+=scalePointsPerSecond*interval;
      blueScaleOwnershipTime+=interval;
    }

    blueOwnershipPercent=(blueScaleOwnershipTime*scaleForOwnership+blueSwitchOwnershipTime*switchForOwnership)*100.0/totalMatchTime;
    redOwnershipPercent=(redScaleOwnershipTime*scaleForOwnership+redSwitchOwnershipTime*switchForOwnership)*100.0/totalMatchTime;

    redScore=redOwnershipScore+redPenaltyScore;
    blueScore=blueOwnershipScore+bluePenaltyScore;

    if (matchTime<=0)
      state=1;

    if (blueSide==Right) {
      drawSwitchScaleIcon(width*.2, height*.9, color(255, 0, 0), color(150), redSwitch(), redScale());
      drawSwitchScaleIcon(width*.8, height*.9, color(0, 0, 255), color(150), blueSwitch(), blueScale());
    } else { 
      drawSwitchScaleIcon(width*.2, height*.9, color(0, 0, 255), color(150), blueSwitch(), blueScale());
      drawSwitchScaleIcon(width*.8, height*.9, color(255, 0, 0), color(150), redSwitch(), redScale());
    }
    drawScores(height*.3, height*.69, .2);
    drawTime(width*.4, height*.25, height*.05);
    drawPenaltyFlags();
  } else {
    millisLastCalculatedScore=millis();
  }
  if (state==1) {
    background(#FFFF00);
    textSize(50);
    fill(0);
    text("final scores are being reviewed", width/4, height/2);
    redScore=redOwnershipScore+redPenaltyScore+climbPoints*redClimbs;
    blueScore=blueOwnershipScore+bluePenaltyScore+climbPoints*blueClimbs;
    redRP=2*int(int(redScore)>int(blueScore)+int(int(redScore)==int(blueScore)))+int(redOwnershipPercent>=ownershipRPPercent)+int(redClimbs==maxClimbs);
    blueRP=2*int(int(blueScore)>int(redScore)+int(int(blueScore)==int(redScore)))+int(blueOwnershipPercent>=ownershipRPPercent)+int(blueClimbs==maxClimbs);
  }
}

void drawPenaltyFlags() {
  pushStyle();
  if (millis()-redFoulMillis<1000) {
    penaltyFlag(blueSide==Left, 1-1*cos((millis()-redFoulMillis)*1*TWO_PI/1000), color(255, 0, 0));
  }
  if (millis()-redTechFoulMillis<1000) {
    penaltyFlag(blueSide==Left, 1-1*cos((millis()-redTechFoulMillis)*1*TWO_PI/1000), color(255, 0, 0));
  } else if (millis()-redTechFoulMillis<2000) {
    techX(-blueSide, color(255, 0, 0));
  }
  if (millis()-blueFoulMillis<1000) {
    penaltyFlag(blueSide==Right, 1-1*cos((millis()-blueFoulMillis)*1*TWO_PI/1000), color(0, 0, 255));
  }
  if (millis()-blueTechFoulMillis<1000) {
    penaltyFlag(blueSide==Right, 1-1*cos((millis()-blueTechFoulMillis)*1*TWO_PI/1000), color(0, 0, 255));
  } else if (millis()-blueTechFoulMillis<2000) {
    techX(blueSide, color(0, 0, 255));
  }
  popStyle();
}

void techX(int s, color c) { 
  pushStyle();
  fill(c);
  textSize(height*.5);
  textAlign(CENTER);
  rectMode(CENTER);
  text("X", width*.5+s*.45*width, height*.5, width*.2, height*.6);
  popStyle();
}

void penaltyFlag(boolean right, float angle, color c) {
  pushMatrix();
  noStroke();
  fill(c);
  rectMode(CORNER);
  if (right) {
    translate(width, height*.7);
    rotate(-angle);
  } else {
    translate(0, height*.7);
    rotate(angle);
  }
  if (right) {
    rect(0, -width*.1, -width*.05, width*.05);
  } else {
    rect(0, -width*.1, width*.05, width*.05);
  }
  fill(0);
  rect(-4, 0, 8, -width*.1);
  popMatrix();
}

void drawTime(float w, float h, float y) {
  pushStyle();
  strokeWeight(3);
  stroke(0);

  if (totalMatchTime-matchTime<autoTime) {    
    fill(220, 245, 90);
  } else {
    fill(255, 200, 100);
  }
  rectMode(CENTER);
  rect(width/2, y+h/2, w, h);

  noStroke();
  rectMode(CORNER);
  if (matchTime>endgameTime) {
    fill(0, 150, 0);
  } else {
    fill(250, 250, 0);
  }
  rect(width/2-w/2, y+h*.02, map(matchTime, totalMatchTime, 0, 0, w), h*.96, 0, h*.3, h*.3, 0);

  fill(255, 100);
  rectMode(CENTER);
  rect(width/2, y+h/2, w/6, h*.9, h*.45, h*.45, h*.45, h*.45);
  textAlign(CENTER);
  fill(0);
  textSize(h*.75);
  text(str(int(matchTime)), width/2, y+h/2, w/6, h*.9);

  popStyle();
}

void drawScores(float y, float h, float w) {
  pushStyle();
  strokeWeight(3);
  stroke(0);
  textAlign(CENTER);
  rectMode(CORNER);
  textSize(height*.4);

  fill(100, 100, 255);
  rect(width*.5, y, width*w*blueSide, h);
  fill(255);
  text(str(int(blueScore)), width/2-w/2*width+w*blueSide*width/2, y, width*w, h);

  fill(100, 0, 0);
  rect(width*.5, y, width*-w*blueSide, h);
  fill(255);
  text(str(int(redScore)), width/2-w/2*width-w*blueSide*width/2, y, width*w, h);

  popStyle();
}

void drawSwitchScaleIcon(float x, float s, color active, color inactive, boolean swi, boolean sca) {
  pushStyle();
  strokeWeight(5);
  stroke(0);
  fill(inactive);
  ellipse(x, height/2, s, s);
  if (sca) {
    fill(active);
  } else {
    fill(inactive);
  }
  arc(x, height/2, s, s, PI, TWO_PI, CHORD);
  if (swi) {
    fill(active);
  } else {
    fill(inactive);
  }    
  arc(x, height/2, s, s, 0, PI, CHORD);

  //icons
  line(x-s*.3, height/2+s*.22, x+s*.3, height/2+s*.22);
  line(x-s*.3, height/2-s*.3, x+s*.3, height/2-s*.3);
  rectMode(CENTER);
  strokeWeight(2);
  fill(255, 255, 0);
  rect(x, height/2+s*.25, s*.4, s*.08);
  rect(x, height/2-s*.3, s*.35, s*.03);
  triangle(x-s*.2, height/2-s*.05, x+s*.2, height/2-s*.05, x, height/2-s*.2); 
  rect(x, height/2-s*.2, s*.06, s*.3);

  popStyle();
}

boolean redSwitch() {
  return (blueSide==Right?(-LswitchBlue*LswitchPos):(RswitchBlue*RswitchPos))==1;
}
boolean blueSwitch() {
  return (blueSide==Right?(RswitchBlue*RswitchPos):(-LswitchBlue*LswitchPos))==1;
}
boolean blueScale() {
  return (scalePos*scaleBlue)==1;
}
boolean redScale() {
  return (-scalePos*scaleBlue)==1;
}
void dispData(color c, String[] msg, String[] val, float x, float y, float w, float h, float ts) {
  pushStyle();
  rectMode(CORNER);
  textSize(ts);
  stroke(255);
  strokeWeight(1);
  fill(c);
  rect(x, y, w, h-1);
  fill(255);
  textAlign(LEFT);
  for (int i=0; i<msg.length; i++) {
    text(msg[i], x+5, (i)*h/(msg.length+1)+y, w*.95, 2*h/(msg.length+1));
    text(": "+val[i], x+5+constrain(textWidth(msg[i]+": "), 0, w*.95), (i)*h/(msg.length+1)+y, w- textWidth(": "+msg[i]), 2*h/(msg.length+1));
  }
  popStyle();
}
