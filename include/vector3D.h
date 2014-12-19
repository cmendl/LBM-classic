/// \file vector3D.h
/// \brief Vector in three dimensions.
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


#ifndef VECTOR3D_H
#define VECTOR3D_H

#include "util.h"
#include <math.h>


//_______________________________________________________________________________________________________________________
///
/// \brief 3D vector
///
typedef struct
{
	real x;		//!< x component
	real y;		//!< y component
	real z;		//!< z component
}
vec3_t;


//_______________________________________________________________________________________________________________________
///
/// \brief Dot product in 3D
///
static inline real Vec3_Dot(const vec3_t a, const vec3_t b)
{
	return a.x*b.x + a.y*b.y + a.z*b.z;
}


//_______________________________________________________________________________________________________________________
///
/// \brief Cross product
///
static inline vec3_t Vec3_Cross(const vec3_t a, const vec3_t b)
{
	vec3_t ret;
	ret.x = a.y*b.z - a.z*b.y;
	ret.y = a.z*b.x - a.x*b.z; 
	ret.z = a.x*b.y - a.y*b.x; 

	return ret;
}


//_______________________________________________________________________________________________________________________
///
/// \brief Multiply by a scalar value
///
static inline vec3_t Vec3_ScalarMultiply(const real s, const vec3_t v)
{
	vec3_t ret;
	ret.x = s*v.x;
	ret.y = s*v.y;
	ret.z = s*v.z;

	return ret;
}


//_______________________________________________________________________________________________________________________
///
/// \brief Norm (Euclidean length) of a vector
///
static inline real Vec3_Norm(const vec3_t v)
{
	// have to change to 'fabs' for 'typedef double real'
	real a = fabsf(v.x);
	real b = fabsf(v.y);
	real c = fabsf(v.z);

	if (a < b)
	{
		if (b < c)
		{
			return c*sqrtf(1 + squaref(a/c) + squaref(b/c));
		}
		else	// a < b, c <= b
		{
			return b*sqrtf(1 + squaref(a/b) + squaref(c/b));
		}
	}
	else	// b <= a
	{
		if (a < c)
		{
			return c*sqrtf(1 + squaref(a/c) + squaref(b/c));
		}
		else	// b <= a, c <= a
		{
			if (a != 0)
			{
				return a*sqrtf(1 + squaref(b/a) + squaref(c/a));
			}
			else
			{
				return 0;
			}
		}
	}
}



#endif
