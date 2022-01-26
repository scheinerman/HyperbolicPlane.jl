export move2zero, move2xplus, rotation, reflect_across, same_side
export in_up, up_in


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
    LL = HLine(ss,tt)
    copy_attr(LL,L)
    return LL
end

function (f::LFT)(R::HRay)
    z = exp(im*R.t)
    p = R.pt
    zz = f(z)
    tt = angle(zz)
    pp = f(p)
    RR = HRay(pp,tt)
    copy_attr(RR,R)
    return RR
end

function (f::LFT)(HC::Horocycle)
    p = HC.pt
    t = HC.t

    pp = f(p)
    z = exp(t*im)
    zz = f(z)
    tt = angle(zz)

    HHCC = Horocycle(pp,tt)
    copy_attr(HHCC,HC)
    return HHCC
end


function (f::LFT)(X::HPolygon)
    pts = f.(X.plist)
    XX = HPolygon(pts)
    copy_attr(XX,X)
    return XX
end

(f::LFT)(H::HPlane) = HPlane()


# Various LFT creation functions.


"""
`in_up` is a `LFT` that maps the Poincaré disk to the upper half plane.
"""
const in_up = LFT(-im, -im, 1, -1)

"""
`up_in` is a `LFT` that maps the upper half plane to the Poincaré disk.
"""
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

function move2xplus(R::HRay)
    A = get_vertex(R)
    w = getz(A)
    z = exp(im * R.t)
    return move2xplus(w,z)
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

    pp = HPoint(w)
    copy_attr(pp,p)
    return pp
end

function reflect_across(S::HSegment, L::Union{HLine,HSegment})
    A,B = endpoints(S)
    AA = reflect_across(A,L)
    BB = reflect_across(B,L)

    SS = HSegment(AA,BB)
    copy_attr(SS,S)
    return SS
end

function reflect_across(T::HTriangle, L::Union{HLine,HSegment})
    A,B,C = endpoints(T)
    AA = reflect_across(A,L)
    BB = reflect_across(B,L)
    CC = reflect_across(C,L)
    TT = HTriangle(AA,BB,CC)
    copy_attr(TT,T)
    return TT
end

function reflect_across(X::HPolygon, L::Union{HLine,HSegment})
    pts = [ reflect_across(p,L) for p in X.plist ]
    XX = HPolygon(pts)
    copy_attr(XX,X)
    return XX
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

"""
`same_side(P,Q,L)` determines if the points `P` and `Q`
lie in the same (closed) halfplane as determined by `L`.
If either point is on `L` then the result is `true`.
"""
function same_side(P::HPoint, Q::HPoint, L::HLine)::Bool

    if in(P,L) || in(Q,L)
        return true
    end

    f = move2xplus(L)
    a = imag(f(getz(P)))
    b = imag(f(getz(Q)))


    return sign(a) == sign(b)
end

same_side(P::HPoint, Q::HPoint, S::Union{HSegment,HRay}) = same_side(P,Q,HLine(S))


## UNARY MINUS

"""
`-X` where `X` is a hyperbolic object is a new object reflected through
the origin.
"""
(-)(H::HPlane) = HPlane()
(-)(P::HPoint) = HPoint(-getz(P))
(-)(P::HPolygon) = HPolygon((-).(P.plist))
(-)(C::HCircle) = HCircle( -(C.ctr), C.rad )

function (-)(L::HSegment)
    a,b = endpoints(L)
    LL = HSegment(-a,-b)
    copy_attr(LL,L)
    return LL
end

function (-)(R::HRay)
    p = -R.pt
    t = R.t + pi
    RR = HRay(p,t)
    copy_attr(RR,R)
    return RR
end

function (-)(T::HTriangle)
    a,b,c = endpoints(T)
    TT = HTriangle(-a,-b,-c)
    copy_attr(TT,T)
    return TT
end

function (-)(L::HLine)
    s = L.s
    t = L.t
    LL = HLine(pi+s,pi+t)
    copy_attr(LL,L)
    return LL
end

function (-)(HC::Horocycle)
    pt = -HC.pt
    t  = HC.t + pi
    HHCC = Horocycle(pt,t)
    copy_attr(HHCC,HC)
    return HHCC
end


## ADJOINT
"""
`adjoint(X::HObject)` (that is, `X'`) returns a new `X` that is reflected
across the `x`-axis.
"""
adjoint(H::HPlane) = HPlane()
adjoint(P::HPoint) = HPoint(getz(P)')
adjoint(P::HPolygon) = HPolygon(adjoint.(P.plist))
adjoint(C::HCircle) = HCircle( (C.ctr)', C.rad )

function adjoint(L::HSegment)
    a,b = endpoints(L)
    LL = HSegment(a',b')
    copy_attr(LL,L)
    return LL
end

function adjoint(L::HLine)
    s = L.s
    t = L.t
    LL = HLine(-s,-t)
    copy_attr(LL,L)
    return LL
end

function adjoint(R::HRay)
    p = (R.pt)'
    t = -(R.t)
    RR = HRay(p,t)
    copy_attr(RR,R)
    return RR
end

function adjoint(HC::Horocycle)
    pt = (HC.pt)'
    t  = -HC.t
    HHCC = Horocycle(pt,t)
    copy_attr(HHCC,HC)
    return HHCC
end

function adjoint(T::HTriangle)
    a,b,c = endpoints(T)
    TT = HTriangle(a',b',c')
    copy_attr(TT,T)
    return TT
end
