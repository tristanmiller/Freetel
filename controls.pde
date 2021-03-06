//Freetel                                                                                   //
//A Teltron Electron Beam Deflection Simulation                                             //
//(controls.pde)                                                                            //
//////////////////////////////////////////////////////////////////////////////////////////////
//Copyright 2014 Tristan Miller                                                             //
//////////////////////////////////////////////////////////////////////////////////////////////
//This file is part of Freetel.                                                             //
//                                                                                          //
//  Freetel is free software: you can redistribute it and/or modify                         //
//  it under the terms of the GNU General Public License as published by                    //
//  the Free Software Foundation, either version 3 of the License, or                       //
//  (at your option) any later version.                                                     //
//                                                                                          //
//  Freetel is distributed in the hope that it will be useful,                              //
//  but WITHOUT ANY WARRANTY; without even the implied warranty of                          //
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                           //
//  GNU General Public License for more details.                                            //
//                                                                                          //
// You should have received a copy of the GNU General Public License                        //
//  along with Freetel.  If not, see <http://www.gnu.org/licenses/>.                        //
//////////////////////////////////////////////////////////////////////////////////////////////


ControlP5 cp5;
Group modeControls;
Group featureControls;

Group beginnerControls;
Group advancedControls;
Group aboutBox;

Button beginner;
Button advanced;
Button about;

Toggle beamVis;
Toggle screenToggle;
Bang   reset;
Toggle lockCam;

Knob EField;
Knob BField;
Knob eSpeed;

Knob plateV;
Knob linacV;
Knob coilI;
Knob coilN;

int controlMode = 0;

int minimumLinacV = 100;
int maximumLinacV = 5000;
int minimumPlateV = -5000;
int maximumPlateV = 5000;
int minimumCoilI = -2;
int maximumCoilI = 2;
PFont p;

void setupControls() {



  

  int modeButtonSize = int(0.18*height);
  int featureButtonSize = int(0.07*height);
  int buttonPadding = int(0.04*height);
  int knobRadius = int(0.12*height);
  
  p = createFont("data/Futura-Medium-48.vlw",int(round(0.015*height)));
  cp5.setControlFont(p);

  controlMode = 0;
  modeControls = cp5.addGroup("modeControls")
                    .setPosition(0, 0)
                    .setWidth(modeButtonSize + 2*buttonPadding)
                    .setBackgroundHeight(2*modeButtonSize + 3*buttonPadding)
                    .setBackgroundColor(color(255, 50))
                    .hideBar()
              ;


  featureControls = cp5.addGroup("featureControls")
                       .setPosition(0, height - (4*featureButtonSize + 5*buttonPadding))
                       .setWidth(modeButtonSize + buttonPadding)
                       .setBackgroundHeight(4*featureButtonSize + 5*buttonPadding)
                       .setBackgroundColor(color(255, 50))
                       .hideBar()
              ;

  beginnerControls = cp5.addGroup("beginnerControls")
                        .setPosition(2*buttonPadding + modeButtonSize, 0)
                        .setWidth(2*buttonPadding + 2*knobRadius)
                        .setBackgroundHeight(height)
                        .setBackgroundColor(color(255, 50))
                        .hideBar()
                        .hide()
                ;

  advancedControls = cp5.addGroup("advancedControls")
                        .setPosition(2*buttonPadding + modeButtonSize, 0)
                        .setWidth(2*buttonPadding + 2*knobRadius)
                        .setBackgroundHeight(height)
                        .setBackgroundColor(color(255, 50))
                        .hideBar()
                        .hide()
                ;


  beginner = cp5.addButton("toggleBeginner", 0, buttonPadding, buttonPadding, modeButtonSize, modeButtonSize)
                .setLabel("Simple Controls")
                .setGroup(modeControls)
        ;

  advanced = cp5.addButton("toggleAdvanced", 0, buttonPadding, modeButtonSize + 2*buttonPadding, modeButtonSize, modeButtonSize)
                .setLabel("Realistic Controls")
                .setGroup(modeControls)
        ;

  beamVis = cp5.addToggle("toggleBeam", int(round(0.5*buttonPadding)), buttonPadding, modeButtonSize, featureButtonSize)
               .setLabel("Beam Visibility OFF/ON")
               .setState(true)
               .setGroup(featureControls)
          ;

  screenToggle = cp5.addToggle("toggleScreen", int(round(0.5*buttonPadding)), featureButtonSize + 2*buttonPadding, modeButtonSize, featureButtonSize)
                    .setLabel("Screen OFF/ON")
                    .setGroup(featureControls)
                    .setState(true)
          ;


  reset = cp5.addBang("resetSim", int(round(0.5*buttonPadding)), 3*featureButtonSize + 4*buttonPadding, modeButtonSize, featureButtonSize)
             .setLabel("Reset")
             .setGroup(featureControls)
        ;

  lockCam = cp5.addToggle("toggleLock", int(round(0.5*buttonPadding)), 2*featureButtonSize + 3*buttonPadding, modeButtonSize, featureButtonSize)
               .setLabel("Lock camera OFF/ON")
               .setGroup(featureControls)
               .setValue(false)
               .setState(false)
            ;


  EField = cp5.addKnob("internalEFieldStrength", minimumPlateV*NewtonsPerCoulombToEUnits/(resY*pixelsToMetres), maximumPlateV*NewtonsPerCoulombToEUnits/(resY*pixelsToMetres), internalEFieldStrength, 0, 0, 0)
              .setPosition(buttonPadding, buttonPadding)
              .setRadius(knobRadius)
              .setResolution(1500)
              .setDecimalPrecision(3)
              .setDragDirection(Knob.HORIZONTAL)
              .setGroup(beginnerControls)
              .setColorForeground(color(180, 0, 255))
              .setColorBackground(color(96, 0, 120))
              .setColorActive(color(255, 0, 255))
              .setLabel("Electric Field Intensity")
              .setValue(internalEFieldStrength)
                        ;


  BField = cp5.addKnob("internalBFieldStrength", pow(0.8, 1.5)*(u0*coilTurns*minimumCoilI/coilRadius)*TeslaToBUnits, pow(0.8, 1.5)*(u0*coilTurns*maximumCoilI/coilRadius)*TeslaToBUnits, internalBFieldStrength, 0, 0, 0)
              .setPosition(buttonPadding, 2*knobRadius + 2* buttonPadding)
              .setRadius(knobRadius)
              .setResolution(1500)
              .setDecimalPrecision(3)
              .setDragDirection(Knob.HORIZONTAL)
              .setGroup(beginnerControls)
              .setColorForeground(color(0, 255, 180))
              .setColorBackground(color(0, 120, 96))
                  .setColorActive(color(0, 255, 255))
                    .setLabel("Magnetic Field Intensity")
                      ;


  eSpeed = cp5.addKnob("internalElectronSpeed", sqrt(2*minimumLinacV*VoltsToPDUnits), sqrt(2*maximumLinacV*VoltsToPDUnits), internalElectronSpeed, 0, 0, 0)
               .setPosition(buttonPadding, 4*knobRadius + 3*buttonPadding)
               .setRadius(knobRadius)
               .setResolution(1500)
               .setDecimalPrecision(2)
               .setDragDirection(Knob.HORIZONTAL)
               .setGroup(beginnerControls)
               .setColorForeground(color(255, 180, 0))
               .setColorBackground(color(120, 96, 0))
               .setColorActive(color(255, 255, 0))
               .setLabel("Electron Speed")
                       ;


  plateV = cp5.addKnob("platePD", minimumPlateV, maximumPlateV, platePD, 0, 0, 0)
              .setPosition(buttonPadding, buttonPadding)
              .setRadius(knobRadius)
              .setResolution(1500)
              .setDecimalPrecision(1)
              .setDragDirection(Knob.HORIZONTAL)
              .setGroup(advancedControls)
              .setColorForeground(color(180, 0, 255))
              .setColorBackground(color(96, 0, 120))
              .setColorActive(color(255, 0, 255))
              .setLabel("Plate PD (V)")
                      ;


  coilI = cp5.addKnob("coilCurrent", minimumCoilI, maximumCoilI, coilCurrent, 0, 0, 0)
             .setPosition(buttonPadding, 2*knobRadius + 2* buttonPadding)
             .setRadius(knobRadius)
             .setResolution(1500)
             .setDecimalPrecision(3)
             .setDragDirection(Knob.HORIZONTAL)
             .setGroup(advancedControls)
             .setColorForeground(color(0, 255, 180))
             .setColorBackground(color(0, 120, 96))
             .setColorActive(color(0, 255, 255))
             .setLabel("Field Coil Current (A)")
                      ;


  linacV = cp5.addKnob("linacPD", minimumLinacV, maximumLinacV, linacPD, 0, 0, 0)
              .setPosition(buttonPadding, 4*knobRadius + 3*buttonPadding)
              .setRadius(knobRadius)
              .setResolution(1500)
              .setDecimalPrecision(1)
              .setDragDirection(Knob.HORIZONTAL)
              .setGroup(advancedControls)
              .setColorForeground(color(255, 180, 0))
              .setColorBackground(color(120, 96, 0))
              .setColorActive(color(255, 255, 0))
              .setLabel("Accelerating PD (V)")
                      ;
}


void updateControls() {
  EField.setValue(internalEFieldStrength);
  BField.setValue(internalBFieldStrength);
  eSpeed.setValue(internalElectronSpeed);

  coilI.setValue(coilCurrent);
  plateV.setValue(platePD);
  linacV.setValue(linacPD);
}


void toggleBeginner() {
  if (beginnerControls.isVisible()) {
    beginnerControls.hide();
    controlMode = 0;
  } else {

    advancedControls.hide();
    beginnerControls.show();
    if (controlMode != 1) {
      updateControls();
      calculateFields();
      //calculate any internal field units and reposition dials
      controlMode = 1;
    }
  }
}

void toggleAdvanced() {
  if (advancedControls.isVisible()) {
    advancedControls.hide();
    controlMode = 0;
  } else {
    advancedControls.show();
    beginnerControls.hide();
    if (controlMode != 2) {
      convertInternalToSI();
      updateControls();
      //calculate any SI field units and reposition dials
      controlMode = 2;
    }
  }
}




void resetSim() {
  controlMode = 0;

  ///Restore default vlaues
  linacPD = linacPD_backup;
  platePD = platePD_backup;
  coilCurrent = coilCurrent_backup;
  resetClock();

  //recalculate all field values
  calculateFields();
  //reset controls

    beginnerControls.hide();
  advancedControls.hide();
  screenToggle.setState(true);
  screenToggle.setValue(true);
  screenExists = true;
  beamVis.setState(true);
  beamVis.setValue(true);
  displayBeam = true;
  lockCam.setState(false);
  lockCam.setValue(false);
  cameraLocked = false;

  //clear all electrons and spots from memory
  chargeList = new ArrayList();
  spotList = new ArrayList();
}

void toggleBeam() {
  displayBeam = !displayBeam;
}

void toggleScreen() {
  spotList = new ArrayList();
  screenExists = !screenExists;
}

void toggleLock() {
  cameraLocked = !cameraLocked;
}

