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
        set_radius(a,3)
        draw(a)
    end 
    finish()
end
