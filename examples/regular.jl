using HyperbolicPlane, Plots

function regular(n::Int=5, r::Real=1.0)
    plot()
    pts = [ HPoint(r, (k/n)*2pi) for k=0:n ]
    for P in pts
        set_radius(P,3)
    end

    segs = [ HSegment(pts[k],pts[k+1]) for k=1:n ]
    draw([segs;pts])
    draw(HPlane())
    finish()
end
