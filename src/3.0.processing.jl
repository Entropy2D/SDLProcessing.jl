## ...- -.- .- .- - - -. .. . .. - .-- .
window_ptr() = SDL_STATE.window_ptr
renderer_ptr() = SDL_STATE.renderer_ptr
event_ref() = SDL_STATE.event_ref


## ...- -.- .- .- - - -. .. . .. - .-- .

# TODO: interface this?
# SDL_SetWindowTitle
# SDL_GetWindowTitle
wintitle()::String = get!(SDL_STATE, "SDL_WIN_TITLE", "SDLProcessing.jl")
wintitle!(title::String) = SDL_STATE["SDL_WIN_TITLE"] = title

# TODO: interface this?
# SDL_GetWindowSize
# SDL_GetWindowSize

function winsize!(w::Int, h::Int)
    SDL_STATE["SDL_WIN_W"] = w
    SDL_STATE["SDL_WIN_H"] = h 
    return (w, h)
end

winsize()::Tuple{Int, Int} = (SDL_STATE["SDL_WIN_W"], SDL_STATE["SDL_WIN_H"])

## ...- -.- .- .- - - -. .. . .. - .-- .




## ...- -.- .- .- - - -. .. . .. - .-- .
# Draw

function drawpoint(x, y)
    CallSDLFunction(SDL_RenderDrawPoint, renderer_ptr(), x, y)
end

function drawpoints(points::Vector{SDL_Point}, n = length(points))
    CallSDLFunction(SDL_RenderDrawPoints, renderer_ptr(), points, n)
end

function drawcolor!(r, g, b, a = SDL_ALPHA_OPAQUE)
    SDL_STATE["SDL_DRAW_COLOR"] = (r, g, b, a)
    CallSDLFunction(SDL_SetRenderDrawColor, renderer_ptr(), r, g, b, a);
end
drawcolor()::Tuple{Int, Int, Int, Int} = get!(SDL_STATE, "SDL_DRAW_COLOR", (0,0,0,0))

function clear!()
    CallSDLFunction(SDL_RenderClear, renderer_ptr())
end

showCursor(toggle::Bool) = CallSDLFunction(SDL_ShowCursor, Int(toggle));

## ...- -.- .- .- - - -. .. . .. - .-- .
# Events

isrunning(dft = true) = get!(SDL_STATE, "SDL_RUNNING", dft)

const _MOUNSE_X_POS = Ref{Int32}(0)
const _MOUNSE_Y_POS = Ref{Int32}(0)
function mousepos()
    SDL_GetMouseState(_MOUNSE_X_POS, _MOUNSE_Y_POS)
    return (_MOUNSE_X_POS[], _MOUNSE_Y_POS[])
end

## ...- -.- .- .- - - -. .. . .. - .-- .
function mousewheel(evt)::Tuple{Int, Int}
    # Derived from: https://github.com/Kyjor/JulGame.jl
    # wheel_x = sdlVersion >= 2018 ? -event.wheel.preciseX : -(Cfloat(event.wheel.x))
    # wheel_x = -evt.wheel.preciseX
    wheel_x = -(Cfloat(evt.wheel.x))
    # wheel_y = sdlVersion >= 2018 ? event.wheel.preciseY : Cfloat(event.wheel.y)
    # wheel_y = evt.wheel.preciseY
    wheel_y = Cfloat(evt.wheel.y)
    return (wheel_x, wheel_y)
end

## ...- -.- .- .- - - -. .. . .. - .-- .
loopcount()::Int = get!(SDL_STATE, "STATS.LOOP_COUNT", 0)

function framerate!(fr::Int)
    SDL_STATE["SDL_FRAME_RATE"] = fr
end
framerate()::Int = SDL_STATE["SDL_FRAME_RATE"]

function msd_framerate()
    n = length(_MSD_FRAMERATE_DUFFER)
    n == 0 && return -1.0
    return sum(_MSD_FRAMERATE_DUFFER) / n
end

