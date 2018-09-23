using Test
using HyperbolicPlane

p = HPoint(0)
q = HPoint(.2)
r = HPoint(0-0.2im)
@test dist(p,q) == dist(p,r)
