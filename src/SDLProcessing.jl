# TODO

# - Try to replicate 'all' examples of Processing page. Of course, completing the interface as required.

module SDLProcessing

    using Reexport
    using Base.Threads
    using DataStructures
    @reexport using SimpleDirectMediaLayer
    @reexport using SimpleDirectMediaLayer.LibSDL2

    #! include .
    include("0.globals.jl")
    include("0.utils.jl")
    include("1.0.SDL.state.jl")
    include("1.1.SDL.utils.jl")
    include("1.2.SDL.init.jl")
    include("1.3.SDL.draw.jl")
    include("1.4.stats.jl")
    include("2.0.callbacks.jl")
    include("2.1.callbacks.defaults.jl")
    include("3.0.processing.jl")
    include("3.1.processing.image.jl")
    include("3.2.processing.geometry.jl")
    include("3.3.processing.imgtext.jl")
    include("exportall.jl")

    @_exportall_non_underscore()

end