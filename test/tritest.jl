using Plots, HyperbolicPlane


function rand_simple(n::Int)
    P = RandomHPolygon(n)
    while !is_simple(P)
        P = RandomHPolygon(n)
    end
    return P
end


function tritest(X::HPolygon)
    # X = rand_simple(n)
    set_thickness(X,3)
    set_color(X,:blue)
    TT = triangulate(X)
    plot()
    draw(TT)
    draw(X)
    for p in X.plist
        a = HPoint(p)
        set_color(a,:red)
        set_radius(a,1.5)
        draw(a)
    end
    finish()
end
#
#
# alf = HSegment(HPoint(), HPoint(2,0))
# bet = HSegment(0.5+0.1im, 0.5-0.0001im)
# meet_check(alf,bet)
