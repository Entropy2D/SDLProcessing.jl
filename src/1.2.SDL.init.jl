function _initSDL()
    
    errflag = SDL_Init(get!(SDL_STATE, "SDL_INIT_FLAG", SDL_INIT_EVERYTHING)) 
    @assert errflag == 0 "error initializing SDL: $(unsafe_string(SDL_GetError()))"

    # TODO: Underestand
    CallSDLFunction(
        SDL_GL_SetAttribute, 
            SDL_GL_MULTISAMPLEBUFFERS, 
            get!(SDL_STATE, "SDL_GL_MULTISAMPLEBUFFERS", 32)
    )
    # TODO: Underestand
    CallSDLFunction(
        SDL_GL_SetAttribute, 
            SDL_GL_MULTISAMPLESAMPLES, 
            get!(SDL_STATE, "SDL_GL_MULTISAMPLESAMPLES", 32)
    )
end

function _initWindowRenderer()

    SDL_win = CallSDLFunction(
        SDL_CreateWindow, 
            wintitle(), 
            get!(SDL_STATE, "SDL_WINDOWPOS_X", SDL_WINDOWPOS_CENTERED), 
            get!(SDL_STATE, "SDL_WINDOWPOS_Y", SDL_WINDOWPOS_CENTERED), 
            get!(SDL_STATE, "SDL_WIN_W", 800), 
            get!(SDL_STATE, "SDL_WIN_H", 800), 
            SDL_WINDOW_SHOWN
    )
    SDL_STATE.window_ptr = SDL_win
    
    SDL_renderer = CallSDLFunction(
        SDL_CreateRenderer, 
            SDL_win, 
            get!(SDL_STATE, "SDL_RENDERER.DRIVER_FLAG", -1),
            SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC
    )
    SDL_STATE.renderer_ptr = SDL_renderer
    
    CallSDLFunction(SDL_RenderClear, SDL_renderer)

    nothing
end

# --.-- -.- .- -. -.-.- -.-.- .-.-
# init
function SDL_init(onsetup::Function = _do_nothing)

    @info "SDL_init"

    get!(SDL_STATE, "INIT.CALLED.FLAG", false) && error("Init was already called!")
    _diderror = false
    try
        # load config (ex: file or ENV)
        _loadConfig()

        # registered callbacks
        for _onconfig in ONCONFIG_CALLBACKS
            _onconfig()
        end

        # init
        _initSDL()
        _initWindowRenderer()

        # direct callback
        onsetup()

        # registered callbacks
        for _onsetup in ONSETUP_CALLBACKS
            _onsetup()
        end

        
        # update flag
        SDL_STATE["INIT.CALLED.FLAG"] = true

    catch err
        # TODO: fix tis so the stacks are better
        # _showerror(err; 
        #     showbox = true, 
        #     showterminal = true
        # )

        _diderror = true
        err isa InterruptException || rethrow(err)
        
    finally
        sleep(1)
        _diderror || return
        
        SDL_DestroyWindow(window_ptr())
        SDL_DestroyRenderer(renderer_ptr())
        SDL_Quit()
    end
    nothing
end
