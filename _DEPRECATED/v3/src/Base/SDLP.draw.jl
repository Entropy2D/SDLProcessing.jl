# --.-- -.- .- -. -.-.- -.-.- .-.-
# loop
function SDLP_draw!(ondraw::Function = OeSes._do_nothing)

    @info "SDL_draw"

    SDL_win = window_ptr()
    SDL_renderer = renderer_ptr()
    SDL_event_ref = event_ref()
    # fsor = SDL_STATE.frequensor
    
    SDL_loop_count = 0
    
    OeS_loop!() do

        # event
        while Bool(CallSDLFunction(SDL_PollEvent, SDL_event_ref))
            evt = SDL_event_ref[]
            # println("Bool(CallSDLFunction(SDL_PollEvent, SDL_event_ref))")
            run_callbacks!("SDLP.draw.onevent", evt)
        end
        
        # direct callback 
        ondraw()

        # registered callbacks
        run_callbacks!("SDLP.draw.ondraw")
        
        getstate!("SDL.RENDER_PRESENT_ENABLE", true) && 
            SDL_RenderPresent(SDL_renderer)
        
        # update loop counter

        # control framerate
        # SDL_forcefrec!("DRAW.LOOP", framerate())
        
    end # while running
end