onevent!() do evt
    
    # default quit
    if evt.type == SDL_QUIT
        SDL_STATE["SDL_RUNNING"] = false
        return
    end

    # print info
    if evt.type == SDL_KEYDOWN
        # println("SDL_KEYDOWN")
        scan_code = evt.key.keysym.scancode
        # if scan_code == SDL_SCANCODE_D
        #     # println("SDL_SCANCODE_D")
        #     SDL_STATE["DEV.FLAG"] = get(SDL_STATE, "DEV.FLAG", true)
        #     return
        # end

        if scan_code == SDL_SCANCODE_I
            # println("SDL_SCANCODE_I")
            isempty(ONINFO_CALLBACKS) && return
            println("INFO ",">"^20)
            for oninfo in ONINFO_CALLBACKS
                oninfo()
            end
            println("<"^25, "\n")
            return
        end
        return
    end

    # mouse wheel
    # TODO: Rethink
    # if evt.type == SDL_MOUSEWHEEL
    #     SDL_STATE["MOUSE_WHEEL"] = mousewheel(evt)
    #     SDL_STATE["MOUSE_WHEEL.UPDATED"] = true
    # end
end

oninfo!() do 
    println("loop.count: ", loopcount())
    println("msd.fr: ", round(msd_framerate(); sigdigits = 2), " sec")
end