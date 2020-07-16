const byte leftSwitchFarPin = 2;
const byte leftSwitchClosePin = 3;
const byte scaleFarPin = 4;
const byte scaleClosePin = 5;
const byte rightSwitchFarPin = 6;
const byte rightSwitchClosePin = 7;

byte dataToSend = 0;

void setup() {
  Serial.begin(250000);
  pinMode(leftSwitchFarPin, INPUT_PULLUP);
  pinMode(leftSwitchClosePin, INPUT_PULLUP);
  pinMode(scaleFarPin, INPUT_PULLUP);
  pinMode(scaleClosePin, INPUT_PULLUP);
  pinMode(rightSwitchFarPin, INPUT_PULLUP);
  pinMode(rightSwitchClosePin, INPUT_PULLUP);
}

void loop() {
  dataToSend = 0;
  if (digitalRead(leftSwitchFarPin) == LOW)
    bitSet(dataToSend, 0);
  if (digitalRead(leftSwitchClosePin) == LOW)
    bitSet(dataToSend, 1);
  if (digitalRead(scaleFarPin) == LOW)
    bitSet(dataToSend, 2);
  if (digitalRead(scaleClosePin) == LOW)
    bitSet(dataToSend, 3);
  if (digitalRead(rightSwitchFarPin) == LOW)
    bitSet(dataToSend, 4);
  if (digitalRead(rightSwitchClosePin) == LOW)
    bitSet(dataToSend, 5);

  Serial.write(dataToSend);
  delay(20);
}
