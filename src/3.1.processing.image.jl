#=
An interface for dealing with images...
The issue is how much of SDL we should hide...
A first idea is to work only on Textures and just have Surfaces as a transient state...
This will make images more or less inmutable after a setup step
=#

#=
Load image/Surface pointer
=#
function loadsurface(path::AbstractString)
    return CallSDLFunction(IMG_Load, path)
end

#=
get the struct from the pointer
=#
function imgobject(img_ptr::Ptr{SDL_Surface})
    img_ptr == C_NULL && return nothing
    return unsafe_load(img_ptr)
end

#=
Define which color will be considered as transparent...
=#
function setcolorkey(img_ptr::Ptr{SDL_Surface}, r, g, b; 
        _img = imgobject(img_ptr)
    )
    img_ptr == C_NULL && return nothing
    CallSDLFunction(SDL_SetColorKey, 
        img_ptr, SDL_TRUE, 
        SDL_MapRGB(_img.format, r, g, b)
    )
end

function setcolorkey(::Ptr{SDL_Texture}, _...)
    error("`setcolorkey` only works on `Ptr{SDL_Surface}`, see loadimage(onsetup::Function, path::String) docs...")
end

function imagesize(tex::Ptr{SDL_Texture})
    w_ref, h_ref = Ref{Cint}(0), Ref{Cint}(0)
    CallSDLFunction(
        SDL_QueryTexture, 
            tex, C_NULL, C_NULL, w_ref, h_ref
    )
    return w_ref[], h_ref[]
end

#=
This is an unified all funtion for images, a load/setup stuff.
It retursn a Ptr{SDL_Texture}
=#
function loadimage(onsetup::Function, path::String)::Ptr{SDL_Texture}
    # load
    sur_ptr = loadsurface(path)
    try
        # setup
        onsetup(sur_ptr)

        # convert to Texture
        text_ptr = CallSDLFunction(
            SDL_CreateTextureFromSurface, 
                renderer_ptr(), sur_ptr
        )

        # register texture finilizer
        onfinally!() do
            SDL_DestroyTexture(text_ptr)
        end

        return text_ptr

    finally
        # Free Surface
        SDL_FreeSurface(sur_ptr)
    end
end
loadimage(path::String)::Ptr{SDL_Texture} = loadimage(_do_nothing, path)

function drawimage(img_ptr::Ptr{SDL_Texture})

end

