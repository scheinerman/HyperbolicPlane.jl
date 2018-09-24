export move2zero, move2xplus, rotation


(f::Lift)(p::HPoint) = HPoint(f(getz(p)))

(f::Lift)(L::HSegment) = HSegment(f(L.A), f(L.B))

const in_up = Lift(-im, -im, 1, -1)
const up_in = Lift(-1, im, -1, -im)


"""
`move2zero(P::Hpoint)`
returns a `Lift` that's an isometry of H^2 that maps `P` to the origin.
"""
function move2zero(z::Complex)::Lift
    # map to upper half plane and find x-displacement
    zz = in_up(z)
    x = real(zz)

    # move horizontally to place above origin
    f = Lift(1, -x, 0, 1)
    zz = f(zz)

    # move down to 0 + im
    y = imag(zz)
    g =  Lift( 1, -y*im, 1, y*im )

    return g*f*in_up
end

move2zero(P::HPoint) = move2zero(getz(P))

"""
`rotation(theta)` is an isometry of H^2 corresponding to a
rotation about the origin of the amount `theta`
"""
rotation(theta::Real)= Lift( exp(im*theta), 0, 0, 1)


"""
`move2xplus(P::HPoint)` returns an isometry of H^2 that maps `P` onto
the positive real axis.
"""
function move2xplus(z::Complex)::Lift
    if z == 0
        return Lift()
    end
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
