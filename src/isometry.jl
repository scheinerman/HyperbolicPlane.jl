export move2zero, move2xplus


(f::Lift)(p::HPoint) = HPoint(f(getz(p)))

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
`move2xplus(P::HPoint)` returns an isometry of H^2 that maps `P` onto
the positive real axis.
"""
function move2xplus(z::Complex)::Lift
    if z == 0
        return Lift()
    end

    theta = angle(z)
    return Lift(exp(-theta*im),0,0,1)
end

move2xplus(P::HPoint) = move2xplus(getz(P))
