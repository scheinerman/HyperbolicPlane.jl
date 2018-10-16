# functions to decompose a proper polygon into triangles

# see if the edge from v[k-1] to v[k+1] intersects the perimeter
# return true if this is a good diagonal (i.e., no intersection)

function check_diagonal(X::HPolygon, k::Int)::Bool
    n = npoints(X)

    kprev = k==1 ? n : k-1
    knext = k==n ? 1 : k+1

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

    # more more more


    return true
end
