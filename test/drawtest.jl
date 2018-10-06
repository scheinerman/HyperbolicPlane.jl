# File I use just to check stuff out.

using HyperbolicPlane, Plots

t = 2pi/5
P = equiangular(4,t)
f = move2zero(P.plist[1])
P = f(P)
r = rotation(t)

for k=1:5
    draw(P)
    global P = r(P)
end

draw(HPlane())
finish()
savefig("foo.pdf")
