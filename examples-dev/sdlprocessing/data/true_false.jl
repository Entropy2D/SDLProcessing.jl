#=

* DO NOT DELETE
* p5js EXAMPLE CODE

 * True/False. 
 * 
 * A Boolean variable has only two possible values: true or false. 
 * It is common to use Booleans with control statements to 
 * determine the flow of a program. In this example, when the
 * boolean value "x" is true, vertical black lines are drawn and when
 * the boolean value "x" is false, horizontal gray lines are drawn. 

boolean b = false;

size(640, 360);
background(0);
stroke(255);

int d = 20;
int middle = width/2;

for (int i = d; i <= width; i += d) {
  
  if (i < middle) {
    b = true;
  } else {
    b = false;
  }
  
  if (b == true) {
    // Vertical line
    line(i, d, i, height-d);
  }
  
  if (b == false) {
    // Horizontal line
    line(middle, i - middle + d, width-d, i - middle + d);
  }
}

=#

using SDLProcessing
const P = SDLProcessing

P.onsetup() do
    P.create_window(640, 360)
end

P.ondraw() do
    P.background(P.color(0))
    P.stroke(P.color(255))

    d = 20
    middle = P.SKETCH.width / 2
    
    b = false

    for i in d:d:P.SKETCH.width
        if i < middle
            b = true
        else
            b = false
        end

        if b
            # Vertical line
            P.line(i, d, i, P.SKETCH.height - d)
        else
            # Horizontal line
            P.line(middle, i - middle + d, P.SKETCH.width - d, i - middle + d)
        end
    end
end

P.run_sketch()