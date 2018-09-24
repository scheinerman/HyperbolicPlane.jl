export HSegment, RandomHSegment, endpoints

"""
`HSegment(A,B)` creates a new line segment with endpoints `A` and `B`.
"""
struct HSegment <: HObject
    A::HPoint
    B::HPoint
    attr::Dict{Symbol,Any}
    function HSegment(a::HPoint,b::HPoint)
        new(a,b,Dict{Symbol,Any}())
    end
end

HSegment(a::Number, B::HPoint) = HSegment(HPoint(a), B)
HSegment(A::HPoint, b::Number) = HSegment(A, HPoint(b))
HSegment(a::Number, b::Number) = HSegment(HPoint(a), HPoint(b))
HSegment(A::HPoint) = HSegment(A, HPoint())
HSegment(a::Number) = HSegment(HPoint(a), HPoint())

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
