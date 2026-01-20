#MARK: SDLP_init!
function SDLP_init!(oninit::Function;
        kwargs...
    )
    OeS_init!(; kwargs...) do

        @info "SDLP_init!"

        _diderror = false
        try
            # register built-in callbacks
            SDLP_register_builtin_callbacks!()

            run_callbacks!("SDLP.callbacks.preinit")

            # init
            _initSDL()
            _initWindowRenderer()

            # direct callback
            oninit()

            run_callbacks!("SDLP.callbacks.oninit")

        catch err

            # TODO: fix this so the stacks are better
            # _showerror(err; 
            #     showbox = true, 
            #     showterminal = true
            # )

            run_callbacks!("SDLP.init.onerror")

            rethrow(err)
            _diderror = true
            err isa InterruptException || rethrow(err)
            
        finally
            
            run_callbacks!("SDLP.init.onfinally")

            sleep(1)
            _diderror && _SDL_Quit!()
        end
        nothing
    end
end

## --. - .- . -- . - .- . .-- - --- .....--- . ..- .- 
#MARK: _initSDL
function _initSDL()
    
    errflag = SDL_Init(getstate!("SDL.SDL_INIT_FLAG", SDL_INIT_EVERYTHING)) 
    @assert errflag == 0 "error initializing SDL: $(unsafe_string(SDL_GetError()))"

    # TODO: Underestand
    CallSDLFunction(
        SDL_GL_SetAttribute, 
            SDL_GL_MULTISAMPLEBUFFERS, 
            getstate!("SDL.SDL_GL_MULTISAMPLEBUFFERS", 32)
    )
    # TODO: Underestand
    CallSDLFunction(
        SDL_GL_SetAttribute, 
            SDL_GL_MULTISAMPLESAMPLES, 
            getstate!("SDL.SDL_GL_MULTISAMPLESAMPLES", 32)
    )
end

## --. - .- . -- . - .- . .-- - --- .....--- . ..- .- 
#MARK: _initWindowRenderer
function _initWindowRenderer()

    SDLP_Window()
    SDLP_Renderer()

    # clear renderer
    SDLP_clear_renderer!()

    nothing
end

