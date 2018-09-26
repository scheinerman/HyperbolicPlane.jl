export HLine, RandomHLine

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
