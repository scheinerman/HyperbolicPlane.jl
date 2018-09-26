# These functions are used to create arcs that represent segments and lines

using LinearAlgebra

"""
`find_center(a,b,c)`: Given three points in the complex plane,
find the point `z` that is equidistant from all three. If the three
points are collinear then return `Inf + Inf*im`.
"""
function find_center(a::Complex, b::Complex, c::Complex)::Complex
    if !non_linear_check(a,b,c)
        return Inf + im*Inf
    end
    A = collect(reim(a))
    B = collect(reim(b))
    C = collect(reim(c))
    AB = 0.5*(A+B)
    BC = 0.5*(B+C)
    M = [(A-B)'; (B-C)']
    rhs = [dot(AB,A-B), dot(BC,B-C)]

    Z = M\rhs
    return Z[1] + im*Z[2]
end

"""
`non_linear_check(a,b,c)`: test if the complex numbers are distinct
and noncollinear.
"""
function non_linear_check(a::Complex,b::Complex, c::Complex)::Bool
    if a==b || b==c || a==c
        return false
    end
    z = (b-a)/(c-a)
    return imag(z) != 0
end
