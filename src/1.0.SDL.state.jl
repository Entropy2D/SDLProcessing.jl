Base.@kwdef mutable struct SDLState <: Wrapper
    
    renderer_ptr::Ptr{SDL_Renderer} = C_NULL
    window_ptr::Ptr{SDL_Window} = C_NULL
    event_ref::Ref{SDL_Event} = Ref{SDL_Event}()

    data::Dict{String, Any} = Dict()
end
const SDL_STATE = SDLState()

function _loadConfig()
    # TODO: load configure from file or env
end