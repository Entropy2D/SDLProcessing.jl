# src/State.jl

# A simple struct for RGBA color
struct Color
    r::UInt8
    g::UInt8
    b::UInt8
    a::UInt8
end

mutable struct SketchState
    # --- Public, read-only properties for the user ---
    width::Int
    height::Int
    frameCount::Int
    mouseWheelY::Int

    # --- Internal library properties (prefixed with _) ---
    _window::Ptr{Nothing}
    _renderer::Ptr{Nothing}
    _should_quit::Bool

    # --- Internal style properties ---
    _use_fill::Bool
    _fill_color::Color
    _use_stroke::Bool
    _stroke_color::Color
    _stroke_weight::Int

    # --- Frame rate properties ---
    _frame_times_ns::CircularBuffer{Float64}

    # --- Typography properties ---
    _font::Ptr{Cvoid}
    _font_path::String
    _font_size::Int
    _text_color::Color

    # --- User-defined function hooks ---
    USER_SETUP_FUNC::Function
    USER_DRAW_FUNC::Function 
end

# Default constructor
function SketchState()

    _frame_times_ns = CircularBuffer{Float64}(100)
    for _ in 1:capacity(_frame_times_ns)
        push!(_frame_times_ns, 0.0)
    end

    return SketchState(
        0, 0, 0, 0, # width, height, frameCount, mouseWheelY
        C_NULL, C_NULL, false, # _window, _renderer, _should_quit
        true, Color(255, 255, 255, 255), # _use_fill, _fill_color
        true, Color(0, 0, 0, 255), 1, # _use_stroke, _stroke_color, _stroke_weight
        _frame_times_ns, # _frame_times_ns
        C_NULL, "", 12, Color(0, 0, 0, 255), # _font, _font_path, _font_size, _text_color
        () -> (), () -> ()  # USER_SETUP_FUNC, USER_DRAW_FUNC
    )
end

# The global state object.
# It is a `const` so it cannot be reassigned, but its fields can be mutated.
const SKETCH = SketchState()
