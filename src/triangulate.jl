# functions to decompose a proper polygon into triangles


"""
`alt_mod(k,n)` is `mod(k,n)` unless the result is zero,
in which case we return `n`.
"""
function alt_mod(k::Int, n::Int)
    r = mod(k,n)
    return r==0 ? n : r
end


# DEBUG STUFF

function rand_simple(n::Int)
    P = RandomHPolygon(n)
    while !is_simple(P)
        P = RandomHPolygon(n)
    end
    return P
end

function visualize(P::HPolygon)
    n = npoints(P)
    set_thickness(P,2)
    plot()
    draw(P)
    f(x) = alt_mod(x,n)
    for i=1:n
        a = P.plist[f(i-1)]
        ii = alt_mod(i+1,n)
        b = P.plist[ii]
        S = a+b
        if check_diagonal(P,i)
            set_color(S,:green)
        else
            continue
        end
        if in(midpoint(S),P)
            draw(S)
        end
    end

    for pt in P.plist
        set_radius(pt,2)
        draw(pt)
    end
    finish()
end


# see if the edge from v[k-1] to v[k+1] intersects the perimeter
# return true if this is a good diagonal (i.e., no intersection)

function check_diagonal(X::HPolygon, k::Int)::Bool
    n = npoints(X)

    if n <= 3
        return true
    end

    kprev = alt_mod(k-1,n)
    knext = alt_mod(k+1,n)

    a = X.plist[kprev]
    b = X.plist[k]      # this is the current vertex (index k)
    c = X.plist[knext]

    dg = a+c  # this is the diagonal we're testing

    # check if ac contains a vertex (other than a or c)
    for i=1:n
        if i != kprev && i != knext
            v = X.plist[i]
            if in(v,dg)
                return false
            end
        end
    end

    # now check that ac doesn't intersect any of the sides of the polygon
    f(x) = alt_mod(x,n)
    exclude = [ f(k+j) for j=-2:1 ]
    for i=1:n
        if in(i,exclude)
            continue
        end
        S = X.plist[f(i)] +X.plist[f(i+1)]
        if meet_check(dg,S)
            return false
        end
    end


    return true
end
