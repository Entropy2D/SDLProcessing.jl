#=
An interface for dealing with images...
The issue is how much of SDL we should hide...
A first idea is to work only on Textures and just have Surfaces as a transient state...
This will make images more or less inmutable after a setup step
=#

# .. -- .-- . .- -. - .--- .-. - . .... - -.- .- 
#=
A wrapper for image data
=#
struct PImage <: Wrapper
    data::Dict{String, Any}
end
PImage(pairs::Pair...) = PImage(Dict(pairs...))

#=
This is an unified all funtion for images, a load/setup stuff.
It retursn a Ptr{SDL_Texture}
=#
function loadimage(onsetup::Function, path::String)
    # load
    sur_ptr = _loadsurface(path)

    # img
    pimg = PImage("SUR.PTR" => sur_ptr)

    try
        # setup
        onsetup(pimg)

        # convert to Texture
        text_ptr = CallSDLFunction(
            SDL_CreateTextureFromSurface, 
                renderer_ptr(), sur_ptr
        )
        pimg["TEX.PTR"] = text_ptr
        pimg["TEX.SIZE"] = texturesize(text_ptr)

        # register texture finilizer
        onfinally!() do
            SDL_DestroyTexture(text_ptr)
        end

        return pimg

    finally
        # Free Surface
        SDL_FreeSurface(sur_ptr)
        pimg["SUR.PTR"] = nothing # invalid pointer
    end
end
loadimage(path::String) = loadimage(_do_nothing, path)

#=
Returns the texture Pointer pointer
=#
_imgtexptr(pimg::PImage)::Ptr{SDL_Texture} = pimg["TEX.PTR"]

function _drawimage(pimg::PImage, src_rect, dst_rect)
    CallSDLFunction(SDL_RenderCopy, 
        renderer_ptr(), _imgtexptr(pimg), src_rect, dst_rect
    )
end
function drawimage(pimg::PImage, src_rect::Ref{SDL_Rect}, dst_rect::Ref{SDL_Rect})
    _drawimage(pimg, src_rect, dst_rect)
end

function drawimage(pimg::PImage, src_rect::SDL_Rect, dst_rect::SDL_Rect)
    _drawimage(pimg, Ref(src_rect), Ref(dst_rect))
end

function drawimage(pimg::PImage, 
        src_x, src_y, src_w, src_h, # source rectangle
        dst_x, dst_y, dst_w, dst_h; # destination rectangle
    )
    drawimage(pimg, 
        SDL_Rect(src_x, src_y, src_w, src_h), 
        SDL_Rect(dst_x, dst_y, dst_w, dst_h)
    )
end

function drawimage(pimg::PImage, 
        dst_x, dst_y, dst_w, dst_h; # destination rectangle
    )
    _drawimage(pimg, 
        C_NULL, 
        Ref(SDL_Rect(dst_x, dst_y, dst_w, dst_h))
    )
end

function drawimage(pimg::PImage, 
        dst_x, dst_y; # destination rectangle
    )
    dst_w, dst_h = size(pimg)
    drawimage(pimg, dst_x, dst_y, dst_w, dst_h)
end

# .. -- .-- . .- -. - .--- .-. - . .... - -.- .- 
# Image Control

function imagecolor!(pimg::PImage, r, g, b)
    CallSDLFunction(SDL_SetTextureColorMod, 
        _imgtexptr(pimg), r, g, b
    )
end
function imagealpha!(pimg::PImage, a)
    CallSDLFunction(SDL_SetTextureAlphaMod, 
        _imgtexptr(pimg), r, g, b
    )
end

import Base.size
function Base.size(pimg::PImage)::Tuple{Int, Int}
    return pimg["TEX.SIZE"]
end


function setcolorkey(pimg::PImage, r, g, b; 
        _surobj = nothing
    )
    # Get Surface
    sur_ptr = get!(pimg, "SUR.PTR", nothing)
    isnothing(sur_ptr) && error(
        "SUR.PTR == nothing. `setcolorkey` can only be called during img load. See loadimage(onsetup::Function, path::String)"
    )

    # get obj from pointer
    if isnothing(_surobj)
        _surobj = _surfaceobj(sur_ptr)
    end

    # set color key
    CallSDLFunction(SDL_SetColorKey, 
        sur_ptr, SDL_TRUE, 
        SDL_MapRGB(_surobj.format, r, g, b)
    )

    return pimg
end

# .. -- .-- . .- -. - .--- .-. - . .... - -.- .- 
#=
Load image/Surface pointer
=#
function _loadsurface(path::AbstractString)
    return CallSDLFunction(IMG_Load, path)
end

#=
get the struct from the pointer
=#
function _surfaceobj(sur_ptr::Ptr{SDL_Surface})
    sur_ptr == C_NULL && return nothing
    return unsafe_load(sur_ptr)
end

#=
Define which color will be considered as transparent...
=#
function _setcolorkey(sur_ptr::Ptr{SDL_Surface}, r, g, b; 
        _img = _surfaceobj(sur_ptr)
    )
    sur_ptr == C_NULL && return nothing
    CallSDLFunction(SDL_SetColorKey, 
        sur_ptr, SDL_TRUE, 
        SDL_MapRGB(_img.format, r, g, b)
    )
end

function texturesize(tex::Ptr{SDL_Texture})
    w_ref, h_ref = Ref{Cint}(0), Ref{Cint}(0)
    CallSDLFunction(
        SDL_QueryTexture, 
            tex, C_NULL, C_NULL, w_ref, h_ref
    )
    return w_ref[], h_ref[]
end
