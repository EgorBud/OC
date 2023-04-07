#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <thread>

#include "MergeSort.h"

int main() {
	srand(clock());
	MergeSort mergeSort(12, 100000000);
	mergeSort.mergeSortTest();
	return 0;
}