export HTriangle, RandomHTriangle, angle, angles, area

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
    # return  (a==aa && b==bb && c==cc) ||
    #         (a==aa && b==cc && c==bb) ||
    #         (a==bb && b==aa && c==cc) ||
    #         (a==bb && b==cc && c==bb) ||
    #         (a==cc && b==aa && c==bb) ||
    #         (a==cc && b==cc && c==bb)
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
`angles(T::HTriangle)` returns a triple containing the angles
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

function show(io::IO,T::HTriangle)
    a,b,c = endpoints(T)
    print(io,"HTriangle($a,$b,$c)")
end
