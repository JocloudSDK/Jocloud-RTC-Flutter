#import "ThunderEngine.h"

@interface ThunderEventHandler :NSObject

+ (instancetype)shareInstance;

@property (strong, nonatomic, readwrite) id<ThunderVideoCaptureFrameObserver> thunderVideoCaptureFrameObserver;
@property (strong, nonatomic, readwrite) id<ThunderVideoDecodeFrameObserver> thunderVideoDecodeFrameObserver;

@end


