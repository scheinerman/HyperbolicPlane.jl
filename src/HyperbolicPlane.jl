module HyperbolicPlane

export HPoint, getz, dist

mutable struct HPoint
    z::Complex{Float64}
    _color::String
    function HPoint(z::Complex)
        if abs(z) >=  1
            @error "Absolute value of $z is too large"
        end
        new(z,"black")
    end
end

HPoint(z::Number) = HPoint(Complex(z))

getz(P::HPoint) = P.z


_mag(z::Complex)::Real = real(z*z')

function dist(P::HPoint, Q::HPoint)
    a = getz(P)
    b = getz(Q)
    delta = 2 * _mag(a-b)/(1-_mag(a))/(1-_mag(b))
    return acosh(1+delta)
end

end #end of module
