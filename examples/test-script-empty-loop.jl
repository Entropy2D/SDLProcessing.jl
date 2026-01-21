# Description: Performance test script example with an empty loop.
# Run with: `julia --project examples/test-script-empty-loop.jl`
# Expected: Should run without errors and print fps to console.

# examples/random-walkers-1.jl
using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))
import SDLProcessing
const P = SDLProcessing
import SimpleDirectMediaLayer
const SDL2 = SimpleDirectMediaLayer.LibSDL2
import DataStructures: capacity

## --- Sketch Definition ---
P.onsetup() do
    P.create_window(800, 600; title="Random Walkers")
    # do nothing
end

nprints = 0
P.ondraw() do

    global nprints

    # wait until we have enough frame time data
    P.SKETCH.frameCount < capacity(P.SKETCH._frame_times_ns) && return  

    # do nothing
    if mod(P.SKETCH.frameCount, 60) == 0
        println("fps: ", P.frameRate())
        nprints += 1
    end
    
    # quit after some prints
    if nprints > 3
        P.SKETCH._should_quit = true
        println("Exiting after $(P.SKETCH.frameCount) frames.")
    end
end

## --- Run the Sketch ---
P.run_sketch()
