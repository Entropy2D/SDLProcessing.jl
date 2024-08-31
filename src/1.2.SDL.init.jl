function _initSDL()
    # TODO: Underestand
    SDL_GL_SetAttribute(SDL_GL_MULTISAMPLEBUFFERS, get!(SDL_STATE, "SDL_GL_MULTISAMPLEBUFFERS", 32))
    # TODO: Underestand
    SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, get!(SDL_STATE, "SDL_GL_MULTISAMPLESAMPLES", 32))

    errflag = SDL_Init(get!(SDL_STATE, "SDL_INIT_FLAG", SDL_INIT_EVERYTHING)) 
    @assert errflag == 0 "error initializing SDL: $(unsafe_string(SDL_GetError()))"
end

function _initWindowRenderer()

    SDL_win = SDL_CreateWindow(
        wintitle(), 
        get!(SDL_STATE, "SDL_WINDOWPOS_X", SDL_WINDOWPOS_CENTERED), 
        get!(SDL_STATE, "SDL_WINDOWPOS_Y", SDL_WINDOWPOS_CENTERED), 
        get!(SDL_STATE, "SDL_WIN_W", 800), 
        get!(SDL_STATE, "SDL_WIN_H", 800), 
        SDL_WINDOW_SHOWN
    )
    SDL_STATE["SDL_WIN"] = SDL_win

    # TODO: Add callback
    SDL_SetWindowResizable(SDL_win, SDL_TRUE) # TODO: Add this as default
    
    SDL_renderer = SDL_CreateRenderer(SDL_win, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC)
    SDL_STATE["SDL_RENDERER"] = SDL_renderer
    
    SDL_RenderClear(SDL_renderer)

    nothing
end

# --.-- -.- .- -. -.-.- -.-.- .-.-
# init
function SDL_init(onsetup::Function = _do_nothing)

    @info "SDL_init"

    try
        # load config
        _loadConfig()

        # call setup
        onsetup()

        # init
        _initSDL()
        _initWindowRenderer()

    catch err
        _show_error_box(err)

        haskey(SDL_STATE, "SDL_WIN") && SDL_DestroyWindow(SDL_STATE["SDL_WIN"])
        haskey(SDL_STATE, "SDL_RENDERER") && SDL_DestroyRenderer(SDL_STATE["SDL_RENDERER"])
        SDL_Quit()
        exit()

    end
    nothing
end
