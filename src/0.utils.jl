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
