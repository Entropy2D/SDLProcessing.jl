#=

* DO NOT DELETE
* p5js EXAMPLE CODE

 * Mouse Pressed.
 *
 * The mousePressed() function is called once every time a mouse button is pressed.
 *
 * In this example, we'll change the background color and display a message.

=#

using SDLProcessing
const P = SDLProcessing
import SimpleDirectMediaLayer
const SDL2 = SimpleDirectMediaLayer.LibSDL2

# --- State ---
current_bg_color = P.color(220)
message = "Click anywhere!"

P.onsetup() do
  P.create_window(640, 360)
  P.textFont(P.asset_path("Open_Sans", "OpenSans-VariableFont_wdth,wght.ttf"), 24)
  P.textAlign(P.H_CENTER, P.V_CENTER)
  P.textSize(20)
end

P.ondraw() do
  global current_bg_color, message
  P.background(current_bg_color)
  P.fill(P.color(0)) # Black text
  if current_bg_color.r + current_bg_color.g + current_bg_color.b < 382 # a bit of contrast
    P.fill(P.color(255))
  end
  P.text(message, P.SKETCH.width / 2, P.SKETCH.height / 2)
end

P.onEvent() do evt
  global current_bg_color, message
  if evt.type == SDL2.SDL_MOUSEBUTTONDOWN
    r = rand(0:255)
    g = rand(0:255)
    b = rand(0:255)
    current_bg_color = P.color(r, g, b)
    message = "Mouse Pressed at: ($(evt.button.x), $(evt.button.y))"
  end
end

P.run_sketch()
