#import "FindMinMaxThread.h"

@implementation FindMinMaxThread {
    NSArray *_numbers;
}

- (instancetype)initWithNumbers:(id)numbers {
    self = [super init];

    if (self) {
        _numbers = numbers;
    }
    return self;
}

- (void)main {
    NSUInteger min;
    NSUInteger max;
    self.min = min;
    self.max = max;
}

@end
