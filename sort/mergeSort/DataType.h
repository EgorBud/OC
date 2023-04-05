#include <immintrin.h>
struct TASK {
	int low;
	int high;
	int busy;
	int* a;
};

struct ComplexNumber {
	float Re;
	float Im;
	float sumOfSquare = -1;
};

void abs(float* re, float* im, float* res);