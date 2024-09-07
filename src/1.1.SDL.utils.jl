_show_SDL_error() = @error("SDL ERROR:\n", unsafe_string(SDL_GetError()))


# TODO: improve backtrace
function _showerror(jlerr = nothing; 
        showbox = true, 
        showterminal = true,
        trace = isnothing(jlerr) ? catch_backtrace() : backtrace()
    )
    
    _trace_str = sprint(Base.show_backtrace, trace)
    jl_error_str = isnothing(jlerr) ? "" : 
        string("JULIA ERROR:\n", sprint(showerror, jlerr))
    
    sdl_error_str = unsafe_string(SDL_GetError())
    sdl_error_str = isempty(sdl_error_str) ? "" : 
        string("SDL ERROR:\n", sdl_error_str)
    
    errmsg = string(
        "------------", "\n", 
        jl_error_str, "\n", 
        "------------", "\n", 
        sdl_error_str, "\n", 
        "------------", "\n", 
        _trace_str
    )
    
    if showterminal
        @error "ERROR"
        println(errmsg)
    end

    if showbox
        SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, "ERROR", errmsg, C_NULL)
    end

    nothing
end

struct SDLException <: Exception
    msg::String
end

import Base.showerror
function Base.showerror(io::IO, err::SDLException)
    print(io, "SDLException: ")
    print(io, err.msg)
end
function Base.showerror(io::IO, err::SDLException, trace)
    print(io, "SDLException: ")
    print(io, err.msg)
    Base.show_backtrace(io, trace)
end

_onerror(fun, ret) = throw(SDLException("Function call failed, fun: $(nameof(fun)), ret: $(ret)"))

## . --. ..- . -- . - .. ..- - ..- - -.. ... -- ...
# Derived from: https://github.com/Kyjor/JulGame.jl

_iscallerr(ret::Number) = ret < 0
_iscallerr(ret) = ret == C_NULL

function CallSDLFunction(func::Function, args...; 
        onerror = _onerror
    )
    SDL_ClearError()

    # Call SDL function and check for errors
    ret = func(args...)
    _iscallerr(ret) && onerror(func, ret)

    return ret
end
