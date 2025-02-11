
function SDLP_register_builtin_callbacks!()
    
    BUILT_IN_PRIORITY = typemin(Int) ÷ 2
    
    # register stuff
    "SDLP.draw.onfinally"
    register_callback!("OeS.loop.onfinally", BUILT_IN_PRIORITY) do
        run_callbacks!("SDLP.loop.onfinally")
        # _SDL_Quit!()
    end
    
    # # default quit
    # TODO: make proper onevent! interface
    register_callback!("SDLP.draw.onevent", BUILT_IN_PRIORITY) do
        evt = callback_args(1)::SDL_Event
        println("""register_callback!("SDLP.draw.onevent", BUILT_IN_PRIORITY)""")
        @show evt.type
        if evt.type == SDL_QUIT
            # _SDL_Quit!()
            running!(false)
            # return
        end # evt.type
    end
    

    nothing
end