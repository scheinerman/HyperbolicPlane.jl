# Hyperbolic Plane


[![Build Status](https://travis-ci.org/scheinerman/HyperbolicPlane.jl.svg?branch=master)](https://travis-ci.org/scheinerman/HyperbolicPlane.jl)

[![Coverage Status](https://coveralls.io/repos/scheinerman/HyperbolicPlane.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/scheinerman/HyperbolicPlane.jl?branch=master)

[![codecov.io](http://codecov.io/github/scheinerman/HyperbolicPlane.jl/coverage.svg?branch=master)](http://codecov.io/github/scheinerman/HyperbolicPlane.jl?branch=master)

## UNDER CONSTRUCTION

The `HyperbolicPlane` module will provide basic objects in the Hyperbolic
plane (realized as the Poincare Disc). So far we only have the following:

+ `HPoint(z)`: Creates a new point in the hyperbolic plane given by the
`Complex` number `z` (which must have absolute value less than 1).
+ `dist(p,q)`: return the distance between points `p` and `q`.
