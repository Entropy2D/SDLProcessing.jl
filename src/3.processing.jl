## ...- -.- .- .- - - -. .. . .. - .-- .
SDL_window()::Ptr{SDL_win} = SDL_STATE["SDL_WIN"]
SDL_renderer()::Ptr{SDL_Renderer} = SDL_STATE["SDL_RENDERER"]

## ...- -.- .- .- - - -. .. . .. - .-- .
wintitle() = get!(SDL_STATE, "SDL_WIN_TITLE", "SDLProcessing.jl")
wintitle!(title) = SDL_STATE["SDL_WIN_TITLE"] = title

function winsize!(w::Int, h::Int)
    SDL_STATE["SDL_WIN_W"] = w
    SDL_STATE["SDL_WIN_H"] = h 
    return (w, h)
end
winsize()::Tuple{Int, Int} = (SDL_STATE["SDL_WIN_W"], SDL_STATE["SDL_WIN_H"])

## ...- -.- .- .- - - -. .. . .. - .-- .
# Draw

function drawpoint(x, y)
    CallSDLFunction(SDL_RenderDrawPoint, SDL_renderer(), x, y)
end

function drawpoints(points::Vector{SDL_Point}, n = length(points))
    CallSDLFunction(SDL_RenderDrawPoints, SDL_renderer(), points, n)
end

function drawcolor!(r, g, b, a = SDL_ALPHA_OPAQUE)
    SDL_STATE["SDL_DRAW_COLOR"] = (r, g, b, a)
    CallSDLFunction(SDL_SetRenderDrawColor, SDL_renderer(), r, g, b, a);
end
drawcolor()::Tuple{Int, Int, Int, Int} = get!(SDL_STATE, "SDL_DRAW_COLOR", (0,0,0,0))

function background!()
    CallSDLFunction(SDL_RenderClear, SDL_renderer())
end

## ...- -.- .- .- - - -. .. . .. - .-- .
# Events

const _MOUNSE_X_POS = Int32[1]
const _MOUNSE_Y_POS = Int32[1]
function mousepos()::Tuple{Int, Int} 
    SDL_GetMouseState(pointer(_MOUNSE_X_POS), pointer(_MOUNSE_Y_POS))
    return ((_MOUNSE_X_POS[1], _MOUNSE_Y_POS[1]))
end


# const _WHEEL_CHANNEL = Channel{Tuple{Int, Int}}(32)
# This pop! the data of the last WHEEL event
function mousewheel!()::Tuple{Int, Int} 
    _zero = (0,0)
    get!(SDL_STATE, "MOUSE_WHEEL.UPDATE", false) || return _zero
    _wheel = get!(SDL_STATE, "MOUSE_WHEEL", _zero)
    SDL_STATE["MOUSE_WHEEL"] = _zero
    SDL_STATE["MOUSE_WHEEL.UPDATE"] = false
    return _wheel
end

## ...- -.- .- .- - - -. .. . .. - .-- .
loopcount()::Int = get!(SDL_STATE, "SDL_LOOP_COUNT", 0)

function framerate!(fr::Int)
    SDL_STATE["SDL_FRAME_RATE"] = fr
end
framerate()::Int = SDL_STATE["SDL_FRAME_RATE"]

msd_framerate() = get!(SDL_STATE, "MEASSURED.FRAMERATE", -1)

