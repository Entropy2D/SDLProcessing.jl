_do_nothing(_...) = nothing

const _ZERO_TUPLE = (0,0)

# --.- - . .-- .-. -. -. -- - -. . .- - - .- .-.--
abstract type Wrapper end

import Base.getindex
Base.getindex(obj::Wrapper, k0, ks...) = getindex(obj.data, k0, ks...)

import Base.get
Base.get(f::Union{Function, Type}, obj::Wrapper, k0) = get(f, obj.data, k0)
Base.get(obj::Wrapper, k0, default) = get(obj.data, k0, default)

import Base.get!
Base.get!(f::Union{Function, Type}, obj::Wrapper, k0) = get!(f, obj.data, k0)
Base.get!(obj::Wrapper, k0, default) = get!(obj.data, k0, default)

import Base.setindex!
Base.setindex!(obj::Wrapper, val, k0, ks...) = setindex!(obj.data, val, k0, ks...)

# --.- - . .-- .-. -. -. -- - -. . .- - - .- .-.--
# keep track of the time between tics
struct Ticker
    buffer::Dict{String, CircularBuffer{Float64}}
    elapsed::Dict{String, Float64}
    buffsize::Int
    Ticker(buffsize = 30) = new(Dict(), Dict(), buffsize)
end

_ticker_buffer_cl(buffsize) = () -> CircularBuffer{Float64}(buffsize)

ticsbuffer(t::Ticker, k::String) = t.buffer[k]
ticsbuffer!(t::Ticker, k::String) = get!(_ticker_buffer_cl(t.buffsize), t.buffer, k)


function tic!(f::Function, t::Ticker, k::String)
    _now = time()
    _tics = ticsbuffer!(t, k)
    _elp = isempty(_tics) ? 0.0 : _now - last(_tics) 
    ret = f(_elp)
    push!(_tics, _now)
    return ret
end

tic!(t::Ticker, k::String) = tic!(identity, t, k)

function tic(t::Ticker, k::String)
    tics = ticsbuffer(t, k)
    return isempty(tics) ? 0.0 : last(tics)
end

function onelapsed!(fun::Function, t::Ticker, k::String, target::Float64)
    _elp = get!(t.elapsed, k, 0.0)
    _elp += tic!(t, k)
    t.elapsed[k] = _elp
    _elp < target && return nothing 
    ret = fun(_elp)
    t.elapsed[k] = 0
    return ret
end


# --.- - . .-- .-. -. -. -- - -. . .- - - .- .-.--
# Try to enfore a frequency ;)
struct Frequensor
    ticker::Ticker
    delays::Dict{String, Float64}
    Frequensor(buffsize = 30) = new(Ticker(buffsize), Dict())
end

# return elps
tic!(f::Frequensor, k::String) = tic!(identity, f.ticker, k)

delays(f::Frequensor, k) = get!(f.delays, k, 0)
delays!(f, k, d) = setindex!(f.delays, d, k)

ticsbuffer(f::Frequensor, k::String) = ticsbuffer(f.ticker, k)
ticsbuffer!(f::Frequensor, k::String) = ticsbuffer!(f.ticker, k)

onelapsed!(fun::Function, f::Frequensor, k::String, target::Float64) = 
        onelapsed!(fun, f.ticker, k, target)

# Delay as much time required for enforcing the given frequency/period
function forceperiod!(delayfun::Function, f::Frequensor, k::String, 
        tperiod; rate = (tperiod * 0.1)
    )
    msdperiod = tic!(f, k)
    iszero(msdperiod) && return # ignore
    # mod delay
    err = tperiod - msdperiod
    dt = err * rate
    d = delays(f, k)
    d += dt
    d = d > 0 ? d : zero(d)
    # @show d
    delays!(f, k, d)
    delayfun(d)
end

function forcefrec!(delay::Function, f::Frequensor, k::String, tfrec; 
        rate = (tfrec * 0.1)
    )
    forceperiod!(delay, f, k, inv(tfrec); rate = inv(rate))
end

function msd_periods(f::Frequensor, k)
    tics = ticsbuffer(f, k)
    n = length(tics)
    n < 1 && return 0.0
    pers = diff(tics)
    return sum(pers) / (n - 1)
end

function msd_frequency(f::Frequensor, k)
    per = msd_periods(f, k)
    iszero(per) && return 0.0
    return inv(per)
end

# --.- - . .-- .-. -. -. -- - -. . .- - - .- .-.--
# Dir structure

stdassets(args...) = joinpath(pkgdir(SDLProcessing), "assets", args...)