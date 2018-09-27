using HyperbolicPlane, Plots

"""
`complete_graph(n,rad=0.5)` draws the complete graph
on `n` vertices in the Hyperbolic plane (using straight line
segments for edges).
"""
function complete_graph(n::Int=5, radius::Real = 0.5)

    if n <= 0
        throw(DomainError(n,"n must be positive"))
    end

    if radius >= 1 || radius <= 0
        throw(DomainError(radius,"radius must be strictly between 0 and 1"))
    end

    pts = [ HPoint(radius * exp(2pi*k*im/n)) for k=1:n ]
    plot()
    for j=1:n-1
        for k=j+1:n
            L = HSegment(pts[j], pts[k])
            draw(L)
        end
    end

    for j=1:n
        P = pts[j]
        set_radius(P,2)
        draw(P)
    end
    draw(HPlane())
    finish()
end
