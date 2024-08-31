SDL_window()::Ptr{SDL_win} = SDL_STATE["SDL_WIN"]
SDL_renderer()::Ptr{SDL_Renderer} = SDL_STATE["SDL_RENDERER"]

loopcount()::Int = get!(SDL_STATE, "SDL_LOOP_COUNT", 0)

function drawpoint(x, y)
    SDL_RenderDrawPoint(SDL_renderer(), x, y)
end

wintitle() = get!(SDL_STATE, "SDL_WIN_TITLE", "SDLProcessing.jl")
wintitle!(title) = SDL_STATE["SDL_WIN_TITLE"] = title

function winsize!(w::Int, h::Int)
    SDL_STATE["SDL_WIN_W"] = w
    SDL_STATE["SDL_WIN_H"] = h 
    return (w, h)
end
winsize()::Tuple{Int, Int} = (SDL_STATE["SDL_WIN_W"], SDL_STATE["SDL_WIN_H"])

function framerate!(fr::Int)
    SDL_STATE["SDL_FRAME_RATE"] = fr
end
framerate()::Int = SDL_STATE["SDL_FRAME_RATE"]

msd_framerate() = get!(SDL_STATE, "MEASSURED.FRAMERATE", -1)

function drawcolor!(r, g, b, a = SDL_ALPHA_OPAQUE)
    SDL_STATE["SDL_DRAW_COLOR"] = (r, g, b, a)
    SDL_SetRenderDrawColor(SDL_renderer(), r, g, b, a);
end
drawcolor() = get!(SDL_STATE, "SDL_DRAW_COLOR", (0,0,0,0))

function background!()
    SDL_RenderClear(SDL_renderer())
end