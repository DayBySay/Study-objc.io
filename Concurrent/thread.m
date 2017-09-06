#import <pthread.h>
#import <stdint.h>
#import <stdlib.h>
#import <Foundation/NSObjCRuntime.h>
#import <Foundation/NSException.h>

struct threadInfo {
    uint32_t * inputValues;
    size_t count;
};

struct threadResult {
    uint32_t min;
    uint32_t max;
};

void * findMinAndMax(void *arg)
{
    struct threadInfo const * const info = (struct threadInfo *) arg;
    uint32_t min = UINT32_MAX;
    uint32_t max = 0;
    for (size_t i = 0; i < info->count; ++i) {
        uint32_t v = info->inputValues[i];
        min = MIN(min, v);
        max = MAX(max, v);
    }

    free(arg);
    struct threadResult * const result = (struct threadResult *) malloc(sizeof(*result));
    result->min = min;
    result->max = max;
    return result;
}

int main(void) {
    size_t const count = 1000000;
    uint32_t inputValues[count];

    for (size_t i= 0; i < count; ++i) {
        inputValues[i] = arc4random();
    }

    size_t const threadCount = 4;
    pthread_t tid[threadCount];

    for (size_t i = 0; i < threadCount; ++i) {
        struct threadInfo * const info = (struct threadInfo *) malloc (sizeof(*info));
        size_t offset = (count / threadCount) * i;
        info->inputValues = inputValues + offset;
        info->count = MIN(count - offset, count / threadCount);
        int err = pthread_create(tid + i, NULL, &findMinAndMax, info);
        NSCAssert(err == 0, @"pthread_create() falied: %d", err);
    }

    struct threadResult * results[threadCount];
    for (size_t i = 0; i < threadCount; ++i) {
        int err = pthread_join(tid[i], (void **) &(results[i]));
        NSCAssert(err == 0, @"pthread_join() failed: %d", err);
    }

    uint32_t min = UINT32_MAX;
    uint32_t max = 0;
    for (size_t i = 0; i < threadCount; ++i) {
        min = MIN(min, results[i]->min);
        max = MAX(max, results[i]->max);
        free(results[i]);
        results[i] = NULL;
    }

    NSLog(@"min = %u", min);
    NSLog(@"max = %u", max);

    return 0;
}
















































