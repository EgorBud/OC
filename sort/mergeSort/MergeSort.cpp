#include <stdlib.h>

#include <chrono>
#include <immintrin.h>
#include <thread>

#include "MergeSort.h"

MergeSort::MergeSort(int maxThreads, int length) {
	this->maxThreads = maxThreads;
	this->length = length;
	lengthPerThread = length / maxThreads;
	offset = length % maxThreads;
	re = new float[length];
	im = new float[length];
	abs = new float[length];

	// test parallel merg
	firstArray = new float[length];
	secondArray = new float[length];

	fillUpRandomly();
}

MergeSort::~MergeSort() {
	delete []re;
	delete []im;
	delete []abs;
}

float MergeSort::generateRandomNumbers(int lower, int upper) {
	return lower + (upper - lower) * ((double)rand() / RAND_MAX);
}

void MergeSort::fillUpRandomly() {
	for (int i = 0; i < length; ++i) {
		re[i] = generateRandomNumbers(1, 100);
		im[i] = generateRandomNumbers(1, 100);
		abs[i] = -1;

		// test parallel merg
		firstArray[i] = generateRandomNumbers(1, 50);
		secondArray[i] = generateRandomNumbers(1, 50);
	}
}

void MergeSort::calculateSquares() {
	for (int i = 0; i < length; ++i) {
		abs[i] = re[i] * re[i] + im[i] * im[i];
	}
}

void MergeSort::calculateSquaresAvx(int begin, int end) {
	for (int i = begin; i < end; i += 8) {
		__m256 real = _mm256_load_ps(re + i);
		__m256 imaginary = _mm256_load_ps(im + i);

		imaginary = _mm256_mul_ps(imaginary, imaginary);
		__m256 result = _mm256_fmadd_ps(real, real, imaginary);
		_mm256_store_ps(abs + i, result);
	}
}

void MergeSort::calculateSquaresTest() {
	std::cout << "Calculate Squares Time: ";
	auto begin = std::chrono::system_clock::now();

	calculateSquares();
	
	auto end = std::chrono::system_clock::now();
	std::chrono::duration<double> time = end - begin;
	std::cout << time.count() << std::endl;


	std::cout << "Calculate Squares With AVX Time: ";
	begin = std::chrono::system_clock::now();

	calculateSquaresAvx(0, length);

	end = std::chrono::system_clock::now();
	time = end - begin;
	std::cout << time.count() << std::endl;
}

void MergeSort::merge(int low, int mid, int high) {
	int n1 = mid - low + 1;
	int n2 = high - mid;

	//int* left = new int[n1];
	float* leftRe = new float[n1];
	float* leftIm = new float[n1];
	float* leftAbs = new float[n1];

	//int* right = new int[n2];
	float* rightRe = new float[n2];
	float* rightIm = new float[n2];
	float* rightAbs = new float[n2];

	int i, j;

	for (i = 0; i < n1; ++i) {
		leftRe[i] = re[i + low];
		leftIm[i] = im[i + low];
		leftAbs[i] = abs[i + low];

	}

	for (i = 0; i < n2; ++i) {
		rightRe[i] = re[i + mid + 1];
		rightIm[i] = im[i + mid + 1];
		rightAbs[i] = abs[i + mid + 1];
	}

	int k = low;
	i = j = 0;

	while (i < n1 && j < n2) {
		if (leftAbs[i] <= rightAbs[j]) {
			//a[k++] = left[i++];
			re[k] = leftRe[i];
			im[k] = leftIm[i];
			abs[k] = leftAbs[i];
			k++; i++;
		} else {
			//a[k++] = right[j++];
			re[k] = rightRe[j];
			im[k] = rightIm[j];
			abs[k] = rightAbs[j];
			k++; j++;
		}
	}

	while (i < n1) {
		//a[k++] = left[i++];
		re[k] = leftRe[i];
		im[k] = leftIm[i];
		abs[k] = leftAbs[i];
		k++; i++;
	}

	while (j < n2) {
		//a[k++] = right[j++];
		re[k] = rightRe[j];
		im[k] = rightIm[j];
		abs[k] = rightAbs[j];
		k++; j++;
	}

	delete[]leftRe;
	delete[]leftIm;
	delete[]leftAbs;
	delete[]rightRe;
	delete[]rightIm;
	delete[]rightAbs;
}

void MergeSort::mergeSort(int low, int high) {
	int mid = low + (high - low) / 2;
	if (low < high) {
		mergeSort(low, mid);
		mergeSort(mid + 1, high);
		merge(low, mid, high);
	}
}

void* MergeSort::mergeSortThread(void* arg) {

	int thread_id = (long)arg;
	int low = thread_id * lengthPerThread;
	int high = (thread_id + 1) * lengthPerThread - 1;
	if (thread_id == maxThreads - 1) {
		high += offset;
	}

	calculateSquaresAvx(low, high);

	int mid = low + (high - low) / 2;
	if (low < high) {
		mergeSort(low, mid);
		mergeSort(mid + 1, high);
		merge(low, mid, high);
	}


	return nullptr;
}

void MergeSort::mergeSectionOfArray(int number, int aggregation) {
	for (int i = 0; i < number; i = i + 2) {
		int low = i * (lengthPerThread * aggregation);
		int high = ((i + 2) * lengthPerThread * aggregation) - 1;
		int mid = low + (lengthPerThread * aggregation) - 1;
		if (high >= length) {
			high = length - 1;
		}
		merge(low, mid, high);
	}
	if (number / 2 >= 1) {
		mergeSectionOfArray(number / 2, aggregation * 2);
	}
}

bool MergeSort::testArrayIsInOrder() {
	for (int i = 0; i < length - 1; ++i) {
		if (abs[i] > abs[i + 1]) {
			return false;
		}
	}
	return true;
}

void MergeSort::mergeSortTest() {
	int n = 3 * maxThreads;
	for (int i = 1; i <= n; ++i) {
		fillUpRandomly();
		maxThreads = i;
		lengthPerThread = length / maxThreads;
		offset = length % maxThreads;

		std::thread* threads = new std::thread[maxThreads];

		std::cout << i << ", ";
		auto begin = std::chrono::system_clock::now();

		for (int j = 0; j < maxThreads; ++j) {
			threads[j] = std::thread(&MergeSort::mergeSortThread, this, (void*)j);
		}

		for (int j = 0; j < maxThreads; ++j) {
			threads[j].join();
		}

		// до слияния
		auto endThreads = std::chrono::system_clock::now();

		for (int j = 1; j < maxThreads; ++j) {
			int mid = j * lengthPerThread - 1;
			int hight = (j + 1) * lengthPerThread - 1;
			merge(0, mid, hight);
		}
		if (i != 1)
			merge(0, lengthPerThread * maxThreads - 1, length - 1);

		auto end = std::chrono::system_clock::now();
		std::chrono::duration<double> time = end - begin;
		std::chrono::duration<double> withoutMerging = endThreads - begin;
		std::cout << withoutMerging.count() << "\t";
		std::cout << time.count() << "\t";

		if (testArrayIsInOrder()) {
			std::cout << "Sorted" << std::endl;
		} else {
			std::cout << "Not sorted" << std::endl;
			return;
		}
		delete []threads;
	}
}


// test parallel merg
void MergeSort::mergeParallel() {
	float* resultArray = new float[2 * length];

	int k = 0;
	for (int i = 0; i < length; ++i) {
		resultArray[k++] = firstArray[i];
	}
	for (int i = 0; i < length; ++i) {
		resultArray[k++] = secondArray[i];
	}














	for (int i = 0; i < length; ++i) {
		std::cout << firstArray[i] << " ";
	}
	std::cout << std::endl;

	for (int i = 0; i < length; ++i) {
		std::cout << secondArray[i] << " ";
	}
	std::cout << std::endl;

	for (int i = 0; i < 2 * length; ++i) {
		std::cout << resultArray[i] << " ";
	}
	std::cout << std::endl;

	delete []resultArray;
}