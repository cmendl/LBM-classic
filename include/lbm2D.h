/// \file lbm2D.h
/// \brief D2Q9 model header file.
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


#ifndef LBM2D_H
#define LBM2D_H

#include "lbm_common.h"
#include "vector2D.h"
#include "util.h"


//_______________________________________________________________________________________________________________________
//


#define SIZE_2D_X			16					//!< x-dimension of the 2D field, must be a power of 2
#define SIZE_2D_Y			32					//!< y-dimension of the 2D field, must be a power of 2

#define MASK_2D_X			(SIZE_2D_X - 1)		//!< bit mask for fast modulo 'SIZE_2D_X' operation
#define MASK_2D_Y			(SIZE_2D_Y - 1)		//!< bit mask for fast modulo 'SIZE_2D_Y' operation


//_______________________________________________________________________________________________________________________
///
/// \brief Distribution functions for D2Q9
///
typedef struct
{
	real f[9];		//!< distribution functions
	int type;		//!< cell type

	// quantities derived from distribution functions
	real rho;		//!< density
	vec2_t u;		//!< velocity

	// keep track of fluid mass exchange
	real mass;		//!< mass

}
dfD2Q9_t;


void DFD2Q9_Init(const int type, const real f[9], dfD2Q9_t *df);


//_______________________________________________________________________________________________________________________
///
/// \brief LBM field in two dimensions
///
typedef struct
{
	dfD2Q9_t *df;		//!< array of distribution functions
	real omega;			//!< 1/tau, with tau the relaxation rate to equilibrium
}
lbm_field2D_t;


void LBM2DField_Allocate(const real omega, lbm_field2D_t *field);

void LBM2DField_Free(lbm_field2D_t *field);


//_______________________________________________________________________________________________________________________
//


/// \brief Access field elements using column-major ordering
static inline dfD2Q9_t *LBM2DField_Get(const lbm_field2D_t *field, const int x, const int y)
{
	return &field->df[x + SIZE_2D_X*y];
}

/// \brief Access field elements using column-major ordering and periodic boundary conditions
static inline dfD2Q9_t *LBM2DField_GetMod(const lbm_field2D_t *field, const int x, const int y)
{
	// bit masking also works for negative integers
	return LBM2DField_Get(field, x & MASK_2D_X, y & MASK_2D_Y);
}


//_______________________________________________________________________________________________________________________
//


void LatticeBoltzmann2DEvolution(const lbm_field2D_t *restrict_ startfield, const int numsteps, const vec2_t gravity, lbm_field2D_t *restrict_ fieldevolv);



#endif
