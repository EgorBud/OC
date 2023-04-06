#pragma once 

#include <iostream>

#include "DataType.h"

class MergeSort {
private:
	float *re;
	float *im;
	float *abs;
	int maxThreads;
	int length;
	int lengthPerThread;
	int offset;

public:
	MergeSort(int, int);
	~MergeSort();

	float generateRandomNumbers(int, int);
	void fillUpRandomly();

	void calculateSquares();
	void calculateSquaresAvx(int, int);
	void calculateSquaresTest();

	void merge(int low, int mid, int high);
	void mergeSort(int low, int high);
	void *mergeSortThread(void *arg);
	void mergeSectionOfArray(int, int);
	bool testArrayIsInOrder();
	void mergeSortTest();
};

