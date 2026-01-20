# TODO: reproduce this

# // g++ main.cpp `pkg-config --cflags --libs sdl2`
# #include <SDL.h>
# #include <vector>

# int main( int argc, char** argv )
# {
#     SDL_Init( SDL_INIT_EVERYTHING );
#     SDL_Window* window = SDL_CreateWindow("SDL", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 800, 600, SDL_WINDOW_SHOWN );
#     SDL_Renderer* renderer = SDL_CreateRenderer( window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC );

#     const std::vector< SDL_Vertex > verts =
#     {
#         { SDL_FPoint{ 400, 150 }, SDL_Color{ 255, 0, 0, 255 }, SDL_FPoint{ 0 }, },
#         { SDL_FPoint{ 200, 450 }, SDL_Color{ 0, 0, 255, 255 }, SDL_FPoint{ 0 }, },
#         { SDL_FPoint{ 600, 450 }, SDL_Color{ 0, 255, 0, 255 }, SDL_FPoint{ 0 }, },
#     };

#     bool running = true;
#     while( running )
#     {
#         SDL_Event ev;
#         while( SDL_PollEvent( &ev ) )
#         {
#             if( ( SDL_QUIT == ev.type ) ||
#                 ( SDL_KEYDOWN == ev.type && SDL_SCANCODE_ESCAPE == ev.key.keysym.scancode ) )
#             {
#                 running = false;
#                 break;
#             }
#         }

#         SDL_SetRenderDrawColor( renderer, 0, 0, 0, SDL_ALPHA_OPAQUE );
#         SDL_RenderClear( renderer );
#         SDL_RenderGeometry( renderer, nullptr, verts.data(), verts.size(), nullptr, 0 );
#         SDL_RenderPresent( renderer );
#     }

#     SDL_DestroyRenderer( renderer );
#     SDL_DestroyWindow( window );
#     SDL_Quit();

#     return 0;
# }

@time begin
    using SDLProcessing
    using SimpleDirectMediaLayer
    using SimpleDirectMediaLayer.LibSDL2
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
let
    # struct SDL_Vertex
    #     position::SDL_FPoint
    #     color::SDL_Color
    #     tex_coord::SDL_FPoint
    # end
    
    
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_init() do
    winsize!(900, 900)
    wintitle!(basename(@__FILE__))
    framerate!(60)
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SIM_STATE = Dict()

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
onevent!() do evt
    # recenter
    if evt.type == SDL_MOUSEBUTTONDOWN
        if evt.button.button == SDL_BUTTON_LEFT
            println("SDL_BUTTON_LEFT")
        end

        if evt.button.button == SDL_BUTTON_RIGHT
            println("SDL_BUTTON_RIGHT")
        end

        if evt.button.button == SDL_BUTTON_MIDDLE
            println("SDL_BUTTON_MIDDLE")
        end
    end


end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_draw() do
    
    renderer = renderer_ptr()
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, SDL_ALPHA_OPAQUE);
    SDL_RenderClear(renderer);

    r = 100
    thetas = range(0, 2π; length = 10)
    w, h = winsize()
    verts = SDL_Vertex[
        SDL_Vertex(
            SDL_FPoint(
                round(Int, r * sin(theta) + w ÷ 2), 
                round(Int, r * cos(theta) + h ÷ 2)
            ), 
            SDL_Color(255,255,255,0), 
            SDL_FPoint(0,0)
        )
        for theta in thetas
    ]
    
    # @show _verts
    # @show collect(thetas)

    CallSDLFunction(SDL_RenderGeometry, 
        renderer, C_NULL, verts, length(verts), C_NULL, 0
    );
    
end
