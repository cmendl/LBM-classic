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

// Demonstration file in 2D with free surfaces (fluid to gas interface)


#include "lbm2D.h"
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
static inline real LBM2DField_AverageMass(const lbm_field2D_t *field)
{
	int x, y;

	real mass = 0;
	for (y = 0; y < SIZE_2D_Y; y++)
	{
		for (x = 0; x < SIZE_2D_X; x++)
		{
			// current cell
			const dfD2Q9_t *df = LBM2DField_Get(field, x, y);
			mass += df->mass;
		}
	}

	// normalization
	mass /= (SIZE_2D_X*SIZE_2D_Y);

	return mass;
}


//_______________________________________________________________________________________________________________________
//


int main()
{
	int i;
	int x, y;

	const real omega = 0.2f;
	const int numsteps = 128;
	const vec2_t gravity = { 0, (real)(-0.1) };

	printf("dimensions: %d x %d\n", SIZE_2D_X, SIZE_2D_Y);
	printf("omega:      %g\n", omega);
	printf("numsteps:   %d\n", numsteps);
	printf("gravity:    (%g, %g)\n", gravity.x, gravity.y);

	// cell types
	const int type0[SIZE_2D_X][SIZE_2D_Y] = {
		{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
		{ 1, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 1 },
		{ 1, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 1 },
		{ 1, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 1 },
		{ 1, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 4, 4, 4, 4, 4, 4, 8, 8, 8, 1 },
		{ 1, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 4, 2, 2, 2, 2, 2, 4, 4, 8, 8, 1 },
		{ 1, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 2, 2, 2, 2, 2, 2, 2, 4, 8, 8, 1 },
		{ 1, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 2, 2, 2, 2, 2, 2, 2, 4, 8, 8, 1 },
		{ 1, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 2, 2, 2, 2, 2, 2, 2, 4, 8, 8, 1 },
		{ 1, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 2, 2, 2, 2, 2, 2, 2, 4, 8, 8, 1 },
		{ 1, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 2, 2, 2, 2, 2, 2, 2, 4, 8, 8, 1 },
		{ 1, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 4, 2, 2, 2, 2, 2, 4, 4, 8, 8, 1 },
		{ 1, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 4, 4, 4, 4, 4, 4, 8, 8, 8, 1 },
		{ 1, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 1 },
		{ 1, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 1 },
		{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
	};

	// enable run-time memory check for debug builds
	#if defined(_WIN32) & (defined(DEBUG) | defined(_DEBUG))
	_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF);
	#endif

	// load initial distribution function data from disk
	real f0[SIZE_2D_X*SIZE_2D_Y*9];
	int hr = ReadData("../test/lbm_sim2D_freesurf_f0.dat", f0, sizeof(real), SIZE_2D_X*SIZE_2D_Y*9);
	if (hr < 0) {
		fprintf(stderr, "File containing distribution function data not found, exiting...\n");
		return hr;
	}

	// allocate and initialize start field
	lbm_field2D_t startfield;
	LBM2DField_Allocate(omega, &startfield);
	for (y = 0; y < SIZE_2D_Y; y++)
	{
		for (x = 0; x < SIZE_2D_X; x++)
		{
			// data stored with row-major ordering
			DFD2Q9_Init(type0[x][y], &f0[9*(x*SIZE_2D_Y + y)], LBM2DField_GetMod(&startfield, x, y));
		}
	}

	lbm_field2D_t *fieldevolv;
	fieldevolv = (lbm_field2D_t *)malloc(numsteps*sizeof(lbm_field2D_t));

	// start timer
	clock_t t_start = clock();

	// perform main calculation
	LatticeBoltzmann2DEvolution(&startfield, numsteps, gravity, fieldevolv);

	clock_t t_end = clock();
	double cpu_time = (double)(t_end - t_start) / CLOCKS_PER_SEC;
	printf("finished simulation, CPU time: %g\n", cpu_time);

	// check mass conservation
	real mass_init  = LBM2DField_AverageMass(&fieldevolv[0]);
	real mass_final = LBM2DField_AverageMass(&fieldevolv[numsteps-1]);
	printf("initial average mass: %g\n", mass_init);
	printf("final   average mass: %g\n", mass_final);
	printf("relative difference:  %g\n", fabsf(mass_final/mass_init - 1));
	printf("(mass not exactly conserved due to excess mass which cannot be distributed)\n\n");

	// clean up
	for (i = 0; i < numsteps; i++)
	{
		LBM2DField_Free(&fieldevolv[i]);
	}
	free(fieldevolv);
	LBM2DField_Free(&startfield);

	return 0;
}
