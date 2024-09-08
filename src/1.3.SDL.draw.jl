# --.-- -.- .- -. -.-.- -.-.- .-.-
# loop
function SDL_draw(ondraw::Function = _do_nothing)

    @info "SDL_draw"

    get!(SDL_STATE, "INIT.CALLED.FLAG", false) || error("You must call `SDL_init` first...")

    SDL_win = window_ptr()
    SDL_renderer = renderer_ptr()
    SDL_event_ref = event_ref()
    fsor = SDL_STATE.frequensor
    
    SDL_loop_count = 0
    
    # loop
    try
        for taskfun in UPTHREAD_CALLBACKS
            @spawn while isrunning()
                taskfun()
            end
        end

        # draw loop
        while isrunning()

            # event
            while Bool(CallSDLFunction(SDL_PollEvent, SDL_event_ref))
                evt = SDL_event_ref[]
                for _onevent in ONEVENT_CALLBACKS
                    ret = _onevent(evt) 
                    ret === :break && break
                end
            end
            
            # direct callback 
            ondraw()

            # registered callbacks
            for _ondraw in ONDRAW_CALLBACKS
                _ondraw()
            end

            # TODO: Underestand
            get!(SDL_STATE, "SDL_RENDER_PRESENT_ENABLE", true) && 
                SDL_RenderPresent(SDL_renderer)

            # update loop counter
            SDL_loop_count += 1
            SDL_STATE["STATS.LOOP_COUNT"] = SDL_loop_count

            # control framerate
            SDL_forcefrec!("DRAW.LOOP", framerate())
            
        end # while running

    catch err
        # TODO: fix tis so the stacks are better
        # err isa InterruptException || _showerror(err; showbox = true, showterminal = true)

        err isa InterruptException || rethrow(err)
    finally
        
        for _onfinally in ONFINALLY_CALLBACKS
            try; _onfinally();
                catch err ignored; 
                _showerror(ignored; showbox = false, showterminal = true)
            end
        end

        SDL_DestroyRenderer(SDL_renderer)
        SDL_DestroyWindow(SDL_win)
        SDL_Quit()
    end
end