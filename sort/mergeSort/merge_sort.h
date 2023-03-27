#pragma once 

void merge(int* a, int low, int mid, int high);

void merge_sort(int* a, int low, int high);

void* merge_sort_thread(void* arg);