/// \file lbm3D.c
/// \brief D3Q19 model implementation.
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


#include "lbm3D.h"
#include "util.h"
#include <stdlib.h>
#include <memory.h>


//_______________________________________________________________________________________________________________________
//


/// \brief Velocity vectors for D3Q19 as integers
static const int vel3Di[19][3] = {
	{  0,  0,  0 },		// zero direction
	{ -1,  0,  0 },		// 6 directions with velocity 1
	{  1,  0,  0 },
	{  0, -1,  0 },
	{  0,  1,  0 },
	{  0,  0, -1 },
	{  0,  0,  1 },
	{ -1, -1,  0 },		// 12 directions with velocity sqrt(2)
	{ -1,  1,  0 },
	{  1, -1,  0 },
	{  1,  1,  0 },
	{  0, -1, -1 },
	{  0, -1,  1 },
	{  0,  1, -1 },
	{  0,  1,  1 },
	{ -1,  0, -1 },
	{ -1,  0,  1 },
	{  1,  0, -1 },
	{  1,  0,  1 },
};

/// \brief Velocity vectors for D3Q19 as floating-point values
static const vec3_t vel3Dv[19] = {
	{  0,  0,  0 },		// zero direction
	{ -1,  0,  0 },		// 6 directions with velocity 1
	{  1,  0,  0 },
	{  0, -1,  0 },
	{  0,  1,  0 },
	{  0,  0, -1 },
	{  0,  0,  1 },
	{ -1, -1,  0 },		// 12 directions with velocity sqrt(2)
	{ -1,  1,  0 },
	{  1, -1,  0 },
	{  1,  1,  0 },
	{  0, -1, -1 },
	{  0, -1,  1 },
	{  0,  1, -1 },
	{  0,  1,  1 },
	{ -1,  0, -1 },
	{ -1,  0,  1 },
	{  1,  0, -1 },
	{  1,  0,  1 },
};

/// \brief Index of inverse direction
static const int invVel3D[19] = { 0, 2, 1, 4, 3, 6, 5, 10, 9, 8, 7, 14, 13, 12, 11, 18, 17, 16, 15 };


//_______________________________________________________________________________________________________________________
//


/// \brief D3Q19 weights
static const real weights3D[19] = { (real)1./3,
	(real)1./18, (real)1./18, (real)1./18, (real)1./18, (real)1./18, (real)1./18,
	(real)1./36, (real)1./36, (real)1./36, (real)1./36, (real)1./36, (real)1./36, (real)1./36, (real)1./36, (real)1./36, (real)1./36, (real)1./36, (real)1./36 };



//_______________________________________________________________________________________________________________________
///
/// \brief Calculate derived quantities density and velocity from distribution functions
///
static inline void DFD3Q19_DeriveQuantities(dfD3Q19_t *df)
{
	int i;

	// calculate average density
	df->rho = 0;
	for (i = 0; i < 19; i++)
	{
		df->rho += df->f[i];
	}
	assert(df->rho >= 0);

	// calculate average velocity u
	df->u.x = 0;
	df->u.y = 0;
	df->u.z = 0;
	if (df->rho > 0)
	{
		for (i = 0; i < 19; i++)
		{
			df->u.x += df->f[i]*vel3Dv[i].x;
			df->u.y += df->f[i]*vel3Dv[i].y;
			df->u.z += df->f[i]*vel3Dv[i].z;
		}
		real s = 1 / df->rho;
		df->u.x *= s;
		df->u.y *= s;
		df->u.z *= s;
	}

	// rescale in case maximum velocity is exceeded
	real n = Vec3_Norm(df->u);
	if (n > v_max)
	{
		df->u = Vec3_ScalarMultiply(v_max/n, df->u);
	}
}


//_______________________________________________________________________________________________________________________
///
/// \brief Calculate the equilibrium distribution function
///
static inline void DFD3Q19_CalcEquilibrium(const vec3_t u, const real rho, real f_eq[19])
{
	int i;

	for (i = 0; i < 19; i++)
	{
		real eiu = Vec3_Dot(vel3Dv[i], u);
		real usq = Vec3_Dot(u, u);

		// note that f_eq[i] can be negative also
		f_eq[i] = weights3D[i]*rho*(1 + 3*eiu - ((real)1.5)*usq + ((real)4.5)*squaref(eiu));
	}
}


//_______________________________________________________________________________________________________________________
///
/// \brief Initialize D3Q19 structure
///
void DFD3Q19_Init(const int type, const real f[19], dfD3Q19_t *df)
{
	// initially set all values to zero
	memset(df, 0, sizeof(dfD3Q19_t));

	// copy cell type
	df->type = type;

	if (type & CT_FLUID)
	{
		// distribution functions and derived quantities
		memcpy(df->f, f, 19*sizeof(real));
		DFD3Q19_DeriveQuantities(df);

		// fluid cells have same mass as density
		df->mass = df->rho;
	}
	else if (type & CT_INTERFACE)
	{
		// distribution functions and derived quantities
		memcpy(df->f, f, 19*sizeof(real));
		DFD3Q19_DeriveQuantities(df);

		// (arbitrarily) assign half-filled mass
		df->mass = 0.5f*df->rho;
	}
}


//_______________________________________________________________________________________________________________________
///
/// \brief Allocate memory for D3Q19 field
///
void LBM3DField_Allocate(const real omega, lbm_field3D_t *field)
{
	field->omega = omega;

	field->df = (dfD3Q19_t *)calloc(SIZE_3D_X*SIZE_3D_Y*SIZE_3D_Z, sizeof(dfD3Q19_t));
}

//_______________________________________________________________________________________________________________________
///
/// \brief Delete D3Q19 field (free memory)
///
void LBM3DField_Free(lbm_field3D_t *field)
{
	free(field->df);
}


//_______________________________________________________________________________________________________________________
///
/// \brief Collision step for D3Q19 (3 dimensions, 19 velocities)
///
static inline void CalculateLBMCollisionStep3D(const lbm_field3D_t *restrict_ f0, const vec3_t gravity, lbm_field3D_t *restrict_ f_coll)
{
	int x, y, z;
	int i;

	// copy omega value
	f_coll->omega = f0->omega;

	for (z = 0; z < SIZE_3D_Z; z++)
	{
		for (y = 0; y < SIZE_3D_Y; y++)
		{
			for (x = 0; x < SIZE_3D_X; x++)
			{
				// current cells
				const dfD3Q19_t *df = LBM3DField_Get(f0, x, y, z);
				dfD3Q19_t *df_coll  = LBM3DField_Get(f_coll, x, y, z);

				// copy cell type and mass
				df_coll->type = df->type;
				df_coll->mass = df->mass;

				// ignore obstacle and empty cells
				if (df->type & (CT_OBSTACLE | CT_EMPTY))
				{
					continue;
				}

				// calculate equilibrium distribution function
				real df_eq[19];
				DFD3Q19_CalcEquilibrium(df->u, df->rho, df_eq);

				// perform collision
				for (i = 0; i < 19; i++)
				{
					// Eq. (3.4)
					df_coll->f[i] = (1 - f0->omega)*df->f[i] + f0->omega*df_eq[i];

					// gravity
					df_coll->f[i] += df->rho*weights3D[i] * Vec3_Dot(vel3Dv[i], gravity);
				}

				// average density and velocity remain constant
				df_coll->rho = df->rho;
				df_coll->u   = df->u;
			}
		}
	}
}


//_______________________________________________________________________________________________________________________
///
/// \brief Calculate the epsilon parameter (mass to density ratio)
///
static inline real DFD3Q19_CalcEpsilon(const dfD3Q19_t *df)
{
	if (df->type & (CT_FLUID | CT_OBSTACLE))
	{
		return 1;
	}
	else if (df->type & CT_INTERFACE)
	{
		assert(df->rho >= 0);

		if (df->rho > 0)
		{
			real epsilon = df->mass / df->rho;

			// df->mass can even be < 0 or > df->rho for interface cells to be converted to fluid or empty cells in the next step;
			// clamp to [0,1] range for numerical stability
			if (epsilon > 1) {
				epsilon = 1;
			}
			else if (epsilon < 0) {
				epsilon = 0;
			}
			return epsilon;
		}
		else
		{
			// return (somewhat arbitrarily) a ratio of 1/2 
			return (real)0.5;
		}
	}
	else	// df->type & CT_EMPTY
	{
		assert(df->type & CT_EMPTY);

		return 0;
	}
}


//_______________________________________________________________________________________________________________________
///
/// \brief Approximate the free surface normal using central differences of fluid fractions (epsilon parameter)
///
static inline vec3_t LBM3DField_CalcNormal(const lbm_field3D_t *field, const int x, const int y, const int z)
{
	// Eq. (4.6)
	vec3_t normal;
	normal.x = 0.5f*(DFD3Q19_CalcEpsilon(LBM3DField_GetMod(field, x-1, y  , z  )) - DFD3Q19_CalcEpsilon(LBM3DField_GetMod(field, x+1, y  , z  )));
	normal.y = 0.5f*(DFD3Q19_CalcEpsilon(LBM3DField_GetMod(field, x,   y-1, z  )) - DFD3Q19_CalcEpsilon(LBM3DField_GetMod(field, x,   y+1, z  )));
	normal.z = 0.5f*(DFD3Q19_CalcEpsilon(LBM3DField_GetMod(field, x,   y,   z-1)) - DFD3Q19_CalcEpsilon(LBM3DField_GetMod(field, x,   y,   z+1)));

	return normal;
}


//_______________________________________________________________________________________________________________________
///
/// \brief Stream step for D3Q19 (3 dimensions, 19 velocities)
///
static inline void CalculateLBMStreamStep3D(const lbm_field3D_t *restrict_ f0, lbm_field3D_t *restrict_ f_strm)
{
	int x, y, z;
	int i;

	// copy omega value
	f_strm->omega = f0->omega;

	// stream step
	for (z = 0; z < SIZE_3D_Z; z++)
	{
		for (y = 0; y < SIZE_3D_Y; y++)
		{
			for (x = 0; x < SIZE_3D_X; x++)
			{
				const dfD3Q19_t *df = LBM3DField_Get(f0, x, y, z);
				dfD3Q19_t *df_strm  = LBM3DField_Get(f_strm, x, y, z);

				// copy cell type and mass
				df_strm->type = df->type;
				df_strm->mass = df->mass;

				// ignore obstacle and empty cells
				if (df->type & (CT_OBSTACLE | CT_EMPTY))
				{
					continue;
				}

				// copy distribution function corresponding to velocity zero
				df_strm->f[0] = df->f[0];

				if (df->type & CT_FLUID)
				{
					// for fluid cells, mass should be equal to density
					assert(df->mass == df->rho);

					for (i = 1; i < 19; i++)		// omit zero vector
					{
						// neighbor cell
						const dfD3Q19_t *df_neigh = LBM3DField_GetMod(f0, x - vel3Di[i][0], y - vel3Di[i][1], z - vel3Di[i][2]);

						// fluid cell must not be adjacent to an empty cell
						assert((df_neigh->type & CT_EMPTY) == 0);

						if (df_neigh->type & (CT_FLUID | CT_INTERFACE))
						{
							// mass exchange with fluid or interface cell, Eq. (4.2)
							df_strm->mass += (df_neigh->f[i] - df->f[invVel3D[i]]);

							// standard streaming, Eq. (3.1)
							df_strm->f[i] = df_neigh->f[i];
						}
						else	// df_neigh->type & CT_OBSTACLE
						{
							assert(df_neigh->type & CT_OBSTACLE);

							// reflect density functions, Eq. (3.5)
							df_strm->f[i] = df->f[invVel3D[i]];
						}
					}
				}
				else if (df->type & CT_INTERFACE)
				{
					const real epsilon = DFD3Q19_CalcEpsilon(df);

					// calculate atmospheric equilibrium distribution function
					real f_atm_eq[19];
					DFD3Q19_CalcEquilibrium(df->u, rhoA, f_atm_eq);

					for (i = 1; i < 19; i++)		// omit zero vector
					{
						// neighbor cell
						const dfD3Q19_t *df_neigh = LBM3DField_GetMod(f0, x - vel3Di[i][0], y - vel3Di[i][1], z - vel3Di[i][2]);

						if (df_neigh->type & CT_FLUID)
						{
							// mass exchange between fluid and interface cell, Eq. (4.2)
							df_strm->mass += (df_neigh->f[i] - df->f[invVel3D[i]]);

							// standard streaming, Eq. (3.1)
							df_strm->f[i] = df_neigh->f[i];
						}
						else if (df_neigh->type & CT_INTERFACE)
						{
							const real eps_neigh = DFD3Q19_CalcEpsilon(df_neigh);

							// mass exchange between two interface cells, Eq. (4.3)
							df_strm->mass += CalculateMassExchange(df->type, df_neigh->type, df_neigh->f[i], df->f[invVel3D[i]])
								* 0.5f*(eps_neigh + epsilon);

							// standard streaming, Eq. (3.1)
							df_strm->f[i] = df_neigh->f[i];
						}
						else if (df_neigh->type & CT_EMPTY)
						{
							// no mass exchange from or to empty cell

							// reconstructed atmospheric distribution function, Eq. (4.5)
							df_strm->f[i] = f_atm_eq[i] + f_atm_eq[invVel3D[i]] - df->f[invVel3D[i]];
						}
						else	// df_neigh->type & CT_OBSTACLE
						{
							assert(df_neigh->type & CT_OBSTACLE);

							// reflect density functions, Eq. (3.5)
							df_strm->f[i] = df->f[invVel3D[i]];
						}
					}

					// calculate surface normal
					const vec3_t normal = LBM3DField_CalcNormal(f0, x, y, z);

					// always use reconstructed atmospheric distribution function for directions along surface normal;
					// separate loop to handle mass exchange correctly
					for (i = 1; i < 19; i++)		// omit zero vector
					{
						if (Vec3_Dot(normal, vel3Dv[invVel3D[i]]) > 0)		// Eq. (4.6)
						{
							// reconstructed atmospheric distribution function, Eq. (4.5)
							df_strm->f[i] = f_atm_eq[i] + f_atm_eq[invVel3D[i]] - df->f[invVel3D[i]];
						}
					}

				}	// df->type & CT_INTERFACE


				// calculate average density and velocity
				DFD3Q19_DeriveQuantities(df_strm);

				// for fluid cells, set density exactly to mass to avoid numerical drift
				if (df_strm->type & CT_FLUID)
				{
					assert(fabs(df_strm->rho / df_strm->mass - 1) < 5e-6);
					df_strm->rho = df_strm->mass;
				}
			}
		}
	}
}


//_______________________________________________________________________________________________________________________
///
/// \brief Initialize 'df' with average density and velocity from cells surrounding (x,y,z)
///
static inline void LBM3DField_AverageSurrounding(const lbm_field3D_t *field, const int x, const int y, const int z, dfD3Q19_t *df)
{
	int i;
	int n = 0;	// counter

	// set mass initially to zero
	df->mass = 0;

	// average density and velocity of surrounding cells
	df->rho = 0;
	df->u.x = 0;
	df->u.y = 0;
	df->u.z = 0;
	for (i = 1; i < 19; i++)		// omit zero vector
	{
		dfD3Q19_t *df_neigh = LBM3DField_GetMod(field, x - vel3Di[i][0], y - vel3Di[i][1], z - vel3Di[i][2]);

		// fluid or interface cells only
		if (df_neigh->type & (CT_FLUID | CT_INTERFACE))
		{
			df->rho += df_neigh->rho;

			df->u.x += df_neigh->u.x;
			df->u.y += df_neigh->u.y;
			df->u.z += df_neigh->u.z;

			n++;
		}
	}
	if (n > 0)
	{
		df->rho /= n;
		df->u.x /= n;
		df->u.y /= n;
		df->u.z /= n;
	}

	// calculate equilibrium distribution function
	DFD3Q19_CalcEquilibrium(df->u, df->rho, df->f);
}


//_______________________________________________________________________________________________________________________
///
/// \brief Update the cell types after streaming for D3Q19 (3 dimensions, 19 velocities)
///
static inline void UpdateTypesLBMStep3D(const lbm_field3D_t *restrict_ f0, lbm_field3D_t *restrict_ f_distr, lbm_field3D_t *restrict_ f_next)
{
	// define additional temporary cell types; only for this function
	#define CT_IF_TO_FLUID		(1 << 7)
	#define CT_IF_TO_EMPTY		(1 << 8)

	int x, y, z;
	int i;

	// copy omega value
	f_next->omega = f0->omega;


	#define FILL_OFFSET			((real)0.003)
	#define LONELY_THRESH		((real)0.1)

	for (z = 0; z < SIZE_3D_Z; z++)
	{
		for (y = 0; y < SIZE_3D_Y; y++)
		{
			for (x = 0; x < SIZE_3D_X; x++)
			{
				// current cell
				const dfD3Q19_t *df = LBM3DField_Get(f0, x, y, z);
				dfD3Q19_t *df_next  = LBM3DField_Get(f_next, x, y, z);

				// copy values
				*df_next = *df;

				// check whether interface cells emptied or filled
				if (df_next->type & CT_INTERFACE)
				{
					// Eq. (4.7), and remove interface cell artifacts
					if ((df_next->mass > (1 + FILL_OFFSET) * df_next->rho) || (df_next->mass >= (1 - LONELY_THRESH)*df_next->rho && (df_next->type & CT_NO_EMPTY_NEIGH)))
					{
						// interface to fluid cell
						df_next->type = CT_IF_TO_FLUID;
					}
					else if ((df_next->mass < -FILL_OFFSET * df_next->rho)
						  || (df_next->mass <= LONELY_THRESH*df_next->rho && (df_next->type & CT_NO_FLUID_NEIGH))
						  || ((df_next->type & CT_NO_IFACE_NEIGH) && (df_next->type & CT_NO_FLUID_NEIGH)))		// isolated interface cell: only empty or obstacle neighbors
					{
						// interface to empty cell
						df_next->type = CT_IF_TO_EMPTY;
					}
				}

				// clear neighborhood flags (will be determined later)
				df_next->type &= ~(CT_NO_FLUID_NEIGH | CT_NO_EMPTY_NEIGH | CT_NO_IFACE_NEIGH);
			}
		}
	}

	// set flags for filled interface cells (interface to fluid)
	for (z = 0; z < SIZE_3D_Z; z++)
	{
		for (y = 0; y < SIZE_3D_Y; y++)
		{
			for (x = 0; x < SIZE_3D_X; x++)
			{
				// current cell
				dfD3Q19_t *df = LBM3DField_Get(f_next, x, y, z);

				if (df->type & CT_IF_TO_FLUID)
				{
					// keep flag 'CT_IF_TO_FLUID' for later excess mass distribution

					// convert neighboring empty cells to interface cells
					for (i = 1; i < 19; i++)		// omit zero vector
					{
						// neighbor cell
						int x_neigh = x - vel3Di[i][0];
						int y_neigh = y - vel3Di[i][1];
						int z_neigh = z - vel3Di[i][2];
						dfD3Q19_t *df_neigh = LBM3DField_GetMod(f_next, x_neigh, y_neigh, z_neigh);

						if (df_neigh->type & CT_EMPTY)
						{
							df_neigh->type = CT_INTERFACE;

							// initialize cell with average density and velocity of surrounding cells, using f0
							LBM3DField_AverageSurrounding(f0, x_neigh, y_neigh, z_neigh, df_neigh);
						}
					}

					// prevent neighboring cells from becoming empty
					for (i = 1; i < 19; i++)		// omit zero vector
					{
						// neighbor cell
						dfD3Q19_t *df_neigh = LBM3DField_GetMod(f_next, x - vel3Di[i][0], y - vel3Di[i][1], z - vel3Di[i][2]);

						if (df_neigh->type & CT_IF_TO_EMPTY)
						{
							df_neigh->type = CT_INTERFACE;
						}
					}
				}
			}
		}
	}

	// set flags for emptied interface cells (interface to empty)
	for (z = 0; z < SIZE_3D_Z; z++)
	{
		for (y = 0; y < SIZE_3D_Y; y++)
		{
			for (x = 0; x < SIZE_3D_X; x++)
			{
				// current cell
				dfD3Q19_t *df = LBM3DField_Get(f_next, x, y, z);

				if (df->type & CT_IF_TO_EMPTY)
				{
					// keep flag 'CT_IF_TO_EMPTY' for later excess mass distribution

					// convert neighboring fluid cells to interface cells
					for (i = 1; i < 19; i++)		// omit zero vector
					{
						// neighbor cell
						dfD3Q19_t *df_neigh = LBM3DField_GetMod(f_next, x - vel3Di[i][0], y - vel3Di[i][1], z - vel3Di[i][2]);

						if (df_neigh->type & CT_FLUID) {
							df_neigh->type = CT_INTERFACE;
						}
					}
				}
			}
		}
	}

	// distribute excess mass
	for (z = 0; z < SIZE_3D_Z; z++)
	{
		for (y = 0; y < SIZE_3D_Y; y++)
		{
			for (x = 0; x < SIZE_3D_X; x++)
			{
				// current cell
				dfD3Q19_t *df = LBM3DField_Get(f_next, x, y, z);

				// calculate surface normal using 'f0', such that excess mass distribution is independent of the filled cell ordering
				vec3_t normal = LBM3DField_CalcNormal(f0, x, y, z);

				// excess mass
				real mex;
				if (df->type & CT_IF_TO_FLUID)
				{
					mex = df->mass - df->rho;

					// after excess mass has been distributed, remaining mass equals density
					df->mass = df->rho;
				}
				else if (df->type & CT_IF_TO_EMPTY)
				{
					mex = df->mass;

					// flip sign of normal
					normal.x = -normal.x;
					normal.y = -normal.y;
					normal.z = -normal.z;

					// after negative excess mass has been distributed, remaining mass is zero
					df->mass = 0;
				}
				else
				{
					continue;
				}

				// Eq. (4.9)
				real eta[19] = { 0 };
				real eta_total = 0;
				unsigned int isIF[19] = { 0 };
				unsigned int numIF = 0;	// number of interface cell neighbors
				for (i = 1; i < 19; i++)		// omit zero vector
				{
					// neighbor cell in the direction of velocity vector
					dfD3Q19_t *df_neigh = LBM3DField_GetMod(f_next, x + vel3Di[i][0], y + vel3Di[i][1], z + vel3Di[i][2]);
					if (df_neigh->type & CT_INTERFACE)
					{
						eta[i] = Vec3_Dot(vel3Dv[i], normal);
						if (eta[i] < 0) {
							eta[i] = 0;
						}
						eta_total += eta[i];

						isIF[i] = 1;
						numIF++;
					}
				}

				// store excess mass to be distributed in 'f_distr';
				// don't actually distribute yet to ensure independence of cell traversal order

				// cell for excess mass distribution, store in distribution functions
				dfD3Q19_t *df_distr = LBM3DField_Get(f_distr, x, y, z);

				if (eta_total > 0)
				{
					real eta_fac = 1/eta_total;
					for (i = 1; i < 19; i++)		// omit zero vector
					{
						// eta[i] is zero for non-interface cells
						df_distr->f[i] = mex * eta[i]*eta_fac;
					}
				}
				else if (numIF > 0)
				{
					// distribute uniformly
					real mex_rel = mex / numIF;
					for (i = 1; i < 19; i++)		// omit zero vector
					{
						df_distr->f[i] = (isIF[i] ? mex_rel : 0);
					}
				}
				// else, excess mass cannot be distributed, i.e., has leaked
			}
		}
	}

	// collect distributed mass and finalize cell flags
	for (z = 0; z < SIZE_3D_Z; z++)
	{
		for (y = 0; y < SIZE_3D_Y; y++)
		{
			for (x = 0; x < SIZE_3D_X; x++)
			{
				// current cell
				dfD3Q19_t *df = LBM3DField_Get(f_next, x, y, z);

				if (df->type & CT_INTERFACE)
				{
					for (i = 1; i < 19; i++)		// omit zero vector
					{
						// neighbor cell from distribution field
						dfD3Q19_t *df_distr = LBM3DField_GetMod(f_distr, x - vel3Di[i][0], y - vel3Di[i][1], z - vel3Di[i][2]);
						df->mass += df_distr->f[i];
					}
				}
				else if (df->type & CT_IF_TO_FLUID)
				{
					df->type = CT_FLUID;
				}
				else if (df->type & CT_IF_TO_EMPTY)
				{
					df->type = CT_EMPTY;
				}

				assert((df->type &  (CT_OBSTACLE | CT_FLUID | CT_INTERFACE | CT_EMPTY)) != 0);
				assert((df->type & ~(CT_OBSTACLE | CT_FLUID | CT_INTERFACE | CT_EMPTY)) == 0);
			}
		}
	}

	// set cell neighborhood flags
	for (z = 0; z < SIZE_3D_Z; z++)
	{
		for (y = 0; y < SIZE_3D_Y; y++)
		{
			for (x = 0; x < SIZE_3D_X; x++)
			{
				// current cell
				dfD3Q19_t *df = LBM3DField_Get(f_next, x, y, z);

				// ignore obstacle cells
				if (df->type & CT_OBSTACLE) {
					continue;
				}

				// set "no ... neighbor" flags
				df->type |= (CT_NO_FLUID_NEIGH | CT_NO_EMPTY_NEIGH | CT_NO_IFACE_NEIGH);
				for (i = 1; i < 19; i++)		// omit zero vector
				{
					// neighbor cell
					dfD3Q19_t *df_neigh = LBM3DField_GetMod(f_next, x - vel3Di[i][0], y - vel3Di[i][1], z - vel3Di[i][2]);
					if (df_neigh->type & CT_FLUID)
					{
						// remove "no fluid neighbor" flag
						df->type &= ~CT_NO_FLUID_NEIGH;
					}
					else if (df_neigh->type & CT_EMPTY)
					{
						// remove "no empty neighbor" flag
						df->type &= ~CT_NO_EMPTY_NEIGH;
					}
					else if (df_neigh->type & CT_INTERFACE)
					{
						// remove "no interface neighbor" flag
						df->type &= ~CT_NO_IFACE_NEIGH;
					}
				}

				// both flags should not be set simultaneously
				if (df->type & CT_NO_EMPTY_NEIGH) {
					df->type &= ~CT_NO_FLUID_NEIGH;
				}
			}
		}
	}
}


//_______________________________________________________________________________________________________________________
///
/// \brief Implement the LBM step for D3Q19 (3 dimensions, 19 velocities)
///
static void CalculateLBMStep3D(const lbm_field3D_t *restrict_ f0, const vec3_t gravity, lbm_field3D_t *restrict_ f1)
{
	// allocate intermediate fields for collision, stream and cell type step
	lbm_field3D_t f_coll, f_strm, f_distr;
	LBM3DField_Allocate(f0->omega, &f_coll);
	LBM3DField_Allocate(f0->omega, &f_strm);
	LBM3DField_Allocate(f0->omega, &f_distr);

	// collision step
	CalculateLBMCollisionStep3D(f0, gravity, &f_coll);

	// stream step
	CalculateLBMStreamStep3D(&f_coll, &f_strm);

	// update cell types
	UpdateTypesLBMStep3D(&f_strm, &f_distr, f1);

	// clean up
	LBM3DField_Free(&f_distr);
	LBM3DField_Free(&f_strm);
	LBM3DField_Free(&f_coll);
}


//_______________________________________________________________________________________________________________________
///
/// \brief Lattice Boltzmann time evolution using D3Q19 (3 dimensions, 19 velocities)
///
void LatticeBoltzmann3DEvolution(const lbm_field3D_t *restrict_ startfield, const int numsteps, const vec3_t gravity, lbm_field3D_t *restrict_ fieldevolv)
{
	int it;

	// copy initial field
	LBM3DField_Allocate(startfield->omega, fieldevolv);
	memcpy(fieldevolv->df, startfield->df, SIZE_3D_X*SIZE_3D_Y*SIZE_3D_Z*sizeof(dfD3Q19_t));

	for (it = 1; it < numsteps; it++)
	{
		LBM3DField_Allocate(startfield->omega, &fieldevolv[it]);

		CalculateLBMStep3D(&fieldevolv[it-1], gravity, &fieldevolv[it]);
	}
}
