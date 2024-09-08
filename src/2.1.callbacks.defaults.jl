onevent!() do evt
    
    # default quit
    if evt.type == SDL_QUIT
        SDL_STATE["SDL_RUNNING"] = false
        return
    end # evt.type

    # print info
    if evt.type == SDL_KEYDOWN

        scan_code = evt.key.keysym.scancode

        if scan_code == SDL_SCANCODE_I
            
            isempty(ONINFO_CALLBACKS) && return
            
            println("INFO ",">"^20)
            for _oninfo in ONINFO_CALLBACKS
                _oninfo()
            end
            println("<"^25, "\n")

            return
        end
        return
    end # evt.type
end

_round(v, d = 4) = round(v; digits = d)

oninfo!() do 
    println("loop.count: ", loopcount())
    println("target.fr: ", _round(framerate()), " frames/sec")
    println("msd.fr: ", _round(msd_framerate()), " frames/sec")
    _delay = delays(SDL_STATE.frequensor, "DRAW.LOOP")
    println("draw.loop.delay: ", _round(_delay), " secs")
end