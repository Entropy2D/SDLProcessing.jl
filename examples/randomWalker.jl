@time begin
    using SDLProcessing
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_init() do
    winsize!(900, 900)
    wintitle!(basename(@__FILE__))
    framerate!(60)
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SIM_STATE = Dict()

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
onevent!() do evt
    # recenter
    if evt.type == SDL_MOUSEBUTTONDOWN
        w, h = winsize()
        SIM_STATE["POS"] = (w, h) .÷ 2
    end
end


## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.

SDL_draw() do

    mod(loopcount(), framerate()) == 0 && println(msd_framerate())
    
    w, h = winsize()
    
    # erase
    drawcolor!(0,0,0)
    background!()
    
    # walk
    x, y = get!(SIM_STATE, "POS", (w, h) .÷ 2)
    for st in 1:300
        x = clamp(x + rand(-1:1), 1, w)
        y = clamp(y + rand(-1:1), 1, h)
        
        # paint
        drawcolor!(255, 255, 255)
        drawpoint(x, y)
    end
    SIM_STATE["POS"] = (x, y)

end
