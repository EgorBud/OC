#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "DataType.h"
#include "merge_sort.h"

#if defined (WIN32) || (_WIN64)

#include <windows.h>
#define pthread_t DWORD
#define pthread_create(THREAD_ID_PTR, ATTR, ROUTINE, PARAMS) CreateThread(NULL,0,(LPTHREAD_START_ROUTINE)ROUTINE,(void*)PARAMS,0,THREAD_ID_PTR)
#define sleep(ms) Sleep(ms)

#else // Linux

#include <pthread.h>
#include <unistd.h>

#endif

void test(int maxArrayElements, int numThreads) {
	printf("\n\nArray[%d] Threads[%d]", maxArrayElements, numThreads);

	// allocate the array
	int* array = (int*)malloc(sizeof(int) * maxArrayElements);

	// generating random values in array
	srand(clock());
	for (int i = 0; i < maxArrayElements; ++i)
		array[i] = rand() % 100;

	printf("  |Array Randomized");

	pthread_t* threads = (pthread_t*)malloc(sizeof(pthread_t) * numThreads);
	TASK* tasklist = (TASK*)malloc(sizeof(TASK) * numThreads);

	int len = maxArrayElements / numThreads;

	TASK* task;
	int low = 0;

	clock_t time = clock();

	for (int i = 0; i < numThreads; ++i, low += len) {
		task = &tasklist[i];
		task->low = low;
		task->high = low + len - 1;
		if (i == (numThreads - 1))
			task->high = maxArrayElements - 1;
	}

	// create the threads
	for (int i = 0; i < numThreads; ++i) {
		task = &tasklist[i];
		task->a = array;
		task->busy = 1;
		pthread_create(&threads[i], 0, merge_sort_thread, task);
	}

	// wait for all threads
	for (int i = 0; i < numThreads; ++i)
		while (tasklist[i].busy)
			sleep(50);

	TASK* taskm = &tasklist[0];
	for (int i = 1; i < numThreads; ++i) {
		TASK* task = &tasklist[i];
		merge(taskm->a, taskm->low, task->low - 1, task->high);
	}

	printf("  |Sorted in %f Seconds", (clock() - time) / 1000.0L);

	int last = 0;
	for (int i = 0; i < maxArrayElements; ++i) {
		if (array[i] < last) {
			printf("\n\n!!!Array not sorted!!!");
			return;
		}
		last = array[i];
	}
	printf("  |Array sorted");

	free(tasklist);
	free(threads);
	free(array);

}

// driver
int main() {
	int MAX_ARRAY_ELEMENTS = 300000000;
	int MAX_THREADS = 12;

	for (int i = 1; i <= 3 * MAX_THREADS; ++i) {
		test(MAX_ARRAY_ELEMENTS, i);
	}	
	
	return 0;
}