module SDLProcessing


    # --- imports ---
    import SimpleDirectMediaLayer
    const SDL2 = SimpleDirectMediaLayer.LibSDL2
    const TTF = SimpleDirectMediaLayer
    using Statistics: mean, std
    using DataStructures
    import Pkg


    # --- Core files ---
    include("State.jl")
    include("Lifecycle.jl")
    include("Drawing.jl")
    include("Typography.jl")
    include("Statistics.jl")
    include("utils.jl")

end # module SDLProcessing
