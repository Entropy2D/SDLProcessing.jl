
function initSDL()
    # globals/params
    
    # TODO: Underestand
    SDL_GL_SetAttribute(SDL_GL_MULTISAMPLEBUFFERS, 32)
    # TODO: Underestand
    SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, 32)

    # TODO: Underestand
    @assert SDL_Init(SDL_INIT_EVERYTHING) == 0 "error initializing SDL: $(unsafe_string(SDL_GetError()))"

    # TODO: Underestand
    @show W, H
    global SDL_win = SDL_CreateWindow("Game", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, W, H, SDL_WINDOW_SHOWN)
    # TODO: Underestand
    SDL_SetWindowResizable(SDL_win, SDL_TRUE)

    # TODO: Underestand
    global SDL_renderer = SDL_CreateRenderer(SDL_win, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC)

    # --.-- -.- .- -. -.-.- -.-.- .-.-
    # setup 
    for _onsetup in ONSETUP_CALLBACKS
        ret = _onsetup()
        ret == :noloop && return
    end
    
    # --.-- -.- .- -. -.-.- -.-.- .-.-
    # loop
    # global SDL_event_ref = Ref{SDL_Event}()
    # global SDL_close = false
    global SDL_close
    try
        while !SDL_close
            # event
            while Bool(SDL_PollEvent(SDL_event_ref))
                evt = SDL_event_ref[]
                evt_ty = evt.type
                # default quit
                if evt_ty == SDL_QUIT
                    SDL_close = true
                    break
                end
                for _onevent in ONEVENT_CALLBACKS
                    _onevent(evt_ty)
                end
            end

            # dest_ref[] = SDL_Rect(x, y, w, h)
            SDL_RenderClear(SDL_renderer)
            
            # loop
            for _onloop in ONLOOP_CALLBACKS
                ret = _onloop()
                ret == :break && break
            end

            # TODO: Underestand
            SDL_RenderPresent(SDL_renderer)
            
            # TODO: make frame rate interface
            SDL_Delay(1000 ÷ 60)
        end
    finally
        SDL_DestroyRenderer(SDL_renderer)
        SDL_DestroyWindow(SDL_win)
        SDL_Quit()
        for _onfinally in ONFINALLY_CALLBACKS
            _onfinally();
        end
    end
end

