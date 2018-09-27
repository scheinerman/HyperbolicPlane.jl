using HyperbolicPlane, Plots
n = 5
r = 0.9
points = [ HPoint(r * exp(2*k*pi*im/n)) for k=1:n ]

plot()
for j=1:n-1
    S = HSegment(points[j], points[j+1])
    draw(S)
end
S = HSegment(points[end], points[1])
draw(S)
draw(HPlane())
finish()
