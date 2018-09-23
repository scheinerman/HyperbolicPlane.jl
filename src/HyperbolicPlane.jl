module HyperbolicPlane

export HPoint

struct HPoint
    z::Complex{Float64}
    _color::String
    function HPoint(z::Complex)
        if abs(z) > 1
            @error "Absolute value of $z is too large"
        end
        new(z,"black")
    end
end


end #end of module
