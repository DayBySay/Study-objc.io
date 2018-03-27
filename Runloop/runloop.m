#import <pthread.h>
#import <stdint.h>
#import <stdlib.h>
#import <Foundation/NSRunLoop.h>

int main(void) {
    NSLog(@"%@", [NSRunLoop currentRunLoop]);
    [[NSRunLoop currentRunLoop] run];

    return 0;
}
















































