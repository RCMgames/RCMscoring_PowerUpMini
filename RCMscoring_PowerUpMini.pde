refPWindow refWin;

static final int Near=1;
static final int Far=-1;
static final int Center=0;
static final int Left=-1;
static final int Right=1;

int blueSide=Right;
int LswitchBlue=Near;
int scaleBlue=Far;
int RswitchBlue=Far;

int LswitchPos=0;
int scalePos=0;
int RswitchPos=0;

float redScore=0;
float blueScore=0;

float redSwitchOwnershipTime=0;
float redScaleOwnershipTime=0;
float blueScaleOwnershipTime=0;
float blueSwitchOwnershipTime=0;

float redOwnershipScore=0;
float blueOwnershipScore=0;

float redPenaltyScore=0;
float bluePenaltyScore=0;

int redClimbs=0;
int blueClimbs=0;

int state=0;

float matchTime=0;
int totalMatchTime=5*60;
int matchStartMillis=0;
int endgameTime=30;
int autoTime=15;

float switchPointsPerSecondStart=1;
float switchPointsPerSecondEnd=2;
float scalePointsPerSecondStart=1;
float scalePointsPerSecondEnd=2;

float climbPoints=90;
float foulValue=15;
float techFoulValue=100;


long millisLastCalculatedScore=0;
long redFoulMillis=0;
long blueFoulMillis=0;

void settings() {
  size(1920, 300);
}  

void setup() {
  refWin=new refPWindow();
}

void draw() {
  background(#E5B102);
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
  }
  if (state==0) {
    matchTime=totalMatchTime-(millis()+matchStartMillis)/1000.0;

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

    redScore=redOwnershipScore-redPenaltyScore;
    blueScore=blueOwnershipScore-bluePenaltyScore;

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
  } else {
    millisLastCalculatedScore=millis();
  }
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


void keyPressed() {
  if (key=='q') {
    LswitchPos=Far;
  }
  if (key=='a') {
    LswitchPos=Center;
  }
  if (key=='z') {
    LswitchPos=Near;
  }
  if (key=='w') {
    scalePos=Far;
  }
  if (key=='s') {
    scalePos=Center;
  }
  if (key=='x') {
    scalePos=Near;
  }
  if (key=='e') {
    RswitchPos=Far;
  }
  if (key=='d') {
    RswitchPos=Center;
  }
  if (key=='c') {
    RswitchPos=Near;
  }
}
