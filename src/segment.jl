export HSegment, RandomHSegment, endpoints, reflect_across
export collinear

"""
`HSegment(A,B)` creates a new line segment with endpoints `A` and `B`.
"""
struct HSegment <: HObject
    A::HPoint
    B::HPoint
    attr::Dict{Symbol,Any}
    function HSegment(a::HPoint,b::HPoint)
        S = new(a,b,Dict{Symbol,Any}())
        set_color(S)
        set_thickness(S)
        set_line_style(S)
        return S
    end
end

HSegment(a::Number, B::HPoint) = HSegment(HPoint(a), B)
HSegment(A::HPoint, b::Number) = HSegment(A, HPoint(b))
HSegment(a::Number, b::Number) = HSegment(HPoint(a), HPoint(b))
HSegment(A::HPoint) = HSegment(A, HPoint())
HSegment(a::Number) = HSegment(HPoint(a), HPoint())

(∨)(A::HPoint, B::HPoint) = HSegment(A,B)


function show(io::IO, L::HSegment)
    p,q = endpoints(L)
    a = getz(p)
    b = getz(q)
    print(io,"HSegment($a,$b)")
end

endpoints(L::HSegment) = (L.A,L.B)

RandomHSegment() = HSegment(RandomHPoint(), RandomHPoint())

function (==)(L::HSegment, LL::HSegment)
    return (endpoints(L)==endpoints(LL)) || (endpoints(L)==(LL.B,LL.A))
end

midpoint(L::HSegment) = midpoint(endpoints(L)...)
length(L::HSegment) = dist(endpoints(L)...)

function adjoint(L::HSegment)
    a,b = endpoints(L)
    return HSegment(a',b')
end

function (-)(L::HSegment)
    a,b = endpoints(L)
    return HSegment(-a,-b)
end

"""
`reflect_across(p::HPoint,L::HSegment)` returns the point `q`
formed by refecting `p` across the line segment `L`
"""
function reflect_across(p::HPoint, L::HSegment)
    f = move2xplus(L)
    pp = f(p)
    return (inv(f))(pp')
end


"""
`collinear` checks if the arguments are collinear. Arguments are:
+ `a,b,c`: three points
+ `a,L`: point and segment (in either order)
+ `L,LL`: two segments
"""
function collinear(a::HPoint, b::HPoint, c::HPoint)::Bool
    if a==b || b==c || a==c
        return true
    end
    aa = reflect_across(a,HSegment(b,c))
    return aa == a
end

collinear(a::HPoint, L::HSegment) = collinear(a,endpoints(L)...)
collinear(L::HSegment, a::HPoint) = collinear(a,L)

function collinear(L::HSegment, LL::HSegment)
    a,b = endpoints(LL)
    return collinear(a,L) && collinear(b,L)
end


function in(a::HPoint, L::HSegment)
    x,y = endpoints(L)
    return between(x,a,y)
end
