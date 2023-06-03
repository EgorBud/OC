#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <thread>

#include "MergeSort.h"

int main() {
	srand(clock());
	MergeSort mergeSort(16, 40000000);


	mergeSort.mergeSortTest();
	return 0;
}