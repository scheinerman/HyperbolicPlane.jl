export HCircle, get_center, get_radius
export RandomHCircle

"""
`HCircle(P,r)` creates a new hyperbolic circle centered at `P` with radius `r`.
"""
struct HCircle <: HObject
    ctr::HPoint
    rad::Float64
    attr::Dict{Symbol,Any}
    function HCircle(P::HPoint,r::Real)
        @assert r>0 "radius must be positive"
        C = new(P,r,Dict{Symbol,Any}())
        set_color(C)
        set_thickness(C)
        set_line_style(C)
        return C
    end
end

"""
`RandomHCircle()` creates a random circle.
"""
RandomHCircle() = HCircle(RandomHPoint(), -log(rand()) )

"""
`get_center(C::HCircle)` returns the center of the circle.
"""
get_center(C::HCircle) = C.ctr

"""
`get_radius(C::HCircle)` returns the radius of the circle.
"""
get_radius(C::HCircle) = C.rad

function show(io::IO, C::HCircle)
    print(io,"HCircle($(C.ctr),$(C.rad))")
end
