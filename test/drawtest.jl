# File I use just to check stuff out.

using HyperbolicPlane, Plots

function line_reflect()
    L = HLine(1,3)
    A = RandomHLine()
    set_color(A,:green)
    B = reflect_across(A,L)
    set_color(B,:red)
    plot()
    draw(A,B,L,HPlane())
    finish()
end

function reg_test()
    t = 2pi/5
    P = equiangular(4,t)
    f = move2zero(P.plist[1])
    P = f(P)
    r = rotation(t)

    for k=1:5
        draw(P)
        P = r(P)
    end

    draw(HPlane())
    finish()
end

function draw_extend(P::HPolygon)
    n = npoints(P)
    pts = deepcopy(P.plist)
    push!(pts, P.plist[1])
    for j=1:n
        a = pts[j]
        b = pts[j+1]
        L = a ∨ b
        draw(L)
    end
    draw(P)
end

function escher_test(n=4, m=5)
    t = 2pi/m
    P = equiangular(n,t)
    f = move2zero(P.plist[1])
    P = f(P)
    plot()
    r = rotation(t)
    for k=1:m
        set_thickness(P,4)
        draw_extend(P)
        P = r(P)
    end
    draw(HPlane())
    finish()
end
