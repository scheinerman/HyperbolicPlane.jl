export HCircle, get_center, get_radius, points_on_circle
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

"""
`points_on_circle(C)` returns a 3-tuple of points
that lie on the circle `C`.
"""
function points_on_circle(C::HCircle)
    P = get_center(C)
    f = inv(move2zero(P))
    r = get_radius(C)
    a = HPoint(r,0)
    b = HPoint(r,2pi/3)
    c = HPoint(r,4pi/3)
    return (f(a), f(b), f(c))
end
