# examples/random-walkers-1.jl
using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))
import SDLProcessing
const P = SDLProcessing
import SimpleDirectMediaLayer
const SDL2 = SimpleDirectMediaLayer.LibSDL2

## --- Sketch Definition ---
P.onsetup() do
    P.create_window(800, 600; title="Random Walkers")
    # do nothing
    P.textFont(P.asset_path("Open_Sans", "OpenSans-VariableFont_wdth,wght.ttf"), 24)
end

P.ondraw() do
    # do nothing
    P.background(P.color(0, 0, 0)) # Black background
    P.text("frameRate: $(round(Int, P.frameRate()))", 10, 10)
end

## --- Run the Sketch ---
P.run_sketch()
