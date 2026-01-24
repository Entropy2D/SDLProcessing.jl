module SDLProcessing


    # --- imports ---
    import SimpleDirectMediaLayer
    const SDL2 = SimpleDirectMediaLayer.LibSDL2
    const TTF = SimpleDirectMediaLayer
    using Statistics: mean, std
    using DataStructures
    import Pkg


    # --- exports ---
    export onsetup, ondraw, run_sketch, create_window,
           background, fill, noFill, stroke, noStroke, strokeWeight,
           line, rect, ellipse, circle, point,
           color,
           textFont, textSize, text,
           frameRate,
           onEvent,
           textAlign, H_LEFT, H_CENTER, H_RIGHT, V_TOP, V_BOTTOM, V_CENTER, V_BASELINE

    # --- Core files ---
    include("State.jl")
    include("Lifecycle.jl")
    include("Drawing.jl")
    include("Typography.jl")
    include("Statistics.jl")
    include("utils.jl")

end # module SDLProcessing
