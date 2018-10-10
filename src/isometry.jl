export move2zero, move2xplus, rotation, reflect_across


# This code enables LFT's to act on HObjects.

(f::LFT)(p::HPoint) = HPoint(f(getz(p)))

(f::LFT)(L::HSegment) = HSegment(f(L.A), f(L.B))

(f::LFT)(T::HTriangle) = HTriangle(f(T.A), f(T.B), f(T.C))

function (f::LFT)(L::HLine)
    s = L.s
    t = L.t
    w = exp(s*im)
    z = exp(t*im)
    ww = f(w)
    zz = f(z)
    ss = angle(ww)
    tt = angle(zz)
    return HLine(ss,tt)
end



function (f::LFT)(X::HPolygon)
    pts = f.(X.plist)
    return HPolygon(pts)
end

(f::LFT)(H::HPlane) = HPlane()

const in_up = LFT(-im, -im, 1, -1)
const up_in = LFT(-1, im, -1, -im)


"""
`move2zero(P::Hpoint)`
returns a `LFT` that's an isometry of H^2 that maps `P` to the origin.
"""
function move2zero(z::Complex)::LFT
    # map to upper half plane and find x-displacement
    zz = in_up(z)
    x = real(zz)

    # move horizontally to place above origin
    f = LFT(1, -x, 0, 1)
    zz = f(zz)

    # move down to 0 + im
    y = imag(zz)
    g =  LFT( 1, -y*im, 1, y*im )

    return g*f*in_up
end

move2zero(P::HPoint) = move2zero(getz(P))

"""
`rotation(theta)` is an isometry of H^2 corresponding to a
rotation about the origin of the amount `theta`
"""
rotation(theta::Real)= LFT( exp(im*theta), 0, 0, 1)


"""
`move2xplus(P::HPoint)` returns an isometry of H^2 that maps `P` onto
the positive real axis.
"""
function move2xplus(z::Complex)::LFT
    if z == 0
        return LFT()
    end
    theta = angle(z)
    return rotation(-theta)
end

move2xplus(P::HPoint) = move2xplus(getz(P))


function move2xplus(a::Complex, b::Complex)
    f = move2zero(a)
    bb = f(b)
    theta = angle(bb)
    g = rotation(-theta)
    return g*f
end

"""
`move2xplus(A,B)` or `move2xplus(L::HSegment)`
gives an isometry `f` so that `f(A)` is 0 and `f(B)` is on the
positive real axis.
"""
move2xplus(A::HPoint, B::HPoint) = move2xplus(getz(A),getz(B))
move2xplus(L::HSegment) = move2xplus(endpoints(L)...)

"""
`move2xplus(L::HLine)` returns a linear fractional transformation
that maps points on `L` to the positive x-axis but is *not* an
isometry of the hyperbolic plane.
"""
function move2xplus(L::HLine)
    a = exp(im*L.s)
    b = getz(point_on_line(L))
    c = exp(im*L.t)
    f = LFT(a,b,c)
    return f
end



"""
`reflect_across(X::HObject,L::HSegment/HLine)` returns the object
formed by refecting `X across the line segment/line `L`.
"""
function reflect_across(p::HPoint, L::Union{HLine,HSegment})
    f = move2xplus(L)
    z = getz(p)
    zz = f(z)'
    w = (inv(f))(zz)
    return HPoint(w)
end

function reflect_across(S::HSegment, L::Union{HLine,HSegment})
    A,B = endpoints(S)
    AA = reflect_across(A,L)
    BB = reflect_across(B,L)
    return HSegment(AA,BB)
end

function reflect_across(T::HTriangle, L::Union{HLine,HSegment})
    A,B,C = endpoints(T)
    AA = reflect_across(A,L)
    BB = reflect_across(B,L)
    CC = reflect_across(C,L)
    return HTriangle(AA,BB,CC)
end

function reflect_across(X::HPolygon, L::Union{HLine,HSegment})
    pts = [ reflect_across(p,L) for p in X.plist ]
    return HPolygon(pts)
end

function reflect_across(X::HLine, L::Union{HLine,HSegment})
    a = exp(im * L.s)
    b = getz(point_on_line(L))
    c = exp(im * L.t)
    f = LFT(a,-1,b,0,c,1)


    Y = f(X)
    s = Y.s
    t = Y.t
    Z = HLine(-s,-t)
    return (inv(f))(Z)
end




reflect_across(X::HPlane, L::Union{HLine,HSegment}) = HPlane()
