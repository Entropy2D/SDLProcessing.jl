# /**
#  * Statements and Comments. 
#  * 
#  * Statements are the elements that make up programs. 
#  * The ";" (semi-colon) symbol is used to end statements in some languages.  
#  * In Julia, statements are typically separated by newlines.
#  * Comments are used for making notes to help people better understand programs. 
#  * A single-line comment begins with "#". Multi-line comments are enclosed in #= =#.
#  */

using SDLProcessing

# The onsetup function is a statement that tells the computer 
# what to do once at the beginning of the sketch.
onsetup() do
    # The create_window function is a statement that tells the computer 
    # how large to make the window.
    # Each function statement has zero or more parameters. 
    # Parameters are data passed into the function
    # and are used as values for telling the computer what to do.
    create_window(640, 360)
end

# The ondraw function is a statement that tells the computer
# what to do on every frame.
ondraw() do
    # The background function is a statement that tells the computer
    # which color (or gray value) to make the background of the display window 
    background(color(204, 153, 0))
end

run_sketch()
