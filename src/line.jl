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


# This doesn't quite work right. Need to find c on the shorter arc.

function point_on_line(L::HLine)
    s = L.s
    t = L.t

    a = exp(im*s)
    b = exp(im*t)
    c = exp(im*(s+t)/2)
    m = (a+b)/2

    v = m-c
    z = c-2m

    return HPoint(z)
end
