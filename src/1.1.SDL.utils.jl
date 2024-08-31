_show_SDL_error() = @error("SDL ERROR:\n", unsafe_string(SDL_GetError()))

function _show_error_box(err)
    
    errmsg = string(
        "JULIA ERROR:\n", sprint(showerror, err, stacktrace()), "\n ",
        "SDL ERROR:\n", unsafe_string(SDL_GetError()), "\n",
    )
    
    @error "ERROR"
    println(errmsg)

    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, "ERROR", errmsg, C_NULL)
end