/// \file util.h
/// \brief Utility functions.
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


#ifndef UTIL_H
#define UTIL_H

#include "platform.h"
#include <math.h>
#include <stdbool.h>
#include <stddef.h>


//_______________________________________________________________________________________________________________________
///
/// \brief square function x -> x^2
///
static inline real squaref(const real x)
{
	return x*x;
}


//_______________________________________________________________________________________________________________________
///
/// \brief maximum of two numbers
///
static inline real maxf(const real x, const real y)
{
	if (x >= y)
	{
		return x;
	}
	else
	{
		return y;
	}
}

//_______________________________________________________________________________________________________________________
///
/// \brief minimum of two numbers
///
static inline real minf(const real x, const real y)
{
	if (x <= y)
	{
		return x;
	}
	else
	{
		return y;
	}
}


//_______________________________________________________________________________________________________________________
//


int ReadData(const char *filename, void *data, const size_t size, const size_t n);

int WriteData(const char *filename, const void *data, const size_t size, const size_t n, const bool append);



#endif
