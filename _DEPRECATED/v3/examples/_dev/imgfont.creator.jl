@time begin
    using SDLProcessing
    using SimpleDirectMediaLayer
    using SimpleDirectMediaLayer.LibSDL2
    using Base.Threads
    using DataStructures
    using InteractiveUtils
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SIM_STATE = Dict()

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# Pre init config
onconfig!() do
    winsize!(1300, 900)
    wintitle!(basename(@__FILE__))
    framerate!(60)
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_init() do
    
    # Load/Prepare textures
    path = joinpath(@__DIR__, "Arial.neg.png")
    SIM_STATE["TEXT.TEMPLATE"] = loadimage(path) do _pimg
        setcolorkey(_pimg, 0, 0, 0) # set transparency
    end 
    
    CHAR_H = 101
    CHAR_W = 50
    MARGIN_TOP = 57
    MARGIN_LEFT = 34

    # MARGINS: [rect_lm, rect_tm]
    # RECT: [rect_x, rect_y, rect_w, rect_h]
    # MARGINS: 157, 34
    # RECT:    257, 134, 53, 101
    SIM_STATE["TEXT.MAP"] = [
        # Chars
        '!' => (;lm = 72, tm = 35, w = 19, h = 107, ),
        '"' => (;lm = 115, tm = 35, w = 34, h = 107, ),
        '#' => (;lm = 156, tm = 35, w = 54, h = 107, ),
        '$' => (;lm = 210, tm = 35, w = 46, h = 107, ),
        '%' => (;lm = 258, tm = 35, w = 52, h = 107, ),
        '&' => (;lm = 309, tm = 35, w = 53, h = 107, ),
        '\'' => (;lm = 377, tm = 35, w = 17, h = 107, ),
        '(' => (;lm = 421, tm = 35, w = 30, h = 107, ),
        ')' => (;lm = 471, tm = 35, w = 30, h = 107, ),
        '*' => (;lm = 515, tm = 35, w = 42, h = 107, ),
        '+' => (;lm = 563, tm = 35, w = 49, h = 107, ),
        ',' => (;lm = 620, tm = 35, w = 27, h = 107, ),
        '-' => (;lm = 672, tm = 35, w = 32, h = 107, ),
        '.' => (;lm = 728, tm = 35, w = 20, h = 107, ),
        '/' => (;lm = 766, tm = 35, w = 44, h = 107, ),
        '0' => (;lm = 816, tm = 35, w = 47, h = 107, ),
        '1' => (;lm = 868, tm = 35, w = 45, h = 107, ),
        '2' => (;lm = 919, tm = 35, w = 45, h = 107, ),
        '3' => (;lm = 971, tm = 35, w = 42, h = 107, ),
        '4' => (;lm = 1015, tm = 35, w = 52, h = 107, ),
        '5' => (;lm = 1072, tm = 35, w = 40, h = 107, ),
        '6' => (;lm = 1120, tm = 35, w = 45, h = 107, ),
        '7' => (;lm = 1171, tm = 35, w = 45, h = 107, ),
        '8' => (;lm = 1222, tm = 35, w = 43, h = 107, ),
        '9' => (;lm = 1271, tm = 35, w = 45, h = 107, ),
        ':' => (;lm = 1334, tm = 35, w = 20, h = 107, ),
        ';' => (;lm = 1378, tm = 35, w = 28, h = 107, ),
        '<' => (;lm = 1424, tm = 35, w = 41, h = 107, ),
        '=' => (;lm = 1474, tm = 35, w = 44, h = 107, ),
        '>' => (;lm = 1528, tm = 35, w = 40, h = 107, ),
        '?' => (;lm = 1583, tm = 35, w = 33, h = 107, ),
        '@' => (;lm = 1620, tm = 35, w = 53, h = 107, ),
        'A' => (;lm = 1672, tm = 35, w = 53, h = 107, ),
        'B' => (;lm = 1727, tm = 35, w = 44, h = 107, ),
        'C' => (;lm = 1776, tm = 35, w = 45, h = 107, ),
        'D' => (;lm = 1827, tm = 35, w = 46, h = 107, ),
        'E' => (;lm = 1882, tm = 35, w = 38, h = 107, ),
        'F' => (;lm = 1932, tm = 35, w = 38, h = 107, ),
        'G' => (;lm = 1977, tm = 35, w = 47, h = 107, ),
        'H' => (;lm = 2029, tm = 35, w = 45, h = 107, ),
        'I' => (;lm = 2081, tm = 35, w = 40, h = 107, ),
        'J' => (;lm = 2133, tm = 35, w = 36, h = 107, ),
        'K' => (;lm = 2183, tm = 35, w = 43, h = 107, ),
        'L' => (;lm = 2236, tm = 35, w = 39, h = 107, ),
        'M' => (;lm = 2279, tm = 35, w = 51, h = 107, ),
        'N' => (;lm = 2332, tm = 35, w = 45, h = 107, ),
        'O' => (;lm = 2380, tm = 35, w = 50, h = 107, ),
        'P' => (;lm = 2435, tm = 35, w = 43, h = 107, ),
        'Q' => (;lm = 2482, tm = 35, w = 52, h = 107, ),
        'R' => (;lm = 2536, tm = 35, w = 45, h = 107, ),
        'S' => (;lm = 2584, tm = 35, w = 45, h = 107, ),
        'T' => (;lm = 2634, tm = 35, w = 47, h = 107, ),
        'U' => (;lm = 2686, tm = 35, w = 45, h = 107, ),
        'V' => (;lm = 2731, tm = 35, w = 54, h = 107, ),
        'W' => (;lm = 2784, tm = 35, w = 51, h = 107, ),
        'X' => (;lm = 2834, tm = 35, w = 50, h = 107, ),
        'Y' => (;lm = 2883, tm = 35, w = 55, h = 107, ),
        'Z' => (;lm = 2939, tm = 35, w = 43, h = 107, ),
        '[' => (;lm = 2998, tm = 35, w = 28, h = 107, ),
        '\\' => (;lm = 3041, tm = 35, w = 43, h = 107, ),
        ']' => (;lm = 3096, tm = 35, w = 28, h = 107, ),
        '^' => (;lm = 3141, tm = 35, w = 43, h = 107, ),
        '_' => (;lm = 3186, tm = 35, w = 55, h = 107, ),
        '`' => (;lm = 3244, tm = 35, w = 27, h = 107, ),
        'a' => (;lm = 3293, tm = 35, w = 41, h = 107, ),
        'b' => (;lm = 3344, tm = 35, w = 43, h = 107, ),
        'c' => (;lm = 3395, tm = 35, w = 40, h = 107, ),
        'd' => (;lm = 3443, tm = 35, w = 42, h = 107, ),
        'e' => (;lm = 3494, tm = 35, w = 45, h = 107, ),
        'f' => (;lm = 3542, tm = 35, w = 48, h = 107, ),
        'g' => (;lm = 3595, tm = 35, w = 46, h = 107, ),
        'h' => (;lm = 3647, tm = 35, w = 41, h = 107, ),
        'i' => (;lm = 3698, tm = 35, w = 41, h = 107, ),
        'j' => (;lm = 3747, tm = 35, w = 37, h = 107, ),
        'k' => (;lm = 3800, tm = 35, w = 43, h = 107, ),
        'l' => (;lm = 3850, tm = 35, w = 40, h = 107, ),
        'm' => (;lm = 3897, tm = 35, w = 47, h = 107, ),
        'n' => (;lm = 3950, tm = 35, w = 41, h = 107, ),
        'o' => (;lm = 3998, tm = 35, w = 46, h = 107, ),
        'p' => (;lm = 4051, tm = 35, w = 43, h = 107, ),
        'q' => (;lm = 4099, tm = 35, w = 42, h = 107, ),
        'r' => (;lm = 4154, tm = 35, w = 41, h = 107, ),
        's' => (;lm = 4204, tm = 35, w = 39, h = 107, ),
        't' => (;lm = 4249, tm = 35, w = 45, h = 107, ),
        'u' => (;lm = 4304, tm = 35, w = 41, h = 107, ),
        'v' => (;lm = 4351, tm = 35, w = 46, h = 107, ),
        'w' => (;lm = 4400, tm = 35, w = 51, h = 107, ),
        'x' => (;lm = 4451, tm = 35, w = 49, h = 107, ),
        'y' => (;lm = 4501, tm = 35, w = 50, h = 107, ),
        'z' => (;lm = 4556, tm = 35, w = 41, h = 107, ),
        '{' => (;lm = 4607, tm = 35, w = 38, h = 107, ),
        '|' => (;lm = 4670, tm = 35, w = 14, h = 107, ),
        '}' => (;lm = 4711, tm = 35, w = 38, h = 107, ),
        '~' => (;lm = 4754, tm = 35, w = 49, h = 107, ),
    ]

    SIM_STATE["TICKER"] = Frequensor()
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
# events
onevent!() do evt
    # recenter
    if evt.type == SDL_MOUSEBUTTONDOWN
        
        if evt.button.button == SDL_BUTTON_LEFT
            # println("SDL_BUTTON_LEFT")
            return
        end

        if evt.button.button == SDL_BUTTON_RIGHT
            # println("SDL_BUTTON_RIGHT")
            return
        end
        
    end # SDL_MOUSEBUTTONDOWN

    if evt.type == SDL_MOUSEWHEEL
        get!(SIM_STATE, "temp_x", 0)
        _, wheel_d = mousewheel(evt)
        SIM_STATE["temp_x"] += round(Int, 10 * wheel_d)
    end # SDL_MOUSEWHEEL

    # print info
    if evt.type == SDL_KEYDOWN

        scan_code = evt.key.keysym.scancode

        if scan_code == SDL_SCANCODE_M
            s = get!(SIM_STATE, "margin.step", -1)
            SIM_STATE["margin.step"] *= -1
        end

        if scan_code == SDL_SCANCODE_W
            s = get!(SIM_STATE, "margin.step", 1)
            get!(SIM_STATE, "rect_tm", 0) # TOCONTROL
            SIM_STATE["rect_tm"] += s
            return
        end

        # rect_h
        if scan_code == SDL_SCANCODE_S
            s = get!(SIM_STATE, "margin.step", 1)
            get!(SIM_STATE, "rect_h", 0) # TOCONTROL
            SIM_STATE["rect_h"] += s
            return
        end

        if scan_code == SDL_SCANCODE_A
            s = get!(SIM_STATE, "margin.step", 1)
            get!(SIM_STATE, "rect_lm", 0) # TOCONTROL
            SIM_STATE["rect_lm"] += s
            return
        end

        if scan_code == SDL_SCANCODE_V
            c = get!(SIM_STATE, "SHOW.CHARS", false)
            SIM_STATE["SHOW.CHARS"] = !c
            return
        end

        # rect_w
        if scan_code == SDL_SCANCODE_D
            s = get!(SIM_STATE, "margin.step", 1)
            get!(SIM_STATE, "rect_w", 0) # TOCONTROL
            SIM_STATE["rect_w"] += s
            return
        end

        if scan_code == SDL_SCANCODE_X
            s = get!(SIM_STATE, "margin.step", 1)
            get!(SIM_STATE, "temp_x", 0) # TOCONTROL
            SIM_STATE["temp_x"] += s * 10
            return
        end

        # copy
        if scan_code == SDL_SCANCODE_R
            tmap = SIM_STATE["TEXT.MAP"]
            _, m0 = last(tmap)

            SIM_STATE["rect_tm"] = m0.tm
            SIM_STATE["rect_h"] = m0.h
            SIM_STATE["rect_lm"] = m0.lm
            SIM_STATE["rect_w"] = m0.w
            SIM_STATE["margin.step"] = 1
            return
        end

        # reset
        if scan_code == SDL_SCANCODE_C
            tmap = SIM_STATE["TEXT.MAP"]
            _, m0 = last(tmap)
            clipboard("""
                'X' => (;lm = $(SIM_STATE["rect_lm"]), tm = $(SIM_STATE["rect_tm"]), w = $(SIM_STATE["rect_w"]), h = $(SIM_STATE["rect_h"]), ),
            """)
            return
        end
        
        return
    end # SDL_KEYDOWN

end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
oninfo!() do 
    
end

## .-- .- .--- .- .--- .- .- .-. -.- .-----.-.-. .----.
SDL_draw() do

    # variables
    tic = SIM_STATE["TICKER"]
    nchars = 94 # MEASSURED
    temp = SIM_STATE["TEXT.TEMPLATE"]::PImage
    tmap = SIM_STATE["TEXT.MAP"]
    # tchars = SIM_STATE["TEXT.CHARS"]
    win_w, win_h = winsize()
    temp_w, temp_h = size(temp)
    temp_x = get!(SIM_STATE, "temp_x", 10)
    temp_y = get!(SIM_STATE, "temp_y", 10)
    
    # draw all
    drawcolor!(0, 0, 0)
    drawbackground!()
    # imagecolor!(temp, 255, 255, 255)
    drawimage(temp, temp_x, temp_y, temp_w, temp_h)
    
    # guide
    _, m0 = last(tmap)
    rect_tm = get!(SIM_STATE, "rect_tm", m0.tm) # TOCONTROL
    rect_lm = get!(SIM_STATE, "rect_lm", m0.lm) # TOCONTROL
    rect_x, rect_y = temp_x + rect_lm, temp_y + rect_tm
    rect_w = get!(SIM_STATE, "rect_w", m0.w)
    rect_h = get!(SIM_STATE, "rect_h", m0.h)
    drawcolor!(200, 200, 200, 200)
    rect = Ref(SDL_Rect(rect_x, rect_y, rect_w, rect_h))
    drawrect(rect)

    # Chars
    if get!(SIM_STATE, "SHOW.CHARS", false)
        for (c, m) in tmap
            # (;h = CHAR_H, w = CHAR_W, tm = MARGIN_TOP, lm = MARGIN_LEFT),
            rect = Ref(SDL_Rect(
                temp_x + m.lm, temp_y + m.tm, 
                m.w, m.h
            ))
            drawrect(rect)
        end
    end
    
    onelapsed!(tic, "INFO", 0.5) do _
        println("MARGINS: ", join([rect_lm, rect_tm], ", "))
        println("RECT:    ", join([rect_x, rect_y, rect_w, rect_h], ", "))
    end

end