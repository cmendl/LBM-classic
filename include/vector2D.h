/// \file vector2D.h
/// \brief Vector in two dimensions.
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


#ifndef VECTOR2D_H
#define VECTOR2D_H

#include "util.h"
#include <math.h>


//_______________________________________________________________________________________________________________________
///
/// \brief 2D vector
///
typedef struct
{
	real x;		//!< x component
	real y;		//!< y component
}
vec2_t;


//_______________________________________________________________________________________________________________________
///
/// \brief Dot product in 2D
///
static inline real Vec2_Dot(const vec2_t a, const vec2_t b)
{
	return a.x*b.x + a.y*b.y;
}


//_______________________________________________________________________________________________________________________
///
/// \brief Multiply by a scalar value
///
static inline vec2_t Vec2_ScalarMultiply(const real s, const vec2_t v)
{
	vec2_t ret;
	ret.x = s*v.x;
	ret.y = s*v.y;

	return ret;
}


//_______________________________________________________________________________________________________________________
///
/// \brief Norm (Euclidean length) of a vector
///
static inline real Vec2_Norm(const vec2_t v)
{
	// have to change to 'fabs' for 'typedef double real'
	real a = fabsf(v.x);
	real b = fabsf(v.y);

	if (a < b)
	{
		return b*sqrtf(1 + squaref(a/b));
	}
	else	// b <= a
	{
		if (a != 0)
		{
			return a*sqrtf(1 + squaref(b/a));
		}
		else
		{
			return 0;
		}
	}
}



#endif
