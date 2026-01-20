## --.-.- - .- .- .. .-. -. .. -. - ... -. .-.- ..- .- .-
abstract type Wrapper end

## --.-.- - .- .- .. .-. -. .. -. - ... -. .-.- ..- .- .-
#MARK: SDLP_Window
mutable struct SDLP_Window <: Wrapper
    window_ptr::Ptr{SDL_Window}
    data::Dict{String, Any}         # in object data (sllow in hot loops)
    
    function SDLP_Window()

        SDL_window = getstate("SDL.window", nothing)
        isnothing(SDL_window) || error("Window already created. Do 'emptystate!' to reset")


        SDL_window_ptr = CallSDLFunction(
            SDL_CreateWindow, 
                getstate!("SDL.SDL_WIN_TITLE", "SDLProcessing.jl"), 
                getstate!("SDL.SDL_WINDOWPOS_X", SDL_WINDOWPOS_CENTERED), 
                getstate!("SDL.SDL_WINDOWPOS_Y", SDL_WINDOWPOS_CENTERED), 
                getstate!("SDL.SDL_WIN_W", 800), 
                getstate!("SDL.SDL_WIN_H", 800), 
                SDL_WINDOW_SHOWN
        )
            
        SDL_window = new(SDL_window_ptr, Dict())
        setstate!("SDL.window", SDL_window)
        setstate!("SDL.window_ptr", SDL_window_ptr)
        finalizer(destroy!, SDL_window)
        return SDL_window
    end

end

function destroy!(win::SDLP_Window)
    println("destroy!(win::Window)")

    SDL.SDL_DestroyWindow(win.window_ptr)
    win.window_ptr = C_NULL
    setstate!("SDL.window", nothing; lk = true)
    setstate!("SDL.window_ptr", nothing; lk = true)
    return nothing
end


## --.-.- - .- .- .. .-. -. .. -. - ... -. .-.- ..- .- .-
#MARK: SDLP_Window
mutable struct SDLP_Renderer <: Wrapper
    win::SDLP_Window
    renderer_ptr::Ptr{SDL_Renderer}
    data::Dict{String, Any}         # in object data (sllow in hot loops)

    function SDLP_Renderer()

        SDL_window = getstate("SDL.window", nothing)
        isnothing(SDL_window) && error("Renderer can't be created without 'SDL_window'")

        SDL_renderer = getstate("SDL.renderer", nothing)
        isnothing(SDL_renderer) || error("Renderer already created. Do 'emptystate!' to reset")

        SDL_renderer_ptr = CallSDLFunction(
            SDL_CreateRenderer, 
                SDL_window.window_ptr, 
                getstate!("SDL.SDL_RENDERER.DRIVER_FLAG", -1),
                SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC
        )
        
        SDL_renderer = new(SDL_window, SDL_renderer_ptr, Dict())
        setstate!("SDL.renderer", SDL_renderer)
        setstate!("SDL.renderer_ptr", SDL_renderer_ptr)

        finalizer(destroy!, SDLP_Renderer)
        return SDL_renderer
    end
end

function destroy!(renderer::SDLP_Renderer)
    println("destroy!(renderer::SDLP_Renderer)")

    SDL.SDL_DestroyRenderer(renderer.renderer_ptr)
    renderer.renderer_ptr = C_NULL
    setstate!("SDL.renderer", nothing; lk = true)
    setstate!("SDL.renderer_ptr", nothing; lk = true)
    return nothing
end

## --.-.- - .- .- .. .-. -. .. -. - ... -. .-.- ..- .- .-
#MARK: SDLP_Image
# To create one use loadimage
mutable struct SDLP_Image <: Wrapper
    surface_ptr::Ptr{SDL_Surface}
    texture_ptr::Ptr{SDL_Texture}
    renderer_ptr::Ptr{SDL_Renderer}
    data::Dict{String, Any}         # in object data (sllow in hot loops)

    function SDLP_Image(surface_ptr; attach_sur = false)
        texture = new(surface_ptr, C_NULL, renderer_ptr(), Dict())
        texture["attach.surface"] = attach_sur
        finalizer(destroy!, texture)
        return texture
    end

end

function destroy!(texture::SDLP_Image)
    println("destroy!(texture::SDLP_Image)")

    SDL_DestroyTexture(texture.texture_ptr)
    texture.texture_ptr = C_NULL
    if get(texture, "attach.surface", false)
        SDL_FreeSurface(texture.surface_ptr)
        texture.surface_ptr = C_NULL
    end
    #TODO del texture from OeS
    return nothing
end


# mutable struct Texture{T} <: AbstractGraphics
#     ptr::Ptr{T}
#     width::Int
#     height::Int
#     center_x::Int
#     center_y::Int
# end

# function Texture(render_ptr::Ptr{SDL_Renderer}, sdl_surface::Ptr{SDL.SDL_Surface}; halign = 0.5, valign = 0.5)
#     texture_ptr = SDL.SDL_CreateTextureFromSurface(render_ptr, sdl_surface)
#     SDL.SDL_FreeSurface(sdl_surface)
#     width, height = Int[0], Int[0]
#     SDL.SDL_QueryTexture(texture_ptr, C_NULL, C_NULL, width, height)
#     self = Texture(texture_ptr, width[], height[], round(Int, width[]*halign), round(Int, height[]*valign))
#     finalizer(destroy!, self)
#     return self
# end
