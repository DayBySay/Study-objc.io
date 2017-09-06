#import <Foundation/Foundation.h>

@interface FindMinMaxThread : NSThread
@property (nonatomic) NSUInteger min;
@property (nonatomic) NSUInteger max;
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
}

@end

int main(void) {
    NSMutableArray *numbers = [NSMutableArray array];
    for (int i = 0; i < 1000000; i++) {
        NSNumber *num = @(arc4random());
        [numbers addObject:num];
    }

    NSMutableSet *threads = [NSMutableSet set];
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

    for (NSUInteger i = 0; i < threadCount; i++) {
        NSUInteger offset = (numberCount / threadCount) * i;
        NSUInteger count = MIN(numberCount - offset, numberCount / threadCount);
        NSRange range = NSMakeRange(offset, count);
        NSArray *subset = [numbers subarrayWithRange:range];
        FindMinMaxThread *thread = [[FindMinMaxThread alloc] initWithNumbers:subset];
        [threads addObject:thread];
        [thread start];
    }

    NSUInteger max;
    NSUInteger min;
    BOOL isFinished = NO;
    while (!isFinished) {
        for (FindMinMaxThread *th in threads) {
            if (th.min == nil || th.max == nil) {
                break;
            }

            isFinished = YES;
            max = th.max;
            min = th.min;
        }
    }

    NSLog(@"min = %ld", min);
    NSLog(@"max = %ld", max);
    return 0;
}
