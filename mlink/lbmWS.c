/// \file lbmWS.c
/// \brief Mathematica WSTP interface.
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


#include "lbm2D.h"
#include "lbm3D.h"
#include "util.h"
#include <wstp.h>
#include <stdlib.h>
#include <string.h>


//_______________________________________________________________________________________________________________________
//

void LatticeBoltzmann(real omega, int numsteps, real *gravity, long gravitylen, real *f0, long f0len, int *type0, long type0len)
{
	int i, j;
	int x, y, z;

	// check range of omega parameter
	if (omega < 0 || omega > 2)
	{
		WSEvaluate(stdlink, "Message[LatticeBoltzmann::invalidOmega]");
		// discard 'ReturnPacket'
		WSNextPacket(stdlink);
		WSNewPacket(stdlink);	// discard
		// final output
		WSPutSymbol(stdlink, "$Failed");
		return;
	}

	if (gravitylen == 2)
	{
		if (f0len != 9*SIZE_2D_X*SIZE_2D_Y)
		{
			WSEvaluate(stdlink, "Message[LatticeBoltzmann::invalidDimensionf0]");
			// discard 'ReturnPacket'
			WSNextPacket(stdlink);
			WSNewPacket(stdlink);	// discard
			// final output
			WSPutSymbol(stdlink, "$Failed");
			return;
		}
		if (type0len != SIZE_2D_X*SIZE_2D_Y)
		{
			WSEvaluate(stdlink, "Message[LatticeBoltzmann::invalidDimensionType0]");
			// discard 'ReturnPacket'
			WSNextPacket(stdlink);
			WSNewPacket(stdlink);	// discard
			// final output
			WSPutSymbol(stdlink, "$Failed");
			return;
		}

		// allocate and initialize start field
		lbm_field2D_t startfield;
		LBM2DField_Allocate(omega, &startfield);
		for (y = 0; y < SIZE_2D_Y; y++)
		{
			for (x = 0; x < SIZE_2D_X; x++)
			{
				// Mathematica uses row-major ordering
				j = x*SIZE_2D_Y + y;
				DFD2Q9_Init(type0[j], &f0[9*j], LBM2DField_Get(&startfield, x, y));
			}
		}

		lbm_field2D_t *fieldevolv = (lbm_field2D_t *)malloc(numsteps*sizeof(lbm_field2D_t));
		if (fieldevolv == NULL)
		{
			WSEvaluate(stdlink, "Message[LatticeBoltzmann::outOfMemory]");
			// discard 'ReturnPacket'
			WSNextPacket(stdlink);
			WSNewPacket(stdlink);	// discard
			// final output
			WSPutSymbol(stdlink, "$Failed");
			return;
		}

		// perform main calculation
		LatticeBoltzmann2DEvolution(&startfield, numsteps, *(real2 *)gravity, fieldevolv);

		// return results to Mathematica
		WSPutFunction(stdlink, "List", 3);

		// cell types
		WSPutFunction(stdlink, "List", numsteps);
		for (i = 0; i < numsteps; i++)
		{
			int *type = (int *)malloc(SIZE_2D_X*SIZE_2D_Y * sizeof(int));
			for (y = 0; y < SIZE_2D_Y; y++)
			{
				for (x = 0; x < SIZE_2D_X; x++)
				{
					// Mathematica uses row-major ordering
					j = x*SIZE_2D_Y + y;
					type[j] = LBM2DField_Get(&fieldevolv[i], x, y)->type & ~(CT_NO_FLUID_NEIGH | CT_NO_EMPTY_NEIGH | CT_NO_IFACE_NEIGH);
				}
			}

			int dims[2] = { SIZE_2D_X, SIZE_2D_Y };
			WSPutInteger32Array(stdlink, type, dims, NULL, 2);

			free(type);
		}

		// distribution functions
		WSPutFunction(stdlink, "List", numsteps);
		for (i = 0; i < numsteps; i++)
		{
			real *f = (real *)malloc(9*SIZE_2D_X*SIZE_2D_Y * sizeof(real));
			for (y = 0; y < SIZE_2D_Y; y++)
			{
				for (x = 0; x < SIZE_2D_X; x++)
				{
					// Mathematica uses row-major ordering
					j = x*SIZE_2D_Y + y;
					memcpy(&f[9*j], LBM2DField_Get(&fieldevolv[i], x, y)->f, 9*sizeof(real));
				}
			}

			int dims[3] = { SIZE_2D_X, SIZE_2D_Y, 9 };
			WSPutReal32Array(stdlink, f, dims, NULL, 3);

			free(f);
		}

		// cell masses
		WSPutFunction(stdlink, "List", numsteps);
		for (i = 0; i < numsteps; i++)
		{
			real *mass = (real *)malloc(SIZE_2D_X*SIZE_2D_Y * sizeof(real));

			for (y = 0; y < SIZE_2D_Y; y++)
			{
				for (x = 0; x < SIZE_2D_X; x++)
				{
					const dfD2Q9_t *df = LBM2DField_Get(&fieldevolv[i], x, y);

					// Mathematica uses row-major ordering
					j = x*SIZE_2D_Y + y;

					mass[j] = df->mass;
				}
			}

			int dims[2] = { SIZE_2D_X, SIZE_2D_Y };
			WSPutReal32Array(stdlink, mass, dims, NULL, 2);

			free(mass);
		}

		WSEndPacket(stdlink);
		WSFlush(stdlink);

		// clean up
		for (i = 0; i < numsteps; i++)
		{
			LBM2DField_Free(&fieldevolv[i]);
		}
		LBM2DField_Free(&startfield);
		free(fieldevolv);
	}
	else if (gravitylen == 3)
	{
		if (f0len != 19*SIZE_3D_X*SIZE_3D_Y*SIZE_3D_Z)
		{
			WSEvaluate(stdlink, "Message[LatticeBoltzmann::invalidDimensionf0]");
			// discard 'ReturnPacket'
			WSNextPacket(stdlink);
			WSNewPacket(stdlink);	// discard
			// final output
			WSPutSymbol(stdlink, "$Failed");
			return;
		}
		if (type0len != SIZE_3D_X*SIZE_3D_Y*SIZE_3D_Z)
		{
			WSEvaluate(stdlink, "Message[LatticeBoltzmann::invalidDimensionType0]");
			// discard 'ReturnPacket'
			WSNextPacket(stdlink);
			WSNewPacket(stdlink);	// discard
			// final output
			WSPutSymbol(stdlink, "$Failed");
			return;
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
					// Mathematica uses row-major ordering
					j = (x*SIZE_3D_Y + y)*SIZE_3D_Z + z;
					DFD3Q19_Init(type0[j], &f0[19*j], LBM3DField_Get(&startfield, x, y, z));
				}
			}
		}

		lbm_field3D_t *fieldevolv = (lbm_field3D_t *)malloc(numsteps*sizeof(lbm_field3D_t));
		if (fieldevolv == NULL)
		{
			WSEvaluate(stdlink, "Message[LatticeBoltzmann::outOfMemory]");
			// discard 'ReturnPacket'
			WSNextPacket(stdlink);
			WSNewPacket(stdlink);	// discard
			// final output
			WSPutSymbol(stdlink, "$Failed");
			return;
		}

		// perform main calculation
		LatticeBoltzmann3DEvolution(&startfield, numsteps, *(real3 *)gravity, fieldevolv);

		// return results to Mathematica
		WSPutFunction(stdlink, "List", 3);

		// cell types
		WSPutFunction(stdlink, "List", numsteps);
		for (i = 0; i < numsteps; i++)
		{
			int *type = (int *)malloc(SIZE_3D_X*SIZE_3D_Y*SIZE_3D_Z * sizeof(int));
			for (z = 0; z < SIZE_3D_Z; z++)
			{
				for (y = 0; y < SIZE_3D_Y; y++)
				{
					for (x = 0; x < SIZE_3D_X; x++)
					{
						// Mathematica uses row-major ordering
						j = (x*SIZE_3D_Y + y)*SIZE_3D_Z + z;
						type[j] = LBM3DField_Get(&fieldevolv[i], x, y, z)->type & ~(CT_NO_FLUID_NEIGH | CT_NO_EMPTY_NEIGH | CT_NO_IFACE_NEIGH);
					}
				}
			}

			int dims[3] = { SIZE_3D_X, SIZE_3D_Y, SIZE_3D_Z };
			WSPutInteger32Array(stdlink, type, dims, NULL, 3);

			free(type);
		}

		// distribution functions
		WSPutFunction(stdlink, "List", numsteps);
		for (i = 0; i < numsteps; i++)
		{
			real *f = (real *)malloc(19*SIZE_3D_X*SIZE_3D_Y*SIZE_3D_Z * sizeof(real));
			for (z = 0; z < SIZE_3D_Z; z++)
			{
				for (y = 0; y < SIZE_3D_Y; y++)
				{
					for (x = 0; x < SIZE_3D_X; x++)
					{
						// Mathematica uses row-major ordering
						j = (x*SIZE_3D_Y + y)*SIZE_3D_Z + z;
						memcpy(&f[19*j], LBM3DField_Get(&fieldevolv[i], x, y, z)->f, 19*sizeof(real));
					}
				}
			}

			int dims[4] = { SIZE_3D_X, SIZE_3D_Y, SIZE_3D_Z, 19 };
			WSPutReal32Array(stdlink, f, dims, NULL, 4);

			free(f);
		}

		// cell masses
		WSPutFunction(stdlink, "List", numsteps);
		for (i = 0; i < numsteps; i++)
		{
			real *mass = (real *)malloc(SIZE_3D_X*SIZE_3D_Y*SIZE_3D_Z * sizeof(real));

			for (z = 0; z < SIZE_3D_Z; z++)
			{
				for (y = 0; y < SIZE_3D_Y; y++)
				{
					for (x = 0; x < SIZE_3D_X; x++)
					{
						const dfD3Q19_t *df = LBM3DField_Get(&fieldevolv[i], x, y, z);

						// Mathematica uses row-major ordering
						j = (x*SIZE_3D_Y + y)*SIZE_3D_Z + z;

						mass[j] = df->mass;
					}
				}
			}

			int dims[3] = { SIZE_3D_X, SIZE_3D_Y, SIZE_3D_Z };
			WSPutReal32Array(stdlink, mass, dims, NULL, 3);

			free(mass);
		}

		WSEndPacket(stdlink);
		WSFlush(stdlink);

		// clean up
		for (i = 0; i < numsteps; i++)
		{
			LBM3DField_Free(&fieldevolv[i]);
		}
		LBM3DField_Free(&startfield);
		free(fieldevolv);
	}
}


//_______________________________________________________________________________________________________________________
//


#if MACINTOSH_WSTP

int main(int argc, char* argv[])
{
	/* Due to a bug in some standard C libraries that have shipped with
	 * MPW, zero is passed to WSMain below.  (If you build this program
	 * as an MPW tool, you can change the zero to argc.)
	 */
	argc = argc; /* suppress warning */
	return WSMain(0, argv);
}

#elif WINDOWS_WSTP

#if __BORLANDC__
#pragma argsused
#endif

int PASCAL WinMain(HINSTANCE hinstCurrent, HINSTANCE hinstPrevious, LPSTR lpszCmdLine, int nCmdShow)
{
	char  buff[512];
	char FAR * buff_start = buff;
	char FAR * argv[32];
	char FAR * FAR * argv_end = argv + 32;

	hinstPrevious = hinstPrevious; /* suppress warning */

	if (!WSInitializeIcon(hinstCurrent, nCmdShow)) return 1;
	WSScanString(argv, &argv_end, &lpszCmdLine, &buff_start);
	return WSMain((int)(argv_end - argv), argv);
}

#else

int main(int argc, char* argv[])
{
	return WSMain(argc, argv);
}

#endif
