export HTriangle, RandomHTriangle, angle, angles, area, perimeter
export interior_point

"""
`HTriangle(A,B,C)` creates a new hyperbolic triangle.
"""
struct HTriangle <: HObject
    A::HPoint
    B::HPoint
    C::HPoint
    attr::Dict{Symbol,Any}
    function HTriangle(a::HPoint,b::HPoint,c::HPoint)
        @assert a!=b && b!=c && a!=c "Three points must be distinct"
        S = new(a,b,c,Dict{Symbol,Any}())
        set_color(S)
        set_thickness(S)
        set_line_style(S)
        return S
    end
end
HTriangle(T::HTriangle) = HTriangle(T.A,T.B,T.C) # copy constructor


"""
`RandomHTriangle()` creates a random triangle via three calls
to `RandomHPoint()`.
"""
RandomHTriangle() = HTriangle(RandomHPoint(), RandomHPoint(), RandomHPoint())

"""
`endpoints(T::HTriangle)` returns the corner points of the triangle.
"""
endpoints(T::HTriangle) = [T.A,T.B,T.C]


function (==)(T::HTriangle,TT::HTriangle)
    Ts = endpoints(T)
    TTs = endpoints(TT)
    return _cyclic_equal(Ts,TTs)|| _cyclic_equal(Ts,reverse(TTs))
end

"""
`angle(A,B,C)` finds the angle betwen `BA` and `BC`.
"""
function angle(A::HPoint, B::HPoint, C::HPoint)
    @assert A!=B && C!=B "Point B must not equal A or C"
    f = move2xplus(B,A)
    z = getz(f(C))
    return abs(angle(z))
end

"""
`perimeter(T::HTriangle)` or `perimeter(P::HPolygon)` returns the perimeter
of the figure.
"""
perimeter(T::HTriangle) = dist(T.A,T.B) + dist(T.A,T.C) + dist(T.B,T.C)

"""
`angles(T::HTriangle)` returns a *sorted* triple containing the angles
at the three corners of the triangle.
"""
function angles(T::HTriangle)
    (a,b,c) = endpoints(T)
    alist = [angle(b,a,c), angle(a,b,c), angle(a,c,b)]
    return sort(alist)
end

function adjoint(T::HTriangle)
    a,b,c = endpoints(T)
    return HTriangle(a',b',c')
end

function (-)(T::HTriangle)
    a,b,c = endpoints(T)
    return HTriangle(-a,-b,-c)
end


"""
`area(T::HTriangle)` returns the area of the triangle.
"""
area(T::HTriangle) = pi - sum(angles(T))

function (+)(S::HSegment, C::HPoint)
    A,B = endpoints(S)
    return HTriangle(A,B,C)
end
(+)(C::HPoint, S::HSegment) = S+C

function interior_point(A::HPoint, B::HPoint, C::HPoint)
    @assert !collinear(A,B,C) "The three points must be noncollinear"
    X = midpoint(B,C)
    return midpoint(A,X)
end

"""
`interior_point(T::HTriangle)` returns a point in the interior of the triangle.
"""
function interior_point(T::HTriangle)
    A,B,C = endpoints(T)
    return interior_point(A,B,C)
end

function show(io::IO,T::HTriangle)
    a,b,c = endpoints(T)
    print(io,"HTriangle($a,$b,$c)")
end
