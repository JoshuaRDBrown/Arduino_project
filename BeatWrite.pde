import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import cc.arduino.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
Arduino arduino;

int ledPin =  12;    
int ledPin2 =  8;    
int ledPin3 =  2;    
float kickSize, snareSize, hatSize;

void setup() {
  size(512, 200, P3D);
  
  minim = new Minim(this);
  arduino = new Arduino(this, Arduino.list()[1], 57600);
  
  song = minim.loadFile("song.mp3", 2048);
  song.play();
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(100);  
  kickSize = snareSize = hatSize = 16;
  bl = new BeatListener(beat, song);  
  textFont(createFont("Helvetica", 16));
  textAlign(CENTER);
  
  arduino.pinMode(ledPin, Arduino.OUTPUT);    
  arduino.pinMode(ledPin2, Arduino.OUTPUT);  
  arduino.pinMode(ledPin3, Arduino.OUTPUT);  
}

void draw() {
  background(0);
  fill(255);
  if(beat.isKick()) {
      arduino.digitalWrite(ledPin, Arduino.HIGH);   
      kickSize = 32;
  }
  if(beat.isSnare()) {
      arduino.digitalWrite(ledPin2, Arduino.HIGH);   
      snareSize = 32;
  }
  if(beat.isHat()) {
      arduino.digitalWrite(ledPin3, Arduino.HIGH);   
      hatSize = 32;
  }
  arduino.digitalWrite(ledPin, Arduino.LOW);    
  arduino.digitalWrite(ledPin2, Arduino.LOW);    
  arduino.digitalWrite(ledPin3, Arduino.LOW);    
  textSize(kickSize);
  text("KICK", width/4, height/2);
  textSize(snareSize);
  text("SNARE", width/2, height/2);
  textSize(hatSize);
  text("HAT", 3*width/4, height/2);
  kickSize = constrain(kickSize * 0.95, 16, 32);
  snareSize = constrain(snareSize * 0.95, 16, 32);
  hatSize = constrain(hatSize * 0.95, 16, 32);
}

void stop() {
  song.close();
  minim.stop();
  super.stop();
}
