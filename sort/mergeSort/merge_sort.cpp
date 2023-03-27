#include <stdlib.h>

#include "DataType.h"
#include "merge_sort.h"

void merge(int* a, int low, int mid, int high) {
	int n1 = mid - low + 1;
	int n2 = high - mid;

	int* left = (int*)malloc(n1 * sizeof(int));
	int* right = (int*)malloc(n2 * sizeof(int));

	int i, j;

	for (i = 0; i < n1; ++i)
		left[i] = a[i + low];

	for (i = 0; i < n2; ++i)
		right[i] = a[i + mid + 1];

	int k = low;
	i = j = 0;

	while (i < n1 && j < n2) {
		if (left[i] <= right[j])
			a[k++] = left[i++];
		else
			a[k++] = right[j++];
	}

	while (i < n1)
		a[k++] = left[i++];

	while (j < n2)
		a[k++] = right[j++];

	free(left);
	free(right);
}

void merge_sort(int* a, int low, int high) {
	int mid = low + (high - low) / 2;
	if (low < high) {
		merge_sort(a, low, mid);
		merge_sort(a, mid + 1, high);
		merge(a, low, mid, high);
	}
}

void* merge_sort_thread(void* arg) {
	TASK* task = (TASK*)arg;
	int low;
	int high;

	// calculating low and high
	low = task->low;
	high = task->high;

	// evaluating mid point;
	int mid = low + (high - low) / 2;

	if (low < high) {
		merge_sort(task->a, low, mid);
		merge_sort(task->a, mid + 1, high);
		merge(task->a, low, mid, high);
	}
	task->busy = 0;
	return 0;
}