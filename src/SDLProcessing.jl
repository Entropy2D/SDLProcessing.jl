# TODO

# - Try to replicate 'all' examples of Processing page. Of course, completing the interface as required.

# - Aknowledge to https://github.com/dalum/Gloria.jl

module SDLProcessing

    import MassExport
    using Reexport
    using Reexport
    using Base.Threads
    using DataStructures
    using OeSes
    @reexport using SimpleDirectMediaLayer
    @reexport using SimpleDirectMediaLayer.LibSDL2

    #! include .

    #! include Drawing


    #! include Base
    include("Base/0_types.jl")
    include("Base/SDL.base.jl")
    include("Base/SDL.texture.base.jl")
    include("Base/SDL.utils.jl")
    include("Base/SDLP.callbacks.builtin.jl")
    include("Base/SDLP.draw.jl")
    include("Base/SDLP.init.jl")
    include("Base/SDLP.utils.jl")

    MassExport.@exportall_non_underscore()

end