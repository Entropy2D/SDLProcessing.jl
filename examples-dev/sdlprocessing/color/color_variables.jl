#=
 * Color Variables (Homage to Albers). 
 * 
 * This example creates variables for colors that may be referred to 
 * in the program by a name, rather than a number. 
=#

using SDLProcessing
const P = SDLProcessing

P.onsetup() do
    P.create_window(640, 360, title="Color Variables")
end

P.ondraw() do
    P.noStroke()
    P.background(P.color(51, 0, 0))

    inside = P.color(204, 102, 0)
    middle = P.color(204, 153, 0)
    outside = P.color(153, 51, 0)

    # First set of rectangles
    P.fill(outside)
    P.rect(80, 80, 200, 200)
    P.fill(middle)
    P.rect(120, 140, 120, 120)
    P.fill(inside)
    P.rect(140, 170, 80, 80)

    # Second set of rectangles
    P.fill(inside)
    P.rect(360, 80, 200, 200)
    P.fill(outside)
    P.rect(400, 140, 120, 120)
    P.fill(middle)
    P.rect(420, 170, 80, 80)
end

P.run_sketch()
