

// Michal Huller 25.12.2014
// Mandala with agents and noise

/**
 * 
 * KEYS
 * A                   : toggle colors from picture or random
 * Y                   : toggle symmetry
 * S                   : save image as png
 * N                   : new drawing
 * R                   : start recording PDF
 * E                   : end recording PDF and save
 * O                   : open image file for a pallette
 * W                   : toggle background black or white
 * L                   : toggle show thin lines
 * K                   : toggle show thik curled lines
 * M                   : toggle show Mandala or abstract
 * T                   : toggle transparent 
 * 1-2                 : 1 - decrease number of agents and 2 - increase
 * 3-4                 : 3 - decrease number of spots and 4 - increase
 * 5-6                 : 5 - decrease number of petals and 6 - increase
 * 7-8                 : 7 - decrease width of pen and 8 - increase
 */

import javax.swing.*; 
import processing.pdf.*;
import java.util.Calendar;
// ------ agents ------
Agent[] agents = new Agent[1000]; // create more ... to fit max slider agentsCount
int agentsCount = 80;
float noiseScale = 80, noiseStrength = 12, noiseZRange = 0.4;
float agentsAlpha = 90, strokeWidth = 0.3, widthFactor = 3.0;
int drawMode = 1;
color bg = 0;
PImage scrShot;
boolean recordPDF = false;
boolean symmetry = false;
boolean showLines = true;
boolean makeMandala = true;
boolean halt = false;
boolean transp = true;
boolean pen = true;
boolean fromPIC = true;
int spotsNum = 5;
int slices = 12;
float minDist = 10.0;

void setup() {
  size(1024, 768); //size(1280,800,P3D);
  background(bg);
  smooth();
  frameRate(10);
  fc = new JFileChooser();
  if (openFileAndGetImage() == 0)
    exit();
  initit();
}

void initit() {
  PVector spots[] = new PVector[spotsNum];
  if (makeMandala) 
    spots[0] = new PVector(0,0);
  else
    spots[0] = new PVector(random(width/6, width/1.2), random(height/6, height/1.2));

  for (int i=1; i < spots.length; i++) {
    if (makeMandala)
      spots[i] = new PVector(random(-width/12, width/2), random(-height/12, height/2));
      //spots[i] = new PVector(random(width), random(height));
    else
      spots[i] = new PVector(random(width/6, width/1.2), random(height/6, height/1.2));
  }
  for (int i=0; i<agents.length; i++) {
    agents[i] = new Agent(spots[i % spots.length].x, spots[i % spots.length].y);
  }
  background(bg);
}

void draw() {

  stroke(0, agentsAlpha);
  //draw agents
  for (int i=0; i<agentsCount; i++) agents[i].updateNdraw();
}

void keyReleased() {
  if (key == 'a' || key == 'A') {
    fromPIC = !fromPIC;
    initit();
  }
  if (key =='r' || key =='R') {
    if (recordPDF == false) {   
      beginRecord(PDF, "pdfs/"+timestamp()+".pdf");
      initit();
      println("recording started");
      recordPDF = true;
    }
  } 
  if (key == 'e' || key =='E') {
    if (recordPDF) {
      println("recording stopped");
      endRecord();
      recordPDF = false;
      initit();
    }
  }
  if (key == 'm' || key == 'M') {
    makeMandala = !makeMandala;
    if (makeMandala)
      symmetry = false;
    else
      symmetry = true;
    initit();
  }
  if (key == 'n' || key == 'N') {
    initit();
  }
  if (key == 'h' || key == 'H') {
    halt = !halt;
    if (halt)
      noLoop();
    else loop();
  }
  if (key == 'y' || key == 'Y') {
    symmetry = !symmetry;
    initit();
  }

  if (key == 's' || key == 'S') {
    int numR = int(random(5000));
    String fname="snapshot/kav_" + year() + month() + day() + "_" + frameCount +"_" + numR + ".png";
    scrShot=get(0, 0, width, height);
    scrShot.save(fname);
  }
  if (key == 't' || key =='T') {
    transp = !transp;
    initit();
  }
  if (key == 'k' || key =='K') {
    pen = !pen;
    initit();
  }
  if (key == 'l' || key =='L') {
    showLines = !showLines;
    initit();
  }
  if (key == 'o' || key =='O') {
    if (openFileAndGetImage() == 0)
      exit();
    initit();
  }
  if (key == 'w' || key =='W') {
    bg = 255 - bg;
    initit();
  }
  if (key == '1') {
    agentsCount-=20;
    if (agentsCount < 20) agentsCount = 20;
    initit();
  }
  if (key == '2') {
    agentsCount+=20;
    if (agentsCount > agents.length - 20) agentsCount = agents.length - 20;
    initit();
  }

  if (key == '3') {
    spotsNum-= 1;
    if (spotsNum < 1) spotsNum = 1;
    initit();
  }
  if (key == '4') {
    spotsNum+=1;
    if (spotsNum > 20) spotsNum = 20;
    initit();
  }
  
  if (key == '5') {
    slices-= 2;
    if (slices < 4) slices = 4;
    initit();
  }
  if (key == '6') {
    slices+=2;
    if (slices > 40) slices = 40;
    initit();
  }
  if (key == '7') {
    widthFactor-= 0.5;
    if (widthFactor < 1) widthFactor = 1;
    initit();
  }
  if (key == '8') {
    widthFactor+=0.5;
    if (widthFactor > 10) widthFactor = 10;
    initit();
  }
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
