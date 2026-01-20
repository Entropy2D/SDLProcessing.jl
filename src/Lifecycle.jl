# src/Lifecycle.jl

"""
    onsetup(f::Function)

Register a function to be run once at the start of the sketch.
Use with `do` block syntax.
"""
function onsetup(f::Function)
    SKETCH.USER_SETUP_FUNC = f
end

"""
    ondraw(f::Function)

Register a function to be run on every frame.
Use with `do` block syntax.
"""
function ondraw(f::Function)
    SKETCH.USER_DRAW_FUNC = f
end


"""
    create_window(w::Int, h::Int; title="SDLProcessing Sketch")

Creates the application window. This should be called from the `onsetup` block.
It initializes the SDL window and renderer and updates the global `SKETCH` object.
"""
function create_window(w::Int, h::Int; title="SDLProcessing Sketch")
    win = SDL2.SDL_CreateWindow(title, SDL2.SDL_WINDOWPOS_CENTERED, SDL2.SDL_WINDOWPOS_CENTERED, w, h, SDL2.SDL_WINDOW_SHOWN)
    @assert win != C_NULL "Failed to create window: $(unsafe_string(SDL2.SDL_GetError()))"

    ren = SDL2.SDL_CreateRenderer(win, -1, SDL2.SDL_RENDERER_ACCELERATED | SDL2.SDL_RENDERER_PRESENTVSYNC)
    @assert ren != C_NULL "Failed to create renderer: $(unsafe_string(SDL2.SDL_GetError()))"

    # After creation, update the SKETCH
    SKETCH.width = w
    SKETCH.height = h
    SKETCH._window = win
    SKETCH._renderer = ren
end


"""
    run_sketch()

This function starts and runs the sketch.
It should be the last call in the user's script.
"""
function run_sketch()
    # 1. Initialize SDL subsystems.
    @assert SDL2.SDL_Init(SDL2.SDL_INIT_EVERYTHING) == 0 "error initializing SDL: $(unsafe_string(SDL2.SDL_GetError()))"
    @assert TTF.TTF_Init() == 0 "error initializing TTF: $(unsafe_string(TTF.TTF_GetError()))"

    # 2. Run the user's setup function.
    SKETCH.USER_SETUP_FUNC()

    # 3. Main application loop.
    event = Ref{SDL2.SDL_Event}()
    while !SKETCH._should_quit
        # 3.1. Handle SDL events (e.g., check for window close).
        while Bool(SDL2.SDL_PollEvent(event))
            evt = event[]
            if evt.type == SDL2.SDL_QUIT
                SKETCH._should_quit = true
                break
            end
        end

        # 3.2. Increment frame count.
        SKETCH.frameCount += 1

        # 3.3. Call the user's draw function.
        SKETCH.USER_DRAW_FUNC()

        # 3.4. Present the renderer.
        SDL2.SDL_RenderPresent(SKETCH._renderer)

        # 3.5. Delay to cap framerate (optional, for later).
        SDL2.SDL_Delay(16) # Roughly 60 FPS
    end

    # 4. Cleanup SDL resources and quit.
    if SKETCH._font != C_NULL
        TTF.TTF_CloseFont(SKETCH._font)
    end
    TTF.TTF_Quit()
    SDL2.SDL_DestroyRenderer(SKETCH._renderer)
    SDL2.SDL_DestroyWindow(SKETCH._window)
    SDL2.SDL_Quit()
end
