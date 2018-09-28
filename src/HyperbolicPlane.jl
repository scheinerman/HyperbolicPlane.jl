module HyperbolicPlane

using LinearFractionalTransformations, Plots

export HObject, HPlane

import Base: getindex, setindex!, isequal, length, ==, show, adjoint, -, in, +
import AbstractLattices: ∨

# this is faster than `abs(z)`
_mag(z::Number)::Real = real(z*z')

abstract type HObject end


THRESHOLD = 10   # Global default threshold = 10*eps(1.0)


setindex!(X::T, val, key::Symbol) where T<:HObject = setindex!(X.attr, val, key)
getindex(X::T, key) where T<:HObject = getindex(X.attr, key)


struct HPlane <: HObject
    attr::Dict{Symbol,Any}
    function HPlane()
        HP = new(Dict{Symbol,Any}())
        set_color(HP)
        set_thickness(HP)
        set_line_style(HP,:dot)
        return HP
    end
end

(==)(A::HPlane, B::HPlane) = true
show(io::IO, A::HPlane) = print(io,"HPlane()")


include("point.jl")
include("segment.jl")
include("line.jl")
include("isometry.jl")
include("attributes.jl")
include("arc-maker.jl")
include("drawing.jl")

end #end of module
