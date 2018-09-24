# Hyperbolic Plane


[![Build Status](https://travis-ci.org/scheinerman/HyperbolicPlane.jl.svg?branch=master)](https://travis-ci.org/scheinerman/HyperbolicPlane.jl)


[![codecov.io](http://codecov.io/github/scheinerman/HyperbolicPlane.jl/coverage.svg?branch=master)](http://codecov.io/github/scheinerman/HyperbolicPlane.jl?branch=master)

## UNDER CONSTRUCTION

## Objects

### The Plane

The `HyperbolicPlane` module will provide basic objects in the Hyperbolic
plane (realized as the Poincare Disc).

+ `HPlane()`: Represents the entire hyperbolic plane.

### Points

+ `HPoint(z)`: Creates a new point in the hyperbolic plane given by the
`Complex` number `z` (which must have absolute value less than 1).
+ `dist(p,q)`: return the distance between points `p` and `q`.
+ `midpoint(p,q)`

### Line Segments

+ `HSegment(a,b)`: Create a new line segment joining points `a` and `b`
(each specified as either a complex number or an `HPoint`).
+ `length(L)`
+ `midpoint(L)`
+ `endpoints(L)`


## Attributes

All hyperbolic objects can take arbitrary attributes. These are key-value
pairs where the key is a `Symbol` and the values can be anything.
```julia 
julia> P = HPoint()
HPoint(0.0 + 0.0im)

julia> P[:color] = "red"
"red"

julia> P[:color]
"red"
```



## Isometries

+ `move2zero`
+ `move2xplus`
