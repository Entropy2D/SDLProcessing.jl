// Description: 
// - Performance test script example with N random walkers.
// - Great to see how performance scales with number of objects.
// Based on: test/scripts/jl/test-script-walkers.jl

// In browser, we can't easily pass command line args.
// Change this value to test with different numbers of walkers.
const N_walkers = 10000;

let walkers = [];
let nprints = 0;
const maxPrints = 3;

class Walker {
  constructor() {
    this.x = random(width);
    this.y = random(height);
  }

  step() {
    this.x += random(-1, 1);
    this.y += random(-1, 1);

    // Periodic boundaries
    if (this.x > width) this.x = 0;
    if (this.x < 0) this.x = width;
    if (this.y > height) this.y = 0;
    if (this.y < 0) this.y = height;
  }

  display() {
    rect(this.x, this.y, 1, 1);
  }
}

function setup() {
  console.log(`N_walkers: ${N_walkers}`);
  createCanvas(800, 600);

  for (let i = 0; i < N_walkers; i++) {
    walkers.push(new Walker());
  }
}

function draw() {
  background(0); // Black background

  fill(128); // Gray color for walkers
  noStroke();

  for (let walker of walkers) {
    walker.step();
    walker.display();
  }

  // p5.js's frameRate() is available but more accurate after some frames.
  if (frameCount > 10 && frameCount % 60 === 0) {
    console.log(`fps: ${frameRate()}`);
    nprints++;
  }

  if (nprints >= maxPrints) {
    console.log(`Exiting after ${frameCount} frames.`);
    noLoop();
  }
}
