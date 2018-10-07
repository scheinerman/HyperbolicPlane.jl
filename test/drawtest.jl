# File I use just to check stuff out.

using HyperbolicPlane, Plots

function expander(P::HPolygon)
    slist = sides(P)
    return [ reflect_across(P,S) for S in slist ]
end


function tess7()
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

    println("Built: $C2")

    plot()
    draw(C2)
    draw(HPlane())
    finish()
end

function tess5()
    P = equiangular(5,2pi/4)

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

    println("Built: $C2")


    plot()
    draw(C2)
    draw(HPlane())
    finish()
end
