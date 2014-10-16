/// \file lbm3D.h
/// \brief D3Q19 model header file.
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


#ifndef LBM3D_H
#define LBM3D_H

#include "lbm_common.h"
#include "vector3D.h"
#include "util.h"


//_______________________________________________________________________________________________________________________
//


#define SIZE_3D_X			8					//!< x-dimension of the 3D field, must be a power of 2
#define SIZE_3D_Y			16					//!< y-dimension of the 3D field, must be a power of 2
#define SIZE_3D_Z			32					//!< z-dimension of the 3D field, must be a power of 2

#define MASK_3D_X			(SIZE_3D_X - 1)		//!< bit mask for fast modulo 'SIZE_3D_X' operation
#define MASK_3D_Y			(SIZE_3D_Y - 1)		//!< bit mask for fast modulo 'SIZE_3D_Y' operation
#define MASK_3D_Z			(SIZE_3D_Z - 1)		//!< bit mask for fast modulo 'SIZE_3D_Z' operation


//_______________________________________________________________________________________________________________________
///
/// \brief Distribution functions for D3Q19
///
typedef struct
{
	real f[19];		//!< distribution functions
	int type;		//!< cell type

	// quantities derived from distribution functions
	real rho;		//!< density
	real3 u;		//!< velocity

	// keep track of fluid mass exchange
	real mass;		//!< mass
}
dfD3Q19_t;


void DFD3Q19_Init(const int type, const real f[19], dfD3Q19_t *df);


//_______________________________________________________________________________________________________________________
///
/// \brief LBM field in three dimensions
///
typedef struct
{
	dfD3Q19_t *df;		//!< array of distribution functions
	real omega;			//!< 1/tau, with tau the relaxation rate to equilibrium
}
lbm_field3D_t;


void LBM3DField_Allocate(const real omega, lbm_field3D_t *field);

void LBM3DField_Free(lbm_field3D_t *field);


//_______________________________________________________________________________________________________________________
//


/// \brief Access field elements using column-major ordering
static inline dfD3Q19_t *LBM3DField_Get(const lbm_field3D_t *field, const int x, const int y, const int z)
{
	return &field->df[x + SIZE_3D_X*(y + SIZE_3D_Y*z)];
}

/// \brief Access field elements using column-major ordering and periodic boundary conditions
static inline dfD3Q19_t *LBM3DField_GetMod(const lbm_field3D_t *field, const int x, const int y, const int z)
{
	// bit masking also works for negative integers
	return LBM3DField_Get(field, x & MASK_3D_X, y & MASK_3D_Y, z & MASK_3D_Z);
}


//_______________________________________________________________________________________________________________________
//


void LatticeBoltzmann3DEvolution(const lbm_field3D_t *restrict_ startfield, const int numsteps, const real3 gravity, lbm_field3D_t *restrict_ fieldevolv);



#endif
