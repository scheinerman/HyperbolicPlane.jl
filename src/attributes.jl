# These functions set visual attributes of HObjects

export set_color, set_radius, set_thickness, set_line_style
export copy_attr

function set_color(P::HPoint, col=:black)
    P[:markercolor] = col
    P[:markerstrokecolor] = col
    nothing
end

function set_radius(P::HPoint, rad=1)
    P[:marker] = rad
end

HLinear = Union{HSegment,HLine,HPlane,HTriangle,HPolygon}

function set_color(P::HLinear, col=:black)
    P[:linecolor] = col
end

function set_thickness(P::HLinear, thk = 1)
    P[:linewidth] = thk
end

function set_line_style(P::HLinear, style = :solid)
    P[:linestyle] = style
end

"""
`copy_attr(A,B)` copies the attributes assigned to `B` into `A`.
"""
function copy_attr(A::HObject, B::HObject)
    for k in keys(B.attr)
        A[k] = B[k]
    end
end
