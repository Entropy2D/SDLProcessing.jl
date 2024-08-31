module SDLProcessing

    using Reexport
    using Base.Threads
    @reexport using SimpleDirectMediaLayer
    @reexport using SimpleDirectMediaLayer.LibSDL2

    #! include .
    include("0.globals.jl")
    include("1.init.SDL.jl")
    include("2.callbacks.jl")
    include("exportall.jl")

    @_exportall_non_underscore()

end