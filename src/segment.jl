export HSegment

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

endpoints(L::HSegment) = (L.A,L.B)

function (==)(L::HSegment, LL::HSegment)
    return (endpoints(L)==endpoints(LL)) || (endpoints(L)==(LL.B,LL.A))
end

midpoint(L::HSegment) = midpoint(endpoints(L)...)
length(L::HSegment) = dist(endpoints(L)...)
