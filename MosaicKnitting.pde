/**
 * MosaicKnitting
 * 
 * Generates random mosaic knitting patterns
 *
 * Author: Laura Kogler
 * License: This code is licensed under the terms of the GPL v.3
 *
 */

import processing.pdf.*; //required to make pdf happen

void setup() {

  // Configurable parameters
  int unitWidth = 6;        // How many stitches wide is the pattern unit
  int unitHeight = 6;       // How many stitches tall is the pattern unit (must be an even number)
  int repsX = 3;            // How many times to repeat the pattern in the horizontal direction
  int repsY = 14;           // How many times to repeat the pattern in the vertical direction
  int stitchSize = 5;       // How many pixels to draw per stitch
  boolean flipX=true;       // The pattern unit is flipped for horizontal symmetry 
  boolean flipY=true;       // The pattern unit is flipped for vertical symmetry
  boolean mutate = false;   // If true, one stitch will be changed on each repetition of the pattern
  boolean dissolve = false; // If true, the pattern will be disolved on each repetition
  boolean savePDF = false;  // If true, an output file will be created each time the program is run
  boolean randomizeColor = true; // If true, pick a random color


  colorMode(HSB);
  color colorA;
  if(randomizeColor)
  {
    colorA = color(random(255),255,255);
  }
  else
  {
    colorA = color(170,225,255);
  }
  color colorB = color(255, 0, 255);
  
   
  PatternUnit unit = new PatternUnit(unitHeight,unitWidth);
  //PatternUnit unit = new PatternUnit();

  int stepX;
  int stepY;
  if(flipX) stepX = (unitWidth*2-2);
  else stepX = unitWidth;

  if(flipY) stepY = (unitHeight*2-2);
  else stepY = unitHeight;

  size((stepX*repsX*stitchSize)+stitchSize*int(flipX), (stepY*repsY*stitchSize)+stitchSize*int(flipY));

  println("stitches x: " + ((stepX*repsX)+int(flipX)));
  println("stitches y: " + ((stepY*repsY)+int(flipY)));

  background(0);
  if(savePDF) beginRecord(PDF, "output"+minute()+second()+".pdf");  

  for(int y = 0; y<repsY; y++)
  {
    if(mutate)
    {
      unit.Mutate();
    }
    if(y>0 && dissolve) unit.Dissolve();
    for(int x=0; x<repsX; x++)
    {
      unit.Draw(stitchSize, x*stepX*stitchSize, y*stepY*stitchSize, colorA, colorB, flipX, flipY);
    }
  }

  if(savePDF) endRecord(); //write to pdf
}

