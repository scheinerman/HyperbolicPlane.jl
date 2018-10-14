export HRay, RandomHRay, get_vertex

"""
`HRay(P::HPoint, t::Real)` returns a ray with vertex `P`
pointing to `exp(im*t)`.
"""
struct HRay <: HObject
    pt::HPoint
    t::Float64
    attr::Dict{Symbol,Any}
    function HRay(P::HPoint, theta::Real)
        th = mod(theta,2pi)
        PP = HPoint(getz(P))
        R = new(PP,th,Dict{Symbol,Any}())
        set_color(R)
        set_thickness(R)
        set_line_style(R)
        return R
    end
end

HRay() = HRay(HPoint(),0.0)

"""
`HRay(A,B)` where `A` and `B` are points creates the ray
with vertex `A` passing through `B`.
"""
function HRay(A::HPoint, B::HPoint)
    @assert A!=B "Points must be distinct to define a ray"
    f = move2xplus(A,B)
    g = inv(f)
    z = g(1)
    t = angle(z)
    return HRay(A,t)
end


"""
`RandomHRay()` creates a random ray.
"""
RandomHRay() = HRay( RandomHPoint(), 2*pi*rand() )

"""
`get_vertex(R::HRay)` returns the vertex (end point) of the ray.
"""
get_vertex(R::HRay) = R.pt

function show(io::IO, R::HRay)
    P = R.pt
    t = R.t
    print(io,"HRay($P,$t)")
end
