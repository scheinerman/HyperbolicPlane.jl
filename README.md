# Hyperbolic Plane


[![Build Status](https://travis-ci.org/scheinerman/HyperbolicPlane.jl.svg?branch=master)](https://travis-ci.org/scheinerman/HyperbolicPlane.jl)


[![codecov.io](http://codecov.io/github/scheinerman/HyperbolicPlane.jl/coverage.svg?branch=master)](http://codecov.io/github/scheinerman/HyperbolicPlane.jl?branch=master)



The `HyperbolicPlane` module provides basic objects
(such as points, segments, rays, lines, polygons) in the Hyperbolic
plane and visualization in the Poincare Disc.

Documentation is in the
[Wiki](https://github.com/scheinerman/HyperbolicPlane.jl/wiki). Also see the
[examples](https://github.com/scheinerman/HyperbolicPlane.jl/tree/master/examples).

This module requires the `Plots` graphics module (with `GR` backend) as well
as these:
+ `LinearFractionalTransformations`: provides Möbius transformations.
+ `AbstractLattices`: Defines `∨` and `∧`.
