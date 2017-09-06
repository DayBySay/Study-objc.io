#import "MyClass.h"

int main(void) {
    NSString *hoge = @"test";
    printf("String is %s", [hoge UTF8String]);
    return 0;
}
