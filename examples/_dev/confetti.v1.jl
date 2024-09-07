@time begin
    using SDLProcessing
    using SimpleDirectMediaLayer
    using SimpleDirectMediaLayer.LibSDL2
    using Base.Threads
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
    surface_ptr = IMG_Load(joinpath(@__DIR__, "Picture1.png"))
    if surface_ptr != C_NULL
        surface = unsafe_load(surface_ptr)
    end
    SDL_SetColorKey(surface_ptr, SDL_TRUE, SDL_MapRGB(surface.format, 0xff, 0xff, 0xff))
    SIM_STATE["TEX"] = SDL_CreateTextureFromSurface(renderer_ptr(), surface_ptr)
    SDL_FreeSurface(surface_ptr)
    tex_w, tex_h = texturesize(SIM_STATE["TEX"])
    win_w, win_h = winsize()
    SIM_STATE["TEX.SIZE"] = (tex_w, tex_h)
    
    # Particles
    SIM_STATE["PARTICLE.POS"] = Tuple{Int, Int}[]

    # register finilizer
    onfinally!() do
        SDL_DestroyTexture(get(SIM_STATE, "TEX", C_NULL))
    end

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
            SIM_STATE["ADD.FLAG"] && return
            pos_vec = SIM_STATE["PARTICLE.POS"]
            empty!(pos_vec)
            return 
        end
    end
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# Update threads
t = @spawn while get!(SDL_STATE, "SDL_RUNNING", true)
    try
        pos_vec = SIM_STATE["PARTICLE.POS"]::Vector{Tuple{Int, Int}}
        win_w, win_h = winsize()
        tex_w, tex_h = SIM_STATE["TEX.SIZE"]
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
    catch err
        println(err)
    end
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_draw() do

    # variables
    tex = SIM_STATE["TEX"]
    tex_w, tex_h = SIM_STATE["TEX.SIZE"]
    win_w, win_h = winsize()
    tex_w_half, tex_h_half = tex_w ÷ 2, tex_h ÷ 2
    renderer = renderer_ptr()
    pos_vec = SIM_STATE["PARTICLE.POS"]::Vector{Tuple{Int, Int}}
    N = length(pos_vec)

    # check adder
    if SIM_STATE["ADD.FLAG"]
        for it in 1:100
            x, y = mousepos()
            push!(pos_vec, (clamp(x, 1, win_w), clamp(y, 1, win_h)))
        end
    end

    # draw
    clear!()
    tex_rect_ref = Ref{SDL_Rect}()
    for i in 1:N
        x, y = pos_vec[i]
        tex_rect_ref[] = SDL_Rect(x - tex_w_half, y - tex_h_half, tex_w, tex_h)
        SDL_RenderCopy(renderer, tex, C_NULL, tex_rect_ref)
    end

end