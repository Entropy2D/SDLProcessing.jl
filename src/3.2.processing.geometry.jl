## ...- -.- .- .- - - -. .. . .. - .-- .
# Draw

function drawbackground!()
    CallSDLFunction(SDL_RenderClear, renderer_ptr())
end

function drawpoint(x, y)
    CallSDLFunction(SDL_RenderDrawPoint, renderer_ptr(), x, y)
end

function drawpoints(points::Vector{SDL_Point}, n = length(points))
    CallSDLFunction(SDL_RenderDrawPoints, renderer_ptr(), points, n)
end

function drawline(x1, y1, x2, y2)
    CallSDLFunction(SDL_RenderDrawLine, renderer_ptr(), x1, y1, x2, y2)
end

function drawlines(points::Vector{SDL_Point}, n = length(points))
    CallSDLFunction(SDL_RenderDrawLines, renderer_ptr(), points, n)
end

# SDL_RenderDrawRect
function drawrect(rect::Ref{SDL_Rect})
    CallSDLFunction(SDL_RenderDrawRect, renderer_ptr(), rect)
end

function drawrects(rect::Vector{SDL_Rect}, n = length(rect))
    CallSDLFunction(SDL_RenderDrawRects, renderer_ptr(), rect, n)
end

function fillrect(rect::SDL_Rect)
    CallSDLFunction(SDL_RenderFillRect, renderer_ptr(), rect)
end

function fillrects(rect::Vector{SDL_Rect}, n = length(rect))
    CallSDLFunction(SDL_RenderFillRects, renderer_ptr(), rect, n)
end

## ...- -.- .- .- - - -. .. . .. - .-- .
# Draw Control



# TODO: Use SDL_GetRenderDrawColor?
function drawcolor!(r, g, b, a = SDL_ALPHA_OPAQUE)
    SDL_STATE["SDL_DRAW_COLOR"] = (r, g, b, a)
    CallSDLFunction(SDL_SetRenderDrawColor, renderer_ptr(), r, g, b, a);
end
drawcolor()::Tuple{Int, Int, Int, Int} = get!(SDL_STATE, "SDL_DRAW_COLOR", (0,0,0,0))

