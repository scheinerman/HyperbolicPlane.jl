module HyperbolicPlane

using Lifts

export HObject

import Base: getindex, setindex!, *, isequal, length, ==, show

# this is faster than `abs(z)`
_mag(z::Number)::Real = real(z*z')

abstract type HObject end


THRESHOLD = 10   # Global default threshold = 10*eps(1.0)


setindex!(X::T, val, key::Symbol) where T<:HObject = setindex!(X.attr, val, key)
getindex(X::T, key) where T<:HObject = getindex(X.attr, key)

include("point.jl")
include("segment.jl")
include("isometry.jl")

end #end of module
