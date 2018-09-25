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

function draw_point(x::Real, y::Real, r::Real=2; opts...)
    plot!([x],[y],marker=r,opts...)
end



function finish()
    plot!(aspectratio=1, legend=false, axis=false, grid=false)
end
