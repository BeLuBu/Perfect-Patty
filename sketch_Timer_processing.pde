import processing.serial.*;

String myString = null;
Serial myPort;


int NUM_OF_VALUES = 4;   // Put the number of sensors we have
int[] sensorValues;      /** this array stores values from Arduino **/

PImage img;
PImage img1;

int hsbH = 0;
int hsbS = 0;
int hsbB = 100;

void setup() {
  size(800, 600);
  background(255);
  setupSerial();
  img = loadImage("grilled2.png");
  img1 = loadImage("PATTY2.jpg");
  colorMode(HSB, 100);
}

void draw() {
  updateSerial();
  printArray(sensorValues);

//Don't edit anything above, except line 7, 11 and 12

  imageMode(CENTER);                                        //background set up
  noTint();
  image(img1, 400, 300, width, height);
    
  textSize(16);                                             //display size of patty
  fill(0, 80, 80);
  textSize(40);
  text(((sensorValues[3]/345)+3), 645, 158);
  
  pushMatrix();                                             //display image of patty
  translate(235, height/2+65);
  scale((sensorValues[3]/350)+2.25);                        //scale with size
  imageMode(CENTER);
  tint(hsbH,hsbS,hsbB);                                     //change color with time
  image(img, 0, 0, 200, 200);
  popMatrix();
  
  int time = sensorValues[2] - (sensorValues[0] - sensorValues[1]); //countdown
  int secs = time;                                                  //how many secs
  int mins = secs/60 ;                                              //how many mins
  secs -= mins * 60;                                                //format to 00:59
  String secs2D = nf(secs, 2);                                      //format to 2 digrat
    
  if (sensorValues[1] == 0){                                  //Start screen
    textSize(32);
    fill(0, 80, 80);
    text("Press button", 550, 207);
  } 
    
  if (time > 0 && sensorValues[1] != 0){                        //display timer
    fill(0, 80, 80);
    textSize(40);
    text(mins + ":" + secs2D, 645, 210);
  } else if (time<=0 && sensorValues[1] != 0){                  //display done
    fill(0, 80, 80);
    text("Done", 645, 210);
    textSize(13);
    text("Press button", 550, 190);
    text("to reset timer", 550, 210);
  } 
  
    if (sensorValues[3] <= 351){                                // chagnes color of patty 
      hsbS = 0 + (sensorValues[3]/30);
      hsbB = 100 - (sensorValues[3]/30) ;
    } else if (sensorValues[3] >= 352 && sensorValues[2] <= 699){
      hsbS = 0 + (sensorValues[3]/100);
      hsbB = 100 - (sensorValues[3]/35);
    } else if (sensorValues[3] >= 700){
      hsbS = 0 + (sensorValues[3]/500);
      hsbB = 100 - (sensorValues[3]/40) ;
    }
}

//Don't edit anything below

void setupSerial() {
  myPort = new Serial(this, Serial.list()[ 2 ], 9600);
  myPort.clear();
  // Throw out the first reading,
  // in case we started reading in the middle of a string from the sender.
  myString = myPort.readStringUntil( 10 );  // 10 = '\n'  Linefeed in ASCII
  myString = null;

  sensorValues = new int[NUM_OF_VALUES];
}



void updateSerial() {
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil( 10 ); // 10 = '\n'  Linefeed in ASCII
    if (myString != null) {
      String[] serialInArray = split(trim(myString), ",");
      if (serialInArray.length == NUM_OF_VALUES) {
        for (int i=0; i<serialInArray.length; i++) {
          sensorValues[i] = int(serialInArray[i]);
        }
      }
    }
  }
}
