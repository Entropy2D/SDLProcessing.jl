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
    SIM_STATE["FR.TARGET.TS"] = fill(h / 2, w)
    SIM_STATE["FR.MSD.TS"] = fill(h / 2, w)

    path = joinpath(@__DIR__, "assets", "circle.noline.fill.png")
    SIM_STATE["MARKER.TALE"] = loadimage(path)
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
SDL_draw() do

    # variables
    target_fr_ts = SIM_STATE["FR.TARGET.TS"]::Vector{Float64}
    msd_fr_ts = SIM_STATE["FR.MSD.TS"]::Vector{Float64}
    win_w, win_h = winsize()

    # record data
    lc = loopcount()
    lc < 5 && return
    idx = mod(lc, win_w) + 1
    
    _scale = 5
    _fr_zero = 30
    target_fr = round(Int, framerate())
    _y = win_h ÷ 2 - _scale * (target_fr - _fr_zero)
    target_fr_ts[idx] = round(Int, _y)
    
    msd_fr = round(msd_framerate(); sigdigits = 3)
    _y = win_h ÷ 2 - _scale * (msd_fr - _fr_zero)
    msd_fr_ts[idx] = round(Int, _y)
    
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
    idx1 = lc > win_w ? win_w : idx
    marker_size = 10
    marker_pimg = SIM_STATE["MARKER.TALE"]
    for (rgb, ts) in [
            ((255, 0, 0), target_fr_ts), 
            ((0, 255, 0), msd_fr_ts),  
        ]
        # tale
        imagecolor!(marker_pimg, rgb...)
        for i in 1:idx1
            val = ts[i]
            drawimage(marker_pimg, 
                i - marker_size ÷ 2, 
                val - marker_size ÷ 2, 
                marker_size, marker_size
            )
        end
    end
end