// Description: Performance test script example with an empty loop.
// Based on: test/scripts/jl/test-script-empty-loop.jl
// Expected: Should run without errors and print fps to console.

let nprints = 0;
const maxPrints = 3;

function setup() {
  createCanvas(800, 600);
}

function draw() {
  // In p5.js, frameRate() is available from the start, but might be
  // inaccurate for the first few frames. We can add a small delay.
  if (frameCount < 10) {
    return;
  }

  if (frameCount % 60 === 0) {
    console.log(`fps: ${frameRate()}`);
    nprints++;
  }

  if (nprints >= maxPrints) {
    console.log(`Exiting after ${frameCount} frames.`);
    noLoop();
  }
}
