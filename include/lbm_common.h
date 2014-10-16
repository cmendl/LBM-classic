/// \file lbm_common.h
/// \brief Common structures and functions shared between the D2Q9 and D3Q19 implementations.
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


#ifndef LBM_COMMON_H
#define LBM_COMMON_H

#include "platform.h"
#include <assert.h>


//_______________________________________________________________________________________________________________________
///
/// \brief Bit masks for the various cell types and neighborhood flags
///
enum cellType
{
	CT_OBSTACLE			= 1 << 0,
	CT_FLUID			= 1 << 1,
	CT_INTERFACE		= 1 << 2,
	CT_EMPTY			= 1 << 3,
	// neighborhood flags, OR'ed with actual cell type
	CT_NO_FLUID_NEIGH	= 1 << 4,
	CT_NO_EMPTY_NEIGH	= 1 << 5,
	CT_NO_IFACE_NEIGH	= 1 << 6,
	// changing the maximum value here requires adapting the temporary cell types in 'UpdateTypesLBMStep(...)'
};


//_______________________________________________________________________________________________________________________
//

static const real rhoA = 1;								//!< atmospheric pressure

static const real v_max = (real)0.816496580927726;		//!< set maximum velocity to sqrt(2/3), such that f_eq[0] >= 0


static inline real CalculateMassExchange(const int type, const int type_neigh, const real fi_neigh, const real fi_inv) CONST_FUNC;

//_______________________________________________________________________________________________________________________
///
/// \brief Calculate mass exchange such that undesired interface cells to fill or empty
///
static inline real CalculateMassExchange(const int type, const int type_neigh, const real fi_neigh, const real fi_inv)
{
	// Table 4.1 in Nils Thuerey's PhD thesis

	if (type & CT_NO_FLUID_NEIGH)
	{
		assert((type & CT_NO_EMPTY_NEIGH) == 0);

		if (type_neigh & CT_NO_FLUID_NEIGH)
		{
			return fi_neigh - fi_inv;
		}
		else
		{
			// neighbor is standard cell or CT_NO_EMPTY_NEIGH
			return -fi_inv;
		}
	}
	else if (type & CT_NO_EMPTY_NEIGH)
	{
		if (type_neigh & CT_NO_EMPTY_NEIGH)
		{
			return fi_neigh - fi_inv;
		}
		else
		{
			// neighbor is standard cell or CT_NO_FLUID_NEIGH
			return fi_neigh;
		}
	}
	else
	{
		// current cell is standard cell

		if (type_neigh & CT_NO_FLUID_NEIGH)
		{
			return fi_neigh;
		}
		else if (type_neigh & CT_NO_EMPTY_NEIGH)
		{
			return -fi_inv;
		}
		else
		{
			// neighbor is standard cell
			return fi_neigh - fi_inv;
		}
	}
}



#endif
