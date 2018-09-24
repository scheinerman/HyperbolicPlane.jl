module HyperbolicPlane

using Lifts

export HObject, HPoint, getz, dist

import Base: getindex, setindex!, *

# this is faster than `abs(z)`
_mag(z::Number)::Real = real(z*z')

abstract type HObject end


setindex!(X::T, val, key::Symbol) where T<:HObject = setindex!(X.attr, val, key)
getindex(X::T, key) where T<:HObject = getindex(X.attr, key)

"""
`HPoint(z::Complex)` creates a new point in the hyperbolic plane.
The argument `z` must have absolute value less than 1.
"""
struct HPoint <: HObject
    z::Complex{Float64}
    attr::Dict{Symbol,Any}
    function HPoint(z::Complex)
        if _mag(z) >=  1
            throw(DomainError(z, "absolute value is too large"))
        end
        new(z,Dict{Symbol,Any}())
    end
end

HPoint(z::Number) = HPoint(Complex(z))
HPoint() = HPoint(0)

"""
`getz(P::HPoint)` returns the point (complex number) in the
interior of the unit disc that represents `P`.
"""
getz(P::HPoint) = P.z

"""
`dist(P,Q)` gives the distance betwen two points in the
hyperbolic plane. If `Q` is omitted, give the distance
from `P` to `HPoint(0)`.
"""
function dist(P::HPoint, Q::HPoint)
    a = getz(P)
    b = getz(Q)
    delta = 2 * _mag(a-b)/(1-_mag(a))/(1-_mag(b))
    return acosh(1+delta)
end

dist(P::HPoint) = dist(P, HPoint(0))


include("isometry.jl")

end #end of module
