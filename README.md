Classical Lattice Boltzmann Method (LBM)
========================================

C implementation of the classical lattice Boltzmann method (LBM) using the D2Q9 and D3Q19 models, based on Nils Thuerey's PhD thesis (see Ref. 1).

Compiling and running the C code:
- Windows: Visual Studio project files are provided in the *vcproj* folder (standalone test and demonstration files) and the *vcproj_mlink* folder (Mathematica MathLink interface)
- Linux, MacOSX etc: see the makefiles in the *bin* folder (standalone test and demonstration files) and the *mlink* folder (Mathematica MathLink interface)

The Mathematica `.cdf` (computable document format) demonstration files in the *test* folder can be viewed with the free [CDF Player](http://www.wolfram.com/cdf-player) or opened and edited with [Mathematica](http://www.wolfram.com/mathematica).

License
-------
Copyright (c) 2014, Christian B. Mendl  
All rights reserved.  
http://christian.mendl.net

This program is free software; you can redistribute it and/or
modify it under the terms of the Simplified BSD License
http://www.opensource.org/licenses/bsd-license.php


References
----------
1. Nils Thuerey  
   Physically based animation of free surface flows with the lattice Boltzmann method  
   PhD thesis, University of Erlangen-Nuremberg (2007) [[pdf](http://www.thuerey.de/ntoken/download/nthuerey_070313_phdthesis.pdf)]
2. Sauro Succi  
   The lattice Boltzmann equation for fluid dynamics and beyond  
   Oxford University Press, ISBN 0198503989 (2001)
