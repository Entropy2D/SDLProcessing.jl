# examples-dev/sdlprocessing/forms/points_lines.jl
using Pkg
Pkg.activate(joinpath(@__DIR__, "..", "..", ".."))
using SDLProcessing
const P = SDLProcessing

#=
* DO NOT DELETE 
* p5js EXAMPLE CODE

 * Points and Lines. 
 * 
 * Points and lines can be used to draw basic geometry.
 * Change the value of the variable 'd' to scale the form.
 * The four variables set the positions based on the value of 'd'. 
 */
 
# Original p5js code:
#
# int d = 70;
# int p1 = d;
# int p2 = p1+d;
# int p3 = p2+d;
# int p4 = p3+d;

# size(640, 360);
# noSmooth();
# background(0);
# translate(140, 0);

# // Draw gray box
# stroke(153);
# line(p3, p3, p2, p3);
# line(p2, p3, p2, p2);
# line(p2, p2, p3, p2);
# line(p3, p2, p3, p3);

# // Draw white points
# stroke(255);
# point(p1, p1);
# point(p1, p3); 
# point(p2, p4);
# point(p3, p1); 
# point(p4, p2);
# point(p4, p4);
=#

const d = 70
const p1 = d
const p2 = p1 + d
const p3 = p2 + d
const p4 = p3 + d

const x_offset = 140

P.onsetup() do
    P.create_window(640, 360; title="Points and Lines")
    P.noFill() # We are only drawing lines and points
end

P.ondraw() do
    P.background(P.color(0, 0, 0)) # Black background

    # Draw gray box
    P.stroke(P.color(153, 153, 153))
    P.line(x_offset + p3, p3, x_offset + p2, p3)
    P.line(x_offset + p2, p3, x_offset + p2, p2)
    P.line(x_offset + p2, p2, x_offset + p3, p2)
    P.line(x_offset + p3, p2, x_offset + p3, p3)

    # Draw white points
    P.stroke(P.color(255, 255, 255))
    P.point(x_offset + p1, p1)
    P.point(x_offset + p1, p3)
    P.point(x_offset + p2, p4)
    P.point(x_offset + p3, p1)
    P.point(x_offset + p4, p2)
    P.point(x_offset + p4, p4)
end

## --- Run the Sketch ---
P.run_sketch()
