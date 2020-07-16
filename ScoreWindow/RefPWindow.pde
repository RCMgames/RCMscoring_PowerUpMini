boolean plateOverride=false;
class refPWindow extends PApplet {
  refPWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void settings() {
    size(1920, 700);
  }

  void setup() {    
    frameRate(100);
    background(255);
  }

  void draw() {
    background(255);
    if (state==0) {
      fill(0);
      textSize(35);
      text("match time elapsed: "+str(int(totalMatchTime-matchTime)) +"  ("+str(int((totalMatchTime-matchTime)*100/totalMatchTime))+" %)", width*.26, 40);
    }
    textSize(35);
    if (millis()-lastMillisArduinoComms<50) {
      fill(0);
      text("field connected", width*.56, 40);
    } else {
      fill(255, 0, 0);
      rect(width*.55, 0, width*.2, 50);
      fill(0);
      text("CONNECTION LOST", width*.56, 40);
    }

    String[] bmsg={"score", "ownership score", "penalty score", "ownership %", "switch own time", "scale own time", "climbs"};
    String[] bval={str(int(blueScore)), str(int(blueOwnershipScore)), str(int(bluePenaltyScore)), nf(blueOwnershipPercent, 3, 1)+(blueOwnershipPercent>=ownershipRPPercent?"   (RP)":""), str(int(blueSwitchOwnershipTime)), str(int(blueScaleOwnershipTime)), blueClimbs==maxClimbs?str(blueClimbs)+"         (RP)":str(blueClimbs)};
    String[] rmsg={"score", "ownership score", "penalty score", "ownership %", "switch own time", "scale own time", "climbs"};
    String[] rval={str(int(redScore)), str(int(redOwnershipScore)), str(int(redPenaltyScore)), nf(redOwnershipPercent, 3, 1)+(redOwnershipPercent>=ownershipRPPercent?"   (RP)":""), str(int(redSwitchOwnershipTime)), str(int(redScaleOwnershipTime)), redClimbs==maxClimbs?str(redClimbs)+"         (RP)":str(redClimbs)};
    if (blueSide==Left) {
      dispData(color(0, 0, 100), bmsg, bval, 0, 0, width*.25, height, 35);
      dispData(color(100, 0, 0), rmsg, rval, width*.75, 0, width*.25, height, 35);
    } else {
      dispData(color(0, 0, 100), bmsg, bval, width*.75, 0, width*.25, height, 35);
      dispData(color(100, 0, 0), rmsg, rval, 0, 0, width*.25, height, 35);
    }

    if (nextState) {
      nextState=false;
      state++;
      if (state==2) {//post match
        String strToSave=str(year())+"/"+str(month())+"/"+str(day())+" "+str(hour())+":"+str(minute())+":"+str(second())+","+str(int(blueScore))+","+str(int(redScore))+","+str(blueRP)+","+str(int(redRP))+","+str(bluePenaltyScore)+","+str(redPenaltyScore)+","+str(blueClimbs)+","+str(redClimbs)+","+nf(blueOwnershipPercent, 3, 1)+","+nf(redOwnershipPercent, 3, 1)+","+int(blueSwitchOwnershipTime)+","+int(redSwitchOwnershipTime)+","+int(blueScaleOwnershipTime)+","+int(redScaleOwnershipTime) +","+str(int(totalMatchTime-matchTime));
        try {        
          String[] stringsToSave=loadStrings(filename);
          stringsToSave=append(stringsToSave, strToSave);                  
          saveStrings(filename, stringsToSave);
        }
        catch(NullPointerException e) {
          String[] stringsToSave={strToSave};
          saveStrings(filename, stringsToSave);
        }
      }
      if (state>2) {
        state=-1;
      }
    }
    pushStyle();
    rectMode(CENTER);
    textSize(20);
    fill(0);
    rect(width*.6, height*.8, width*.1, height*.2);
    fill(255);
    textAlign(CENTER);
    String[] ms={"start match", "stop match", "submit scores", "reset"};
    text("(b) "+ms[state+1], width*.6, height*.8, width*.1, height*.2);
    popStyle();

    if (state==0||state==1) {
      rectMode(CENTER);
      textSize(20);
      if (blueSide==Right) {
        fill(0, 0, 255);
      } else {
        fill(255, 0, 0);
      }
      rect(width*.58, height*.5, width*.09, height*.2);
      rect(width*.7, height*.5, width*.09, height*.2);
      rect(width*.6, height*.3, width*.09, height*.15);
      fill(255);
      text("(j) Foul", width*.58, height*.5, width*.09, height*.2);
      text("(k) Tech Foul", width*.7, height*.5, width*.09, height*.2);
      text("(h) Climb", width*.6, height*.3, width*.09, height*.15);
      if (blueSide==Left) {
        fill(0, 0, 255);
      } else {
        fill(255, 0, 0);
      }
      rect(width*.42, height*.5, width*.09, height*.2);
      rect(width*.3, height*.5, width*.09, height*.2);
      rect(width*.4, height*.3, width*.09, height*.15);
      fill(255);
      text("(f) Foul", width*.42, height*.5, width*.09, height*.2);
      text("(d) Tech Foul", width*.3, height*.5, width*.09, height*.2);
      text("(g) Climb", width*.4, height*.3, width*.09, height*.15);
      rectMode(CORNER);
    }
    if (plateOverride) {
      rectMode(CENTER);
      if (leftSwitchOverride!=null&&leftSwitchOverride==Far) {
        fill(0);
      } else {
        fill(160);
      }
      rect(width*(.4-.05), height*(.8-.1), width*.04, height*.09);
      if (leftSwitchOverride!=null&&leftSwitchOverride==Center) {
        fill(0);
      } else {
        fill(160);
      }
      rect(width*(.4-.05), height*(.8), width*.04, height*.09);
      if (leftSwitchOverride!=null&&leftSwitchOverride==Near) {
        fill(0);
      } else {
        fill(160);
      }
      rect(width*(.4-.05), height*(.8+.1), width*.04, height*.09);

      if (scaleOverride!=null&&scaleOverride==Far) {
        fill(0);
      } else {
        fill(160);
      }
      rect(width*(.4), height*(.8-.1), width*.04, height*.09);
      if (scaleOverride!=null&&scaleOverride==Center) {
        fill(0);
      } else {
        fill(160);
      }
      rect(width*(.4), height*(.8), width*.04, height*.09);
      if (scaleOverride!=null&&scaleOverride==Near) {
        fill(0);
      } else {
        fill(160);
      }
      rect(width*(.4), height*(.8+.1), width*.04, height*.09);

      if (rightSwitchOverride!=null&&rightSwitchOverride==Far) {
        fill(0);
      } else {
        fill(160);
      }
      rect(width*(.4+.05), height*(.8-.1), width*.04, height*.09);
      if (rightSwitchOverride!=null&&rightSwitchOverride==Center) {
        fill(0);
      } else {
        fill(160);
      }
      rect(width*(.4+.05), height*(.8), width*.04, height*.09);
      if (rightSwitchOverride!=null&&rightSwitchOverride==Near) {
        fill(0);
      } else {
        fill(160);
      }
      rect(width*(.4+.05), height*(.8+.1), width*.04, height*.09);
      rectMode(CORNER);
    }
  }

  void mouseReleased() {
    if (mouseInCR(width*.6, height*.8, width*.1, height*.2)) {
      nextState=true;
    }
    if (plateOverride) {
      if (mouseInCR(width*(.4-.05), height*(.8-.1), width*.04, height*.09)) {
        if (leftSwitchOverride==null) {
          leftSwitchOverride=Far;
        } else {
          leftSwitchOverride=null;
        }
      }
      if (mouseInCR(width*(.4-.05), height*(.8), width*.04, height*.09)) {      
        if (leftSwitchOverride==null) {
          leftSwitchOverride=Center;
        } else {
          leftSwitchOverride=null;
        }
      }
      if (mouseInCR(width*(.4-.05), height*(.8+.1), width*.04, height*.09)) {      
        if (leftSwitchOverride==null) {
          leftSwitchOverride=Near;
        } else {
          leftSwitchOverride=null;
        }
      }

      if (mouseInCR(width*(.4), height*(.8-.1), width*.04, height*.09)) {      
        if (scaleOverride==null) {
          scaleOverride=Far;
        } else {
          scaleOverride=null;
        }
      }
      if (mouseInCR(width*.4, height*.8, width*.04, height*.09)) {
        if (scaleOverride==null) {
          scaleOverride=Center;
        } else {
          scaleOverride=null;
        }
      }
      if (mouseInCR(width*(.4), height*(.8+.1), width*.04, height*.09)) {
        if (scaleOverride==null) {
          scaleOverride=Near;
        } else {
          scaleOverride=null;
        }
      }

      if (mouseInCR(width*(.4+.05), height*(.8-.1), width*.04, height*.09)) {
        if (rightSwitchOverride==null) {
          rightSwitchOverride=Far;
        } else {
          rightSwitchOverride=null;
        }
      }
      if (mouseInCR(width*(.4+.05), height*(.8), width*.04, height*.09)) {
        if (rightSwitchOverride==null) {
          rightSwitchOverride=Center;
        } else {
          rightSwitchOverride=null;
        }
      }
      if (mouseInCR(width*(.4+.05), height*(.8+.1), width*.04, height*.09)) {
        if (rightSwitchOverride==null) {
          rightSwitchOverride=Near;
        } else {
          rightSwitchOverride=null;
        }
      }
    }

    if (state==0||state==1) {
      if (mouseInCR(width*.58, height*.5, width*.09, height*.2)) {
        if (blueSide==Left) {
          redPenaltyScore-=foulValue;
          redFoulMillis=millis();
        } else {
          bluePenaltyScore-=foulValue;
          blueFoulMillis=millis();
        }
      }
      if (mouseInCR(width*.7, height*.5, width*.09, height*.2)) {
        if (blueSide==Left) {
          redPenaltyScore-=techFoulValue;
          redTechFoulMillis=millis();
        } else {
          bluePenaltyScore-=techFoulValue;
          blueTechFoulMillis=millis();
        }
      }
      if (mouseInCR(width*.42, height*.5, width*.09, height*.2)) {
        if (blueSide==Right) {
          redPenaltyScore-=foulValue;
          redFoulMillis=millis();
        } else {
          bluePenaltyScore-=foulValue;
          blueFoulMillis=millis();
        }
      }
      if (mouseInCR(width*.3, height*.5, width*.09, height*.2)) {
        if (blueSide==Right) {
          redPenaltyScore-=techFoulValue;
          redTechFoulMillis=millis();
        } else {
          bluePenaltyScore-=techFoulValue;
          blueTechFoulMillis=millis();
        }
      }
      if (mouseInCR(width*.4, height*.3, width*.09, height*.15)) {
        if (blueSide==Right) {
          redClimbs++;
        } else {
          blueClimbs++;
        }
      }
      if (mouseInCR(width*.6, height*.3, width*.09, height*.15)) {
        if (blueSide==Left) {
          redClimbs++;
        } else {
          blueClimbs++;
        }
      }
      if (redClimbs>maxClimbs)
        redClimbs=0;
      if (blueClimbs>maxClimbs)
        blueClimbs=0;
    }
  }
  void keyReleased() {
    if (key=='b') {
      nextState=true;
    }
    if (key=='0') {
      plateOverride=!plateOverride;
    }
    if (state==0||state==1) {
      if (key=='j') {
        if (blueSide==Left) {
          redPenaltyScore-=foulValue;
          redFoulMillis=millis();
        } else {
          bluePenaltyScore-=foulValue;
          blueFoulMillis=millis();
        }
      }
      if (key=='k') {
        if (blueSide==Left) {
          redPenaltyScore-=techFoulValue;
          redTechFoulMillis=millis();
        } else {
          bluePenaltyScore-=techFoulValue;
          blueTechFoulMillis=millis();
        }
      }
      if (key=='f') {
        if (blueSide==Right) {
          redPenaltyScore-=foulValue;
          redFoulMillis=millis();
        } else {
          bluePenaltyScore-=foulValue;
          blueFoulMillis=millis();
        }
      }
      if (key=='d') {
        if (blueSide==Right) {
          redPenaltyScore-=techFoulValue;
          redTechFoulMillis=millis();
        } else {
          bluePenaltyScore-=techFoulValue;
          blueTechFoulMillis=millis();
        }
      }

      if (key=='g') {
        if (blueSide==Right) {
          redClimbs++;
        } else {
          blueClimbs++;
        }
      }
      if (key=='h') {
        if (blueSide==Left) {
          redClimbs++;
        } else {
          blueClimbs++;
        }
      }
      if (redClimbs>maxClimbs)
        redClimbs=0;
      if (blueClimbs>maxClimbs)
        blueClimbs=0;
    }
  }

  boolean mouseInCR(float x, float y, float w, float h) {
    return (abs(mouseX-x)<w/2&&abs(mouseY-y)<w/2);
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
      text(msg[i], x+5, (i+1)*h/(msg.length+1)+y, w*.95, 2*h/(msg.length+1));
      text(": "+val[i], x+5+constrain(textWidth(msg[i]+": "), 0, w*.95), (i+1)*h/(msg.length+1)+y, w- textWidth(": "+msg[i]), 2*h/(msg.length+1));
    }
    popStyle();
  }
}
