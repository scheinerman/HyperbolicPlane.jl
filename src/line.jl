export HLine, RandomHLine, point_on_line, ∨
export meet_check, meet, ∧


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

"""
`meet_check(L::HLine,LL::HLine)` determines if two lines intersect.
"""
function meet_check(L::HLine, LL::HLine)::Bool
    s = L.s
    t = L.t
    ss = LL.s
    tt = LL.t

    if s < ss < t < tt
        return true
    end
    if ss < s < tt < t
        return true
    end
    return false
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

"""
`meet(L,LL)` finds a point on lines `L` and `LL` or throws an
error if they don't intersect. See `meet_check`.
"""
function meet(L::HLine, LL::HLine)
    @assert meet_check(L,LL) "The lines do not intersect"

    s = L.s   # artificially rotate to 0
    t = L.t
    ss = LL.s
    tt = LL.t

    a = exp(im*(t-s))
    b = exp(im*(ss-s))
    c = exp(im*(tt-s))

    A = real(in_up(a))
    B = real(in_up(b))
    C = real(in_up(c))

    R = abs(B-C)/2
    Z = (B+C)/2

    y = sqrt(R^2 - (A-Z)^2)

    p = up_in(A + im*y)*exp(im*s)

    return HPoint(p )

end

(∧)(L::HLine, LL::HLine) = meet(L,LL)



function in(a::HPoint, L::HLine)
    P = point_on_line(L)
    aa = exp(L.s*im)
    bb = getz(P)
    cc = exp(L.t*im)
    f = LFT(aa,bb,cc)
    z = f(getz(a))
    return abs(imag(z)) < THRESHOLD*eps(1.0)
end

function issubset(S::HSegment, L::T) where T <: Union{HSegment,HLine}
    P,Q = endpoints(S)
    return in(P,L) && in(Q,L)
end
