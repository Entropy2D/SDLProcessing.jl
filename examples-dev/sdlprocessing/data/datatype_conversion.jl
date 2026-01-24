#=

* DO NOT DELETE
* p5js EXAMPLE CODE

 * Datatype Conversion. 
 * 
 * It is sometimes beneficial to convert a value from one type of 
 * data to another. Each of the conversion functions converts its parameter 
 * to an equivalent representation within its datatype. 
 * The conversion functions include int(), float(), char(), byte(), and others. 

size(640, 360);
background(0);
noStroke();

textFont(createFont("SourceCodePro-Regular.ttf",24));

char c;    // Chars are used for storing alphanumeric symbols
float f;   // Floats are decimal numbers
int i;     // Integers are values between 2,147,483,647 and -2147483648
byte b;    // Bytes are values between -128 and 127

c = 'A';
f = float(c);      // Sets f = 65.0
i = int(f * 1.4);  // Sets i to 91
b = byte(c / 2);   // Sets b to 32

//println(f);
//println(i);
//println(b);

text("The value of variable c is " + c, 50, 100);
text("The value of variable f is " + f, 50, 150);
text("The value of variable i is " + i, 50, 200);
text("The value of variable b is " + b, 50, 250);

=#

using SDLProcessing
const P = SDLProcessing

c = ' '
f = 0.0
i = 0
b = 0

P.onsetup() do
    P.create_window(640, 360)
    P.noStroke()
    P.textFont(P.asset_path("Open_Sans", "OpenSans-VariableFont_wdth,wght.ttf"), 24)
    P.fill(P.color(255))

    global c = 'A'
    global f = Float64(c)      # Sets f = 65.0
    global i = Int(f * 1.4)  # Sets i to 91
    global b = Int8(div(Int(c), 2))   # Sets b to 32
end

P.ondraw() do
    P.background(P.color(0))

    P.text("The value of variable c is " * string(c), 50, 100)
    P.text("The value of variable f is " * string(f), 50, 150)
    P.text("The value of variable i is " * string(i), 50, 200)
    P.text("The value of variable b is " * string(b), 50, 250)
end

P.run_sketch()
