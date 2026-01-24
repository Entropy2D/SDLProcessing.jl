# examples/random-walkers-1.jl
using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))
import SDLProcessing
const P = SDLProcessing
import SimpleDirectMediaLayer
const SDL2 = SimpleDirectMediaLayer.LibSDL2

## --- Walker Object ---
mutable struct Walker
    x::Float64
    y::Float64
end

# Create a global list of walkers
walkers = Walker[]

## --- Utils ---
function rand_position()
    return (rand() * P.SKETCH.width, rand() * P.SKETCH.height)
end

## --- Sketch Definition ---

P.onsetup() do
    P.create_window(800, 600; title="Random Walkers")

    # Initialize 100 walkers at random positions
    for _ in 1:100
        push!(walkers, Walker(rand_position()...))
    end

    P.textFont(P.asset_path("Open_Sans", "OpenSans-VariableFont_wdth,wght.ttf"), 24)
end

P.ondraw() do
    P.background(P.color(0, 0, 0)) # Black background

    # --- Handle Mouse Input ---
    x, y = Ref{Cint}(0), Ref{Cint}(0)
    mouse_state = SDL2.SDL_GetMouseState(x, y)
    if (mouse_state & SDL2.SDL_BUTTON(SDL2.SDL_BUTTON_LEFT)) != 0
        # Add 1% of current walkers per frame
        num_new_walkers = ceil(Int, 0.01 * length(walkers))
        if num_new_walkers == 0
            num_new_walkers = 1
        end

        for _ in 1:num_new_walkers
            push!(walkers, Walker(Float64(x[]), Float64(y[])))
        end
    end

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

    # --- Display Walker Count ---
    P.fill(P.color(190, 190, 190)) # Gray text
    P.text("Walkers: $(length(walkers))", 10, 10)
    P.text("frameRate: $(round(Int, P.frameRate()))", 10, 10)
end

## --- Run the Sketch ---
P.run_sketch()
