module SDLProcessing


    # --- imports ---
    import SimpleDirectMediaLayer
    const SDL2 = SimpleDirectMediaLayer.LibSDL2
    const TTF = SimpleDirectMediaLayer

    # --- Core files ---
    include("State.jl")
    include("Lifecycle.jl")
    include("Drawing.jl")
    include("Typography.jl")

    # --- Exports for the user ---

    # State
    export SKETCH

    # Lifecycle
    export onsetup, ondraw, run_sketch, create_window

    # Drawing
    export background, fill, noFill, stroke, noStroke, ellipse, rect, color

    # Typography
    export text, textFont, textSize

end # module SDLProcessing
