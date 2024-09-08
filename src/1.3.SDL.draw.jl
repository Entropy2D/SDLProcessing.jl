# --.-- -.- .- -. -.-.- -.-.- .-.-
# loop
function SDL_draw(ondraw::Function = _do_nothing)

    @info "SDL_draw"

    get!(SDL_STATE, "INIT.CALLED.FLAG", false) || error("You must call `SDL_init` first...")

    SDL_win = window_ptr()
    SDL_renderer = renderer_ptr()
    SDL_event_ref = event_ref()
    fsor = SDL_STATE.frequensor
    
    SDL_loop_count = 0
    
    # loop
    try
        for taskfun in UPTHREAD_CALLBACKS
            @spawn while isrunning()
                taskfun()
            end
        end

        # draw loop
        while isrunning()

            # event
            while Bool(CallSDLFunction(SDL_PollEvent, SDL_event_ref))
                evt = SDL_event_ref[]
                for _onevent in ONEVENT_CALLBACKS
                    ret = _onevent(evt) 
                    ret === :break && break
                end
            end
            
            # direct callback 
            ondraw()

            # registered callbacks
            for _ondraw in ONDRAW_CALLBACKS
                _ondraw()
            end

            # TODO: Underestand
            get!(SDL_STATE, "SDL_RENDER_PRESENT_ENABLE", true) && 
                SDL_RenderPresent(SDL_renderer)

            # update loop counter
            SDL_loop_count += 1
            SDL_STATE["STATS.LOOP_COUNT"] = SDL_loop_count

            # control framerate
            SDL_forcefrec!("DRAW.LOOP", framerate())
            
        end # while running

    catch err
        # TODO: fix tis so the stacks are better
        # err isa InterruptException || _showerror(err; showbox = true, showterminal = true)

        err isa InterruptException || rethrow(err)
    finally
        
        for _onfinally in ONFINALLY_CALLBACKS
            try; _onfinally();
                catch err ignored; 
                _showerror(ignored; showbox = false, showterminal = true)
            end
        end

        SDL_DestroyRenderer(SDL_renderer)
        SDL_DestroyWindow(SDL_win)
        SDL_Quit()
    end
end

# --.-- -.- .- -. -.-.- -.-.- .-.-
# Utils
# function _draw_loop_delay(_msd_fr = msd_framerate())
#     get!(SDL_STATE, "SDL_DELAY_ENABLE", true) || return
#     _target_fr = get!(SDL_STATE, "SDL_FRAME_RATE", 60)
#     _curr_delay = get!(SDL_STATE, "SDL_LOOP_DELAY", round(Int, 1000 / _target_fr))
#     _curr_delay += _target_fr > _msd_fr ? -1 : 1
#     if _curr_delay > 0 
#         SDL_STATE["SDL_LOOP_DELAY"] = _curr_delay
#         SDL_Delay(_curr_delay)
#     else
#         SDL_STATE["SDL_LOOP_DELAY"] = 0
#     end
# end

# function _msd_framerate_tic()
#     _now = time()
#     _tic = get!(SDL_STATE, "MEASSURED.FRAMERATE.TIC", -1.0)
#     _msd_framerate = -1.0
#     if _tic != -1.0
#         _msd_framerate = 1/(_now - _tic)
#         push!(_MSD_FRAMERATE_DUFFER, _msd_framerate)
#     end
#     SDL_STATE["MEASSURED.FRAMERATE.TIC"] = _now
#     return _msd_framerate
# end

# const _MSD_FRAMERATE_DUFFER = CircularBuffer{Float64}(30)
# function _msd_fr_tic!()
#     t = SDL_STATE.ticker
#     return tic!(t, "MSD.FR") do elp
#         isnan(elp) && return 0.0
#         push!(_MSD_FRAMERATE_DUFFER, inv(elp))
#         return elp
#     end
# end