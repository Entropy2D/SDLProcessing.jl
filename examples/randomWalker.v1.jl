@time begin
    using SDLProcessing
    using Base.Threads
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# TODO: Add some documentation

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# SIM GLOBALS
SIM_STATE = Dict()
MAX_STEPS = 100_000
INIT_STEPS = 300

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_init() do
    winsize!(900, 900)
    wintitle!(basename(@__FILE__))
    framerate!(60)
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
onevent!() do evt
    # recenter
    if evt.type == SDL_MOUSEBUTTONDOWN

        if evt.button.button == SDL_BUTTON_LEFT
            if get!(SIM_STATE, "RUNNING", true)
                w, h = winsize()
                SIM_STATE["POS"] = mousepos()
            end
        end

        # pause/play
        if evt.button.button == SDL_BUTTON_RIGHT
            SIM_STATE["RUNNING"] = !get!(SIM_STATE, "RUNNING", true)
        end

        if evt.button.button == SDL_BUTTON_MIDDLE
            if get!(SIM_STATE, "RUNNING", true)
                SIM_STATE["NUM_STEPS"] = INIT_STEPS
            end
        end
    end
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_draw() do
    
    # erase
    drawcolor!(0,0,0)
    background!()

    # up step (temperature)
    _running = get!(SIM_STATE, "RUNNING", true)
    _, wheel_d = mousewheel!()
    nsteps = get!(SIM_STATE, "NUM_STEPS", INIT_STEPS)
    if _running
        _increment = max(abs(wheel_d) * nsteps, 1)
        _increment = sign(wheel_d) * ceil(Int, 0.1 * _increment)
        nsteps = clamp(nsteps + _increment, 0, MAX_STEPS)
        SIM_STATE["NUM_STEPS"] = nsteps
    end

    # walk
    w, h = winsize()
    points_buff = get!(SIM_STATE, "POINT_BUFF") do 
        _vec = Vector{SDL_Point}(undef, MAX_STEPS)
        _fill = SDL_Point(w ÷ 2, h ÷ 2)
        for i in 1:MAX_STEPS
            _vec[i] = _fill
        end
        return _vec
    end::Vector{SDL_Point}
        
    x, y = get!(SIM_STATE, "POS", (w, h) .÷ 2)
    if _running
        @threads :static for st in 1:nsteps
            x = clamp(x + rand(-1:1), 1, w)
            y = clamp(y + rand(-1:1), 1, h)
            points_buff[st] = SDL_Point(x, y)
        end
        # update pos
        SIM_STATE["POS"] = (x, y)
    end

    # paint
    drawcolor!(255, 255, 255)
    if nsteps > 0; drawpoints(points_buff, nsteps)
        else; drawpoint(x, y) 
    end

    # print some info
    c = loopcount()
    if mod(c, framerate()) == 0 
        @info("Iter $(c)",
            msd_framerate = msd_framerate(),
            nsteps = nsteps,
            running = _running,
        )
        println()
    end

end
