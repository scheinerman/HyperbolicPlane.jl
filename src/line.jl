export HLine, RandomHLine, point_on_line, ∨


struct HLine <: HObject
    s::Float64
    t::Float64
    attr::Dict{Symbol,Any}
    function HLine(a::Real,b::Real)
        a = mod(a,2pi)
        b = mod(b,2pi)
        @assert a!=b "Invalid line"

        if a>b
            a,b = b,a
        end
        L = new(a,b,Dict{Symbol,Any}())
        set_color(L)
        set_thickness(L)
        set_line_style(L)
        return L
    end
end
HLine(L::HLine) = HLine(H.s,H.t) # copy constructor
HLine() = HLine(0,pi)  #default line is a horizontal diameter

(==)(L::HLine, LL::HLine) = abs(L.s-LL.s)<THRESHOLD*eps(1.) && abs(L.t-LL.t)<THRESHOLD*eps(1.)

function show(io::IO, L::HLine)
    s = L.s
    t = L.t
    print(io,"HLine($s,$t)")
end

"""
`HLine(P,Q)` creates a new line from the given two points.
"""
function HLine(P::HPoint, Q::HPoint)
    @assert P != Q "Need two distinct points to determine a line"
    f = move2xplus(P,Q)
    g = inv(f)
    a = angle(g(-1))
    b = angle(g(1))
    return HLine(a,b)
end

(∨)(P::HPoint, Q::HPoint) = HLine(P,Q)

"""
`HLine(S::HSegment)` extends the segment `S` to give a (new) line.
"""
function HLine(S::HSegment)
    P,Q = endpoints(S)
    return HLine(P,Q)
end



"""
`RandomHLine()` returns a random line in the hyperbolic plane.

Algorithm: choose two values `s,t` in `[0,2pi)` uniformly at random
and then make the line from `exp(s*im)` to `exp(t*im)`.
"""
function RandomHLine()::HLine
    x = 2*pi*rand()
    y = 2*pi*rand()
    return HLine(x,y)
end


"""
`point_on_line(L)` returns a (finite) point on the hyperbolic line `L`.
"""
function point_on_line(L::HLine)
    s = L.s
    t = L.t

    if abs(abs(s-t) - pi) < THRESHOLD*eps(1.0)
        return HPoint()
    end

    # del is 1/2 the size of the angle between s and t
    del = (t-s)/2
    if del>pi
        del -= pi
    end

    r = abs(sec(del))-abs(tan(del))

    # bi is the angle bisector

    bi = (s+t)/2
    if (bi-s)>pi/2
        bi -= pi
    end

    z = r * exp(bi * im)
    return HPoint(z)
end

# Find the complex point that's the euclidean center of the line as drawn
function e_center(L::HLine)::Complex
    s = L.s
    t = L.t

    if abs((t-s)-pi) < THRESHOLD*eps(1.0)
        return Inf + Inf*im
    end
    P = point_on_line(L)
    a = exp(im*s)
    b = exp(im*t)
    c = getz(P)
    return find_center(a,b,c)
end

# Fine the euclidean radius
function e_radius(L::HLine)::Real
    s = exp(im*L.s)
    t = exp(im*L.t)
    z = e_center(L)
    if isinf(z)
        return Inf
    end
    r1 = abs(z-s)
    r2 = abs(z-t)
    return (r1+r2)/2
end

function in(P::HPoint, L::HLine)
    PP = reflect_across(P,L)
    return P == PP
end

function adjoint(L::HLine)
    s = L.s
    t = L.t
    return HLine(-s,-t)
end

function (-)(L::HLine)
    s = L.s
    t = L.t
    return HLine(pi+s,pi+t)
end



function issubset(S::HSegment, L::T) where T <: Union{HSegment,HLine}
    P,Q = endpoints(S)
    return in(P,L) && in(Q,L)
end
