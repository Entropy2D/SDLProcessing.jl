# examples/random-walkers-2.jl
using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))
import SDLProcessing
const P = SDLProcessing
import SimpleDirectMediaLayer
const SDL2 = SimpleDirectMediaLayer.LibSDL2
using SparseArrays
using Random

## --- Agent Objects ---
mutable struct Walker
    x::Float64
    y::Float64
end

struct Quine
    x::Float64
    y::Float64
end

# Create a global list of walkers and quines
walkers = Walker[]
quines = Quine[]
quine_positions = spzeros(Bool, 0, 0)
good_power = 1000
temperature = 1.0


# --- Interaction Traces ---
const MAX_TRACES = 10_000
interaction_traces = []
hist_x = Int[]
hist_y = Int[]



## --- Utils ---
function rand_position()
    return (rand() * P.SKETCH.width, rand() * P.SKETCH.height)
end

## --- Sketch Definition ---

P.onsetup() do
    P.create_window(800, 600; title="Random Walkers")

    # Initialize 100 walkers at random positions
    for _ in 1:100
        push!(walkers, Walker(rand_position()...))
    end

    # Initialize quine tracking matrix
    global quine_positions = spzeros(Bool, P.SKETCH.width, P.SKETCH.height)

    # Initialize histogram arrays
    global hist_x = zeros(Int, P.SKETCH.width)
    global hist_y = zeros(Int, P.SKETCH.height)

    P.textFont(joinpath(@__DIR__, "..", "assets", "Open_Sans", "OpenSans-VariableFont_wdth,wght.ttf"), 24)
end

P.ondraw() do
    global good_power, temperature, hist_x, hist_y
    # --- Handle Mouse Wheel ---
    if P.SKETCH.mouseWheelY > 0
        # good_power += floor(Int, good_power * 0.1) + 1
        temperature += 1.0
    elseif P.SKETCH.mouseWheelY < 0
        # good_power -= floor(Int, good_power * 0.1) + 1
        # good_power = max(1, good_power)
        temperature -= 1.0
        temperature = max(1, temperature)
    end

    P.background(P.color(0, 0, 0)) # Black background

    # --- Draw Interaction Traces ---
    P.strokeWeight(1)
    current_traces_len = length(interaction_traces)
    for (idx, trace) in enumerate(interaction_traces)
        if current_traces_len == 0
            alpha = 0
        elseif current_traces_len == 1
            alpha = 255
        else
            # Linear map: idx=1 -> alpha=255, idx=current_traces_len -> alpha=0
            alpha = round(Int, 255 * (current_traces_len - idx) / (current_traces_len - 1))
        end
        P.stroke(P.color(80, 80, 80, UInt8(alpha)))
        P.line(trace[1][1], trace[1][2], trace[2][1], trace[2][2])
    end
    P.noStroke() # Reset stroke


    # --- Handle Mouse Input ---
    x, y = Ref{Cint}(0), Ref{Cint}(0)
    mouse_state = SDL2.SDL_GetMouseState(x, y)

    # Left-click adds walkers
    if (mouse_state & SDL2.SDL_BUTTON(SDL2.SDL_BUTTON_LEFT)) != 0
        # Add 1% of current walkers per frame
        num_new_walkers = ceil(Int, 0.01 * length(walkers))
        if num_new_walkers == 0
            num_new_walkers = 1
        end

        for _ in 1:num_new_walkers
            push!(walkers, Walker(Float64(x[]), Float64(y[])))
        end
    end

    # Right-click adds quines
    if (mouse_state & SDL2.SDL_BUTTON(SDL2.SDL_BUTTON_RIGHT)) != 0
        mx, my = Int(x[]), Int(y[])
        # Add quine only if position is not occupied
        if 1 <= mx <= P.SKETCH.width && 1 <= my <= P.SKETCH.height && !quine_positions[mx, my]
            push!(quines, Quine(Float64(mx), Float64(my)))
            quine_positions[mx, my] = true
        end
    end

    # Middle-click teleports a walker
    if (mouse_state & SDL2.SDL_BUTTON(SDL2.SDL_BUTTON_MIDDLE)) != 0
        if !isempty(walkers)
            for i in 1:good_power
                target_walker = rand(walkers)
                target_walker.x = Float64(x[])
                target_walker.y = Float64(y[])
            end
        end
    end

    # --- Reset and Populate Histograms ---
    fill!(hist_x, 0)
    fill!(hist_y, 0)

    # --- Update and Draw Walkers ---
    P.fill(P.color(128, 128, 128)) # Gray color for walkers
    P.noStroke()

    shuffle!(walkers) # Randomize walker update order
    for walker in walkers
        # Move walker
        walker.x += (rand() - 0.5) * 2 * temperature
        walker.y += (rand() - 0.5) * 2 * temperature

        # Periodic boundaries
        if walker.x > P.SKETCH.width
            walker.x = 0
        elseif walker.x < 0
            walker.x = P.SKETCH.width
        end

        if walker.y > P.SKETCH.height
            walker.y = 0
        elseif walker.y < 0
            walker.y = P.SKETCH.height
        end

        # Populate histograms
        ix = clamp(round(Int, walker.x), 1, P.SKETCH.width)
        iy = clamp(round(Int, walker.y), 1, P.SKETCH.height)
        hist_x[ix] += 1
        hist_y[iy] += 1

        # --- Walker-Quine Interaction ---
        wx, wy = round(Int, walker.x), round(Int, walker.y)
        if 1 <= wx <= P.SKETCH.width && 1 <= wy <= P.SKETCH.height && quine_positions[wx, wy]
            # A quine was hit
            if !isempty(walkers)
                # Select a random walker
                target_walker = rand(walkers)

                # --- Record Interaction Trace ---
                hitter_pos = (walker.x, walker.y)
                teleported_pos_before = (target_walker.x, target_walker.y)
                trace = (hitter_pos, teleported_pos_before)
                pushfirst!(interaction_traces, trace)
                if length(interaction_traces) > MAX_TRACES
                    pop!(interaction_traces)
                end

                # Relocate it around the hit quine's position (wx, wy)
                angle = rand() * 2 * pi
                radius = rand() * 5 # 10px diameter -> 5px radius
                target_walker.x = wx + radius * cos(angle)
                target_walker.y = wy + radius * sin(angle)
            end
        end

        # Draw walker as a pixel
        P.rect(round(Int, walker.x), round(Int, walker.y), 1, 1)
    end

    # --- Draw Quines ---
    P.fill(P.color(0, 0, 255)) # Blue for quines
    for quine in quines
        P.rect(quine.x, quine.y, 1, 1)
    end

    # --- Draw Histograms ---
    P.fill(P.color(255, 255, 255, 100)) # Semi-transparent white for histograms
    P.noStroke()

    # X-axis histogram (bottom)
    max_x = maximum(hist_x)
    if max_x > 0
        for i in 1:P.SKETCH.width
            bar_height = (hist_x[i] / max_x) * 20
            P.rect(i, P.SKETCH.height - bar_height, 1, bar_height)
        end
    end

    # Y-axis histogram (right)
    max_y = maximum(hist_y)
    if max_y > 0
        for i in 1:P.SKETCH.height
            bar_width = (hist_y[i] / max_y) * 20
            P.rect(P.SKETCH.width - bar_width, i, bar_width, 1)
        end
    end


    # --- Display Agent Counts ---
    P.fill(P.color(190, 190, 190)) # Gray text
    P.text("frameRate: $(round(Int, P.frameRate()))", 10, 10)
    P.text("Walkers: $(length(walkers))", 10, 40)
    P.text("Quines: $(length(quines))", 10, 70)
    P.text("Good Power: $(good_power)", 10, 100)
    P.text("Temperature: $(temperature)", 10, 130)
end

## --- Run the Sketch ---
P.run_sketch()
