export HPolygon, add_point!, npoints, RandomHPolygon

"""
`HPolygon()` creates a new polygon (with no points).

`HPolygon(list)` creates a polygon whose points are specified in `list`.

See: `add_point!`
"""
struct HPolygon <: HObject
    plist::Array{HPoint,1}
    attr::Dict{Symbol,Any}
    function HPolygon()
        X = new(HPoint[],Dict{Symbol,Any}())
        set_color(X)
        set_thickness(X)
        set_line_style(X)
        return X
    end
end

"""
`add_point!(X::HPolygon, P::HPoint)` adds the point `P`
as the last point of the polygon `X`
"""
add_point!(X::HPolygon, P::HPoint) = push!(X.plist,P)

"""
`endpoints(X::HPolygon)` returns the list of vertices (in order)
of the polygon.
"""
endpoints(X::HPolygon) = deepcopy(X.plist)

"""
`npoints(X::HPolygon)` returns the number of points on the polygon.
"""
npoints(X::HPolygon) = length(X.plist)

function HPolygon(pts::Array{HPoint,1})
    X = HPolygon()
    for p in pts
        add_point!(X,p)
    end
    return X
end

HPolygon(pts...) = HPolygon(collect(pts))

function HPolygon(T::HTriangle)
    a,b,c = endpoints(T)
    return HPolygon(a,b,c)
end


function HTriangle(X::HPolygon)
    @assert npoints(X)==3 "Can only convert a 3-point HPolygon into an HTriangle"
    return HTriangle(X.plist...)
end

"""
`RandomHPolygon(n)` create a new `HPolygon` with `n` points chosen
at random. (It's likely to intersect itself.)
"""
function RandomHPolygon(n::Int)
    pts = [ RandomHPoint() for j=1:n]
    return HPolygon(pts)
end

#


function show(io::IO,X::HPolygon)
    print(io,"HPolygon with $(npoints(X)) points")
end
