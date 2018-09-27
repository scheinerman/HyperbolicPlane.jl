export HLine, RandomHLine, point_on_line

struct HLine <: HObject
    s::Float64
    t::Float64
    attr::Dict{Symbol,Any}
    function HLine(a::Real,b::Real)
        a = mod(a,2pi)
        b = mod(b,2pi)
        if a==b
            a = 0*a
            b = 0*b
        end
        if a>b
            a,b = b,a
        end
        L = new(a,b,Dict{Symbol,Any}())
        set_color(L)
        set_thickness(L)
        set_line_style(L)
        return L
    end
end

function RandomHLine()::HLine
    x = 2*pi*rand()
    y = 2*pi*rand()
    return HLine(x,y)
end


# This doesn't work (yet)

function point_on_line(L::HLine)
    s = L.s
    t = L.t

    if abs(abs(s-t) - pi) < THRESHOLD*eps(1.0)
        return HPoint()
    end


    alpha = (s+t)/2

    if abs(alpha-s) > pi/2
        alpha = alpha-pi
    end


    r = abs(sec(alpha))-abs(tan(alpha))
    z = r * exp(s + alpha * im)
    return HPoint(z)

end
