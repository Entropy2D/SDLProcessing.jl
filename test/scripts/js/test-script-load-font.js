// Description: Test script for loading a font and displaying text.
// Based on: test/scripts/jl/test-script-load-font.jl

let myFont;

function preload() {
  // Path is relative to the HTML file.
  myFont = loadFont('../../../assets/Open_Sans/OpenSans-VariableFont_wdth,wght.ttf');
}

function setup() {
  createCanvas(800, 600);
  textFont(myFont);
  textSize(24);
}

function draw() {
  background(0); // Black background
  fill(255); // White text
  text(`frameRate: ${round(frameRate())}`, 10, 30);
}
