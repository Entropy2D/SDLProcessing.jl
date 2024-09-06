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
    SDL_STATE["SDL_WIN"] = SDL_win

    # TODO: Add callback
    CallSDLFunction(
        SDL_SetWindowResizable, 
           SDL_win, SDL_TRUE # TODO: Add this as default
    )
    
    SDL_renderer = CallSDLFunction(
        SDL_CreateRenderer, 
            SDL_win, 
            get!(SDL_STATE, "SDL_RENDERER.DRIVER_FLAG", -1),
            SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC
    )
    SDL_STATE["SDL_RENDERER"] = SDL_renderer
    
    CallSDLFunction(
        SDL_RenderClear, 
            SDL_renderer,
    )

    nothing
end

# --.-- -.- .- -. -.-.- -.-.- .-.-
# init
function SDL_init(onsetup::Function = _do_nothing)

    @info "SDL_init"

    get!(SDL_STATE, "INIT.CALLED.FLAG", false) && error("Init was already called!")

    try
        # load config
        _loadConfig()

        # init
        _initSDL()
        _initWindowRenderer()

        # call setup
        onsetup()

        # update flag
        SDL_STATE["INIT.CALLED.FLAG"] = true

    catch err
        _showerror(err; 
            showbox = true, 
            showterminal = true
        )

        haskey(SDL_STATE, "SDL_WIN") && SDL_DestroyWindow(SDL_STATE["SDL_WIN"])
        haskey(SDL_STATE, "SDL_RENDERER") && SDL_DestroyRenderer(SDL_STATE["SDL_RENDERER"])
        SDL_Quit()
        exit()
    end
    nothing
end
