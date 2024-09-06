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
# Texture

function texsize(tex)
    w_ref, h_ref = Ref{Cint}(0), Ref{Cint}(0)
    CallSDLFunction(
        SDL_QueryTexture, 
            tex, C_NULL, C_NULL, w_ref, h_ref
    )
    return w_ref[], h_ref[]
end


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
const _MOUNSE_X_POS = Ref{Int32}(0)
const _MOUNSE_Y_POS = Ref{Int32}(0)
function mousepos()
    SDL_GetMouseState(_MOUNSE_X_POS, _MOUNSE_Y_POS)
    return (_MOUNSE_X_POS[], _MOUNSE_Y_POS[])
end

# TODO: Rethink
# const _WHEEL_CHANNEL = Channel{Tuple{Int, Int}}(32)
# This pop! the data of the last WHEEL event
# function mousewheel!()::Tuple{Int, Int} 
#     get!(SDL_STATE, "MOUSE_WHEEL.UPDATED", false) || return _ZERO_TUPLE
#     _wheel = get!(SDL_STATE, "MOUSE_WHEEL", _ZERO_TUPLE)
#     SDL_STATE["MOUSE_WHEEL"] = _ZERO_TUPLE
#     SDL_STATE["MOUSE_WHEEL.UPDATED"] = false
#     return _wheel
# end

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
loopcount()::Int = get!(SDL_STATE, "SDL_LOOP_COUNT", 0)

function framerate!(fr::Int)
    SDL_STATE["SDL_FRAME_RATE"] = fr
end
framerate()::Int = SDL_STATE["SDL_FRAME_RATE"]

msd_framerate() = get!(SDL_STATE, "MEASSURED.FRAMERATE", -1)

