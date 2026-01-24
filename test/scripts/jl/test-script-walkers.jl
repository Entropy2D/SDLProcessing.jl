# Description: 
# - Performance test script example with N random walkers.
#   - Great to see how performance scales with number of objects.
# Usage: `julia --project examples/test-script-walkers.jl --nwalkers 200`
# Expected: Should run without errors and print fps to console.
# Output Example:
#   N_walkers: 100
#   fps: 41.94161430139263
#   fps: 42.10860020065973
#   fps: 42.122480158458885
#   Exiting after 240 frames.


# examples/random-walkers-1.jl
using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))
import SDLProcessing
const P = SDLProcessing
import SimpleDirectMediaLayer
const SDL2 = SimpleDirectMediaLayer.LibSDL2

## --- Get N from ARGS ---
# Usage: `julia --project examples/test-script-walkers.jl --nwalkers 200`
global N_walkers = 10000
for (i, arg) in enumerate(ARGS)
    if arg == "--nwalkers" && i < length(ARGS)
        global N_walkers = parse(Int, ARGS[i+1])
    end
end

## --- Walker Object ---
mutable struct Walker
    x::Float64
    y::Float64
end

# Create a global list of walkers
walkers = Walker[]

## --- Sketch Definition ---

P.onsetup() do
    global N_walkers
    println("N_walkers: ", N_walkers)

    P.create_window(800, 600; title="Random Walkers")

    # Initialize N_walkers walkers at random positions
    for _ in 1:N_walkers
        x = rand() * P.SKETCH.width
        y = rand() * P.SKETCH.height
        push!(walkers, Walker(x, y))
    end
end

nprints = 0

P.ondraw() do
    
    global nprints

    P.background(P.color(0, 0, 0)) # Black background

    # --- Update and Draw Walkers ---
    P.fill(P.color(128, 128, 128)) # Gray color for walkers
    P.noStroke()

    for walker in walkers
        # Move walker
        walker.x += (rand() - 0.5) * 2
        walker.y += (rand() - 0.5) * 2

        # Periodic boundaries
        if walker.x > P.SKETCH.width
            walker.x = 0
        elseif walker.x < 0
            walker.x = P.SKETCH.width
        end

        if walker.y > P.SKETCH.height
            walker.y = 0
        elseif walker.y < 0
            walker.y = P.SKETCH.height
        end

        # Draw walker as a pixel
        P.rect(walker.x, walker.y, 1, 1)
    end

    # do nothing
    if P.isFrameRateDataReady() && mod(P.SKETCH.frameCount, 60) == 0
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
