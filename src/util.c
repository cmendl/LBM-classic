/// \file util.c
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


#include "util.h"
#include <stdio.h>


//_______________________________________________________________________________________________________________________
///
/// \brief Read 'n' items of size 'size' from file 'fileName', expecting the file size to be exactly n*size
///
int ReadData(const char *filename, void *data, size_t size, size_t n)
{
	FILE *fd = fopen(filename, "rb");
	if (fd == NULL)
	{
		perror("'fopen' failed");
		return -1;
	}

	// obtain the file size
	fseek(fd, 0 , SEEK_END);
	long filesize = ftell(fd);
	rewind(fd);
	// printf("file size: %d\n", filesize);
	if ((size_t)filesize != n*size)
	{
		perror("File size does not match");
		return -2;
	}

	// copy the file into the data array
	if (fread(data, size, n, fd) != n)
	{
		perror("'fread' failed");
		return -3;
	}

	fclose(fd);

	return 0;
}


//_______________________________________________________________________________________________________________________
///
/// \brief Write 'n' items of size 'size' to file 'fileName'
///
int WriteData(const char *filename, void *data, size_t size, size_t n, bool append)
{
	const char *mode = append ? "ab" : "wb";

	FILE *fd = fopen(filename, mode);
	if (fd == NULL)
	{
		perror("'fopen' failed");
		return -1;
	}

	// write data array to file
	if (fwrite(data, size, n, fd) != n)
	{
		perror("'fwrite' failed");
		return -3;
	}

	fclose(fd);

	return 0;
}
