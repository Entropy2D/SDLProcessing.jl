using SDLProcessing
const P = SDLProcessing

P.onsetup() do
  P.create_window(640, 360)
  P.noFill()
  P.stroke(P.color(51))
end

P.ondraw() do
  P.background(P.color(51))

  P.stroke(P.color(204))
  for i in 0:4:P.SKETCH.width-20
    # The 30 is added to 70 and then evaluated
    # if it is greater than the current value of "i"
    # For clarity, write as "if (i > (30 + 70)) {"
    if i > 30 + 70
      P.line(i, 0, i, 50)
    end
  end

  P.stroke(P.color(255))
  # The 2 is multiplied by the 8 and the result is added to the 4
  # For clarity, write as "rect(5 + (2 * 8), 0, 90, 20);"
  P.rect(4 + 2 * 8, 52, 290, 48)
  P.rect((4 + 2) * 8, 100, 290, 49)
    
  P.stroke(P.color(153))
  for i in 0:2:P.SKETCH.width
    # The relational statements are evaluated 
    # first, and then the logical AND statements and 
    # finally the logical OR. For clarity, write as:
    # "if(((i > 20) && (i < 50)) || ((i > 100) && (i < P.SKETCH.width-20))) {"
    if i > 20 && i < 50 || i > 100 && i < P.SKETCH.width-20
      P.line(i, 151, i, P.SKETCH.height-1)
    end 
  end
end

P.run_sketch()
