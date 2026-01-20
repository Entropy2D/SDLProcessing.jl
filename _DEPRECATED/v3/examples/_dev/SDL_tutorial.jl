@time begin
    using SDLProcessing
    using SimpleDirectMediaLayer
    using SimpleDirectMediaLayer.LibSDL2
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.


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

        if evt.button.button == SDL_BUTTON_LEFT
            println("SDL_BUTTON_LEFT")
        end

        if evt.button.button == SDL_BUTTON_RIGHT
            println("SDL_BUTTON_RIGHT")
        end

        if evt.button.button == SDL_BUTTON_MIDDLE
            println("SDL_BUTTON_MIDDLE")
        end
    end


end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_draw() do

end
