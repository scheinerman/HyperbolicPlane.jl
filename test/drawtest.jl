# File I use just to check stuff out.

using HyperbolicPlane, Plots

function expander(P::HPolygon)
    slist = sides(P)
    return [ reflect_across(P,S) for S in slist ]
end


function tess()
    P = equiangular(7,2pi/3)

    C = HContainer(P)
    for Q in expander(P)
        add!(C,Q)
        for QQ in expander(Q)
            add!(C,QQ)
        end
    end

    C2 = HContainer()
    for P in collect(C)
        S = sides(P)
        add!(C2,S...)
    end


    plot()
    draw(C2)
    finish()
end
