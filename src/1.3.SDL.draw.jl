# --.-- -.- .- -. -.-.- -.-.- .-.-
# loop
function SDL_draw(onloop::Function = _do_nothing)

    @info "SDL_draw"

    get!(SDL_STATE, "INIT.CALLED.FLAG", false) || error("You must call `SDL_init` first...")

    SDL_win = SDL_STATE["SDL_WIN"]::Ptr{SDL_Window}
    SDL_renderer = SDL_STATE["SDL_RENDERER"]::Ptr{SDL_Renderer}
    SDL_event_ref = get!(Ref{SDL_Event}, SDL_STATE, "SDL_EVENT_REF")::Ref{SDL_Event}
    
    SDL_loop_count = 0
    tic = time()
    
    # loop
    try
        while get!(SDL_STATE, "SDL_RUNNING", true)

            # event
            while Bool(CallSDLFunction(SDL_PollEvent, SDL_event_ref))
                evt = SDL_event_ref[]
                for _onevent in ONEVENT_CALLBACKS
                    ret = _onevent(evt) 
                    ret === :break && break
                end
            end
            
            # callback 
            onloop()

            # TODO: Underestand
            get!(SDL_STATE, "SDL_RENDER_PRESENT_ENABLE", true) && 
                SDL_RenderPresent(SDL_renderer)

            # loop counter
            SDL_loop_count += 1
            SDL_STATE["SDL_LOOP_COUNT"] = SDL_loop_count
            
            # measure framerate
            _now = time()
            _msd_framerate = 1/(_now - tic)
            SDL_STATE["MEASSURED.FRAMERATE"] = _msd_framerate
            tic = _now

            # TODO: make frame rate interface
            if get!(SDL_STATE, "SDL_DELAY_ENABLE", true)
                _target_framerate = get!(SDL_STATE, "SDL_FRAME_RATE", 60)
                _curr_delay = get!(SDL_STATE, "SDL_LOOP_DELAY", round(Int, 1000 / _target_framerate))
                _curr_delay += _target_framerate > _msd_framerate ? -1 : 1
                if _curr_delay > 0 
                    SDL_STATE["SDL_LOOP_DELAY"] = _curr_delay
                    SDL_Delay(_curr_delay)
                else
                    SDL_STATE["SDL_LOOP_DELAY"] = 0
                end
            end
            
        end # while running

    catch err
        err isa InterruptException || _showerror(err; showbox = true, showterminal = true)
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

