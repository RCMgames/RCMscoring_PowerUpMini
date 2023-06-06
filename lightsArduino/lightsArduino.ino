#include <FastLED.h>

#define lctR 300
#define lctB 399
#define R_PIN 6
#define B_PIN 7
CRGB ledsR[lctR];
CRGB ledsB[lctB];

int serialI = 0;

int matchState = 0;
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
  FastLED.addLeds<WS2812B, R_PIN, GRB>(ledsR, lctR);
  FastLED.addLeds<WS2812B, B_PIN, GRB>(ledsB, lctB);
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
        winner = constrain((char)((int)buffer[5] - 10), -1, 1); // 1=red, 0=tie, -1=blue
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
  ledsR[0] = CRGB(255, 0, 0);
  ledsR[1] = CRGB(0, 255, 0);
  ledsR[2] = CRGB(0, 255, 0);
  ledsR[3] = CRGB(0, 0, 255);
  ledsR[4] = CRGB(0, 0, 255);
  ledsR[5] = CRGB(0, 0, 255);
  ledsR[6] = CRGB(0, 0, 0);
  ledsR[lctR - 3] = CRGB(250, 0, 0);
  ledsR[lctR - 2] = CRGB(250, 0, 0);
  ledsR[lctR - 1] = CRGB(250, 0, 0);

  ledsB[0] = CRGB(255, 0, 0);
  ledsB[1] = CRGB(0, 255, 0);
  ledsB[2] = CRGB(0, 255, 0);
  ledsB[3] = CRGB(0, 0, 255);
  ledsB[4] = CRGB(0, 0, 255);
  ledsB[5] = CRGB(0, 0, 255);
  ledsB[6] = CRGB(0, 0, 0);
  ledsB[lctB - 3] = CRGB(0, 0, 250);
  ledsB[lctB - 2] = CRGB(0, 0, 250);
  ledsB[lctB - 1] = CRGB(0, 0, 250);
  FastLED.show();
  delay(1);
}
