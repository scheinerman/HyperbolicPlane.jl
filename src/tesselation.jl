export tesselation

"""
`expander(P::HPolygon)` returns a list of polygons formed by reflecting `P`
across each of its sides.
"""
function expander(P::HPolygon)
    slist = sides(P)
    return [ reflect_across(P,S) for S in slist ]
end



"""
`tesselation(n,k,deep)`: Tesselate the hyperbolic plane by regular `n`-gons in which
each vertex is a corner of `k` polygons. `deep` controls how many layers.
"""
function tesselation(n::Int, k::Int, deep::Int=2)
    theta = 2pi/k
    P = equiangular(n,theta)
    outlist = HContainer()
    todo = HContainer()
    add!(todo,P)
    add!(outlist,P)

    for j=1:deep
        new_todo = HContainer()
        for X in todo.objs
            add!(outlist,X)
            for Y in expander(X)
                if !in(Y,outlist)
                    add!(new_todo,Y)
                end
            end
        end
        todo = new_todo
    end

    return outlist
end
