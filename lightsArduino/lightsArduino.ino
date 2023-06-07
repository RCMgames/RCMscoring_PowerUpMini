#include <FastLED.h>

#define lctR 240
#define lctB 225
#define R_PIN 1
#define B_PIN 0
CRGB ledsR[lctR];
CRGB ledsB[lctB];

#define redNearS 0
#define redNearE 69
#define redSideS 73
#define redSideE 145
#define redAwayS 151
#define redAwayE 220
#define loopRedS 225
#define loopRedE 240
#define bluNearS 0
#define bluNearE 69
#define bluSideS 73
#define bluSideE 145
#define bluAwayS 151
#define bluAwayE 220

CRGB matchTimeBackground = CRGB(40, 40, 0);
CRGB matchTimeForeground = CRGB(0, 220, 0);
CRGB climbColor = CRGB(255, 255, 0);

int matchLength = 300;
int climbTime = 30;

int serialI = 0;

int matchState = -2;
int matchTime = 0;
bool blueSwitch = false;
bool redSwitch = false;
bool blueScale = false;
bool redScale = false;
int winner = 0;
int redScore = 0;
int blueScore = 0;

void setup()
{
  Serial.begin(250000);
  delay(2000);
  FastLED.addLeds<WS2812, R_PIN, GRB>(ledsR, lctR);
  FastLED.addLeds<WS2812, B_PIN, GRB>(ledsB, lctB);
  FastLED.setBrightness(100);

}
void loop()
{
  // Read the serial buffer and save to char array
  byte buffer[32];
  while (Serial.available() > 0) {

    buffer[serialI] = Serial.read();
    //    Serial.print(buffer[serialI]);
    if (buffer[serialI] == 255) {

      if (serialI == 8 && buffer[0] == 254) {
        // valid length, process.
        matchState = constrain(buffer[1] - 10, -1, 2);
        matchTime = (buffer[2] & 0b1111111) << 7 | (buffer[3] & 0b1111111);
        blueSwitch = bitRead(buffer[4], 0);
        redSwitch = bitRead(buffer[4], 1);
        blueScale = bitRead(buffer[4], 2);
        redScale = bitRead(buffer[4], 3);
        winner = constrain((((int)buffer[5]) - 10), -1, 1); // 1=red, 0=tie, -1=blue
        redScore  = constrain(5 * buffer[6], 0, 1000);
        blueScore = constrain(5 * buffer[7], 0, 1000);

        //        Serial.print("matchState: "); Serial.print(matchState); Serial.print(",");
        //        Serial.print("matchTime: "); Serial.print(matchTime); Serial.print(",");
        //        Serial.print("blueSwitch: "); Serial.print(blueSwitch); Serial.print(",");
        //        Serial.print("redSwitch: "); Serial.print(redSwitch); Serial.print(",");
        //        Serial.print("blueScale: "); Serial.print(blueScale); Serial.print(",");
        //        Serial.print("redScale: "); Serial.print(redScale); Serial.print(",");
        //        Serial.print("winner: "); Serial.print(winner); Serial.print(",");
        //        Serial.print("redScore: "); Serial.print(redScore); Serial.print(",");
        //        Serial.print("blueScore: "); Serial.print(blueScore); Serial.print(",");
        //        Serial.println();

      }
      serialI = 0;
    } else {
      if (serialI < 32 - 1) { // prevent buffer overflow "attacks"
        serialI++;
      }
    }
  }
  // display lights
  switch (matchState) {
    case -1:
      for (int i = bluNearS; i <= bluAwayE; i ++) {
        ledsB[i] = CHSV(millis() / 4 - i * 10 * 255 / (bluAwayE - bluNearS + redAwayE - redNearS), 150, 70);
      }
      for (int i = redAwayE; i >= redNearS ; i --) {
        ledsR[i] = CHSV(millis() / 4 - i * 10 * 255 / (bluAwayE - bluNearS + redAwayE - redNearS), 150, 70);
      }
      for (int i = loopRedS; i <= loopRedE; i++) {
        ledsR[i] = CHSV(millis() / 10 + i * 20, 200, ((millis() / 30) % (loopRedE - loopRedS + 1) == i - loopRedS) ? 255 : 120);
      }
      for (int i = redNearS + 5; i <= redAwayE; i += 10) {
        ledsR[i - 1] = CRGB(255, 0, 0);
        ledsR[i] = CRGB(255, 0, 0);
        ledsR[i + 1] = CRGB(255, 0, 0);
      }
      for (int i = bluNearS + 5; i <= bluAwayE; i += 10) {
        ledsB[i - 1] = CRGB(0, 0, 255);
        ledsB[i] = CRGB(0, 0, 255);
        ledsB[i + 1] = CRGB(0, 0, 255);
      }
      break;
    case 0:
      FastLED.clear();
      for (int i = redSideS; i <= redSideE; i++) {
        ledsR[i] = CRGB(sin8(millis() / 16) / 8 + 100, 0, 0);
      }
      for (int i = bluSideS; i <= bluSideE; i++) {
        ledsB[i] = CRGB(0, 0, sin8(millis() / 16) / 8 + 100);
      }

      for (int i = redNearS; i <= redNearE; i ++) {
        if (-i + redNearE > matchTime * (redNearE - redNearS) / matchLength) {
          ledsR[i] = matchTimeBackground;
        } else {
          ledsR[i] = matchTimeForeground;
        }
        if (matchLength - matchTime <= climbTime) {
          if ((i + (millis() / 100)) % 12 == 0) {
            ledsR[i] = climbColor;
          }
        }
      }
      for (int i = bluNearS; i <= bluNearE; i ++) {
        if (-i + bluNearE > matchTime * (bluNearE - bluNearS) / matchLength) {
          ledsB[i] = matchTimeBackground;
        } else {
          ledsB[i] = matchTimeForeground;
        }
        if (matchLength - matchTime <= climbTime) {
          if ((i + (millis() / 100)) % 12 == 0) {
            ledsB[i] = climbColor;
          }
        }
      }
      for (int i = redAwayS; i <= redAwayE; i ++) {
        if (i - redAwayS > matchTime * (redAwayE - redAwayS) / matchLength) {
          ledsR[i] = matchTimeBackground;
        } else {
          ledsR[i] = matchTimeForeground;
        }
        if (matchLength - matchTime <= climbTime) {
          if ((-i + (millis() / 100)) % 12 == 0) {
            ledsR[i] = climbColor;
          }
        }
      }
      for (int i = bluAwayS; i <= bluAwayE; i ++) {
        if (i - bluAwayS > matchTime * (bluAwayE - bluAwayS) / matchLength) {
          ledsB[i] = matchTimeBackground;
        } else {
          ledsB[i] = matchTimeForeground;
        }

        if (matchLength - matchTime <= climbTime) {
          if ((-i + (millis() / 100)) % 12 == 0) {
            ledsB[i] = climbColor;
          }
        }
      }

      break;
    case 1:
      for (int i = bluNearS; i <= bluAwayE; i ++) {
        ledsB[i] = CRGB(100, 0, 100);
      }
      for (int i = redAwayE; i >= redNearS ; i --) {
        ledsR[i] = CRGB(100, 0, 100);
      }
      for (int i = loopRedS; i <= loopRedE; i++) {
        ledsR[i] = CHSV(millis() / 10 + i * 20, 200, ((millis() / 30) % (loopRedE - loopRedS + 1) == i - loopRedS) ? 255 : 120);
      }

      break;
    case 2:

      for (int i = bluNearS; i <= bluAwayE; i ++) {
        if (winner == 1) {
          ledsB[i] = CRGB(220, 0, 0);
        } else if (winner == -1) {
          ledsB[i] = CRGB(0, 0, 220);
        } else {
          ledsB[i] = CRGB(200, 200, 0);
        }
      }
      for (int i = redAwayE; i >= redNearS ; i --) {
        if (winner == 1) {
          ledsR[i] = CRGB(220, 0, 0);
        } else if (winner == -1) {
          ledsR[i] = CRGB(0, 0, 220);
        } else {
          ledsR[i] = CRGB(200, 200, 0);
        }
      }
      break;
    default:
      FastLED.clear();
      break;
  }

  FastLED.show();
  delay(1);

}
