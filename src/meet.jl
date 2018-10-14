# Everything about intersecting
export meet_check, meet, ∧


"""
`meet_check(L::HLine,LL::HLine)` determines if two lines intersect.
Also for any combination of lines, segments, or rays.
"""
function meet_check(L::HLine, LL::HLine)::Bool
    if L == LL
        return false
    end
    s = L.s
    t = L.t
    ss = LL.s
    tt = LL.t

    if s < ss < t < tt
        return true
    end
    if ss < s < tt < t
        return true
    end
    return false
end


function meet_check(L::HLine, S::HSegment)::Bool
    LL = HLine(S)  # extend S
    if !meet_check(L,LL)
        return false
    end

    P = meet(L,LL)
    return in(P,S)
end

meet_check(S::HSegment,L::HLine)::Bool = meet_check(L,S)


function meet_check(S::HSegment, SS::HSegment)::Bool
    L = HLine(S)
    LL = HLine(SS)

    if L==LL  # see if they share exactly one endpoint
        A,B = endpoints(S)
        AA,BB = endpoints(SS)
        if A==AA && between(B,A,BB)
            return true
        end
        if A==BB && between(A,B,BB)
            return true
        end
        if B==AA && between(A,B,BB)
            return true
        end
        if B==BB && between(A,B,AA)
            return true
        end
        return false
    end

    if !meet_check(L,LL)
        return false
    end

    P = meet(L,LL)
    if in(P,S) && in(P,SS)
        return true
    end
    return false
end


function meet_check(L::HLine, R::HRay)::Bool
    LL = HLine(R)
    if !meet_check(L,LL)
        return false
    end
    P = meet(L,LL)
    return in(P,R)
end
meet_check(R::HRay, L::HLine)::Bool = meet_check(L,R)


function meet_check(R::HRay, S::HSegment)::Bool
    LR = HLine(R)
    LS = HLine(S)
    if !meet_check(LR,LS)
        return false
    end
    P = meet(LR,LS)
    return in(P,R) && in(P,S)
end
meet_check(S::HSegment, R::HRay)::Bool = meet_check(R,S)

function meet_check(R::HRay, RR::HRay)::Bool
    L = HLine(R)
    LL = HLine(RR)
    if !meet_check(L,LL)
        return false
    end
    P = meet(L,LL)
    return in(P,R) && in(P,RR)
end


################################################################

"""
`meet(L,LL)` finds a point on lines `L` and `LL` or throws an
error if they don't intersect.  Also for a line and a segment, or
two segments.

See `meet_check`.
"""
function meet(L::HLine, LL::HLine)::HPoint
    @assert meet_check(L,LL) "The lines do not intersect"

    s = L.s   # artificially rotate to 0
    t = L.t
    ss = LL.s
    tt = LL.t

    a = exp(im*(t-s))
    b = exp(im*(ss-s))
    c = exp(im*(tt-s))

    A = real(in_up(a))
    B = real(in_up(b))
    C = real(in_up(c))

    R = abs(B-C)/2
    Z = (B+C)/2

    y = sqrt(R^2 - (A-Z)^2)

    p = up_in(A + im*y)*exp(im*s)

    return HPoint(p)
end

function meet(L::HLine, S::HSegment)::HPoint
    @assert meet_check(L,S) "The line and segment do not intersect at a unique point"
    p = meet(L, HLine(S))
    return p
end

meet(S::HSegment,L::HLine)::HPoint = meet(L,S)

function meet(S::HSegment,SS::HSegment)
    @assert meet_check(S,SS) "The segments do not intersect at a unique point"

    L = HLine(S)
    LL = HLine(SS)

    if L != LL
        p = meet(HLine(S),HLine(SS))
        return p
    end

    # special case: segments overlap in an end point
    A,B = endpoints(S)
    AA,BB = endpoints(SS)

    if A==AA || A==B
        return A
    end
    if B==AA || B==BB
        return B
    end
    # Should never get here
    @error "Programming error in meet(HSegment, HSegment)"
end


function meet(L::HLine, R::HRay)::HPoint
    @assert meet_check(L,R) "The line and ray do not intersect at a unique point"
    return meet(L, HLine(R))
end
meet(R::HRay, L::HLine)::HPoint = meet(L,R)


function meet(R::HRay, S::HSegment)::HPoint
    @assert meet_check(R,S) "The line and segment do not intersect at a unique point"
    return meet(HLine(R, HLine(S)))
end
meet(S::HSegment, R::HRay)::HPoint = meet(R,S)

function meet(R::HRay, RR::HRay)::HPoint
    @assert meet_check(R,RR) "The two rays do not instersect at a unique point"
    return meet(HLine(R,HLine(RR)))
end


(∧)(L::HLinear, LL::HLinear)::HPoint = meet(L,LL)
