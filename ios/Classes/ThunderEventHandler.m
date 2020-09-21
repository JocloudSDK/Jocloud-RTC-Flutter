#import "ThunderEventHandler.h"

@implementation ThunderEventHandler

+ (instancetype)shareInstance
{
    static ThunderEventHandler* handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[ThunderEventHandler alloc] init];
    });
    return handler;
}

@end
