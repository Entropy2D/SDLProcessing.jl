# src/Drawing.jl

# --- Color Helpers ---
function color(r, g, b, a=255)
    return Color(UInt8(r), UInt8(g), UInt8(b), UInt8(a))
end

# --- Style Functions ---
function background(c::Color)
    # Sets the SDL draw color to c and clears the renderer
    SDL2.SDL_SetRenderDrawColor(SKETCH._renderer, c.r, c.g, c.b, c.a)
    SDL2.SDL_RenderClear(SKETCH._renderer)
end

function fill(c::Color)
    SKETCH._use_fill = true
    SKETCH._fill_color = c
end

function noFill()
    SKETCH._use_fill = false
end

function stroke(c::Color)
    SKETCH._use_stroke = true
    SKETCH._stroke_color = c
end

function noStroke()
    SKETCH._use_stroke = false
end

function strokeWeight(w::Int)
    SKETCH._stroke_weight = w
end

function line(x1, y1, x2, y2)
    if SKETCH._use_stroke
        c = SKETCH._stroke_color
        SDL2.SDL_SetRenderDrawColor(SKETCH._renderer, c.r, c.g, c.b, c.a)

        w = SKETCH._stroke_weight
        if w <= 1
            SDL2.SDL_RenderDrawLine(SKETCH._renderer, round(Int, x1), round(Int, y1), round(Int, x2), round(Int, y2))
            return
        end

        # Implementation for thick lines
        dx = x2 - x1
        dy = y2 - y1
        len = sqrt(dx*dx + dy*dy)
        if len == 0 # It's a point
             # For a point, we can draw a small filled rectangle
            half_w = w / 2.0
            r = SDL2.SDL_Rect(round(Int, x1 - half_w), round(Int, y1 - half_w), round(Int, w), round(Int, w))
            SDL2.SDL_RenderFillRect(SKETCH._renderer, Ref(r))
            return
        end

        nx = -dy / len
        ny = dx / len

        start_offset = -floor(Int, (w-1)/2)
        end_offset = ceil(Int, (w-1)/2)

        for i in start_offset:end_offset
            offset_x = i * nx
            offset_y = i * ny
            SDL2.SDL_RenderDrawLine(SKETCH._renderer, 
                                   round(Int, x1 + offset_x), round(Int, y1 + offset_y),
                                   round(Int, x2 + offset_x), round(Int, y2 + offset_y))
        end
    end
end


# --- Shape Functions ---

# Basic Midpoint circle algorithm for a filled circle
function _draw_filled_circle(renderer, centerX, centerY, radius, c::Color)
    SDL2.SDL_SetRenderDrawColor(renderer, c.r, c.g, c.b, c.a)
    
    x = radius
    y = 0
    
    # Printing the initial point on the axes after translation
    SDL2.SDL_RenderDrawLine(renderer, centerX - radius, centerY, centerX + radius, centerY)
    
    # When radius is 0, just print a single point
    if radius > 0
        SDL2.SDL_RenderDrawLine(renderer, centerX, centerY - radius, centerX, centerY + radius)
    end
    
    P = 1 - radius
    while x > y
        y += 1
        
        if P <= 0
            P = P + 2*y + 1
        else
            x -= 1
            P = P + 2*y - 2*x + 1
        end
        
        if x < y
            break
        end

        # Draw lines to fill the circle
        SDL2.SDL_RenderDrawLine(renderer, centerX - x, centerY + y, centerX + x, centerY + y)
        SDL2.SDL_RenderDrawLine(renderer, centerX - x, centerY - y, centerX + x, centerY - y)
        SDL2.SDL_RenderDrawLine(renderer, centerX - y, centerY + x, centerX + y, centerY + x)
        SDL2.SDL_RenderDrawLine(renderer, centerX - y, centerY - x, centerX + y, centerY - x)
    end
end


function ellipse(x, y, w, h)
    # NOTE: For now, this only draws a circle using 'w' as diameter. 'h' is ignored.
    radius = w / 2
    if SKETCH._use_fill
        _draw_filled_circle(SKETCH._renderer, round(Int, x), round(Int, y), round(Int, radius), SKETCH._fill_color)
    end
    # TODO: Implement stroke for ellipse
end

function rect(x, y, w, h)
    r = SDL2.SDL_Rect(round(Int, x), round(Int, y), round(Int, w), round(Int, h))
    
    if SKETCH._use_fill
        c = SKETCH._fill_color
        SDL2.SDL_SetRenderDrawColor(SKETCH._renderer, c.r, c.g, c.b, c.a)
        SDL2.SDL_RenderFillRect(SKETCH._renderer, Ref(r))
    end

    if SKETCH._use_stroke
        c = SKETCH._stroke_color
        SDL2.SDL_SetRenderDrawColor(SKETCH._renderer, c.r, c.g, c.b, c.a)
        SDL2.SDL_RenderDrawRect(SKETCH._renderer, Ref(r))
    end
end
