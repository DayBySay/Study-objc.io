#import <Foundation/Foundation.h>

@interface FindMinMaxThread : NSThread
@property (nonatomic) NSUInteger min;
@property (nonatomic) NSUInteger max;
@property (nonatomic) BOOL isFinished;
- (instancetype)initWithNumbers:(NSArray *)numbers;
@end

@implementation FindMinMaxThread {
    NSArray *_numbers;
}

- (instancetype)initWithNumbers:(NSArray *)numbers 
{
    self = [super init];
    if (self) {
        _numbers = numbers;
    }
    return self;
}

- (void)main
{
    NSUInteger min = NSIntegerMax;
    NSUInteger max = 0;

    for (NSNumber *num in _numbers) {
        NSUInteger i = [num integerValue];
        min = MIN(i, min);
        max = MAX(i, max);
    }

    self.min = min;
    self.max = max;
    self.isFinished = YES;

    NSLog(@"%@ finished", [self name]);
}

@end

int main(void) {
    NSMutableArray *numbers = [NSMutableArray array];
    for (int i = 0; i < 1000000; i++) {
        NSNumber *num = @(arc4random());
        [numbers addObject:num];
    }

    NSMutableArray *threads = [NSMutableArray array];
    NSUInteger numberCount = numbers.count;
	NSUInteger threadCount = 4;

    for (NSUInteger i = 0; i < threadCount; i++) {
        NSUInteger offset = (numberCount / threadCount) * i;
        NSUInteger count = MIN(numberCount - offset, numberCount / threadCount);
        NSRange range = NSMakeRange(offset, count);
        NSArray *subset = [numbers subarrayWithRange:range];
        FindMinMaxThread *thread = [[FindMinMaxThread alloc] initWithNumbers:subset];
        [threads addObject:thread];
        [thread start];
    }

    NSUInteger max = 0;
    NSUInteger min = NSIntegerMax;
    BOOL isFinished = NO;
    while (!isFinished) {
        for (int i = 0; i < threads.count; i++) {
        /* for (FindMinMaxThread *th in threads) { */
            FindMinMaxThread *th = threads[i];
            if (i == 0) {
                isFinished = th.isFinished;;
            } else {
                isFinished = isFinished && th.isFinished;
            }

            if (isFinished) {
                min = MIN(min, th.min);
                max = MAX(max, th.max);
            }
        }
    }

    NSLog(@"min = %ld", min);
    NSLog(@"max = %ld", max);
    return 0;
}
