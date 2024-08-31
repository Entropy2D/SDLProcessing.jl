onevent!() do evt
    
    # default quit
    if evt.type == SDL_QUIT
        SDL_STATE["SDL_RUNNING"] = false
    end

    # mouse wheel
    if evt.type == SDL_MOUSEWHEEL
        # wheel_x = sdlVersion >= 2018 ? -event.wheel.preciseX : -(Cfloat(event.wheel.x))
        # wheel_x = -evt.wheel.preciseX
        wheel_x = -(Cfloat(evt.wheel.x))
        # wheel_y = sdlVersion >= 2018 ? event.wheel.preciseY : Cfloat(event.wheel.y)
        # wheel_y = evt.wheel.preciseY
        wheel_y = Cfloat(evt.wheel.y)
        SDL_STATE["MOUSE_WHEEL"] = (wheel_x, wheel_y)
        SDL_STATE["MOUSE_WHEEL.UPDATE"] = true
    end
end
