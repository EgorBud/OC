//#include <assert.h>
//#include <string.h>
//#include <stdlib.h>
#include <iostream>
#include <time.h>
#include <omp.h>
#include <immintrin.h>

#define TASK_SIZE 100

struct ComplexNumber {
    float Re;
    float Im;
    float sumOfSquare = -1;
    bool operator<(ComplexNumber& other);
    bool operator>(ComplexNumber& other);
};
bool ComplexNumber::operator<(ComplexNumber& other) {
    return sumOfSquare < other.sumOfSquare;
}

bool ComplexNumber::operator>(ComplexNumber& other) {
    return sumOfSquare > other.sumOfSquare;
}

void abs(float* rel, float* im, float* res, int n) {
    for (int i = 0; i < n; i += 8) {
        __m256 real = _mm256_load_ps(rel + i);

        __m256 imaginary = _mm256_load_ps(im + i);
  
        imaginary = _mm256_mul_ps(imaginary, imaginary);
        __m256 result = _mm256_fmadd_ps(real, real, imaginary);
        result = _mm256_sqrt_ps(result);
        _mm256_store_ps(res + i, result);

       
    }    

}

 float rand_interval(unsigned int min, unsigned int max)
{
    float r;
    const unsigned int range = 1 + max - min;
    const unsigned int buckets = RAND_MAX / range;
    const unsigned int limit = buckets * range;

    do
    {
        r = rand();
    } while (r >= limit);
   // std::cout<<(min + (r / buckets))<<" ";
    return min + (r / buckets);
}

void fillupRandomly(ComplexNumber* m, int size, unsigned int min, unsigned int max) {
    float* re =new float[size];
    float* im =new float[size];
    float* mod=new float[size];


    for (int i = 0; i < size; i++)
        re[i] = rand_interval(min, max);

    for (int i = 0; i < size; i++)
        im[i] = rand_interval(min, max);



    abs(re, im, mod, size - (size % 8));

    for (int i = size - (size % 8); i < size; i++) 
        mod[i] = sqrt(re[i] * re[i] + im[i] * im[i]);

    for (int i = 0; i < size; i++) {
        m[i].Im = im[i];
        m[i].Re = re[i];
        m[i].sumOfSquare = mod[i];
    }
}

void mergeSortAux(ComplexNumber* X, int n, ComplexNumber* tmp) {
    int i = 0;
    int j = n / 2;
    int ti = 0;

    while (i < n / 2 && j < n) {
        if (X[i] < X[j]) {
            tmp[ti] = X[i];
            ti++; i++;
        }
        else {
            tmp[ti] = X[j];
            ti++; j++;
        }
    }
    while (i < n / 2) { /* finish up lower half */
        tmp[ti] = X[i];
        ti++; i++;
    }
    while (j < n) { /* finish up upper half */
        tmp[ti] = X[j];
        ti++; j++;
    }
    std::memcpy(X, tmp, n * sizeof(ComplexNumber));
}

void mergeSort(ComplexNumber* X, int n, ComplexNumber* tmp)
{
    if (n < 2) return;

#pragma omp task shared(X) if (n > TASK_SIZE)
    mergeSort(X, n / 2, tmp);

#pragma omp task shared(X) if (n > TASK_SIZE)
    mergeSort(X + (n / 2), n - (n / 2), tmp + n / 2);

#pragma omp taskwait
    mergeSortAux(X, n, tmp);
}
/*
void init(ComplexNumber* a, int size) {
    for (int i = 0; i < size; i++)
        a[i] = 0;
}*/

void printArray(ComplexNumber* a, int size) {
    for (int i = 0; i < size; i++)
        std::cout << a[i].sumOfSquare << " ";
    std::cout << std::endl;
}

int isSorted(ComplexNumber* a, int size) {
    for (int i = 0; i < size - 1; i++)
        if (a[i] > a[i + 1])
            return 0;
    return 1;
}

int main(int argc, char* argv[]) {
    srand(123456);
    int N = 10;
    int print = 1;
    int numThreads = 4;
    ComplexNumber* X = new ComplexNumber[N];
    ComplexNumber* tmp = new ComplexNumber[N];

    omp_set_dynamic(0);              /** Explicitly disable dynamic teams **/
    omp_set_num_threads(numThreads);
    /** Use N threads for all parallel regions **/
#pragma omp parallel
    {
#pragma omp single
        printf("num_threads = %d\n", omp_get_num_threads());
    }
    // Dealing with fail memory allocation
    if (!X || !tmp)
    {
        delete[](X);
        delete[](tmp);
        return (EXIT_FAILURE);
    }
    fillupRandomly(X, N, 2, 10);
    if (print) {
        printArray(X, N);
    }
    double begin = omp_get_wtime();
#pragma omp parallel
    {
#pragma omp single
        mergeSort(X, N, tmp);
    }
    double end = omp_get_wtime();
    std::cout << ("Time: %f (s)", end - begin) << std::endl;

    //assert(1 == isSorted(X, N));

    if (print) {
        printArray(X, N);
    }

    delete[](X);
    delete[](tmp);
    return (EXIT_SUCCESS);
}
