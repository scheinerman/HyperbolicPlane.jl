using Plots
# export draw

function draw_circle(x::Real, y::Real, r::Real; opts...)
    f(t) = r*cos(t) + x
    g(t) = r*sin(t) + y
    plot!(f,g,0,2pi;opts...)
end


function draw_circle(a::Complex, b::Complex, c::Complex; opts...)
    z = find_center(a,b,c)
    r = abs(a-z)
    x,y = reim(z)
    draw_circle(x,y,r; opts...)
end



function draw_arc(x::Real, y::Real, r::Real, t1::Real, t2::Real; opts...)
    f(t) = r*cos(t) + x
    g(t) = r*sin(t) + y

    t1 = mod(t1, 2pi)
    t2 = mod(t2, 2pi)

    if t1==t2
        return
    end

    if t1 > t2
        t1,t2 = t2,t1
    end

    if t2-t1>pi
        t1 += 2pi
    end

    plot!(f,g,t1,t2;opts...)
end


function draw_arc(a::Complex, b::Complex, c::Complex; opts...)
    z = find_center(a,b,c)
    r = abs(b-z)
    t1 = angle(a-z)
    t2 = angle(c-z)
    draw_arc(real(z), imag(z), r, t1, t2; opts...)
end





function draw_segment(a::Real,b::Real,c::Real,d::Real; opts...)
    plot!([a,c],[b,d];opts...)
end

function draw_segment(a::Complex, b::Complex; opts...)
    x,y = reim(a)
    xx,yy = reim(b)
    draw_segment(x,y,xx,yy; opts...)
end

function draw_point(x::Real, y::Real; opts...)
    plot!([x],[y];opts...)
end

draw_point(z::Complex; opts...) = draw_point(real(z),imag(z); opts...)

function finish()
    plot!(aspectratio=1, legend=false, axis=false, grid=false)
end


#############################################################

function draw(P::HPoint)
    x,y = reim(getz(P))
    draw_point(x,y;P.attr...)
end

function draw(S::HSegment)
    P,Q = endpoints(S)

    if P==Q
        return
    end

    M = midpoint(S)

    z = getz(P)
    zz = getz(Q)
    w = getz(M)

    if abs(imag( (z-w)/(zz-w) )) < THRESHOLD*eps(1.0)   # they're linear
        draw_segment(z,zz;S.attr...)
    else
        draw_arc(z,w,zz; S.attr...)
    end
end

function draw(L::HLine)
    t1 = L.s
    t2 = L.t

    if t1==t2
        return
    end

    x = cos(t1)
    y = sin(t1)
    xx = cos(t2)
    yy = sin(t2)

    if abs(abs(t1-t2)-pi) < THRESHOLD*eps(1.0)
        draw_segment(x,y,xx,yy;L.attr...)
    else
        P = point_on_line(L)
        m = getz(P)
        draw_arc(x+im*y, m, xx+im*yy; L.attr...)
    end

end


function draw(HP::HPlane)
    draw_circle(0,0,1; HP.attr...)
end


############################

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

    for i=0:n-1
        for j=i+1:n
            L = HLine(2pi*i/n,2pi*j/n)
            draw(L)
        end
    end 

    draw(HPlane())

    finish()
    return plist
end
