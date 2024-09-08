@time begin
    using SDLProcessing
    using SimpleDirectMediaLayer
    using SimpleDirectMediaLayer.LibSDL2
    using Base.Threads
    using DataStructures
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
struct Particle
    pos::Ref{Tuple{Int, Int}}
    img::PImage
    time::Float64
    cmode::Float64
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_init() do
    
    # Load/Prepare textures
    NUM_IMAGES = 9
    SIM_STATE["IMGS"] = PImage[]
    for i in 1:NUM_IMAGES
        # TODO: create a small assets library/collection
        path = stdassets("Picture$i.png")
        pimg = loadimage(path) do _pimg
            setcolorkey(_pimg, 255, 255, 255) # set transparency
        end    
        push!(SIM_STATE["IMGS"], pimg)
    end
    
    # Particles
    N = 5_000
    SIM_STATE["PARTICLES"] = CircularBuffer{Particle}(N)

    SIM_STATE["PARTICLES.SIZE"] = 30
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
            showcursor(!SIM_STATE["ADD.FLAG"])
            return
        end

        if evt.button.button == SDL_BUTTON_RIGHT
            # println("SDL_BUTTON_RIGHT")
            
            SIM_STATE["ADD.FLAG"] && return
            particles = SIM_STATE["PARTICLES"]
            empty!(particles)
            
            return
        end
        
        if evt.button.button == SDL_BUTTON_MIDDLE
            SIM_STATE["CURR.COLORMODE"] = rand(1:3)
        end
    end # SDL_MOUSEBUTTONDOWN

    if evt.type == SDL_MOUSEWHEEL
        if SIM_STATE["ADD.FLAG"] 
            SIM_STATE["ADD.FLAG"] = false
            showcursor(true)
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
        particles = SIM_STATE["PARTICLES"]::CircularBuffer{Particle}
        
        win_w, win_h = winsize()
        id = string("UP.LOOP.", rand(Int))
        
        # move chunk
        while isrunning()
            N = length(particles)

            imgsize = SIM_STATE["PARTICLES.SIZE"]::Int
            for i in i0:s:N
                part = particles[i]
                x, y = part.pos[]
                part.pos[] = (
                    clamp(x + rand(-1:1), 1, win_w - imgsize),
                    clamp(y + rand(-1:1), 1, win_h - imgsize)
                )
            end

            # control framerate
            tfrec = framerate() ÷ 4
            SDL_forcefrec!(id, tfrec)
        end
    catch ignored
        # showerror(stdout, ignored, catch_backtrace())
        # rethrow(ignored)
    end
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# Register threaded tasks
let
    T = 2 # set the number of non-drawing tasks (typically T < nthreads())
    for t in 1:T
        onthread!() do
            _update_loop(t, T)
        end
    end
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
oninfo!() do 
    particles = SIM_STATE["PARTICLES"]
    println("particles.num: ", length(particles))
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_draw() do

    # variables
    pimgs = SIM_STATE["IMGS"]
    particles = SIM_STATE["PARTICLES"]::CircularBuffer{Particle}

    win_w, win_h = winsize()
    imgsize = SIM_STATE["PARTICLES.SIZE"]::Int

    # Add Particles
    currcmode = SIM_STATE["CURR.COLORMODE"]
    if SIM_STATE["ADD.FLAG"]
        x, y = mousepos()
        for it in 1:1
            part = Particle(
                Ref((
                    clamp(x - imgsize ÷ 2, 1, win_w), 
                    clamp(y - imgsize ÷ 2, 1, win_h)
                )), 
                rand(pimgs), 
                time(), 
                currcmode
            )
            push!(particles, part)
        end
    end
    
    # draw all
    drawbackground!()
    N = length(particles)
    N < 1 && return # ignore
    t0, t1 = extrema(p.time for p in particles)
    for i in 1:N
        part = particles[i]
        x, y = part.pos[]
        cmode = part.cmode
        pimg = part.img
        c = (part.time - t0) / (t1 - t0) * 255
        c = isfinite(c) ? c : 255
        c = round(Int, c)
        c = clamp(c, 25, 255)
        if cmode == 1; imagecolor!(pimg, c, 0, 0)
            elseif cmode == 2; imagecolor!(pimg, 0, c, 0)
            elseif cmode == 3; imagecolor!(pimg, 0, 0, c)
        end
        drawimage(pimg, x, y, imgsize, imgsize)
    end

end