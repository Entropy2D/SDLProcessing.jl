# examples/bouncing_ball.jl
using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))
using SDLProcessing
const P = SDLProcessing

## --- Ball Object ---
mutable struct Ball
    x::Float64
    y::Float64
    vx::Float64 # Velocity x
    vy::Float64 # Velocity y
    radius::Float64
end

# Create a global instance of the ball for the sketch
ball = Ball(0, 0, 0, 0, 20)


## --- Sketch Definition ---

P.onsetup() do
    P.create_window(800, 600)

    # Initialize ball in the center with a random velocity
    ball.x = P.SKETCH.width / 2
    ball.y = P.SKETCH.height / 2
    ball.vx = (rand() - 0.5) * 10
    ball.vy = (rand() - 0.5) * 10

    P.textFont(joinpath(@__DIR__, "..", "assets", "Open_Sans", "OpenSans-VariableFont_wdth,wght.ttf"), 24)
    P.stroke(P.color(255, 255, 255))
    P.fill(P.color(255, 0, 100))
end

P.ondraw() do
    P.background(P.color(0, 0, 0)) # Black background
    # 1. Update ball position
    ball.x += ball.vx
    ball.y += ball.vy

    # 2. Check for wall collisions and bounce
    if ball.x + ball.radius > P.SKETCH.width || ball.x - ball.radius < 0
        ball.vx *= -1
    end
    if ball.y + ball.radius > P.SKETCH.height || ball.y - ball.radius < 0
        ball.vy *= -1
    end

    # 3. Draw the ball
    P.ellipse(ball.x, ball.y, ball.radius * 2, ball.radius * 2)

    # 4. Display ball position
    P.fill(P.color(255, 255, 255)) # White text
    P.text("Position: ($(round(Int, ball.x)), $(round(Int, ball.y)))", 10, 10)
    
    # Restore fill color for the ball
    P.fill(P.color(255, 0, 100))
end

## --- Run the Sketch ---
P.run_sketch()