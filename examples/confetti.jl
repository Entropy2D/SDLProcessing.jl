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
# Pre init config
onconfig!() do
    winsize!(1300, 900)
    wintitle!(basename(@__FILE__))
    framerate!(35)
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_init() do
    
    # Load/Prepare textures
    NUM_IMAGES = 9
    SIM_STATE["IMGS"] = PImage[]
    for i in 1:NUM_IMAGES
        path = joinpath(@__DIR__, "assets", "Picture$i.png")
        pimg = loadimage(path) do _pimg
            setcolorkey(_pimg, 255, 255, 255) # set transparency
        end    
        push!(SIM_STATE["IMGS"], pimg)
    end
    
    # Particles
    N = 5_000
    SIM_STATE["PARTICLES.POS"] = CircularBuffer{Tuple{Int, Int}}(N)
    # DOING: DRAW PARTICLES DEPENDING HOW OLD THEY ARE
    SIM_STATE["PARTICLES.ADDTIME"] = CircularBuffer{Float64}(N)
    SIM_STATE["PARTICLES.IMGS"] = CircularBuffer{PImage}(N)
    SIM_STATE["PARTICLES.SIZE"] = 30
    SIM_STATE["PARTICLES.COLORMODES"] = CircularBuffer{Int}(N)
    SIM_STATE["CURR.COLORMODE"] = 3

    # initialize adder
    SIM_STATE["ADD.FLAG"] = false
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# events
onevent!() do evt
    # recenter
    if evt.type == SDL_MOUSEBUTTONDOWN
        
        if evt.button.button == SDL_BUTTON_LEFT
            # println("SDL_BUTTON_LEFT")
            SIM_STATE["ADD.FLAG"] = !SIM_STATE["ADD.FLAG"]
            showCursor(!SIM_STATE["ADD.FLAG"])
            return
        end

        if evt.button.button == SDL_BUTTON_RIGHT
            # println("SDL_BUTTON_RIGHT")
            SIM_STATE["ADD.FLAG"] && return
            pos_vec = SIM_STATE["PARTICLES.POS"]
            time_vec = SIM_STATE["PARTICLES.ADDTIME"]
            cmode_vec = SIM_STATE["PARTICLES.COLORMODES"]
            empty!(pos_vec)
            empty!(time_vec)
            empty!(cmode_vec)
            return
        end
        
        if evt.button.button == SDL_BUTTON_MIDDLE
            SIM_STATE["CURR.COLORMODE"] = rand(1:3)
        end
    end # SDL_MOUSEBUTTONDOWN

    if evt.type == SDL_MOUSEWHEEL
        if SIM_STATE["ADD.FLAG"] 
            SIM_STATE["ADD.FLAG"] = false
            return
        end
        _, wheel_d = mousewheel(evt)
        SIM_STATE["PARTICLES.SIZE"] += sign(wheel_d)
    end # SDL_MOUSEWHEEL
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# Update task
function _update_loop(i0, s)
    try
        # variables
        pos_vec = SIM_STATE["PARTICLES.POS"]::CircularBuffer{Tuple{Int, Int}}
        win_w, win_h = winsize()
        
        # move chunk
        while isrunning()
            N = length(pos_vec)
            # N == 0 && sleep(0.05)
            imgsize = SIM_STATE["PARTICLES.SIZE"]::Int
            for i in i0:s:N
                x, y = pos_vec[i]
                pos_vec[i] = (
                    clamp(x + rand(-1:1), 1, win_w - imgsize),
                    clamp(y + rand(-1:1), 1, win_h - imgsize)
                )
            end
        end
    catch ignored
        # println(ignored)
    end
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# Register threaded tasks
T = (nthreads() - 1)
# T = 1
for t in 1:T
    # onthread!(() -> _update_loop(t, T)) 
    onthread!(() -> _update_loop(1, 1)) 
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
oninfo!() do 
    pos_vec = SIM_STATE["PARTICLES.POS"]
    println("particles.num: ", length(pos_vec))
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_draw() do

    # variables
    pimgs = SIM_STATE["IMGS"]
    win_w, win_h = winsize()
    renderer = renderer_ptr()
    pos_vec = SIM_STATE["PARTICLES.POS"] 
    time_vec = SIM_STATE["PARTICLES.ADDTIME"]
    img_vec = SIM_STATE["PARTICLES.IMGS"]
    cmode_vec = SIM_STATE["PARTICLES.COLORMODES"]
    N = length(pos_vec)
    imgsize = SIM_STATE["PARTICLES.SIZE"]::Int

    # check adder
    currcmode = SIM_STATE["CURR.COLORMODE"]
    if SIM_STATE["ADD.FLAG"]
        for it in 1:10
            x, y = mousepos()
            push!(pos_vec, (
                clamp(x - imgsize ÷ 2, 1, win_w), 
                clamp(y - imgsize ÷ 2, 1, win_h)
            ))
            push!(time_vec, time())
            push!(img_vec, rand(pimgs))
            push!(cmode_vec, currcmode)
        end
    end

    # draw
    clear!()
    (isempty(time_vec) || isempty(pos_vec)) && return
    t0, t1 = extrema(time_vec)
    for i in 1:N
        x, y = pos_vec[i]
        pimg = img_vec[i]
        cmode = cmode_vec[i]
        c = round(Int, (time_vec[i] - t0) / (t1 - t0) * 255)
        c = clamp(c, 25, 255)
        cmode == 1 && imagecolor!(pimg, c, 0, 0)
        cmode == 2 && imagecolor!(pimg, 0, c, 0)
        cmode == 3 && imagecolor!(pimg, 0, 0, c)
        drawimage(pimg, x, y, imgsize, imgsize)
    end

end