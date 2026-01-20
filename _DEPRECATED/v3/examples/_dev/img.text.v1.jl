@time begin
    using SDLProcessing
    using SimpleDirectMediaLayer
    using SimpleDirectMediaLayer.LibSDL2
    using Base.Threads
    using DataStructures
    using InteractiveUtils
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SIM_STATE = Dict()

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# Pre init config
onconfig!() do
    winsize!(1300, 900)
    wintitle!(basename(@__FILE__))
    framerate!(60)
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_init() do
    w, h = winsize()
    SIM_STATE["FR.TARGET.TS"] = fill(SDL_Point(0, h ÷ 2), w)
    SIM_STATE["FR.MSD.TS"] = fill(SDL_Point(0, h ÷ 2), w)
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# events
onevent!() do evt
    if evt.type == SDL_MOUSEWHEEL
        _, wheel_d = mousewheel(evt)
        fr = framerate()
        fr = clamp(fr + sign(wheel_d), 5, 60)
        framerate!(fr)
    end # SDL_MOUSEWHEEL
end 

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
oninfo!() do 
    
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_draw() do

    # variables
    target_fr_ts = SIM_STATE["FR.TARGET.TS"]::Vector{SDL_Point}
    msd_fr_ts = SIM_STATE["FR.MSD.TS"]::Vector{SDL_Point}
    win_w, win_h = winsize()

    # record
    lc = loopcount()
    lc < 5 && return
    idx = mod(lc, win_w) + 1
    
    _scale = 5
    _fr_zero = 30
    target_fr = round(Int, framerate())
    _y = win_h ÷ 2 - _scale * (target_fr - _fr_zero)
    target_fr_ts[idx] = SDL_Point(idx, round(Int, _y))
    
    msd_fr = round(msd_framerate(); sigdigits = 3)
    _y = win_h ÷ 2 - _scale * (msd_fr - _fr_zero)
    msd_fr_ts[idx] = SDL_Point(idx, round(Int, _y))
    
    # clear
    drawcolor!(0, 0, 0)
    drawbackground!()
    
    # Info
    drawimgtext(
            "INFO:", "\n",
            "Move the mouse wheel to control the framerate!!!", "\n",
            "\t", "loop.count:   ", lc, "\n",
            "\t", "fr.target:    ", target_fr, "\n",
            "\t", "fr.meassured: ", msd_fr,
        ;
        x = 20, y = 20, s = 35,
        mono = true
    )

    # Time Serie Plot
    npoints = lc > win_w ? win_w : idx

    drawcolor!(255, 0, 0)
    drawpoints(target_fr_ts, npoints)
    
    drawcolor!(0, 255, 0)
    drawpoints(msd_fr_ts, npoints)

    SDL_Point
    
end