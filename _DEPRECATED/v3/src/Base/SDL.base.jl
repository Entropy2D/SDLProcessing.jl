## ...- -.- .- .- - - -. .. . .. - .-- .
# TODO/TAI: check performans

window_ptr(;lk = true) = getstate(
    Union{Nothing, Ptr{SDL_Window}}, 
    "SDL.window_ptr", nothing; lk
) 

renderer_ptr(;lk = true) = getstate(
    Union{Nothing, Ptr{SDL_Renderer}}, 
    "SDL.renderer_ptr", nothing; lk
) 

event_ref(;lk = true) = getstate!(
    Ref{SDL_Event}, "SDL.event_ref", Ref{SDL_Event}(); lk
) 

function _SDL_Quit!()

    # TODO place a callback 

    win = window_ptr()
    isnothing(win) || SDL_DestroyWindow(win)
    ren = renderer_ptr()
    isnothing(ren) || SDL_DestroyRenderer(ren)
    SDL_Quit()
end

# clear_renderer
SDLP_clear_renderer!(SDL_renderer_ptr::Ptr{SDL_Renderer}) =
    CallSDLFunction(SDL_RenderClear, SDL_renderer_ptr)
SDLP_clear_renderer!(SDL_renderer::SDLP_Renderer) =
    CallSDLFunction(SDL_RenderClear, SDL_renderer.renderer_ptr)
SDLP_clear_renderer!() = SDLP_clear_renderer!(renderer_ptr())