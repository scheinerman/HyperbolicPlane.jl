# Hyperbolic Plane


[![Build Status](https://travis-ci.org/scheinerman/HyperbolicPlane.jl.svg?branch=master)](https://travis-ci.org/scheinerman/HyperbolicPlane.jl)


[![codecov.io](http://codecov.io/github/scheinerman/HyperbolicPlane.jl/coverage.svg?branch=master)](http://codecov.io/github/scheinerman/HyperbolicPlane.jl?branch=master)

## UNDER CONSTRUCTION

## Objects

The `HyperbolicPlane` module will provide basic objects in the Hyperbolic
plane (realized as the Poincare Disc). So far we only have the following:

+ `HPoint(z)`: Creates a new point in the hyperbolic plane given by the
`Complex` number `z` (which must have absolute value less than 1).

## Functions

+ `dist(p,q)`: return the distance between points `p` and `q`.



## Isometries

+ `move2zero`
+ `move2xplus`
