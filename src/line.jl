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
    # end points of the arc
    a = exp(im*s)
    b = exp(im*t)

    f = LFT(-im,-im,1,-1)  # map from Poincare disc to upper half plane

    aa = f(a)
    bb = f(b)
    r = abs(aa-bb)/2

    cc = (aa+bb)/2 + r*im

    z = (inv(f))(cc)


    return HPoint(z)  # debug
end
