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

    SDL_Surface

    # Load/Prepare texture
    surface_ptr = IMG_Load(joinpath(@__DIR__, "Picture1.png"))
    if surface_ptr != C_NULL
        surface = unsafe_load(surface_ptr)
    end
    SDL_SetColorKey(surface_ptr, SDL_TRUE, SDL_MapRGB(surface.format, 0xff, 0xff, 0xff))
    SIM_STATE["TEX"] = SDL_CreateTextureFromSurface(SDL_renderer(), surface_ptr)
    SDL_FreeSurface(surface_ptr)
    tex_w, tex_h = texsize(SIM_STATE["TEX"])
    win_w, win_h = winsize()
    SIM_STATE["TEX.SIZE"] = (tex_w, tex_h)
    
    # Particles
    SIM_STATE["PARTICLE.POS"] = Tuple{Int, Int}[]
    N = 5
    for i in 1:N
        push!(SIM_STATE["PARTICLE.POS"], (win_w ÷ 2, win_h ÷ 2))
    end


    # register finilizer
    onfinally!() do
        SDL_DestroyTexture(get(SIM_STATE, "TEX", C_NULL))
    end
    
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
onevent!() do evt
    # recenter
    if evt.type == SDL_MOUSEBUTTONDOWN
        w, h = winsize()
        x, y = mousepos()
        pos_vec = SIM_STATE["PARTICLE.POS"]::Vector{Tuple{Int, Int}}
        push!(pos_vec, (clamp(x, 1, w), clamp(y, 1, h)))
    end
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# Update threads
t = @spawn let
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
                    clamp(x + rand(-1:1), tex_w_half, win_w_mhalf),
                    clamp(y + rand(-1:1), tex_h_half, win_h_mhalf)
                )
            end
        end
    catch err
        println(err)
    end
end
@show t

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_draw() do

    # variables
    tex = SIM_STATE["TEX"]
    tex_w, tex_h = SIM_STATE["TEX.SIZE"]
    win_w, win_h = winsize()
    tex_w_half, tex_h_half = tex_w ÷ 2, tex_h ÷ 2
    renderer = SDL_renderer()
    pos_vec = SIM_STATE["PARTICLE.POS"]::Vector{Tuple{Int, Int}}
    N = length(pos_vec)

    # draw
    background!()
    tex_rect_ref = Ref{SDL_Rect}()
    for i in 1:N
        x, y = pos_vec[i]
        tex_rect_ref[] = SDL_Rect(x - tex_w_half, y - tex_h_half, tex_w, tex_h)
        SDL_RenderCopy(renderer, tex, C_NULL, tex_rect_ref)
    end

end