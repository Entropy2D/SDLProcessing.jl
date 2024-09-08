## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# CONFIG
Base.@kwdef mutable struct UseLessWorld
    gravity::Float64 = 9.8
    time_step::Float64 = 0.1
    repulsion_field::Float64 = 100.0
    damp::Float64 = 0.9
    max_speed::Float64 = 100.0
    x0::Int = 1
    x1::Int = 400
    y0::Int = 1
    y1::Int = 400
end
const WORLD = UseLessWorld()

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
abstract type UseLessParticle end

# Example
# mutable struct Ball <: UseLessParticle
#     x_vel::Float64           # y velocity
#     y_vel::Float64           # x velocity
#     r::Int                   # radius
#     x_pos::Int               # pos of center
#     y_pos::Int               # pos of center
# end

function _interact!(b::UseLessParticle, balls = [])
    # check collitions
    # floor
    _twall_detected = b.y_pos - b.r < WORLD.y0
    _bwall_detected = b.y_pos + b.r > WORLD.y1
    _lwall_detected = b.x_pos - b.r < WORLD.x0
    _rwall_detected = b.x_pos + b.r > WORLD.x1
    # balls
    hits = Ball[]
    for b2 in balls
        d = _dist(b, b2)
        iszero(d) && continue
        d > (b.r + b2.r) && continue
        push!(hits, b2)
    end
    _ball_detected = !isempty(hits)

    # accelerate
    x1_vel = b.x_vel
    y1_vel = b.y_vel
    # gravity
    if _twall_detected
        y1_vel = abs(y1_vel) * WORLD.damp
    elseif _bwall_detected
        y1_vel = -abs(y1_vel) * WORLD.damp
    end
    y1_vel += WORLD.gravity * WORLD.time_step

    # walls
    if _lwall_detected
        x1_vel = abs(x1_vel) * WORLD.damp
    end
    if _rwall_detected
        x1_vel = -abs(x1_vel) * WORLD.damp
    end

    # balls
    if _ball_detected
        # println("BALL DETECTED")
        for b2 in hits
            dv0 = WORLD.repulsion_field * WORLD.time_step

            dvx = max(abs(x1_vel), dv0)
            dx = b2.x_pos - b.x_pos
            x1_vel += dx < 0 ? dvx : -dvx

            dvy = max(abs(y1_vel), dv0)
            dy = b2.y_pos - b.y_pos
            y1_vel += dy < 0 ? dvy : -dvy
        end
            
    end

    # update
    _set_x_vel!(b, x1_vel)
    _set_y_vel!(b, y1_vel)

    return b
end

function _move!(b::UseLessParticle)

    x1_pos = b.x_pos + b.x_vel * WORLD.time_step
    _set_x_pos!(b, x1_pos)
    
    y1_pos = b.y_pos + b.y_vel * WORLD.time_step
    _set_y_pos!(b, y1_pos)

    return b
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
_dist(b1::UseLessParticle, b2::UseLessParticle) = 
    sqrt((b1.x_pos - b2.x_pos)^2 + (b1.y_pos - b2.y_pos)^2)

function _set_x_pos!(b::UseLessParticle, x0_pos)
    x1_pos = round(Int, x0_pos)
    x1_pos = clamp(x1_pos, WORLD.x0 + b.r - 1, WORLD.x1 - b.r + 1)
    b.x_pos = x1_pos
end

function _set_y_pos!(b::UseLessParticle, y0_pos)
    y1_pos = round(Int, y0_pos)
    y1_pos = clamp(y1_pos, WORLD.y0 + b.r - 1, WORLD.y1 - b.r + 1)
    b.y_pos = y1_pos
end

function _set_x_vel!(b::UseLessParticle, x_vel)
    b.x_vel = clamp(x_vel, -WORLD.max_speed, WORLD.max_speed)
end

function _set_y_vel!(b::UseLessParticle, y_vel)
    b.y_vel = clamp(y_vel, -WORLD.max_speed, WORLD.max_speed)
end
