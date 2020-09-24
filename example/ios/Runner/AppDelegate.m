#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <flutterthunder/FlutterthunderPlugin.h>


@interface AppDelegate()<FlutterThunderVideoCaptureFrameObserver,FlutterThunderVideoDecodeFrameObserver>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.

    [FlutterthunderPlugin sharedPlugin].flutterThunderVideoCaptureFrameObserver = self;

    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


//- (FlutterThunderVideoCaptureFrameDataType)needThunderVideoCaptureFrameDataType {
//    <#code#>
//}
//
//- (CVPixelBufferRef _Nullable)onVideoCaptureFrame:(EAGLContext * _Nonnull)glContext PixelBuffer:(CVPixelBufferRef _Nonnull)pixelBuf {
//    <#code#>
//}
//
//- (BOOL)onVideoCaptureFrame:(EAGLContext * _Nonnull)context PixelBuffer:(CVPixelBufferRef _Nonnull)pixelBuffer SourceTextureID:(unsigned int)srcTextureID DestinationTextureID:(unsigned int)dstTextureID TextureFormat:(int)textureFormat TextureTarget:(int)textureTarget TextureWidth:(int)width TextureHeight:(int)height {
//    <#code#>
//}
//
//- (void)onVideoDecodeFrame:(CVPixelBufferRef _Nonnull)pixelBuf pts:(uint64_t)pts uid:(NSString * _Nonnull)uid {
//    <#code#>
//}

@end
