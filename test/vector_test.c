#include "vector2D.h"
#include "vector3D.h"
#include <stdio.h>



int main()
{

	real x = (real)(-1.0/3);
	real y = (real)( 9.0/2);
	real z = (real)( 7.0/5);

	// 2D
	{
		// reference value of norm
		real n_ref = (real)(sqrt(733.0)/6);

		real2 v;
		v.x = x;
		v.y = y;
		real err = fabsf(Vec2_Norm(v) - n_ref);

		// flip x <-> y
		v.x = y;
		v.y = x;
		err = maxf(err, fabsf(Vec2_Norm(v) - n_ref));

		// zero vector
		v.x = 0;
		v.y = 0;
		err = maxf(err, fabsf(Vec2_Norm(v)));

		printf("maximum error (2D case): %g\n", err);
	}

	// 3D
	{
		// reference value of norm
		real n_ref = (real)(sqrt(20089.0)/30);

		real3 v;

		// x, y, z
		v.x = x;
		v.y = y;
		v.z = z;
		real err = fabsf(Vec3_Norm(v) - n_ref);

		// x, z, y
		v.x = x;
		v.y = z;
		v.y = y;
		err = maxf(err, fabsf(Vec3_Norm(v) - n_ref));

		// y, x, z
		v.x = y;
		v.y = x;
		v.z = z;
		err = maxf(err, fabsf(Vec3_Norm(v) - n_ref));

		// y, z, x
		v.x = y;
		v.y = z;
		v.z = x;
		err = maxf(err, fabsf(Vec3_Norm(v) - n_ref));

		// z, x, y
		v.x = z;
		v.y = x;
		v.z = y;
		err = maxf(err, fabsf(Vec3_Norm(v) - n_ref));

		// z, y, x
		v.x = z;
		v.y = y;
		v.z = x;
		err = maxf(err, fabsf(Vec3_Norm(v) - n_ref));

		// zero vector
		v.x = 0;
		v.y = 0;
		v.z = 0;
		err = maxf(err, fabsf(Vec3_Norm(v)));

		printf("maximum error (3D case): %g\n", err);
	}

	return 0;
}
