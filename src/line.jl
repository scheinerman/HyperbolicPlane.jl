export HLine

struct HLine <: HObject
    s::Float64
    t::Float64
    attr::Dict{Symbol,Any}
    function HLine(a::Real,b::Real)
        a = mod(a,2pi)
        b = mod(a,2pi)
        if a==b
            a = 0*a
            b = 0*b
        end
        if a>b
            a,b = b,a
        end
        new(a,b,Dict{Symbol,Any}())
    end
end
