# Everything about intersecting
export meet_check, meet, ∧


"""
`meet_check(L::HLine,LL::HLine)` determines if two lines intersect.
Also for two segments, or a line and a segment.
"""
function meet_check(L::HLine, LL::HLine)::Bool
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
    if !meet_check(L,LL)
        return false
    end

    P = meet(L,LL)
    if in(P,S) && in(P,SS)
        return true
    end
    return false
end


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
    @assert meet_check(L,S) "The line and segment do not intersect"
    p = meet(L, HLine(S))
    return p
end

meet(S::HSegment,L::HLine)::HPoint = meet(L,S)

function meet(S::HSegment,SS::HSegment)
    @assert meet_check(S,SS) "The segments do not intersect"
    p = meet(HLine(S),HLine(SS))
    return p
end

(∧)(L::HLinear, LL::HLinear)::HPoint = meet(L,LL)
