# src/Statistics.jl
using Statistics

function isFrameRateDataReady()
    return SKETCH.frameCount >= capacity(SKETCH._frame_times_ns)
end

# MARK: DataFrame Stats
function _foreach_dt_ns(f::Function)
    i0 = firstindex(SKETCH._frame_times_ns)
    i1 = lastindex(SKETCH._frame_times_ns)
    for i in i0+1:i1
        dt_ns = SKETCH._frame_times_ns[i] - SKETCH._frame_times_ns[i-1]
        f(dt_ns)
    end
end

"""
    frameRate() -> Float64

Returns the average frame rate in frames per second.
"""
function frameRateMean()
    _sum = 0.0
    _len = length(SKETCH._frame_times_ns)
    _foreach_dt_ns(dt_ns -> _sum += dt_ns)
    return (_len - 1) * 1e9 / _sum # fps
end

const frameRate = frameRateMean # Alias

"""
    frameRateMax() -> Float64

Returns the maximum frame rate in frames per second.
"""
function frameRateMax()
    _min_dt = Inf
    _foreach_dt_ns() do dt_ns
        _min_dt = min(_min_dt, dt_ns)
    end
    return 1e9 / _min_dt # fps
end

"""
    frameRateMin() -> Float64

Returns the minimum frame rate in frames per second.
"""
function frameRateMin()
    _max_dt = 0.0
    _foreach_dt_ns() do dt_ns
        _max_dt = max(_max_dt, dt_ns)
    end
    return 1e9 / _max_dt # fps
end

"""
    frameRateStd() -> Float64

Returns the standard deviation of the frame rate.
"""
function frameRateStd()
    _dt_sum = 0.0
    _len = length(SKETCH._frame_times_ns)
    _foreach_dt_ns() do dt_ns
        _dt_sum += dt_ns
    end
    _mean = _dt_sum / (_len - 1) # ns
    
    _sq_diff_sq = 0.0
    _foreach_dt_ns() do dt_ns
        _sq_diff_sq += (_mean - dt_ns) ^ 2
    end
    _str = sqrt(_sq_diff_sq / (_len - 1)) # ns
    return 1e9 * _str / (_mean ^ 2) # fps
end
