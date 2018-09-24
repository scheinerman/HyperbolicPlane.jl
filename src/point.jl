export HPoint, getz, dist, midpoint, RandomHPoint


RandomHPoint() = HPoint(rand() * exp(2*pi*rand()*im))

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

function show(io::IO,P::HPoint)
    print(io,"HPoint($(getz(P)))")
end

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

adjoint(P::HPoint) = HPoint(getz(P)')
(-)(P::HPoint) = HPoint(-getz(P))

dist(P::HPoint) = dist(P, HPoint(0))

(==)(P::HPoint,Q::HPoint) = _mag(getz(P)-getz(Q)) <= THRESHOLD*eps(1.0)

function _dist(t::Real)
    delta = 2*t*t/(1-t*t)
    return acosh(1+delta)
end

function solve_dist(goal,left=0,right=1,thresh=THRESHOLD)
    t = (right+left)/2
    d = _dist(t)
    if abs(d-goal) < thresh*eps(1.0)
        return t
    end
    if d < goal
        return solve_dist(goal,t,right,thresh)
    else
        return solve_dist(goal,left,t,thresh)
    end
    # Should never get here!
end



"""
`midpoint(p,q)` finds the mid point of the line segment
from `p` to `q`
"""
function midpoint(p::HPoint, q::HPoint, thresh=THRESHOLD)::HPoint
    if p==q
        return p
    end
    d = dist(p,q)
    f = move2zero(p)
    qq = f(q)
    g = move2xplus(qq)

    t = solve_dist(d/2,0,1,thresh)

    r = HPoint(t)
    h = inv(g*f)
    return h(r)
end
