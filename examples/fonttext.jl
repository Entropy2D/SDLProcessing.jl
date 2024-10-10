@time begin
    using SDLProcessing
    using SimpleDirectMediaLayer
    using SimpleDirectMediaLayer.LibSDL2
    using Base.Threads
    using DataStructures
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# Pre init config
onconfig!() do
   
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_init() do
    winsize!(1300, 900)
    wintitle!(basename(@__FILE__))
    framerate!(60)

    filename = "/Users/Pereiro/.julia/dev/Gloria/examples/Asteroids/assets/NotoSans-Black.ttf"
    fontsize = 14
    text = "Hello"
    font_ptr = TTF_OpenFont(filename, fontsize)
    sdl_surface = TTF_RenderText_Blended(font_ptr, text, SDL_Color(255, 255, 255, 255))
    @show font_ptr
    @show sdl_surface
    # @show getfields(font)
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# # events
# onevent!() do evt
#     # recenter
#     if evt.type == SDL_MOUSEBUTTONDOWN
        
#         if evt.button.button == SDL_BUTTON_LEFT
#             return
#         end

#         if evt.button.button == SDL_BUTTON_RIGHT
#             return
#         end
        
#         if evt.button.button == SDL_BUTTON_MIDDLE
#             return
#         end
#     end # SDL_MOUSEBUTTONDOWN

#     if evt.type == SDL_MOUSEWHEEL
#         _, wheel_d = mousewheel(evt)
#         return
#     end # SDL_MOUSEWHEEL
# end


# ## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# oninfo!() do 
#     # particles = SIM_STATE["PARTICLES"]
#     # println("particles.num: ", length(particles))
# end

# ## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# SDL_draw() do

# end