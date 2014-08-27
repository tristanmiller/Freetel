import controlP5.*;

ControlP5 myController;
PGraphics electronBeam;
PGraphics teltronScreen;
ArrayList chargeList;
ArrayList spotList;

float EFieldStrength;
float BFieldStrength;
float electronCharge;  //set to unity
float electronMass;    //set to unity
float electronSpeed;

float screenTilt = 3; // rotation of screen (degrees) around vertical axis, away from beam axis.
int resX;
int resY;
int textHeight;
int cellSize;
int vertCells;
int horiCells;
float beamSpreadY = 10;
float beamSpreadZ = 30;

void setup() {
  size(displayWidth,displayHeight , P3D);
  resX = int(round(width/2.0));
  resY = int(round(resX*(9/16.0)));
  println(resX);
  println(resY);
  textHeight = int(round(resX/30.0));
  cellSize = int(round(resX/5.0));
  vertCells = int(round(resY/(1.0*cellSize)));
  horiCells = int(round(resX/(1.0*cellSize)));
  println(textHeight);
  println(cellSize);
  println(vertCells);
  println(horiCells);
  background(0);

  electronCharge = -1;
  electronMass = 1;
  electronSpeed = 5;
  EFieldStrength = -0.08; //positive is up
  BFieldStrength = 0.05; //positive is across beam, left-to-right from electron POV



  electronBeam = createGraphics(resX, resY, P3D);
  teltronScreen = createGraphics(resX, resY, P3D);
  chargeList = new ArrayList();
  spotList = new ArrayList();

  screenTilt = constrain(screenTilt, 0, 89);
  myController = new ControlP5(this);

  myController.addSlider("BFieldStrength", -1.0, 1.0, -0.08, 10, 10, 100, 150); 
  myController.controller("BFieldStrength").setColorForeground(#CC0000);
  myController.addSlider("EFieldStrength", -4.0, 4.0, -0.08, 10, 180, 100, 150); 
  myController.controller("EFieldStrength").setColorForeground(#CCCC00);
  myController.addSlider("electronSpeed", 0.0, 10.0, 5, 10, 350, 100, 150); 
  myController.controller("electronSpeed").setColorForeground(#0000CC);
}

void draw() {

  background(0);

  teltronScreen.beginDraw();
  teltronScreen.blendMode(SCREEN);
  teltronScreen.background(1, 0, 10);
  teltronScreen.noFill();
  teltronScreen.stroke(2);
  teltronScreen.stroke(255);
  teltronScreen.pushMatrix();
  teltronScreen.translate(width/2, height/2);
  teltronScreen.rotateY(radians(screenTilt));
  teltronScreen.rectMode(CENTER);
  teltronScreen.rect(0, 0, width, height);
  teltronScreen.pushMatrix();
  teltronScreen.textAlign(CENTER, CENTER);
  teltronScreen.fill(255);
  teltronScreen.textSize(textHeight);
  //begin loop for vertical lines.
  for (int i = 1; i < horiCells; i++) {
    teltronScreen.pushMatrix();
    teltronScreen.translate(i*1.0*cellSize - width/2.0, 0);
    teltronScreen.text(str(horiCells - i), 0, 0);
    teltronScreen.line(0, 0.75*textHeight, 0, 1.4*cellSize);
    teltronScreen.line(0, 1.6*cellSize, 0, height/2.0);
    teltronScreen.line(0, -0.75*textHeight, 0, -1.4*cellSize);
    teltronScreen.line(0, -1.6*cellSize, 0, -1*height/2.0);
    teltronScreen.popMatrix();
  }
  //begin loop for horizontal lines
  for (int i = 1; i < vertCells/2.0 + 1; i++) {
    teltronScreen.pushMatrix();
    teltronScreen.translate(-width/2, -1*i*cellSize);
    teltronScreen.line(0, 0, width - 1.5*textHeight, 0);
    teltronScreen.translate(width - 0.75*textHeight, 0);
    teltronScreen.text(str(i), 0, 0);
    teltronScreen.popMatrix();
    teltronScreen.pushMatrix();
    teltronScreen.translate(-width/2, i*cellSize);
    teltronScreen.line(0, 0, width - 1.5*textHeight, 0);
    teltronScreen.translate(width - 0.75*textHeight, 0);
    teltronScreen.text(str(i), 0, 0);
    teltronScreen.popMatrix();
  }
  //begin loop for fancy centreline
  teltronScreen.translate(-width/2, 0);
  for (int i = 0; i < horiCells; i++) {
    teltronScreen.line(i*cellSize + 1.5*textHeight, 0, (i+1)*cellSize - 1.5*textHeight, 0);
  }
  teltronScreen.translate(width - 0.75*textHeight, 0);
  teltronScreen.text("0", 0, 0);
  teltronScreen.popMatrix();

  teltronScreen.translate(0, -height/2);
  teltronScreen.rotateX(HALF_PI);
  teltronScreen.fill(0, 50, 50, 50);
  teltronScreen.rect(0, 0, 1.1*width, 150);
  teltronScreen.translate(0, 0, -height);
  teltronScreen.rect(0, 0, 1.1*width, 150);
  teltronScreen.popMatrix();
  teltronScreen.camera(2*mouseX, 2*(mouseY - height/2), (height/2)/tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  for (int i = 0; i < spotList.size (); i++) {
    Spot thisSpot = (Spot) spotList.get(i);
    if (thisSpot.timer > 500) {
      spotList.remove(i);
    }
  }

  for (int i = 0; i < spotList.size (); i++) {
    Spot thisSpot = (Spot) spotList.get(i);
    thisSpot.update();
    thisSpot.display(teltronScreen);
  }

  teltronScreen.pushMatrix();
  teltronScreen.translate(width/2, 0.8*height);
  teltronScreen.popMatrix();
  teltronScreen.endDraw();

  electronBeam.beginDraw();
  electronBeam.camera(2*mouseX, 2*(mouseY - height/2), (height/2)/tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  electronBeam.clear();
  //electronBeam.ortho();
  for (int i = 0; i < chargeList.size (); i++) {
    Particle thisElectron = (Particle) chargeList.get(i);
    if (thisElectron.posX < 0||thisElectron.posX > width || thisElectron.posY < 0 || thisElectron.posY > height) {
      chargeList.remove(i);
    } else if (thisElectron.posZ < -1*(thisElectron.posX - width/2)*tan(radians(screenTilt))) {
      screenCollide(thisElectron);
      chargeList.remove(i);
    }
  }

  for (int i = 0; i < chargeList.size (); i++) {
    Particle thisElectron = (Particle) chargeList.get(i);
    thisElectron.update(EFieldStrength, BFieldStrength);
    thisElectron.display(electronBeam);
  }

  makeElectron();

  electronBeam.endDraw();

  pushMatrix();
  scale(1.0*width/resX, 1.0*height/resY);
  image(teltronScreen, 0, 0);
  image(electronBeam, 0, 0);
  popMatrix();
}

void makeElectron() {
  Particle newElectron = new Particle(electronCharge, electronMass, width, height/2 + random(-1*beamSpreadY, beamSpreadY), random(-1*beamSpreadZ, beamSpreadZ), (-1*electronSpeed)+random(-0.01, 0.01), random(-0.1, 0.1), random(-0.02, 0.02));
  chargeList.add(newElectron);
}

void screenCollide(Particle thisParticle) {
  Spot newSpot = new Spot(thisParticle.posX, thisParticle.posY, thisParticle.posZ);
  spotList.add(newSpot);
}

