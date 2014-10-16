/// \file platform.h
/// \brief Platform-specific code sections and compiler directives.
//
//	Copyright (c) 2014, Christian B. Mendl
//	All rights reserved.
//	http://christian.mendl.net
//
//	This program is free software; you can redistribute it and/or
//	modify it under the terms of the Simplified BSD License
//	http://www.opensource.org/licenses/bsd-license.php
//
//	Reference:
//	  Nils Thuerey, Physically based animation of free surface flows with the lattice Boltzmann method,
//	  PhD thesis, University of Erlangen-Nuremberg (2007)
//_______________________________________________________________________________________________________________________
//


#ifndef PLATFORM_H
#define PLATFORM_H


/// \brief floating-point data type used in the simulations
typedef float real;


#ifdef _MSC_VER
// Visual C specific

// from MSDN: noalias means that a function call does not modify or reference visible global state
// and only modifies the memory pointed to directly by pointer parameters (first-level indirections).
#define FIRST_LEVEL_PTRS __declspec(noalias)

// no equivalent of __attribute__((const)) in Visual C
#define CONST_FUNC

// from MSDN: The __restrict keyword indicates that a symbol is not aliased in the current scope.
#define restrict_ __restrict

#define inline __inline

#else
// gcc, icc and similar compilers

// no equivalent of __declspec(noalias) in gcc
#define FIRST_LEVEL_PTRS 

#define CONST_FUNC __attribute__((const))

#define restrict_ __restrict__

#endif



#endif
