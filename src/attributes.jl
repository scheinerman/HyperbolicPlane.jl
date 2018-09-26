# These functions set visual attributes of HObjects

export set_color, set_radius

function set_color(P::HPoint, col="black")
    P[:linecolor] = col
    P[:fillcolor] = col
    nothing
end

function set_radius(P::HPoint, rad=4)
    P[:marker] = rad
end
