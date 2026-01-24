# src/Typography.jl

function textFont(filename::String, size::Int)
    # Close previous font if one was loaded
    if SKETCH._font != C_NULL
        TTF.TTF_CloseFont(SKETCH._font)
    end

    font = TTF.TTF_OpenFont(filename, size)
    if font == C_NULL
        @warn "Failed to load font `$(filename)`: $(unsafe_string(TTF.TTF_GetError()))"
        return
    end
    
    SKETCH._font = font
    SKETCH._font_size = size
    SKETCH._font_path = filename
end

function textSize(size::Int)
    if SKETCH._font != C_NULL && SKETCH._font_size != size
        # Reload the font with the new size
        textFont(SKETCH._font_path, size)
    end
    SKETCH._font_size = size
end

function text(str::String, x::Real, y::Real)
    if SKETCH._font == C_NULL
        # For now, just print a warning. 
        # In the future, we could load a default font.
        @warn "No font loaded. Call textFont() first."
        return
    end

    # Use the fill color for the text
    c = SKETCH._fill_color
    sdl_color = SDL2.SDL_Color(c.r, c.g, c.b, c.a)

    surface = TTF.TTF_RenderText_Blended(SKETCH._font, str, sdl_color)
    if surface == C_NULL
        @warn "Failed to render text: $(unsafe_string(TTF.TTF_GetError()))"
        return
    end

    texture = SDL2.SDL_CreateTextureFromSurface(SKETCH._renderer, surface)
    if texture == C_NULL
        SDL2.SDL_FreeSurface(surface)
        @warn "Failed to create texture from text surface: $(unsafe_string(SDL2.SDL_GetError()))"
        return
    end

    w = Ref{Cint}()
    h = Ref{Cint}()
    TTF.TTF_SizeText(SKETCH._font, str, w, h)
    
    # Adjust x and y based on alignment
    new_x = Float64(x)
    new_y = Float64(y)

    if SKETCH._text_align_horiz == H_CENTER
        new_x = x - w[] / 2
    elseif SKETCH._text_align_horiz == H_RIGHT
        new_x = x - w[]
    end

    if SKETCH._text_align_vert == V_CENTER
        new_y = y - h[] / 2
    elseif SKETCH._text_align_vert == V_BOTTOM
        new_y = y - h[]
    end
    
    dest_rect = SDL2.SDL_Rect(round(Int, new_x), round(Int, new_y), w[], h[])

    SDL2.SDL_RenderCopy(SKETCH._renderer, texture, C_NULL, Ref(dest_rect))

    SDL2.SDL_FreeSurface(surface)
    SDL2.SDL_DestroyTexture(texture)
end

function textAlign(horiz::TextAlignHoriz, vert::TextAlignVert=V_BOTTOM)
    SKETCH._text_align_horiz = horiz
    SKETCH._text_align_vert = vert
end