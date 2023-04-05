#include <immintrin.h>
#include <stdio.h>
#include <iostream>
struct ComplexNumber {
    float Re;
    float Im;
    float sumOfSquare = -1;
};
void abs(float *re) {
    re[1] = 4;

  
}
 /* __m256 real = _mm256_load_ps(re);
    __m256 imaginary = _mm256_load_ps(im);
        imaginary = _mm256_mul_ps(imaginary, imaginary);
    __m256 result = _mm256_fmadd_ps(real, real, imaginary);
    result = _mm256_sqrt_ps(result);
    res= (float*)&res;*/
    /*printf("%f %f %f %f %f %f %f %f\n",
        res[0], res[1], res[2], res[3], res[4], res[5], res[6], res[7]);*/
/*__m256 real = _mm256_setr_ps(num->Re, (num + 1)->Re, (num + 2)->Re, (num + 3)->Re, (num + 4)->Re, (num + 5)->Re, (num + 6)->Re, (num + 7)->Re);
    __m256 imaginary = _mm256_setr_ps(num->Im, (num + 1)->Im, (num + 2)->Im, (num + 3)->Im, (num + 4)->Im, (num + 5)->Im, (num + 6)->Im, (num + 7)->Im);*/

int main() {
    float* a = new float[2];
    a[0] = 2;
 
    std::cout << a[0] << std::endl;
   abs(a);

   std::cout << a[1] << std::endl;
    /* Initialize the two argument vectors */
    __m256 real = _mm256_setr_ps(1.0, -3.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0);
    __m256 imaginary = _mm256_setr_ps(1.0, 4.0, 5.0, 7.0, 9.0, 11.0, 13.0, 15.0);
    float* f = (float*)&real;
    printf("%f %f %f %f %f %f %f %f\n",     
        f[0], f[1], f[2], f[3], f[4], f[5], f[6], f[7]);
    /* Compute the difference between the two vectors */
    imaginary = _mm256_mul_ps(imaginary, imaginary);
    __m256 res = _mm256_fmadd_ps(real,real, imaginary);


    f = (float*)&res;
    printf("%f %f %f %f %f %f %f %f\n",
        f[0], f[1], f[2], f[3], f[4], f[5], f[6], f[7]);
    res = _mm256_sqrt_ps(res);
    /* Display the elements of the result vector */
     f = (float*)&res;
    printf("%f %f %f %f %f %f %f %f\n",
        f[0], f[1], f[2], f[3], f[4], f[5], f[6], f[7]);

    return 0;
}

// Запуск программы: CTRL+F5 или меню "Отладка" > "Запуск без отладки"
// Отладка программы: F5 или меню "Отладка" > "Запустить отладку"

// Советы по началу работы 
//   1. В окне обозревателя решений можно добавлять файлы и управлять ими.
//   2. В окне Team Explorer можно подключиться к системе управления версиями.
//   3. В окне "Выходные данные" можно просматривать выходные данные сборки и другие сообщения.
//   4. В окне "Список ошибок" можно просматривать ошибки.
//   5. Последовательно выберите пункты меню "Проект" > "Добавить новый элемент", чтобы создать файлы кода, или "Проект" > "Добавить существующий элемент", чтобы добавить в проект существующие файлы кода.
//   6. Чтобы снова открыть этот проект позже, выберите пункты меню "Файл" > "Открыть" > "Проект" и выберите SLN-файл.
