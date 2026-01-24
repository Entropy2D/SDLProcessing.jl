#=

* DO NOT DELETE 
* p5js EXAMPLE CODE

 * Variables. 
 * 
 * Variables are used for storing values. In this example, change 
 * the values of variables to affect the composition. 

size(640, 360);
background(0);
stroke(153);
strokeWeight(4);
strokeCap(SQUARE);

int a = 50;
int b = 120;
int c = 180;

line(a, b, a+c, b);
line(a, b+10, a+c, b+10);
line(a, b+20, a+c, b+20);
line(a, b+30, a+c, b+30);

a = a + c;
b = height-b;

line(a, b, a+c, b);
line(a, b+10, a+c, b+10);
line(a, b+20, a+c, b+20);
line(a, b+30, a+c, b+30);

a = a + c;
b = height-b;

line(a, b, a+c, b);
line(a, b+10, a+c, b+10);
line(a, b+20, a+c, b+20);
line(a, b+30, a+c, b+30);

=#

using SDLProcessing
const P = SDLProcessing

P.onsetup() do
    P.create_window(640, 360)
end

P.ondraw() do
    P.background(P.color(0))
    P.stroke(P.color(153))
    P.strokeWeight(4)

    a = 50
    b = 120
    c = 180

    P.line(a, b, a+c, b)
    P.line(a, b+10, a+c, b+10)
    P.line(a, b+20, a+c, b+20)
    P.line(a, b+30, a+c, b+30)

    a = a + c
    b = P.SKETCH.height-b

    P.line(a, b, a+c, b)
    P.line(a, b+10, a+c, b+10)
    P.line(a, b+20, a+c, b+20)
    P.line(a, b+30, a+c, b+30)

    a = a + c
    b = P.SKETCH.height-b

    P.line(a, b, a+c, b)
    P.line(a, b+10, a+c, b+10)
    P.line(a, b+20, a+c, b+20)
    P.line(a, b+30, a+c, b+30)
end

P.run_sketch()
