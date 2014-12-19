/// \file lbm2D.c
/// \brief D2Q9 model implementation.
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
#include "util.h"
#include <stdlib.h>
#include <memory.h>


//_______________________________________________________________________________________________________________________
//


/// \brief Velocity vectors for D2Q9 as integers
static const int vel2Di[9][2] = {
	{  0,  0 },		// zero direction
	{ -1,  0 },		// 4 directions with velocity 1
	{  1,  0 },
	{  0, -1 },
	{  0,  1 },
	{ -1, -1 },		// 4 directions with velocity sqrt(2)
	{ -1,  1 },
	{  1, -1 },
	{  1,  1 },
};

/// \brief Velocity vectors for D2Q9 as floating-point values
static const vec2_t vel2Dv[9] = {
	{  0,  0 },		// zero direction
	{ -1,  0 },		// 4 directions with velocity 1
	{  1,  0 },
	{  0, -1 },
	{  0,  1 },
	{ -1, -1 },		// 4 directions with velocity sqrt(2)
	{ -1,  1 },
	{  1, -1 },
	{  1,  1 },
};

/// \brief Index of inverse direction
static const int invVel2D[9] = { 0, 2, 1, 4, 3, 8, 7, 6, 5 };


//_______________________________________________________________________________________________________________________
//


/// \brief D2Q9 weights
static const real weights2D[9] = { (real)4./9,
	(real)1./ 9, (real)1./ 9, (real)1./ 9, (real)1./ 9,
	(real)1./36, (real)1./36, (real)1./36, (real)1./36 };


//_______________________________________________________________________________________________________________________
///
/// \brief Calculate derived quantities density and velocity from distribution functions
///
static inline void DFD2Q9_DeriveQuantities(dfD2Q9_t *df)
{
	int i;

	// calculate average density
	df->rho = 0;
	for (i = 0; i < 9; i++)
	{
		df->rho += df->f[i];
	}
	assert(df->rho >= 0);

	// calculate average velocity u
	df->u.x = 0;
	df->u.y = 0;
	if (df->rho > 0)
	{
		for (i = 0; i < 9; i++)
		{
			df->u.x += df->f[i]*vel2Dv[i].x;
			df->u.y += df->f[i]*vel2Dv[i].y;
		}
		real s = 1 / df->rho;
		df->u.x *= s;
		df->u.y *= s;
	}

	// rescale in case maximum velocity is exceeded
	real n = Vec2_Norm(df->u);
	if (n > v_max)
	{
		df->u = Vec2_ScalarMultiply(v_max/n, df->u);
	}
}


//_______________________________________________________________________________________________________________________
///
/// \brief Calculate the equilibrium distribution function
///
static inline void DFD2Q9_CalcEquilibrium(const vec2_t u, const real rho, real f_eq[9])
{
	int i;

	for (i = 0; i < 9; i++)
	{
		real eiu = Vec2_Dot(vel2Dv[i], u);
		real usq = Vec2_Dot(u, u);

		// note that f_eq[i] can be negative also
		f_eq[i] = weights2D[i]*rho*(1 + 3*eiu - ((real)1.5)*usq + ((real)4.5)*squaref(eiu));
	}
}


//_______________________________________________________________________________________________________________________
///
/// \brief Initialize D2Q9 structure
///
void DFD2Q9_Init(const int type, const real f[9], dfD2Q9_t *df)
{
	// initially set all values to zero
	memset(df, 0, sizeof(dfD2Q9_t));

	// copy cell type
	df->type = type;

	if (type & CT_FLUID)
	{
		// distribution functions and derived quantities
		memcpy(df->f, f, 9*sizeof(real));
		DFD2Q9_DeriveQuantities(df);

		// fluid cells have same mass as density
		df->mass = df->rho;
	}
	else if (type & CT_INTERFACE)
	{
		// distribution functions and derived quantities
		memcpy(df->f, f, 9*sizeof(real));
		DFD2Q9_DeriveQuantities(df);

		// (arbitrarily) assign half-filled mass
		df->mass = 0.5f*df->rho;
	}
}


//_______________________________________________________________________________________________________________________
///
/// \brief Allocate memory for D2Q9 field
///
void LBM2DField_Allocate(const real omega, lbm_field2D_t *field)
{
	field->omega = omega;

	field->df = (dfD2Q9_t *)calloc(SIZE_2D_X*SIZE_2D_Y, sizeof(dfD2Q9_t));
}

//_______________________________________________________________________________________________________________________
///
/// \brief Delete D2Q9 field (free memory)
///
void LBM2DField_Free(lbm_field2D_t *field)
{
	free(field->df);
}


//_______________________________________________________________________________________________________________________
///
/// \brief Collision step for D2Q9 (2 dimensions, 9 velocities)
///
static inline void CalculateLBMCollisionStep2D(const lbm_field2D_t *restrict_ f0, const vec2_t gravity, lbm_field2D_t *restrict_ f_coll)
{
	int x, y;
	int i;

	// copy omega value
	f_coll->omega = f0->omega;

	for (y = 0; y < SIZE_2D_Y; y++)
	{
		for (x = 0; x < SIZE_2D_X; x++)
		{
			// current cells
			const dfD2Q9_t *df = LBM2DField_Get(f0, x, y);
			dfD2Q9_t *df_coll  = LBM2DField_Get(f_coll, x, y);

			// copy cell type and mass
			df_coll->type = df->type;
			df_coll->mass = df->mass;

			// ignore obstacle and empty cells
			if (df->type & (CT_OBSTACLE | CT_EMPTY))
			{
				continue;
			}

			// calculate equilibrium distribution function
			real df_eq[9];
			DFD2Q9_CalcEquilibrium(df->u, df->rho, df_eq);

			// perform collision
			for (i = 0; i < 9; i++)
			{
				// Eq. (3.4)
				df_coll->f[i] = (1 - f0->omega)*df->f[i] + f0->omega*df_eq[i];

				// gravity
				df_coll->f[i] += df->rho*weights2D[i] * Vec2_Dot(vel2Dv[i], gravity);
			}

			// average density and velocity remain constant
			df_coll->rho = df->rho;
			df_coll->u   = df->u;
		}
	}
}


//_______________________________________________________________________________________________________________________
///
/// \brief Calculate the epsilon parameter (mass to density ratio)
///
static inline real DFD2Q9_CalcEpsilon(const dfD2Q9_t *df)
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
static inline vec2_t LBM2DField_CalcNormal(const lbm_field2D_t *field, const int x, const int y)
{
	// Eq. (4.6)
	vec2_t normal;
	normal.x = 0.5f*(DFD2Q9_CalcEpsilon(LBM2DField_GetMod(field, x-1, y  )) - DFD2Q9_CalcEpsilon(LBM2DField_GetMod(field, x+1, y  )));
	normal.y = 0.5f*(DFD2Q9_CalcEpsilon(LBM2DField_GetMod(field, x,   y-1)) - DFD2Q9_CalcEpsilon(LBM2DField_GetMod(field, x,   y+1)));

	return normal;
}


//_______________________________________________________________________________________________________________________
///
/// \brief Stream step for D2Q9 (2 dimensions, 9 velocities)
///
static inline void CalculateLBMStreamStep2D(const lbm_field2D_t *restrict_ f0, lbm_field2D_t *restrict_ f_strm)
{
	int x, y;
	int i;

	// copy omega value
	f_strm->omega = f0->omega;

	// stream step
	for (y = 0; y < SIZE_2D_Y; y++)
	{
		for (x = 0; x < SIZE_2D_X; x++)
		{
			const dfD2Q9_t *df = LBM2DField_Get(f0, x, y);
			dfD2Q9_t *df_strm  = LBM2DField_Get(f_strm, x, y);

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

				for (i = 1; i < 9; i++)		// omit zero vector
				{
					// neighbor cell
					const dfD2Q9_t *df_neigh = LBM2DField_GetMod(f0, x - vel2Di[i][0], y - vel2Di[i][1]);

					// fluid cell must not be adjacent to an empty cell
					assert((df_neigh->type & CT_EMPTY) == 0);

					if (df_neigh->type & (CT_FLUID | CT_INTERFACE))
					{
						// mass exchange with fluid or interface cell, Eq. (4.2)
						df_strm->mass += (df_neigh->f[i] - df->f[invVel2D[i]]);

						// standard streaming, Eq. (3.1)
						df_strm->f[i] = df_neigh->f[i];
					}
					else	// df_neigh->type & CT_OBSTACLE
					{
						assert(df_neigh->type & CT_OBSTACLE);

						// reflect density functions, Eq. (3.5)
						df_strm->f[i] = df->f[invVel2D[i]];
					}
				}
			}
			else if (df->type & CT_INTERFACE)
			{
				const real epsilon = DFD2Q9_CalcEpsilon(df);

				// calculate atmospheric equilibrium distribution function
				real f_atm_eq[9];
				DFD2Q9_CalcEquilibrium(df->u, rhoA, f_atm_eq);

				for (i = 1; i < 9; i++)		// omit zero vector
				{
					// neighbor cell
					const dfD2Q9_t *df_neigh = LBM2DField_GetMod(f0, x - vel2Di[i][0], y - vel2Di[i][1]);

					if (df_neigh->type & CT_FLUID)
					{
						// mass exchange between fluid and interface cell, Eq. (4.2)
						df_strm->mass += (df_neigh->f[i] - df->f[invVel2D[i]]);

						// standard streaming, Eq. (3.1)
						df_strm->f[i] = df_neigh->f[i];
					}
					else if (df_neigh->type & CT_INTERFACE)
					{
						const real eps_neigh = DFD2Q9_CalcEpsilon(df_neigh);

						// mass exchange between two interface cells, Eq. (4.3)
						df_strm->mass += CalculateMassExchange(df->type, df_neigh->type, df_neigh->f[i], df->f[invVel2D[i]])
							* 0.5f*(eps_neigh + epsilon);

						// standard streaming, Eq. (3.1)
						df_strm->f[i] = df_neigh->f[i];
					}
					else if (df_neigh->type & CT_EMPTY)
					{
						// no mass exchange from or to empty cell

						// reconstructed atmospheric distribution function, Eq. (4.5)
						df_strm->f[i] = f_atm_eq[i] + f_atm_eq[invVel2D[i]] - df->f[invVel2D[i]];
					}
					else	// df_neigh->type & CT_OBSTACLE
					{
						assert(df_neigh->type & CT_OBSTACLE);

						// reflect density functions, Eq. (3.5)
						df_strm->f[i] = df->f[invVel2D[i]];
					}
				}

				// calculate surface normal
				const vec2_t normal = LBM2DField_CalcNormal(f0, x, y);

				// always use reconstructed atmospheric distribution function for directions along surface normal;
				// separate loop to handle mass exchange correctly
				for (i = 1; i < 9; i++)		// omit zero vector
				{
					if (Vec2_Dot(normal, vel2Dv[invVel2D[i]]) > 0)		// Eq. (4.6)
					{
						// reconstructed atmospheric distribution function, Eq. (4.5)
						df_strm->f[i] = f_atm_eq[i] + f_atm_eq[invVel2D[i]] - df->f[invVel2D[i]];
					}
				}

			}	// df->type & CT_INTERFACE


			// calculate average density and velocity
			DFD2Q9_DeriveQuantities(df_strm);

			// for fluid cells, set density exactly to mass to avoid numerical drift
			if (df_strm->type & CT_FLUID)
			{
				assert(fabs(df_strm->rho / df_strm->mass - 1) < 5e-6);
				df_strm->rho = df_strm->mass;
			}
		}
	}
}


//_______________________________________________________________________________________________________________________
///
/// \brief Initialize 'df' with average density and velocity from cells surrounding (x,y)
///
static inline void LBM2DField_AverageSurrounding(const lbm_field2D_t *field, const int x, const int y, dfD2Q9_t *df)
{
	int i;
	int n = 0;	// counter

	// set mass initially to zero
	df->mass = 0;

	// average density and velocity of surrounding cells
	df->rho = 0;
	df->u.x = 0;
	df->u.y = 0;
	for (i = 1; i < 9; i++)		// omit zero vector
	{
		dfD2Q9_t *df_neigh = LBM2DField_GetMod(field, x - vel2Di[i][0], y - vel2Di[i][1]);

		// fluid or interface cells only
		if (df_neigh->type & (CT_FLUID | CT_INTERFACE))
		{
			df->rho += df_neigh->rho;

			df->u.x += df_neigh->u.x;
			df->u.y += df_neigh->u.y;

			n++;
		}
	}
	if (n > 0)
	{
		df->rho /= n;
		df->u.x /= n;
		df->u.y /= n;
	}

	// calculate equilibrium distribution function
	DFD2Q9_CalcEquilibrium(df->u, df->rho, df->f);
}


//_______________________________________________________________________________________________________________________
///
/// \brief Update the cell types after streaming for D2Q9 (2 dimensions, 9 velocities)
///
static inline void UpdateTypesLBMStep2D(const lbm_field2D_t *restrict_ f0, lbm_field2D_t *restrict_ f_distr, lbm_field2D_t *restrict_ f_next)
{
	// define additional temporary cell types; only for this function
	#define CT_IF_TO_FLUID		(1 << 7)
	#define CT_IF_TO_EMPTY		(1 << 8)

	int x, y;
	int i;

	// copy omega value
	f_next->omega = f0->omega;


	#define FILL_OFFSET			((real)0.003)
	#define LONELY_THRESH		((real)0.1)

	for (y = 0; y < SIZE_2D_Y; y++)
	{
		for (x = 0; x < SIZE_2D_X; x++)
		{
			// current cell
			const dfD2Q9_t *df = LBM2DField_Get(f0, x, y);
			dfD2Q9_t *df_next  = LBM2DField_Get(f_next, x, y);

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

	// set flags for filled interface cells (interface to fluid)
	for (y = 0; y < SIZE_2D_Y; y++)
	{
		for (x = 0; x < SIZE_2D_X; x++)
		{
			// current cell
			dfD2Q9_t *df = LBM2DField_Get(f_next, x, y);

			if (df->type & CT_IF_TO_FLUID)
			{
				// keep flag 'CT_IF_TO_FLUID' for later excess mass distribution

				// convert neighboring empty cells to interface cells
				for (i = 1; i < 9; i++)		// omit zero vector
				{
					// neighbor cell
					int x_neigh = x - vel2Di[i][0];
					int y_neigh = y - vel2Di[i][1];
					dfD2Q9_t *df_neigh = LBM2DField_GetMod(f_next, x_neigh, y_neigh);

					if (df_neigh->type & CT_EMPTY)
					{
						df_neigh->type = CT_INTERFACE;

						// initialize cell with average density and velocity of surrounding cells, using f0
						LBM2DField_AverageSurrounding(f0, x_neigh, y_neigh, df_neigh);
					}
				}

				// prevent neighboring cells from becoming empty
				for (i = 1; i < 9; i++)		// omit zero vector
				{
					// neighbor cell
					dfD2Q9_t *df_neigh = LBM2DField_GetMod(f_next, x - vel2Di[i][0], y - vel2Di[i][1]);

					if (df_neigh->type & CT_IF_TO_EMPTY)
					{
						df_neigh->type = CT_INTERFACE;
					}
				}
			}
		}
	}

	// set flags for emptied interface cells (interface to empty)
	for (y = 0; y < SIZE_2D_Y; y++)
	{
		for (x = 0; x < SIZE_2D_X; x++)
		{
			// current cell
			dfD2Q9_t *df = LBM2DField_Get(f_next, x, y);

			if (df->type & CT_IF_TO_EMPTY)
			{
				// keep flag 'CT_IF_TO_EMPTY' for later excess mass distribution

				// convert neighboring fluid cells to interface cells
				for (i = 1; i < 9; i++)		// omit zero vector
				{
					// neighbor cell
					dfD2Q9_t *df_neigh = LBM2DField_GetMod(f_next, x - vel2Di[i][0], y - vel2Di[i][1]);

					if (df_neigh->type & CT_FLUID) {
						df_neigh->type = CT_INTERFACE;
					}
				}
			}
		}
	}

	// distribute excess mass
	for (y = 0; y < SIZE_2D_Y; y++)
	{
		for (x = 0; x < SIZE_2D_X; x++)
		{
			// current cell
			dfD2Q9_t *df = LBM2DField_Get(f_next, x, y);

			// calculate surface normal using 'f0', such that excess mass distribution is independent of the filled cell ordering
			vec2_t normal = LBM2DField_CalcNormal(f0, x, y);

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

				// after negative excess mass has been distributed, remaining mass is zero
				df->mass = 0;
			}
			else
			{
				continue;
			}

			// Eq. (4.9)
			real eta[9] = { 0 };
			real eta_total = 0;
			unsigned int isIF[9] = { 0 };
			unsigned int numIF = 0;	// number of interface cell neighbors
			for (i = 1; i < 9; i++)		// omit zero vector
			{
				// neighbor cell in the direction of velocity vector
				dfD2Q9_t *df_neigh = LBM2DField_GetMod(f_next, x + vel2Di[i][0], y + vel2Di[i][1]);
				if (df_neigh->type & CT_INTERFACE)
				{
					eta[i] = Vec2_Dot(vel2Dv[i], normal);
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
			dfD2Q9_t *df_distr = LBM2DField_Get(f_distr, x, y);

			if (eta_total > 0)
			{
				real eta_fac = 1/eta_total;
				for (i = 1; i < 9; i++)		// omit zero vector
				{
					// eta[i] is zero for non-interface cells
					df_distr->f[i] = mex * eta[i]*eta_fac;
				}
			}
			else if (numIF > 0)
			{
				// distribute uniformly
				real mex_rel = mex / numIF;
				for (i = 1; i < 9; i++)		// omit zero vector
				{
					df_distr->f[i] = (isIF[i] ? mex_rel : 0);
				}
			}
			// else, excess mass cannot be distributed, i.e., has leaked
		}
	}

	// collect distributed mass and finalize cell flags
	for (y = 0; y < SIZE_2D_Y; y++)
	{
		for (x = 0; x < SIZE_2D_X; x++)
		{
			// current cell
			dfD2Q9_t *df = LBM2DField_Get(f_next, x, y);

			if (df->type & CT_INTERFACE)
			{
				for (i = 1; i < 9; i++)		// omit zero vector
				{
					// neighbor cell from distribution field
					dfD2Q9_t *df_distr = LBM2DField_GetMod(f_distr, x - vel2Di[i][0], y - vel2Di[i][1]);
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

	// set cell neighborhood flags
	for (y = 0; y < SIZE_2D_Y; y++)
	{
		for (x = 0; x < SIZE_2D_X; x++)
		{
			// current cell
			dfD2Q9_t *df = LBM2DField_Get(f_next, x, y);

			// ignore obstacle cells
			if (df->type & CT_OBSTACLE) {
				continue;
			}

			// set "no ... neighbor" flags
			df->type |= (CT_NO_FLUID_NEIGH | CT_NO_EMPTY_NEIGH | CT_NO_IFACE_NEIGH);
			for (i = 1; i < 9; i++)		// omit zero vector
			{
				// neighbor cell
				dfD2Q9_t *df_neigh = LBM2DField_GetMod(f_next, x - vel2Di[i][0], y - vel2Di[i][1]);
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


//_______________________________________________________________________________________________________________________
///
/// \brief Implement the LBM step for D2Q9 (2 dimensions, 9 velocities)
///
static void CalculateLBMStep2D(const lbm_field2D_t *restrict_ f0, const vec2_t gravity, lbm_field2D_t *restrict_ f1)
{
	// allocate intermediate fields for collision, stream and cell type step
	lbm_field2D_t f_coll, f_strm, f_distr;
	LBM2DField_Allocate(f0->omega, &f_coll);
	LBM2DField_Allocate(f0->omega, &f_strm);
	LBM2DField_Allocate(f0->omega, &f_distr);

	// collision step
	CalculateLBMCollisionStep2D(f0, gravity, &f_coll);

	// stream step
	CalculateLBMStreamStep2D(&f_coll, &f_strm);

	// update cell types
	UpdateTypesLBMStep2D(&f_strm, &f_distr, f1);

	// clean up
	LBM2DField_Free(&f_distr);
	LBM2DField_Free(&f_strm);
	LBM2DField_Free(&f_coll);
}


//_______________________________________________________________________________________________________________________
///
/// \brief Lattice Boltzmann time evolution using D2Q9 (2 dimensions, 9 velocities)
///
void LatticeBoltzmann2DEvolution(const lbm_field2D_t *restrict_ startfield, const int numsteps, const vec2_t gravity, lbm_field2D_t *restrict_ fieldevolv)
{
	int it;

	// copy initial field
	LBM2DField_Allocate(startfield->omega, fieldevolv);
	memcpy(fieldevolv->df, startfield->df, SIZE_2D_X*SIZE_2D_Y*sizeof(dfD2Q9_t));

	for (it = 1; it < numsteps; it++)
	{
		LBM2DField_Allocate(startfield->omega, &fieldevolv[it]);

		CalculateLBMStep2D(&fieldevolv[it-1], gravity, &fieldevolv[it]);
	}
}
