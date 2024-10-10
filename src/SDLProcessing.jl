# TODO

# - Try to replicate 'all' examples of Processing page. Of course, completing the interface as required.

module SDLProcessing

    using Reexport
    using MassExport
    using Base.Threads
    using DataStructures
    @reexport using SimpleDirectMediaLayer
    @reexport using SimpleDirectMediaLayer.LibSDL2

    # TODO: move to utils or Base
    var"@f_str" = var"@styled_str"


    #! include .

    @_exportall_non_underscore()

end