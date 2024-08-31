module SDLProcessing

    using Reexport
    using Base.Threads
    @reexport using SimpleDirectMediaLayer
    @reexport using SimpleDirectMediaLayer.LibSDL2

    #! include .
    include("0.globals.jl")
    include("0.utils.jl")
    include("1.0.SDL.state.jl")
    include("1.1.SDL.utils.jl")
    include("1.2.SDL.init.jl")
    include("1.3.SDL.draw.jl")
    include("2.callbacks.jl")
    include("3.processing.jl")
    include("exportall.jl")

    @_exportall_non_underscore()

end