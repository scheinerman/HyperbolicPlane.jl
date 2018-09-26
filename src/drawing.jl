using Plots

function draw_circle(x::Real, y::Real, r::Real; opts...)
    f(t) = r*cos(t) + x
    g(t) = r*sin(t) + y
    plot!(f,g,0,2pi;opts...)
end

function draw_arc(x::Real, y::Real, r::Real, t1::Real, t2::Real; opts...)
    f(t) = r*cos(t) + x
    g(t) = r*sin(t) + y
    plot!(f,g,t1,t2;opts...)
end

function draw_segment(a::Real,b::Real,c::Real,d::Real; opts...)
    plot!([a,c],[b,d];opts...)
end

function draw_point(x::Real, y::Real; opts...)
    plot!([x],[y];opts...)
end

function finish()
    plot!(aspectratio=1, legend=false, axis=false, grid=false)
end


function draw(P::HPoint)
    x,y = reim(getz(P))
    draw_point(x,y;P.attr...)
end

function draw(S::HSegment)
    P,Q = endpoints(S)
    x,y = reim(getz(P))
    xx,yy = reim(getz(Q))
    draw_segment(x,y,xx,yy;S.attr...)  # THIS IS WRONG
end

function draw(L::HLine)
    t1 = L.s
    t2 = L.t
    x = cos(t1)
    y = sin(t1)
    xx = cos(t2)
    yy = sin(t2)
    draw_segment(x,y,xx,yy; L.attr...)
end


function draw(HP::HPlane)
    draw_circle(0,0,1; HP.attr...)
end



function draw_test()
    plot()

    P = RandomHPoint()
    Q = RandomHPoint()
    S = HSegment(P,Q)
    L = RandomHLine()

    set_color(P,:red)
    set_color(S,:blue)
    set_color(L,:green)

    draw(L)
    draw(S)
    draw(P)
    draw(Q)
    draw(HPlane())
    
    finish()
end
