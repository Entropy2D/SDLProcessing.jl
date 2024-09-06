@time begin
    using SDLProcessing
    using SimpleDirectMediaLayer
    using SimpleDirectMediaLayer.LibSDL2
    using Base.Threads
    using DataStructures
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SIM_STATE = Dict()

# TODO: make image interface...
# The problem is how much we hide SDL or not

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_init() do
    winsize!(900, 900)
    wintitle!(basename(@__FILE__))
    framerate!(60)

    # Load/Prepare texture
    path = joinpath(@__DIR__, "Picture1.png")
    SIM_STATE["IMG"] = loadimage(path) do _pimg
        setcolorkey(_pimg, 255, 255, 255) # set transparency
    end
    
    # Particles
    # SIM_STATE["PARTICLES.POS"] = Tuple{Int, Int}[]
    SIM_STATE["PARTICLES.POS"] = CircularBuffer{Tuple{Int, Int}}(10_000)

    # initialize adder
    SIM_STATE["ADD.FLAG"] = false
    
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# events
onevent!() do evt
    # recenter
    if evt.type == SDL_MOUSEBUTTONDOWN
        
        if evt.button.button == SDL_BUTTON_LEFT
            println("SDL_BUTTON_LEFT")
            SIM_STATE["ADD.FLAG"] = !SIM_STATE["ADD.FLAG"]
            return
        end

        if evt.button.button == SDL_BUTTON_RIGHT
            println("SDL_BUTTON_RIGHT")
            if !SIM_STATE["ADD.FLAG"]
                pos_vec = SIM_STATE["PARTICLES.POS"]
                empty!(pos_vec)
            end
            return
        end

        if evt.button.button == SDL_BUTTON_MIDDLE
            pos_vec = SIM_STATE["PARTICLES.POS"]
            println("NUM PARTICLES: ", length(pos_vec))
            return
        end
    end
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# Update task
t = @spawn while get!(SDL_STATE, "SDL_RUNNING", true)
    try
        # variables
        pos_vec = SIM_STATE["PARTICLES.POS"]::CircularBuffer{Tuple{Int, Int}}
        win_w, win_h = winsize()
        pimg = SIM_STATE["IMG"]
        tex_w, tex_h = imagesize(pimg)
        tex_w_half, tex_h_half = tex_w ÷ 2, tex_h ÷ 2
        win_w_mhalf, win_h_mhalf = win_w - tex_w_half, win_h - tex_h_half
        
        while get!(SDL_STATE, "SDL_RUNNING", true)
            # move
            N = length(pos_vec)
            for i in 1:N
                x, y = pos_vec[i]
                pos_vec[i] = (
                    clamp(x + rand(-1:1), 1, win_w_mhalf),
                    clamp(y + rand(-1:1), 1, win_h_mhalf)
                )
            end
        end
    catch ignored
        # println(ignored)
    end
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_draw() do

    # variables
    pimg = SIM_STATE["IMG"]
    tex_w, tex_h = imagesize(pimg)
    win_w, win_h = winsize()
    tex_w_half, tex_h_half = tex_w ÷ 2, tex_h ÷ 2
    renderer = renderer_ptr()
    pos_vec = SIM_STATE["PARTICLES.POS"]::CircularBuffer{Tuple{Int, Int}}
    N = length(pos_vec)

    # check adder
    if SIM_STATE["ADD.FLAG"]
        for it in 1:10
            x, y = mousepos()
            push!(pos_vec, (clamp(x, 1, win_w), clamp(y, 1, win_h)))
        end
    end

    # draw
    background!()
    for i in 1:N
        x, y = pos_vec[i]
        drawimage(pimg, 
            x - tex_w_half, y - tex_h_half, 5, 5
        )
    end

end