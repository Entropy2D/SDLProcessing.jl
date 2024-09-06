onevent!() do evt
    
    # default quit
    if evt.type == SDL_QUIT
        SDL_STATE["SDL_RUNNING"] = false
    end

    # mouse wheel
    # TODO: Rethink
    # if evt.type == SDL_MOUSEWHEEL
    #     SDL_STATE["MOUSE_WHEEL"] = mousewheel(evt)
    #     SDL_STATE["MOUSE_WHEEL.UPDATED"] = true
    # end
end
