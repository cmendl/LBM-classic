
:Begin:
:Function:		LatticeBoltzmann
:Pattern:		LatticeBoltzmann[omega_Real, numsteps_Integer, gravity_List, f0_List, type0_List]
:Arguments:		{ omega, numsteps, gravity, f0, type0 }
:ArgumentTypes:	{ Real32, Integer, Real32List, Real32List, IntegerList }
:ReturnType:	Manual
:End:

:Evaluate: LatticeBoltzmann::usage = "LatticeBoltzmann[omega_Real, numsteps_Integer, gravity_List, f0_List, type0_List] runs a Lattice Boltzmann Method (LBM) simulation"
:Evaluate: LatticeBoltzmann::invalidOmega = "'omega' parameter must be between 0 and 2"
:Evaluate: LatticeBoltzmann::invalidDimensionf0 = "'f0' must be a Real32List of length 9*dimX*dimY for dimension 2 (D2Q9), and 19*dimX*dimY*dimZ for dimension 3 (D3Q19)"
:Evaluate: LatticeBoltzmann::invalidDimensionType0 = "'type0' must be an integer list of length dimX*dimY for dimension 2 (D2Q9), and dimX*dimY*dimZ for dimension 3 (D3Q19)"
:Evaluate: LatticeBoltzmann::outOfMemory = "malloc failed, probably out of memory"
