#=

* DO NOT DELETE 
* p5js EXAMPLE CODE

 * Characters Strings. 
 *  
 * The character datatype, abbreviated as char, stores letters and 
 * symbols in the Unicode format, a coding system developed to support 
 * a variety of world languages. Characters are distinguished from other
 * symbols by putting them between single quotes ('P').
 * 
 * A string is a sequence of characters. A string is noted by surrounding 
 * a group of letters with double quotes ("Processing"). 
 * Chars and strings are most often used with the keyboard methods, 
 * to display text to the screen, and to load images or files.
 * 
 * The String datatype must be capitalized because it is a complex datatype.
 * A String is actually a class with its own methods, some of which are
 * featured below. 

char letter;
String words = "Begin...";

void setup() {
  size(640, 360);
  // Create the font
  textFont(createFont("SourceCodePro-Regular.ttf", 36));
}

void draw() {
  background(0); // Set background to black

  // Draw the letter to the center of the screen
  textSize(14);
  text("Click on the program, then type to add to the String", 50, 50);
  text("Current key: " + letter, 50, 70);
  text("The String is " + words.length() +  " characters long", 50, 90);
  
  textSize(36);
  text(words, 50, 120, 540, 300);
}

void keyTyped() {
  // The variable "key" always contains the value 
  // of the most recent key pressed.
  if ((key >= 'A' && key <= 'z') || key == ' ') {
    letter = key;
    words = words + key;
    // Write the letter to the console
    println(key);
  }
}

=#

using SDLProcessing
const P = SDLProcessing

letter = ' '
words = "Begin..."

P.onsetup() do
    P.create_window(640, 360)
    P.textFont(P.asset_path("Open_Sans", "OpenSans-VariableFont_wdth,wght.ttf"), 36)
    P.fill(P.color(255))
end

P.ondraw() do
    P.background(P.color(0))

    P.textSize(14)
    P.text("Click on the program, then type to add to the String", 50, 50)
    P.text("Current key: " * string(letter), 50, 70)
    P.text("The String is " * string(length(words)) * " characters long", 50, 90)
    
    P.textSize(36)
    P.text(words, 50, 120)
end

P.run_sketch()
