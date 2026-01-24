#=

* DO NOT DELETE
* p5js EXAMPLE CODE

 * Integers Floats.
 *
 * Integers and floats are two different kinds of numerical data.
 * An integer (more commonly called an int) is a number without
 * a decimal point. A float is a floating-point number, which means
 * it is a number that has a decimal place. Floats are used when
 * more precision is needed.

=#

using SDLProcessing
const P = SDLProcessing

a = 0
b = 0.0

P.onsetup() do
    P.create_window(640, 360)
    P.stroke(P.color(255))
end

P.ondraw() do
    global a, b
    P.background(P.color(0))

    a = a + 1
    b = b + 0.2
    P.line(a, 0, a, P.SKETCH.height/2)
    P.line(b, P.SKETCH.height/2, b, P.SKETCH.height)

    if a > P.SKETCH.width
        a = 0
    end
    if b > P.SKETCH.width
        b = 0.0
    end
end

P.run_sketch()
