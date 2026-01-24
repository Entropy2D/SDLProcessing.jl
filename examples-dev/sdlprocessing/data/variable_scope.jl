#=

* DO NOT DELETE
* p5js EXAMPLE CODE

 * Variable Scope. 
 * 
 * Variables have a global or local "scope". 
 * For example, variables declared within either the
 * setup() or draw() functions may be only used in these
 * functions. Global variables, variables declared outside
 * of setup() and draw(), may be used anywhere within the program.
 * If a local variable is declared with the same name as a
 * global variable, the program will use the local variable to make 
 * its calculations within the current scope. Variables are localized
 * within each block, the space between a { and }. 

int a = 80;  // Create a global variable "a"

void setup() {
  size(640, 360);
  background(0);
  stroke(255);
  noLoop();
}

void draw() {
  // Draw a line using the global variable "a"
  line(a, 0, a, height);
  
  // Create a new variable "a" local to the for() statement 
  for (int a = 120; a < 200; a += 2) {
    line(a, 0, a, height);
  }
  
  // Create a new variable "a" local to the draw() function
  int a = 300;
  // Draw a line using the new local variable "a"
  line(a, 0, a, height);  
  
  // Make a call to the custom function drawAnotherLine()
  drawAnotherLine();
  
  // Make a call to the custom function setYetAnotherLine()
  drawYetAnotherLine();
}

void drawAnotherLine() {
  // Create a new variable "a" local to this method
  int a = 320;
  // Draw a line using the local variable "a"
  line(a, 0, a, height);
}

void drawYetAnotherLine() {
  // Because no new local variable "a" is set, 
  // this line draws using the original global
  // variable "a", which is set to the value 80.
  line(a+2, 0, a+2, height);
}

=#

using SDLProcessing
const P = SDLProcessing

a = 80  # Create a global variable "a"

function drawAnotherLine()
    # Create a new variable "a" local to this function
    a = 320
    # Draw a line using the local variable "a"
    P.line(a, 0, a, P.SKETCH.height)
end

function drawYetAnotherLine()
    # Because no new local variable "a" is set, 
    # this line draws using the original global
    # variable "a", which is set to the value 80.
    P.line(a + 2, 0, a + 2, P.SKETCH.height)
end


P.onsetup() do
    P.create_window(640, 360)
    P.stroke(P.color(255))
    P.noLoop()
end

P.ondraw() do
    P.background(P.color(0))

    # Draw a line using the global variable "a"
    P.line(a, 0, a, P.SKETCH.height)

    # Create a new variable "a" local to the for loop
    for a in 120:2:198
        P.line(a, 0, a, P.SKETCH.height)
    end

    # Create a new variable "a" local to this block
    let a = 300
        # Draw a line using the new local variable "a"
        P.line(a, 0, a, P.SKETCH.height)
    end

    # Make a call to the custom function drawAnotherLine()
    drawAnotherLine()

    # Make a call to the custom function drawYetAnotherLine()
    drawYetAnotherLine()
end

P.run_sketch()