@time begin
    using SDLProcessing
    using Base.Threads
    using DataStructures
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
include("_useless.engine.jl")

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SIM_STATE = Dict()

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# CONFIG ENGINE

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
mutable struct Ball <: UseLessParticle
    x_vel::Float64           # y velocity
    y_vel::Float64           # x velocity
    r::Int                   # radius
    c::Tuple{Int, Int, Int}  # radius
    x_pos::Int               # pos of center
    y_pos::Int               # pos of center
end

function _draw!(b::Ball; pimg = SIM_STATE["CIRCLE"])
    imagecolor!(pimg, b.c...)
    drawimage(pimg, b.x_pos - b.r, b.y_pos - b.r, 2 * b.r, 2 * b.r)
    return b
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# Pre init config
onconfig!() do
    winsize!(600, 600)
    wintitle!(basename(@__FILE__))
    framerate!(60)
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_init() do
    # Load/Prepare textures
    SIM_STATE["CIRCLE"] = loadimage(
        stdassets("circle.noline.fill.png")
    )
    SIM_STATE["BALLS"] = Ball[]
    SIM_STATE["WIN.POS0"] = Dict{Int, Tuple}()

    # Config Enigine
    w, h = winsize()
    WORLD.x0 = round(Int, w * 0.1)
    WORLD.x1 = round(Int, w * 0.9)
    WORLD.y0 = round(Int, h * 0.1)
    WORLD.y1 = round(Int, h * 0.9)
    WORLD.gravity = 30.0
    WORLD.time_step = 0.05

    nothing
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# events
onevent!() do evt
    # recenter
    if evt.type == SDL_MOUSEBUTTONDOWN
        if evt.button.button == SDL_BUTTON_LEFT
            SIM_STATE["ADD.BALL"] = true
            return
        end

        if evt.button.button == SDL_BUTTON_RIGHT
            return
        end
        
        if evt.button.button == SDL_BUTTON_MIDDLE
            return
        end
    end # SDL_MOUSEBUTTONDOWN

    if evt.type == SDL_MOUSEWHEEL
        # _, wheel_d = mousewheel(evt)
        return
    end # SDL_MOUSEWHEEL
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# Update task
function _update_loop(i0, s)
    try
        # variables
        balls = SIM_STATE["BALLS"]
        id = string("UP.LOOP.", rand(Int))
        
        # move chunk
        while isrunning()
            
            N = length(balls)

            # update
            for i in i0:s:N
                _interact!(balls[i], balls)
            end
            # move
            for i in i0:s:N
                _move!(balls[i])
            end

            # window correction
            wpos0_reg = SIM_STATE["WIN.POS0"]
            for i in i0:s:N
                wpos = winpos()
                wpos0 = get!(wpos0_reg, i, wpos)
                wpos == wpos0 && continue
                dwx, dwy = wpos0 .- wpos
                b = balls[i]
                _set_x_pos!(b, b.x_pos + dwx)
                _set_y_pos!(b, b.y_pos + dwy)
                wpos0_reg[i] = wpos
            end

            # control framerate
            tfrec = 50
            SDL_forcefrec!(id, tfrec)
        end
    catch ignored
        println(ignored)
        showerror(stdout, ignored, catch_backtrace())
        rethrow(ignored)
    end
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# Register threaded tasks
# T: set the number of non-drawing tasks (typically T < nthreads())
let T = nthreads() - 1 
    for t in 1:T
        onthread!() do
            _update_loop(t, T)
        end
    end
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
oninfo!() do 
    # println("Write here stuff")
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_draw() do

    loopcount() < 1 && return

    balls = SIM_STATE["BALLS"]
    win_w, win_h = winsize()

    # add ball
    if get!(SIM_STATE, "ADD.BALL", false)
        x, y = mousepos()
        for i in 1:10
            r = rand(3:10)
            c = tuple(rand(1:255, 3)...)
            v = 10 .* rand([-1, 1], 2)
            ball = Ball(v..., r, c, x + rand(-3:3), y + rand(-3:3))
            push!(balls, ball)
        end
        SIM_STATE["ADD.BALL"] = false
    end
    
    # draw all
    drawbackground!()
    pimg = SIM_STATE["CIRCLE"]
    for b in balls
        _draw!(b; pimg)
    end

end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# Engine
