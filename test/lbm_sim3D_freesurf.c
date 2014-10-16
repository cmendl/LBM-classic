//	Implementation of the lattice Boltzmann method (LBM) using the D2Q9 and D3Q19 models
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

// Demonstration file in 3D with free surfaces (fluid to gas interface)


#include "lbm3D.h"
#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#if defined(_WIN32) & (defined(DEBUG) | defined(_DEBUG))
#include <crtdbg.h>
#endif


//_______________________________________________________________________________________________________________________
///
/// \brief Calculate the average mass of a field
///
static inline real LBM3DField_AverageMass(const lbm_field3D_t *field)
{
	int x, y, z;

	real mass = 0;
	for (z = 0; z < SIZE_3D_Z; z++)
	{
		for (y = 0; y < SIZE_3D_Y; y++)
		{
			for (x = 0; x < SIZE_3D_X; x++)
			{
				// current cell
				const dfD3Q19_t *df = LBM3DField_Get(field, x, y, z);
				mass += df->mass;
			}
		}
	}

	// normalization
	mass /= (SIZE_3D_X*SIZE_3D_Y*SIZE_3D_Z);

	return mass;
}


//_______________________________________________________________________________________________________________________
///
/// \brief Calculate the average velocity of a field
///
static inline real3 LBM3DField_AverageVelocity(const lbm_field3D_t *field)
{
	int x, y, z;

	real rho = 0;
	real3 vel = { 0 };
	for (z = 0; z < SIZE_3D_Z; z++)
	{
		for (y = 0; y < SIZE_3D_Y; y++)
		{
			for (x = 0; x < SIZE_3D_X; x++)
			{
				// current cell
				const dfD3Q19_t *df = LBM3DField_Get(field, x, y, z);

				rho += df->rho;

				// weighted contribution to overall velocity
				vel.x += df->rho * df->u.x;
				vel.y += df->rho * df->u.y;
				vel.z += df->rho * df->u.z;
			}
		}
	}

	// normalization
	real s = 1 / rho;
	vel.x *= s;
	vel.y *= s;
	vel.z *= s;

	return vel;
}


//_______________________________________________________________________________________________________________________
//


int main()
{
	int i;
	int x, y, z;

	const real omega = 0.2f;
	const int numsteps = 64;
	const real3 gravity = { 0, 0, (real)(-0.1) };

	printf("dimensions: %d x %d x %d\n", SIZE_3D_X, SIZE_3D_Y, SIZE_3D_Z);
	printf("omega:      %g\n", omega);
	printf("numsteps:   %d\n", numsteps);
	printf("gravity:    (%g, %g, %g)\n", gravity.x, gravity.y, gravity.z);

	// enable run-time memory check for debug builds
	#if defined(_WIN32) & (defined(DEBUG) | defined(_DEBUG))
	_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF);
	#endif

	// load initial cell types from disk
	int t0[SIZE_3D_X*SIZE_3D_Y*SIZE_3D_Z];
	int hr = ReadData("../test/lbm_sim3D_freesurf_t0.dat", t0, sizeof(int), SIZE_3D_X*SIZE_3D_Y*SIZE_3D_Z);
	if (hr < 0) {
		fprintf(stderr, "File containing initial cell types not found, exiting...\n");
		return hr;
	}

	// load initial distribution function data from disk
	real f0[SIZE_3D_X*SIZE_3D_Y*SIZE_3D_Z*19];
	hr = ReadData("../test/lbm_sim3D_freesurf_f0.dat", f0, sizeof(real), SIZE_3D_X*SIZE_3D_Y*SIZE_3D_Z*19);
	if (hr < 0) {
		fprintf(stderr, "File containing distribution function data not found, exiting...\n");
		return hr;
	}

	// allocate and initialize start field
	lbm_field3D_t startfield;
	LBM3DField_Allocate(omega, &startfield);
	for (z = 0; z < SIZE_3D_Z; z++)
	{
		for (y = 0; y < SIZE_3D_Y; y++)
		{
			for (x = 0; x < SIZE_3D_X; x++)
			{
				// data stored with row-major ordering
				i = (x*SIZE_3D_Y + y)*SIZE_3D_Z + z;
				DFD3Q19_Init(t0[i], &f0[19*i], LBM3DField_Get(&startfield, x, y, z));
			}
		}
	}

	lbm_field3D_t *fieldevolv;
	fieldevolv = (lbm_field3D_t *)malloc(numsteps*sizeof(lbm_field3D_t));

	// start timer
	clock_t t_start = clock();

	// perform main calculation
	LatticeBoltzmann3DEvolution(&startfield, numsteps, gravity, fieldevolv);

	clock_t t_end = clock();
	double cpu_time = (double)(t_end - t_start) / CLOCKS_PER_SEC;
	printf("finished simulation, CPU time: %g\n\n", cpu_time);

	// check mass conservation
	real mass_init  = LBM3DField_AverageMass(&fieldevolv[0]);
	real mass_final = LBM3DField_AverageMass(&fieldevolv[numsteps-1]);
	printf("initial average mass: %g\n", mass_init);
	printf("final   average mass: %g\n", mass_final);
	printf("relative difference:  %g\n", fabsf(mass_final/mass_init - 1));
	printf("(mass not exactly conserved due to excess mass which cannot be distributed)\n\n");

	// check momentum conservation
	real3 vel_init  = LBM3DField_AverageVelocity(&fieldevolv[0]);
	real3 vel_final = LBM3DField_AverageVelocity(&fieldevolv[numsteps-1]);
	printf("initial average velocity: (%g, %g, %g)\n",  vel_init.x,  vel_init.y,  vel_init.z);
	printf("final   average velocity: (%g, %g, %g)\n", vel_final.x, vel_final.y, vel_final.z);
	real3 vel_diff = {
		vel_final.x - vel_init.x,
		vel_final.y - vel_init.y,
		vel_final.z - vel_init.z
	};
	printf("norm of difference: %g\n", Vec3_Norm(vel_diff));
	printf("(velocity not conserved due to clamping to maximum velocity)\n\n");

	// clean up
	for (i = 0; i < numsteps; i++)
	{
		LBM3DField_Free(&fieldevolv[i]);
	}
	free(fieldevolv);
	LBM3DField_Free(&startfield);

	return 0;
}
