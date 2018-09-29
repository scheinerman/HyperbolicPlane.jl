# File I use just to check stuff out.

using HyperbolicPlane, Plots

function seg_draw_test(S::HSegment)
    P,Q = endpoints(S)
    M  = midpoint(S)
    set_color(M,:red)
    plot()
    draw(S)
    draw(P)
    draw(Q)
    draw(M)
    draw(HPlane())
    finish()
end

seg_draw_test(P::HPoint, Q::HPoint) = seg_draw_test(HSegment(P,Q))


function draw_test(n::Int=7)
    plot()

    for i=0:n-2
        for j=i+1:n-1
            L = HLine(2pi*i/n,2pi*j/n)
            set_thickness(L,0.5)
            draw(L)
            P = point_on_line(L)
            set_color(P,:red)
            draw(P)
        end
    end

    draw(HPlane())

    finish()
end


function extend_test()
    P = RandomHPoint()
    Q = RandomHPoint()
    S = P + Q
    L = P ∨ Q
    set_line_style(L,:dash)
    set_thickness(S,4)
    set_color(S,:red)
    draw([L,S,P,Q,HPlane()])
    finish()
end

function meet_test()
    L = RandomHLine()
    LL = RandomHLine()
    plot()
    draw([L,LL,HPlane()])

    if !meet_check(L,LL)
        plot!(title="No intersection")
    else
        plot!(title="Intersection found!")
        P = meet(L,LL)
        set_color(P,:red)
        set_radius(P,4)
        draw(P)
    end
    finish()
end
