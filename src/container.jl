export HContainer, add!

import Base: collect, delete!


"""
`HContainer` is a device for holding a collection of hyperbolic objects.
It is like a set, but we have to do a lot of work before adding a new
element because equal hyperbolic objects might differ a tiny amount and
that would mess up hashing.

+ `C = HContainer()` creates a new container.
+ `C = HContainer(items...)` creates a new container with the items.
"""
struct HContainer
    objs::Set{HObject}
    function HContainer()
        A = Set{HObject}()
        new(A)
    end
end

function HContainer(args...)
    C = HContainer()
    add!(C,args...)
    return C
end

length(C::HContainer) = length(C.objs)

collect(C::HContainer) = collect(C.objs)

function add!(C::HContainer, X::HObject)::Bool
    # see if we already have it ... yeah, this is bad
    for Z in C.objs
        if X==Z
            return false
        end
    end

    # not here, so OK to add
    push!(C.objs, X)
    return true
end

function add!(C::HContainer, args...)
    for X in args
        add!(C,X)
    end
end

function delete!(C::HContainer, X::HObject)::Bool
    # see if we already have it; if so, delete
    for Z in C.objs
        if Z==X
            delete!(C.objs, X)
            return true
        end
    end
    return false # never found
end

function show(io::IO, C::HContainer)
    print(io,"HContainer of size $(length(C))")
end
