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
            get!(SIM_STATE, "RUNNING", true) || return
            w, h = winsize()
            SIM_STATE["POS"] = mousepos()
            return
        end

        # pause/play
        if evt.button.button == SDL_BUTTON_RIGHT
            SIM_STATE["RUNNING"] = !get!(SIM_STATE, "RUNNING", true)
            return
        end

        if evt.button.button == SDL_BUTTON_MIDDLE
            get!(SIM_STATE, "RUNNING", true) || return
            SIM_STATE["NUM_STEPS"] = INIT_STEPS
            return
        end
    end # SDL_MOUSEBUTTONDOWN

    # up step ("temperature")
    if evt.type == SDL_MOUSEWHEEL
        get!(SIM_STATE, "RUNNING", true) || return
        nsteps = get!(SIM_STATE, "NUM_STEPS", INIT_STEPS)
        _, wheel_d = mousewheel(evt)
        increment = max(abs(wheel_d) * nsteps, 1)
        increment = sign(wheel_d) * ceil(Int, 0.1 * increment)
        nsteps = clamp(nsteps + increment, 0, MAX_STEPS)
        SIM_STATE["NUM_STEPS"] = nsteps
        return
    end # SDL_MOUSEWHEEL
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_draw() do
    
    # erase
    drawcolor!(0,0,0)
    background!()

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
    
    _running = get!(SIM_STATE, "RUNNING", true)
    nsteps = get!(SIM_STATE, "NUM_STEPS", INIT_STEPS)
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
