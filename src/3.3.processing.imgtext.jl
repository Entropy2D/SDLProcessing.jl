# Arial
# SDL_STATE["IMG_TEXT_TEMPLATE_PATH"] = joinpath(@__DIR__, "..", "assets", "Arial.neg.png")
IMG_TEXT_SEP_W = 5
IMG_TEXT_MAX_LETTER_H = 107
IMG_TEXT_MAX_LETTER_W = 55

const IMG_TEXT_CMAP = Dict(
    # x, y, w, h
    '!' => Ref(SDL_Rect(72, 35, 19, 107)),
    '"' => Ref(SDL_Rect(115, 35, 34, 107)),
    '#' => Ref(SDL_Rect(156, 35, 54, 107)),
    '$' => Ref(SDL_Rect(210, 35, 46, 107)),
    '%' => Ref(SDL_Rect(258, 35, 52, 107)),
    '&' => Ref(SDL_Rect(309, 35, 53, 107)),
    '\'' => Ref(SDL_Rect(377, 35, 17, 107)),
    '(' => Ref(SDL_Rect(421, 35, 30, 107)),
    ')' => Ref(SDL_Rect(471, 35, 30, 107)),
    '*' => Ref(SDL_Rect(515, 35, 42, 107)),
    '+' => Ref(SDL_Rect(563, 35, 49, 107)),
    ',' => Ref(SDL_Rect(620, 35, 27, 107)),
    '-' => Ref(SDL_Rect(672, 35, 32, 107)),
    '.' => Ref(SDL_Rect(728, 35, 20, 107)),
    '/' => Ref(SDL_Rect(766, 35, 44, 107)),
    '0' => Ref(SDL_Rect(816, 35, 47, 107)),
    '1' => Ref(SDL_Rect(868, 35, 45, 107)),
    '2' => Ref(SDL_Rect(919, 35, 45, 107)),
    '3' => Ref(SDL_Rect(971, 35, 42, 107)),
    '4' => Ref(SDL_Rect(1015, 35, 52, 107)),
    '5' => Ref(SDL_Rect(1072, 35, 40, 107)),
    '6' => Ref(SDL_Rect(1120, 35, 45, 107)),
    '7' => Ref(SDL_Rect(1171, 35, 45, 107)),
    '8' => Ref(SDL_Rect(1222, 35, 43, 107)),
    '9' => Ref(SDL_Rect(1271, 35, 45, 107)),
    ':' => Ref(SDL_Rect(1334, 35, 20, 107)),
    ';' => Ref(SDL_Rect(1378, 35, 28, 107)),
    '<' => Ref(SDL_Rect(1424, 35, 41, 107)),
    '=' => Ref(SDL_Rect(1474, 35, 44, 107)),
    '>' => Ref(SDL_Rect(1528, 35, 40, 107)),
    '?' => Ref(SDL_Rect(1583, 35, 33, 107)),
    '@' => Ref(SDL_Rect(1620, 35, 53, 107)),
    'A' => Ref(SDL_Rect(1672, 35, 53, 107)),
    'B' => Ref(SDL_Rect(1727, 35, 44, 107)),
    'C' => Ref(SDL_Rect(1776, 35, 45, 107)),
    'D' => Ref(SDL_Rect(1827, 35, 46, 107)),
    'E' => Ref(SDL_Rect(1882, 35, 38, 107)),
    'F' => Ref(SDL_Rect(1932, 35, 38, 107)),
    'G' => Ref(SDL_Rect(1977, 35, 47, 107)),
    'H' => Ref(SDL_Rect(2029, 35, 45, 107)),
    'I' => Ref(SDL_Rect(2081, 35, 40, 107)),
    'J' => Ref(SDL_Rect(2133, 35, 36, 107)),
    'K' => Ref(SDL_Rect(2183, 35, 43, 107)),
    'L' => Ref(SDL_Rect(2236, 35, 39, 107)),
    'M' => Ref(SDL_Rect(2279, 35, 51, 107)),
    'N' => Ref(SDL_Rect(2332, 35, 45, 107)),
    'O' => Ref(SDL_Rect(2380, 35, 50, 107)),
    'P' => Ref(SDL_Rect(2435, 35, 43, 107)),
    'Q' => Ref(SDL_Rect(2482, 35, 52, 107)),
    'R' => Ref(SDL_Rect(2536, 35, 45, 107)),
    'S' => Ref(SDL_Rect(2584, 35, 45, 107)),
    'T' => Ref(SDL_Rect(2634, 35, 47, 107)),
    'U' => Ref(SDL_Rect(2686, 35, 45, 107)),
    'V' => Ref(SDL_Rect(2731, 35, 54, 107)),
    'W' => Ref(SDL_Rect(2784, 35, 51, 107)),
    'X' => Ref(SDL_Rect(2834, 35, 50, 107)),
    'Y' => Ref(SDL_Rect(2883, 35, 55, 107)),
    'Z' => Ref(SDL_Rect(2939, 35, 43, 107)),
    '[' => Ref(SDL_Rect(2998, 35, 28, 107)),
    '\\' => Ref(SDL_Rect(3041, 35, 43, 107)),
    ']' => Ref(SDL_Rect(3096, 35, 28, 107)),
    '^' => Ref(SDL_Rect(3141, 35, 43, 107)),
    '_' => Ref(SDL_Rect(3186, 35, 55, 107)),
    '`' => Ref(SDL_Rect(3244, 35, 27, 107)),
    'a' => Ref(SDL_Rect(3293, 35, 41, 107)),
    'b' => Ref(SDL_Rect(3344, 35, 43, 107)),
    'c' => Ref(SDL_Rect(3395, 35, 40, 107)),
    'd' => Ref(SDL_Rect(3443, 35, 42, 107)),
    'e' => Ref(SDL_Rect(3494, 35, 45, 107)),
    'f' => Ref(SDL_Rect(3542, 35, 48, 107)),
    'g' => Ref(SDL_Rect(3595, 35, 46, 107)),
    'h' => Ref(SDL_Rect(3647, 35, 41, 107)),
    'i' => Ref(SDL_Rect(3698, 35, 41, 107)),
    'j' => Ref(SDL_Rect(3747, 35, 37, 107)),
    'k' => Ref(SDL_Rect(3800, 35, 43, 107)),
    'l' => Ref(SDL_Rect(3850, 35, 40, 107)),
    'm' => Ref(SDL_Rect(3897, 35, 47, 107)),
    'n' => Ref(SDL_Rect(3950, 35, 41, 107)),
    'o' => Ref(SDL_Rect(3998, 35, 46, 107)),
    'p' => Ref(SDL_Rect(4051, 35, 43, 107)),
    'q' => Ref(SDL_Rect(4099, 35, 42, 107)),
    'r' => Ref(SDL_Rect(4154, 35, 41, 107)),
    's' => Ref(SDL_Rect(4204, 35, 39, 107)),
    't' => Ref(SDL_Rect(4249, 35, 45, 107)),
    'u' => Ref(SDL_Rect(4304, 35, 41, 107)),
    'v' => Ref(SDL_Rect(4351, 35, 46, 107)),
    'w' => Ref(SDL_Rect(4400, 35, 51, 107)),
    'x' => Ref(SDL_Rect(4451, 35, 49, 107)),
    'y' => Ref(SDL_Rect(4501, 35, 50, 107)),
    'z' => Ref(SDL_Rect(4556, 35, 41, 107)),
    '{' => Ref(SDL_Rect(4607, 35, 38, 107)),
    '|' => Ref(SDL_Rect(4670, 35, 14, 107)),
    '}' => Ref(SDL_Rect(4711, 35, 38, 107)),
    '~' => Ref(SDL_Rect(4754, 35, 49, 107)),
)

function drawimgtext(str::String, x0, y0, s; mono = true)
    isempty(str) && return
    
    temp = get!(SDL_STATE, "IMG_TEXT_TEMPLATE") do 
        path = joinpath(@__DIR__, "..", "assets", "Arial.neg.png")
        loadimage(path) do _pimg
            setcolorkey(_pimg, 0, 0, 0) # set transparency
        end
    end

    scale = s / IMG_TEXT_MAX_LETTER_H
    sep_w = round(Int, IMG_TEXT_SEP_W * scale)
    space_w = round(Int, IMG_TEXT_MAX_LETTER_W * scale) 
    tab_w = 3 * space_w
    char_h = round(Int, IMG_TEXT_MAX_LETTER_H * scale) 
    cursor_x = x0
    cursor_y = y0
    for c in str

        # special cases
        if c == ' '
            cursor_x += space_w + sep_w
            continue
        end

        if c == '\t'
            cursor_x += tab_w + sep_w
            continue
        end

        if c == '\n' 
            cursor_x = x0
            cursor_y += char_h + sep_w
            continue
        end

        # check cmap
        src_ref = get(IMG_TEXT_CMAP, c, IMG_TEXT_CMAP['?'])
        src = src_ref[]

        dst_w = round(Int, src.w * scale)
        dst_h = round(Int, src.h * scale)
        dst_ref = Ref(SDL_Rect(cursor_x, cursor_y, dst_w, dst_h))

        drawimage(temp, src_ref, dst_ref)
        cursor_x += mono ? space_w + sep_w : dst_w + sep_w
    end
end

drawimgtext(arg, args...; x, y, s, mono = true) =
    drawimgtext(string(arg, args...), x, y, s; mono)