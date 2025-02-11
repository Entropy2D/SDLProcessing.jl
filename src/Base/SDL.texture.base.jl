#TODO rename file to SDLP_Image

#MARK: loadimage
function SDLP_loadimage(onsetup::Function, path::String; attach_sur = false)
    
    # load
    surface_ptr = CallSDLFunction(IMG_Load, path)

    # texture
    img = SDLP_Image(surface_ptr; attach_sur)

    try
        # setup
        onsetup(img)

        # convert to Texture
        text_ptr = CallSDLFunction(
            SDL_CreateTextureFromSurface, 
            img.renderer_ptr, surface_ptr
        )
        img.texture_ptr = text_ptr

        return pimg

    finally
        # Free Surface
        if !attach_sur
            SDL_FreeSurface(surface_ptr)
            img.surface_ptr = C_NULL
        end
    end
end

#MARK: SDLP_imagesize
function _texturesize(tex::Ptr{SDL_Texture})
    w_ref, h_ref = Ref{Cint}(0), Ref{Cint}(0)
    CallSDLFunction(
        SDL_QueryTexture, 
            tex, C_NULL, C_NULL, w_ref, h_ref
    )
    return w_ref[], h_ref[]
end

function SDLP_imagesize(img::SDLP_Image)
    get!(pimg, "TEX.SIZE") do
        _texturesize(img.texture_ptr)
    end
end