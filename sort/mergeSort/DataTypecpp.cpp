
#include "DataType.h"
void abs(float* re, float* im, float* res, int n) {
    for (int i = 0; i < n; i += 8) {
    __m256 real = _mm256_load_ps(re+i);
    __m256 imaginary = _mm256_load_ps(im+i);
    imaginary = _mm256_mul_ps(imaginary, imaginary);
    __m256 result = _mm256_fmadd_ps(real, real, imaginary);
    result = _mm256_sqrt_ps(result);
    res = (float*)&res;
    res += i;
    /*printf("%f %f %f %f %f %f %f %f\n",
        res[0], res[1], res[2], res[3], res[4], res[5], res[6], res[7]);*/
}