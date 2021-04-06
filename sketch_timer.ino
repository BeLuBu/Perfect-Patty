const int nopPin = A0;
int foodSize = 0;
int howLong = 0;

const int redPin = 13;
const int yellowPin = 12;
const int greenPin = 8;

const int startButton = 2;
int onOff = 0;

const int soundPin = 7;

unsigned long preCounter = 0;
unsigned long realTimer = 0;

void setup() {
 Serial.begin(9600);
 pinMode(nopPin, INPUT);
 pinMode(redPin, OUTPUT);
 pinMode(yellowPin, OUTPUT);
 pinMode(greenPin, OUTPUT);
 pinMode(startButton, INPUT);
 pinMode(soundPin, OUTPUT);
}

void loop() {
 unsigned long currentCounter = millis()/1000UL; //counter in second
 foodSize = analogRead(nopPin);                  //read nop pin
 onOff = digitalRead(startButton);              //read button pin
  
 if (onOff == HIGH){                             //push button to reset
  preCounter = currentCounter;                   //reset the clock
  digitalWrite(redPin, LOW);                     //reset lights
  digitalWrite(yellowPin,LOW);
  digitalWrite(greenPin, LOW);
  howLong = foodSize/2;                 //formula for time to cook
 }
 if ((currentCounter - preCounter <= howLong*.40) && (preCounter != 0)) { //counting how many time leave and react
  digitalWrite(redPin, HIGH);
  digitalWrite(yellowPin,LOW);
  digitalWrite(greenPin, LOW);
 } else if ((currentCounter - preCounter <= howLong*.80) && (preCounter != 0)) {
  digitalWrite(redPin, LOW);
  digitalWrite(yellowPin,HIGH);
  digitalWrite(greenPin, LOW);
  } else if ((currentCounter - preCounter >= howLong) && (preCounter != 0)) {
  digitalWrite(redPin, LOW);
  digitalWrite(yellowPin,LOW);
  digitalWrite(greenPin, HIGH);
  tone(soundPin, 300,500);
  }

// Add new sensor below to send data to processing

 int sensor1 = currentCounter;
 int sensor2 = preCounter;
 int sensor3 = howLong;
 int sensor4 = foodSize;

  Serial.print(sensor1);
  Serial.print(",");
  Serial.print(sensor2);
  Serial.print(",");
  Serial.print(sensor3);
  Serial.print(",");
  Serial.print(sensor4);
  Serial.println(); 

  delay(100);
}
